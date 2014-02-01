package itsumono.sprite;
import massive.munit.Assert;

/**
 * @author agersant
 */

class AnimationTest {

	public function new() { }
	
	@Test
	public function calcTotalDuration() : Void {
		var anim = new Animation(["0", "0", "0"], [50, 40, 100], true);
		Assert.areEqual(anim.getDuration(), 190);
	}
	
	@Test
	public function nonLoopingAnimation() : Void {
		var anim = new Animation(["0", "1", "2"], [50, 40, 100], false);
		Assert.areEqual(anim.getFrameAt(0), "0");
		Assert.areEqual(anim.getFrameAt(30), "0");
		Assert.areEqual(anim.getFrameAt(60), "1");
		Assert.areEqual(anim.getFrameAt(89), "1");
		Assert.areEqual(anim.getFrameAt(91), "2");
		Assert.areEqual(anim.getFrameAt(100), "2");
		Assert.areEqual(anim.getFrameAt(150), "2");
		Assert.areEqual(anim.getFrameAt(500), "2");
	}
	
	@Test
	public function loopingAnimation() : Void {
		var anim = new Animation(["0", "1", "2"], [50, 40, 100], true);
		Assert.areEqual(anim.getFrameAt(0), "0");
		Assert.areEqual(anim.getFrameAt(30), "0");
		Assert.areEqual(anim.getFrameAt(60), "1");
		Assert.areEqual(anim.getFrameAt(89), "1");
		Assert.areEqual(anim.getFrameAt(91), "2");
		Assert.areEqual(anim.getFrameAt(100), "2");
		Assert.areEqual(anim.getFrameAt(150), "2");
		Assert.areEqual(anim.getFrameAt(200), "0");
		Assert.areEqual(anim.getFrameAt(190*500000 + 51), "1");
	}
	
	
}