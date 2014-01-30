package itsumono.assertive;
import itsumono.assertive.Assertive.AssertionError;
import massive.munit.Assert;

/**
 * @author agersant
 */

class AssertiveTest {

	public function new() { }
	
	@Test
	public function assertPass() : Void {
		Assertive.assert(true);
	}
	
	@Test
	public function assertErrorRelease() : Void {
		Assertive.assert(false);
	}
	
	@TestDebug
	public function assertErrorDebug() : Void {
		try {
			Assertive.assert(false);
		} catch (e : AssertionError) {			
			return;
		}
		Assert.fail("Assert 'false' did not throw an AssertionError in a debug build.");
	}
	
}