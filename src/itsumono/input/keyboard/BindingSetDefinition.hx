package itsumono.input.keyboard;
import flash.events.KeyboardEvent;
import itsumono.math.IMath;

/**
 * @author agersant
 */

class BindingSetDefinition {
	
	var bindings : List<Binding>;
	var locks : Int;

	public function new (_bindings : Iterable<Binding>) {
		bindings = Lambda.list(_bindings);
		locks = 1;
	}
	
	public function lock() : Void {
		locks++;
	}
	
	public function unlock() : Void {
		locks = IMath.max(0, locks - 1);
	}
	
	public function handleKeyboardEvent (event : KeyboardEvent, keyUp : Bool) {
		if (locks > 0) return;
		for (binding in bindings)
			binding.handleKeyboardEvent(event, keyUp);
	}
	
}