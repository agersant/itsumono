package itsumono.input.keyboard;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.Lib;
import itsumono.assertive.Assertive;

/**
 * @author agersant
 */

class KeyBindings extends Sprite {

	var bindingSets : Map<String, BindingSetDefinition>;
	
	public function new() {
		super();
		bindingSets = new Map();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
	}
	
	public function register (key : String, content : Iterable<Binding>) {
		Assertive.assert(!bindingSets.exists(key));
		var definition = new BindingSetDefinition(content);
		bindingSets.set(key, definition);
	}
	
	public function enable (key : String) : Void {
		Assertive.assert(bindingSets.exists(key));
		bindingSets.get(key).unlock();
	}

	public function disable (key : String) : Void {
		Assertive.assert(bindingSets.exists(key));
		bindingSets.get(key).lock();
	}
	
	function keyHandler (event : KeyboardEvent, keyUp : Bool) : Void {
		for (set in bindingSets)
			set.handleKeyboardEvent(event, keyUp);
	}
	
	function keyDownHandler (event : KeyboardEvent) : Void {
		keyHandler(event, false);
	}
	
	function keyUpHandler (event : KeyboardEvent) : Void {
		keyHandler(event, true);
	}
	
	
}