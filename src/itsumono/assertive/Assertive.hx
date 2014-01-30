package itsumono.assertive;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;
import itsumono.assertive.Assertive.AssertionError;

/**
 * @author agersant
 */

class AssertionError {
	public function new(){}
}

class Assertive {

	inline static public function assert (condition : Bool, ?message : String, ?pos : PosInfos) : Void {
		#if debug
			if (!condition)
				Assertive.fail(message, pos);
		#end
	}
	
	static function fail (message : String, ?pos : PosInfos) : Void {
		trace("Assertion failed!");
		trace("In " + pos.fileName + ":" + pos.methodName + " (line " + pos.lineNumber + ")" );
		if (message != null) trace(message);
		throw new AssertionError();
	}
	
}