package itsumono.sprite;
import itsumono.assertive.Assertive;

/**
 * @author agersant
 */

class Animation {
	
	var loop : Bool;
	var frames: Array<{key: String, duration: Int}>;
	var totalDuration : Int;

	public function new (frameKeys : Array<String>, frameDurations : Array<Int>, _loop : Bool) {
		Assertive.assert(frameKeys.length == frameDurations.length);
		Assertive.assert(frameKeys.length > 0);
		loop = _loop;
		frames = [];
		totalDuration = 0;
		for (f in 0...frameKeys.length)
			addFrame(frameKeys[f], frameDurations[f]);
	}
	
	function addFrame (key : String, duration : Int) : Void {
		Assertive.assert(duration > 0);
		frames.push( { key: key, duration: duration } );
		totalDuration += duration;
	}
	
	public function getFrameAt (time : Int) : String {
		Assertive.assert(time >= 0);
		if (loop) time = time % totalDuration;
		var acc : Int = 0;
		for (frame in frames) {
			acc += frame.duration;
			if (time <= acc)
				return frame.key;
		}
		return frames[frames.length - 1].key;
	}
	
	public function getDuration() : Int {
		return totalDuration;
	}
	
}