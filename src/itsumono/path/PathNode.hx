package itsumono.path;

/**
 * @author agersant
 */

typedef PathNode<T> = {
	var node : T;
	var parent : PathNode<T>;
	var distanceToEnd : Int;
	var cost : Float;
}