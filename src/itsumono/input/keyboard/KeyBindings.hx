package itsumono.input.keyboard;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import itsumono.assertive.Assertive;

/**
 * @author agersant
 */

class KeyBindings extends Sprite {

	var bindingSets : Map<String, BindingSetDefinition>;
	var listeningForEvents : Bool;
	
	public function new() {
		super();
		bindingSets = new Map();
		listeningForEvents = false;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	}
	
	public function register (key : String, content : Iterable<Binding>) {
		Assertive.assert(!bindingSets.exists(key));
		var definition = new BindingSetDefinition(content);
		bindingSets.set(key, definition);
	}
	
	public function enableAll() : Void {
		for (bindingSet in bindingSets)
			bindingSet.unlock();
	}

	public function disableAll() : Void {
		for (bindingSet in bindingSets)
			bindingSet.lock();
	}
	
	public function forceEnableAll() : Void {
		for (bindingSet in bindingSets)
			bindingSet.forceUnlock();
	}
	
	public function enable (key : String) : Void {
		Assertive.assert(bindingSets.exists(key));
		bindingSets.get(key).unlock();
	}

	public function disable (key : String) : Void {
		Assertive.assert(bindingSets.exists(key));
		bindingSets.get(key).lock();
	}
	
	public function forceEnable (key : String) : Void {
		Assertive.assert(bindingSets.exists(key));
		bindingSets.get(key).forceUnlock();
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
	
	function onAdded (event : Event) : Void {
		if (!listeningForEvents) {
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			listeningForEvents = true;
		}
	}
	
	function onRemoved (event : Event) : Void {
		if (listeningForEvents) {
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			listeningForEvents = false;
		}
	}
	
}