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
	
	public static inline var BACKSPACE 	: Int = 8;
	public static inline var TAB 		: Int = 9;
	public static inline var ENTER 		: Int = 13;
	public static inline var SHIFT 		: Int = 16;
	public static inline var CTRL 		: Int = 17;
	public static inline var ALT 		: Int = 18;
	public static inline var CAPSLOCK	: Int = 20;
	public static inline var ESCAPE		: Int = 27;
	public static inline var SPACE		: Int = 32;
	public static inline var LEFT		: Int = 37;
	public static inline var UP			: Int = 38;
	public static inline var RIGHT		: Int = 39;
	public static inline var DOWN		: Int = 40;
	
	public static inline var F1 		: Int = 112;
	public static inline var F2 		: Int = 113;
	public static inline var F3 		: Int = 114;
	public static inline var F4 		: Int = 115;
	public static inline var F5 		: Int = 116;
	public static inline var F6 		: Int = 117;
	public static inline var F7 		: Int = 118;
	public static inline var F8 		: Int = 119;
	public static inline var F9 		: Int = 120;
	public static inline var F10 		: Int = 121;
	public static inline var F11 		: Int = 122;
	public static inline var F12 		: Int = 123;
	
	public static inline var ZERO 		: Int = 48;
	public static inline var ONE 		: Int = 49;
	public static inline var TWO 		: Int = 50;
	public static inline var THREE 		: Int = 51;
	public static inline var FOUR 		: Int = 52;
	public static inline var FIVE 		: Int = 53;
	public static inline var SIX 		: Int = 54;
	public static inline var SEVEN 		: Int = 55;
	public static inline var EIGHT 		: Int = 56;
	public static inline var NINE 		: Int = 57;
	
	public static inline var A 			: Int = 65;
	public static inline var B 			: Int = 66;
	public static inline var C 			: Int = 67;
	public static inline var D 			: Int = 69;
	public static inline var E 			: Int = 69;
	public static inline var F 			: Int = 70;
	public static inline var G 			: Int = 71;
	public static inline var H 			: Int = 72;
	public static inline var I 			: Int = 73;
	public static inline var J 			: Int = 74;
	public static inline var K 			: Int = 75;
	public static inline var L 			: Int = 76;
	public static inline var M 			: Int = 77;
	public static inline var N 			: Int = 78;
	public static inline var O 			: Int = 79;
	public static inline var P 			: Int = 80;
	public static inline var Q 			: Int = 81;
	public static inline var R 			: Int = 82;
	public static inline var S 			: Int = 83;
	public static inline var T 			: Int = 84;
	public static inline var U 			: Int = 85;
	public static inline var V 			: Int = 86;
	public static inline var W 			: Int = 87;
	public static inline var X 			: Int = 88;
	public static inline var Y 			: Int = 89;
	public static inline var Z 			: Int = 90;
	
	public static inline var SEMICOLON	: Int = 186;
	public static inline var EQUAL		: Int = 187;
	public static inline var COMMA		: Int = 188;
	public static inline var DASH		: Int = 189;
	public static inline var DOT		: Int = 190;
	public static inline var SLASH		: Int = 191;
	public static inline var BACKQUOTE 	: Int = 192;
	public static inline var LEFTSQUAREBRACKET 	: Int = 219;
	public static inline var BACKSLASH	: Int = 220;
	public static inline var RIGHTSQUAREBRACKET : Int = 221;
	public static inline var APOSTROPHE : Int = 222;
	
	
}