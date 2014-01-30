package itsumono.sprite.formats;
import flash.display.BitmapData;
import itsumono.assertive.Assertive;
import itsumono.sprite.Spritesheet;

/**
 * @author agersant
 */

class RM2003 {
	
	static inline var characters : Int = 8;
	static inline var directions : Int = 4;
	static inline var framesPerAnim : Int = 3;
	static inline var frameWidth : Int = 24;
	static inline var frameHeight : Int = 32;
	static inline var sheetWidth : Int = 288;
	static inline var sheetHeight : Int = 256;
	static inline var frameDuration : Int = 200;

	static public function makeSpritesheet (bitmapData : BitmapData) : Spritesheet {
		
		Assertive.assert(bitmapData.width == sheetWidth);
		Assertive.assert(bitmapData.height == sheetHeight);
		
		var output = new Spritesheet(bitmapData);
		var charactersPerRow = sheetWidth / (frameWidth * framesPerAnim);
		var frameDurations = [for (f in 0...4) frameDuration];
		var frameKeys : Array<String>;
		var key : String;
		var x : Int;
		var y : Int;
		
		for (c in 0...characters)
			for (d in 0...directions) {
				frameKeys = [];
				for (f in 0...framesPerAnim) {
					key = makeFrameName(c, d, f);
					x = (frameWidth * (c*framesPerAnim + f)) % sheetWidth;
					y = frameHeight * (Math.floor(c / charactersPerRow) * directions + d);
					output.registerFrame(key, x, y, frameWidth, frameHeight);
					frameKeys.push(key);
				}
				Assertive.assert(frameKeys.length > 1);
				frameKeys.push(frameKeys[1]);
				output.registerAnimation(walkAnimation(c, d), frameKeys, frameDurations, true);
				output.registerAnimation(standAnimation(c, d), frameKeys.slice(1, 2), [frameDuration], true);
			}
			
		return output;
		
	}
	
	public static function walkAnimation (character : Int, direction : Int) : String {
		return "char_" + character + "_walk_dir_" + direction;
	}
	
	public static function standAnimation (character : Int, direction : Int) : String {
		return "char_" + character + "_stand_dir_" + direction;
	}
	
	static function makeFrameName (character : Int, direction : Int, frame : Int) : String {
		return "char_" + character + "_dir_" + direction + "_frame_" + frame;
	}
	
}