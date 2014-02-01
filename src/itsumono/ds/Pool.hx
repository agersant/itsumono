package itsumono.ds;
import itsumono.assertive.Assertive;

/**
 * @author agersant
 */

class Pool<T> {

	var freeObjects : Array<T>;
	var freeIndex : Int;
	var factory : Void->T;
	var resetFunction : T->Void;
	
	public function new (_factory : Void->T, ?_resetFunction : T->Void) {
		factory = _factory;
		resetFunction = _resetFunction;
		freeObjects = [];
		freeIndex = -1;
	}
	
	public function get () : T {
		Assertive.assert(freeIndex >= -1);
		if (freeIndex < 0) return factory();
		var output = freeObjects[freeIndex--];
		if (resetFunction != null) resetFunction(output);
		return output;
	}
	
	public function free (o : T) : Void {
		Assertive.assert(o != null);
		freeObjects[++freeIndex] = o;
	}
	
}