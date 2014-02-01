import massive.munit.TestSuite;

import ExampleTest;
import itsumono.assertive.AssertiveTest;
import itsumono.ds.PoolTest;
import itsumono.sprite.AnimationTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(itsumono.assertive.AssertiveTest);
		add(itsumono.ds.PoolTest);
		add(itsumono.sprite.AnimationTest);
	}
}
