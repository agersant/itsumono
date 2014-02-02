package itsumono.ui.flow;
import flash.display.Sprite;

/**
 * @author agersant
 */

typedef FrameDefinition<T : Sprite, U> = {
	var constructor : Void->T;
	var fullscreen : Bool;
	var save : T->U;
	var restore : T->U->Void;
}