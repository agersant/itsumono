package itsumono.ui.cli;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;
#if macro
import sys.FileSystem;
#end

using Lambda;

/**
 * @author agersant
 */

class CLIMacros {
	
	static inline var CLICommandsMeta : String = "commands";
	static inline var CLICommandMeta : String = ":command";
	static inline var CLIRegisterAllName : String = "registerCommands";
	static var badPackages = ["templates.flash.haxe"];

	macro public static function storeCommandsAsMetadata() : Expr {
		var CLIType = Context.getLocalClass();
		Context.onGenerate(function(types : Array<haxe.macro.Type>) {
			var pos = Context.currentPos();
			for (type in types) {
				switch (type) {
					default:
					case TInst(classType, params):
						var statics = classType.get().statics.get();
						for (func in statics)
							if (func.meta.has(CLICommandMeta)) {
								var funcName = classType.toString() + "." + func.name;
								var args = readArgumentsList(func).map(function(a) { return macro $v{a}; } ).array();
								CLIType.get().meta.add(funcName, args, pos);
							}
				}
			}
		});
		return macro {};
	}
	
	#if macro
	// TODO: support booleans
	static function readArgumentsList (field : haxe.macro.Type.ClassField) : Array<CLIArgument> {
		var errorMessage = "Unsupported CLI argument type: ";
		var output = [];
		switch (field.type) {
			case TFun(args, _):
				for (arg in args) {
					switch (arg.t) {
						// String or optional String
						case TInst(classType, _):
							if (classType.get().name != "String") throw errorMessage + arg.t;
							output.push({ name: arg.name, optional: arg.opt, type: Type.enumIndex(CLIArgumentType.CLIString) });
						// Int/Float
						case TAbstract(basicType, _):
							if (basicType.get().name == "Int") output.push({ name: arg.name, optional: arg.opt, type: Type.enumIndex(CLIArgumentType.CLIInt) });
							else if (basicType.get().name == "Float") output.push({ name: arg.name, optional: arg.opt, type: Type.enumIndex(CLIArgumentType.CLIFloat) });
							else if (basicType.get().name == "Bool") output.push({ name: arg.name, optional: arg.opt, type: Type.enumIndex(CLIArgumentType.CLIBool) });
							else throw errorMessage + arg.t;
						// Optional Int/Float						
						case TType(defType, params):
							if (defType.get().name != "Null") throw errorMessage + arg.t;
							switch(params[0]) {
								case TAbstract(basicType, _):
									if (basicType.get().name == "Int") output.push({ name: arg.name, optional: true, type: Type.enumIndex(CLIArgumentType.CLIInt) });
									else if (basicType.get().name == "Float") output.push({ name: arg.name, optional: true, type: Type.enumIndex(CLIArgumentType.CLIFloat) });
									else throw errorMessage + arg.t;
								default: throw errorMessage + arg.t;
							}
						default: throw errorMessage + arg.t;
					}
				}
			default: throw "Function expected";
		}
		return output;
	}
	#end
	
}
