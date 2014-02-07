package itsumono.ui.cli;
import haxe.rtti.Meta;

/**
 * @author agersant
 */

class CLIAPI {
	
	static var availableCommands : Map<String, Array<CLIArgument>>;

	function new() { }
	
	// Read commands from class metadata
	public static function init() : Void {
		CLIMacros.storeCommandsAsMetadata();
		if (availableCommands != null) return;
		availableCommands = new Map < String, Array<CLIArgument> > ();
		var meta = Meta.getType(CLIAPI);
		for (field in Reflect.fields(meta)) {
			availableCommands.set(field, untyped Reflect.getProperty(meta, field));
			if (availableCommands.get(field) == null)
				availableCommands.set(field, []);
		}
	}
	
	// Run a command
	public static function exec (userInput : String) : Bool {
		var parsed = parseInput(userInput);
		
		// Parse class and method
		var split = parsed.command.split(".");
		var method = split.pop();
		var module = split.join(".");
		var classType: Class<Dynamic> = Type.resolveClass(module);
		var methodField: Dynamic = Reflect.field(classType, method);
		
		// Parse arguments
		var callArgs : Array<Dynamic> = [];
		var expectedArgs : Array<CLIArgument> = availableCommands.get(parsed.command);
		var expectedArg : CLIArgument;
		var expectedArgType : CLIArgumentType;
		var receivedArg : String;
		var optional : Bool;
		
		for (i in 0...expectedArgs.length) {
			
			expectedArg = expectedArgs[i];
			expectedArgType = Type.createEnumIndex(CLIArgumentType, expectedArg.type);
			
			// Optional argument not provided
			if (expectedArg.optional && i >= parsed.args.length)
				continue;
				
			// Argument missing
			if (parsed.args.length <= i) {
				trace("Missing argument " + expectedArg.name + " for command " + parsed.command);
				return false;
			}
			
			// Argument provided, check type
			receivedArg = parsed.args[i];
			switch (expectedArgType) {
				case CLIArgumentType.CLIBool:
					switch (receivedArg.toLowerCase()) {
						case "true": callArgs.push(true);
						case "false": callArgs.push(false);
						default:
							trace("Argument " + expectedArg.name + " should be a bool");
							return false;
					}
				case CLIArgumentType.CLIInt:
					if (Std.parseInt(receivedArg) == null || Std.parseFloat(receivedArg) != Std.parseInt(receivedArg)) {
						trace("Argument " + expectedArg.name + " should be an int");
						return false;
					}
					callArgs.push(Std.parseInt(receivedArg));
				case CLIArgumentType.CLIFloat:
					if (!Math.isNaN(Std.parseFloat(receivedArg))) {
						trace("Argument " + expectedArg.name + " should be a float");
						return false;
					}
					callArgs.push(Std.parseFloat(receivedArg));
				case CLIArgumentType.CLIString:
					callArgs.push(receivedArg);
			}
			
		}
		
		// Run command
		Reflect.callMethod(classType, methodField, callArgs);
		return true;
	}
	
	// Gather autocomplete suggestions
	public static function runAutoComplete (userInput : String) : Array<AutoCompleteEntry> {

		var parsed = parseInput(userInput);
		var command = parsed.command;
		var goodMatches = [];
		var moreMatches = [];
		
		// Find matches
		if (command.length > 0) {
			for (c in availableCommands.keys()) {
				var i = c.toLowerCase().indexOf(command.toLowerCase());
				if (i >= 0) {
					var help = makeAutoCompleteSuggestion(parsed, c);
					if (i == 0) goodMatches.push(help);
					else moreMatches.push(help);
				}
			}
		}
		
		// Sort results
		var comparisonFunction : AutoCompleteEntry -> AutoCompleteEntry -> Int = function (a, b) : Int {
			var ta : String = a.text;
			var tb : String = b.text;
			if (ta < tb) return -1;
			if (ta > tb) return  1;
			return 0;
		}
		goodMatches.sort(comparisonFunction);
		moreMatches.sort(comparisonFunction);
		return goodMatches.concat(moreMatches);
	}
	
	// Parse command and arguments from input string
	static function parseInput (input : String) : ParsedInput {
		
		var parseRegex = ~/("[^"]*")|([^\s]+)/i;
		var command = "";
		var args = [];
		
		// Parse command
		if (!parseRegex.match(input))
			return {command: command, args: args};
		command = parseRegex.matched(0);
		input = parseRegex.matchedRight();
		
		// Parse arguments
		while (parseRegex.match(input)) {
			args.push(parseRegex.matched(0));
			input = parseRegex.matchedRight();
		}
		
		// Remove quotes around command and arguments
		if (command.charAt(0) == "\"")
			command = command.substr(1, command.length-2);
		for (i in 0...args.length)
			if (args[i].charAt(0) == "\"")
				args[i] = args[i].substr(1, args[i].length-2);
		
		return { command: command, args: args };
		
	}
	
	// Make autocomplete suggestion from input and one possible command
	static function makeAutoCompleteSuggestion (parsed : ParsedInput, targetCommandName : String) : AutoCompleteEntry {

		var output : AutoCompleteEntry = { text: "", searchHighlights: [], confirmHighlights: [] };
		var commandExists : Bool = availableCommands.exists(parsed.command);
		
		// Command name
		output.text += targetCommandName;
		if (commandExists) {
			output.confirmHighlights.push({ start: 0, end: targetCommandName.length });
		} else {
			var matchLocation : Int = targetCommandName.toLowerCase().indexOf(parsed.command.toLowerCase());
			output.searchHighlights.push({ start: matchLocation, end: matchLocation + parsed.command.length });
		}
		
		// Command args
		var expectedArgs : Array<CLIArgument> = availableCommands.get(targetCommandName);
		var hasAcceptableValue : Bool;
		var receivedArg : String;
		var argHelp : String;
		
		for (i in 0...expectedArgs.length) {
			
			var expectedArg = expectedArgs[i];
			var expectArgType = Type.createEnumIndex(CLIArgumentType, expectedArg.type);
			
			// Help output
			argHelp = " " + switch (expectArgType) {
				case CLIBool: (expectedArg.optional? "?" : "") + expectedArg.name + ":Bool";
				case CLIInt: (expectedArg.optional? "?" : "") + expectedArg.name + ":Int";
				case CLIFloat: (expectedArg.optional? "?" : "") + expectedArg.name + ":Float";
				case CLIString: (expectedArg.optional? "?" : "") + expectedArg.name + ":String";
			}
			
			// Colorize correct arguments
			if (commandExists) {
				
				// Do we have enough arguments to even check the type?
				hasAcceptableValue = i < parsed.args.length;
				
				// Type checking!
				if (hasAcceptableValue) {
					receivedArg = parsed.args[i];
					hasAcceptableValue = switch(expectArgType) {
						case CLIBool: receivedArg.toLowerCase() == "true" || receivedArg.toLowerCase() == "false";
						case CLIInt: Std.parseInt(receivedArg) != null && Std.parseFloat(receivedArg) == Std.parseInt(receivedArg);
						case CLIFloat: !Math.isNaN(Std.parseFloat(receivedArg));
						case CLIString: true;
					}
				}
				
				// Colorize
				if (hasAcceptableValue)
					output.confirmHighlights.push( { start: output.text.length, end: output.text.length + argHelp.length } );
				
			}
			
			output.text += argHelp;
		}
		
		return output;

	}
	
}