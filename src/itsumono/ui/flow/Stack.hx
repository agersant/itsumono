package itsumono.ui.flow;
import flash.display.Sprite;
import itsumono.assertive.Assertive;

using Lambda;

/**
 * @author agersant
 */

class Stack extends Sprite {

	var frameDefinitions : Map <String, FrameDefinition<Dynamic, Dynamic>>;
	var stack : List<FrameInstance<Dynamic, Dynamic>>;
	
	public function new() {
		frameDefinitions = new Map();
		stack = new List();
		super();
	}
	
	public function register<T : Sprite, U> (key : String, constructor : Void->T, ?fullscreen : Bool = true, ?save : T->U, ?restore : T->U->Void) : Void {
		Assertive.assert(key != null);
		Assertive.assert(!frameDefinitions.exists(key));
		if (save == null) save = function(a) { return null; };
		if (restore == null) restore = function(a, b) { };
		var frameDefinition : FrameDefinition < T, U > = {
			constructor: constructor,
			fullscreen: fullscreen,
			save: save,
			restore: restore
		};
		frameDefinitions.set(key, frameDefinition);
	}
	
	public function open (key : String) : Void {
		
		Assertive.assert(frameDefinitions.exists(key));
		var definition = frameDefinitions.get(key);
		
		// Close frame below
		var oldTop = stack.first();
		if (oldTop != null && definition.fullscreen) {
			save(oldTop);
			detach(oldTop);
		}
		
		// Open new frame
		var frameInstance = {
			definition: definition,
			sprite: null,
			savedState: null,
		}
		push(frameInstance);
		
	}
	
	public function closeTop() : Void {
		
		// Close top frame
		Assertive.assert(!stack.empty());
		var oldTop = stack.first();
		pop(oldTop);
		
		// Restore frame below
		var newTop = stack.first();
		if (newTop != null && oldTop.definition.fullscreen) {
			attach(newTop);			
			restore(newTop);
		}
		
	}
	
	public function closeAll() : Void {
		while (!stack.empty())
			pop(stack.first());
	}
	
	function push<T : Sprite, U> (frame : FrameInstance<T, U >) : Void {
		Assertive.assert(!stack.has(frame));
		stack.push(frame);
		attach(frame);
	}
	
	function pop<T: Sprite, U> (frame : FrameInstance < T, U > ) : Void {
		Assertive.assert(stack.has(frame));
		stack.remove(frame);
		detach(frame);
	}
	
	function attach<T : Sprite, U> (frame : FrameInstance<T, U>) : Void {
		if (frame.sprite == null)
			frame.sprite = frame.definition.constructor();
		Assertive.assert(!contains(frame.sprite));
		addChild(frame.sprite);
	}
	
	function detach<T : Sprite, U> (frame : FrameInstance<T, U>) : Void {
		if (frame.sprite != null) {
			Assertive.assert(contains(frame.sprite));
			removeChild(frame.sprite);
		}
		frame.sprite = null;
	}
	
	function save<T: Sprite, U> (frame : FrameInstance<T, U>) : Void {
		Assertive.assert(frame.sprite != null);
		frame.savedState = frame.definition.save(frame.sprite);
	}
	
	function restore<T: Sprite, U> (frame : FrameInstance<T, U>) : Void {
		Assertive.assert(frame.sprite != null);
		frame.definition.restore(frame.sprite, frame.savedState);
		frame.savedState = null;
	}
	
}