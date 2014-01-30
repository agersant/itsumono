package itsumono.sprite;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import itsumono.assertive.Assertive;

/**
 * @author agersant
 */

class Spritesheet {
	
	var bitmapData : BitmapData;
	var frames : Map<String, BitmapData>;
	var animations : Map<String, Animation>;
	
	public function new (_bitmapData : BitmapData) {
		bitmapData = _bitmapData;
		frames = new Map();
		animations = new Map();
	}
	
	public function registerFrame (key : String, x : Int, y : Int, w : Int, h : Int, ?fx : Int = 0, ?fy : Int = 0, ?fw : Int, ?fh : Int) : Void {
		if (fw == null) fw = w;
		if (fh == null) fh = h;
		Assertive.assert(key != null);
		Assertive.assert(!frames.exists(key));
		Assertive.assert(w > 0 && h > 0);
		Assertive.assert(fx >= 0 && fy >= 0);
		Assertive.assert(fw >= w && fh >= h);
		var frame = new BitmapData(fw, fh, true, 0);
		var copyRect = new Rectangle(x, y, w, h);		
		var destPoint = new Point(-fx, -fy);
		Assertive.assert(bitmapData.rect.containsRect(copyRect));
		Assertive.assert(frame.rect.containsPoint(destPoint));
		Assertive.assert(frame.rect.contains(destPoint.x + copyRect.width - 1, destPoint.y + copyRect.height - 1));
		frame.copyPixels(bitmapData, copyRect, destPoint);
		frames.set(key, frame);
	}
	
	public function registerAnimation (key : String, frameKeys : Array<String>, frameDurations : Array<Int>, loop : Bool) : Void {
		Assertive.assert(key != null);
		Assertive.assert(!animations.exists(key));
		for (frame in frameKeys) Assertive.assert(frames.exists(frame));
		var animation = new Animation(frameKeys, frameDurations, loop);
		animations.set(key, animation);
	}
	
	public function getAnimation (key : String) : Animation {
		Assertive.assert(animations.exists(key));
		return animations.get(key);
	}
	
	public function getFrame (key : String) : BitmapData {
		Assertive.assert(frames.exists(key));
		return frames.get(key);
	}
	
}