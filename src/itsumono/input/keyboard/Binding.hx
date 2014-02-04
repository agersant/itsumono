package itsumono.input.keyboard;
import flash.events.KeyboardEvent;

/**
 * @author agersant
 */

class Binding {

	var onKeyUp : Bool;
	var action : Void -> Void;
	var keyCode : Int;
	
	public function new (_keyCode : Int, _action : Void->Void, ?_onKeyUp : Bool = false) {
		keyCode = _keyCode;
		action = _action;
		onKeyUp = _onKeyUp;
	}
	
	public function handleKeyboardEvent (event : KeyboardEvent, keyUp : Bool) : Void {
		if (keyUp != onKeyUp) return;
		if (event.keyCode != keyCode) return;
		action();
	}
	
	public static inline var TAB : Int = 9;
	public static inline var ENTER : Int = 13;
	public static inline var ALT : Int = 18;
	public static inline var c : Int = 67;
	public static inline var F2 : Int = 113;
	public static inline var BACKQUOTE : Int = 192;
	
}