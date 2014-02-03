package itsumono.ui.stack;
import flash.display.Sprite;
import itsumono.assertive.Assertive;

using Lambda;

/**
 * @author agersant
 */

class UIStack extends Sprite {

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
			key: key,
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
		if (definition.fullscreen) {
			for (frame in stack) {
				if (frame.sprite == null) break;
				save(frame);
				detach(frame);
			}
		}
		var frameInstance = {
			definition: definition,
			sprite: null,
			savedState: null,
		}
		push(frameInstance);
	}
	
	public function closeTop() : Void {
		Assertive.assert(!stack.empty());
		var oldTop = stack.first();
		pop(oldTop);
		if (oldTop.definition.fullscreen)
			restoreTopFrames();
	}
	
	public function closeAll() : Void {
		while (!stack.empty())
			pop(stack.first());
	}
	
	public function closeAllAbove (key : String) : Void {
		Assertive.assert(frameDefinitions.exists(key));
		var closedFullscreen = false;
		var frame = stack.first();
		while (frame != null && frame.definition.key != key) {
			pop(frame);
			closedFullscreen = frame.definition.fullscreen;
			frame = stack.first();
		}
		if (closedFullscreen)
			restoreTopFrames();
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
	
	function restoreTopFrames<T: Sprite, U>() : Void {
		var framesToRestore = new List();
		for (frame in stack) {
			framesToRestore.push(frame);
			if (frame.definition.fullscreen) break;
		}
		for (frame in framesToRestore) {
			attach(frame);
			restore(frame);
		}
	}
	
}