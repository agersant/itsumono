package itsumono.ui.cli;
import flash.display.Sprite;
import flash.Lib;
import itsumono.input.keyboard.Binding;
import itsumono.input.keyboard.KeyBindings;

/**
 * @author agersant
 */

class CLI extends Sprite {

	static inline var CLI_CONTROLS : String = "CLI_CONTROLS";
	static inline var CLI_TOGGLE : String = "CLI_TOGGLE";
	static inline var margin : Int = 10;
	
	var keyBindings : KeyBindings;
	var input : CLIInput;
	
	public function new () {
		
		super();
		CLIAPI.init();
		
		keyBindings = new KeyBindings();
		addChild(keyBindings);
		
		input = new CLIInput(Lib.current.stage.stageWidth - 2 * margin);
		input.x = margin;
		input.y = margin;
		addChild(input);
		
		visible = false;
		keyBindings.register(CLI_TOGGLE, [new Binding(Binding.BACKQUOTE, toggle)]);
		keyBindings.register(CLI_CONTROLS, [
			new Binding(Binding.TAB, tabAutoComplete),
			new Binding(Binding.ENTER, exec)
		]);
		keyBindings.enable(CLI_TOGGLE);
		
	}
	
	function toggle() : Void {
		visible = !visible;
		if (visible) {
			keyBindings.enable(CLI_CONTROLS);
			input.grabFocus();
		} else keyBindings.disable(CLI_CONTROLS);
	}
	
	function tabAutoComplete() : Void {
		input.tabAutoComplete();
	}
	
	function exec() : Void {
		var command = input.getText();
		var success = CLIAPI.exec(command);
		if (success) input.clear();
	}
	
}