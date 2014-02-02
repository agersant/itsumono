package itsumono.ui.flow;
import flash.display.Sprite;

/**
 * @author agersant
 */

typedef FrameInstance<T : Sprite, U> = {
	var definition : FrameDefinition<T, U>;
	var sprite : T;
	var savedState: U;
}