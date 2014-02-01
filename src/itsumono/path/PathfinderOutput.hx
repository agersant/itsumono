package itsumono.path;

/**
 * @author agersant
 */

typedef PathfinderOutput<T> = {
	cost: Float,
	path: List<T>,
	finalDistanceToTarget: Int,
}