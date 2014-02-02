package itsumono.sprite;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import itsumono.assertive.Assertive;
import msignal.Signal.Signal0;
import msignal.Slot.Slot0;

/**
 * @author agersant
 */

class AnimatedSprite extends Sprite  {

	public var animationEndSignal (default, null) : Signal0;
	
	var autoAnimSlot : Slot0;
	var spritesheet : Spritesheet;
	var animation : Animation;
	var bitmap : Bitmap;
	var clock : Int;
	var animateCallback : Event->Void;
	
	public function new (_spritesheet: Spritesheet, _animation : String) {
		super();
		animationEndSignal = new Signal0();
		bitmap = new Bitmap();
		addChild(bitmap);
		spritesheet = _spritesheet;
		setAnimation(_animation);
	}
	
	public function setAnimation (key : String) : Void {
		var newAnimation = spritesheet.getAnimation(key);
		Assertive.assert(newAnimation != null);
		animation = newAnimation;
		if (autoAnimSlot != null)
			autoAnimSlot.remove();
		clock = 0;
		update(0);
	}
	
	public function animateSequence (keys : Array<String>) : Void {
		if (keys.length == 0) return;
		setAnimation(keys.shift());
		if (keys.length > 0)
			autoAnimSlot = animationEndSignal.addOnce(function() {
				animateSequence(keys);
			});
	}
	
	public function animateLoop (keys : Array<String>) : Void {
		if (keys.length == 0) return;
		var key = keys.shift();
		setAnimation(key);
		keys.push(key);
		if (keys.length > 1) {
			autoAnimSlot = animationEndSignal.addOnce(function() {
				animateLoop(keys);
			});
		}
	}
	
	public function update (dt : Int) : Void {
		var animationDuration = animation.getDuration();
		var frame = animation.getFrameAt(clock + dt);
		bitmap.bitmapData = spritesheet.getFrame(frame);
		var oldLoop = Math.floor(clock / animationDuration);
		var newLoop = Math.floor((clock + dt) / animationDuration);
		if (newLoop > oldLoop)
			animationEndSignal.dispatch();
		clock += dt;
	}
	
}