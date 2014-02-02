package itsumono.path;
import itsumono.assertive.Assertive;
import itsumono.ds.Pool.Pool;
using Lambda;


/**
 * @author agersant
 */

class Pathfinder<T> {
	
	public static var DEFAULT_ITERATIONS_LIMIT : Int = 500;
	public var maxIterations : Int;
	
	var pathNodes : Pool<PathNode<T>>;
	var heuristics : T->T->Int;
	var exploreFrom : T->Iterable<Move<T>>;
	
	public function new (_heuristics: T->T->Int, _exploreFrom: T->List<Move<T>>) {
		maxIterations = DEFAULT_ITERATIONS_LIMIT;
		pathNodes = new Pool(function() : PathNode<T> {
			return { node: null, parent: null, cost: 0, distanceToEnd: 0 };
		});
		heuristics = _heuristics;
		exploreFrom = _exploreFrom;
	}

	public function findPath (start: T, target: T) : PathfinderOutput<T> {
		
		// Initialization
		var iterations : Int = 0;
		var bestNode : PathNode<T> = null;
		var currentNode : PathNode<T>;
		var newPathNode : PathNode<T> = pathNodes.get();
		newPathNode.node = start;
		newPathNode.parent = null;
		newPathNode.distanceToEnd = heuristics(start, target);
		newPathNode.cost = 0;
		var openList : Array<PathNode<T>> = [newPathNode];
		var closedList : List<PathNode<T>> = new List();
		var addToOpenList : Bool;
		var newCost : Float;

		// A* search
		Assertive.assert(maxIterations >= 0);
		while (!openList.empty() && iterations <= maxIterations) {
			
			iterations++;
			currentNode = openList.shift();
			closedList.push(currentNode);
			
			currentNode.distanceToEnd = heuristics(currentNode.node, target);
			if (bestNode == null || bestNode.distanceToEnd > currentNode.distanceToEnd) {
				bestNode = currentNode;
				if (bestNode.distanceToEnd == 0)
					break;
			}
			
			for (move in exploreFrom(currentNode.node)) {
				
				if (closedList.exists(function(n) { return heuristics(move.to, n.node) == 0; }))
					continue;
				
				addToOpenList = true;
				newCost = currentNode.cost + move.cost;
				for (n in openList) {
					if (heuristics(n.node, move.to) == 0) {
						addToOpenList = newCost < n.cost;
						if (addToOpenList) openList.remove(n);
						break;
					}
				}
				
				if (!addToOpenList)
					continue;
				
				newPathNode = pathNodes.get();
				newPathNode.node = move.to;
				newPathNode.parent = currentNode;
				newPathNode.distanceToEnd = heuristics(move.to, target);
				newPathNode.cost = newCost;
				for (i in 0...(openList.length+1)) {
					if (i == openList.length || newPathNode.distanceToEnd <= openList[i].distanceToEnd) {
						openList.insert(i, newPathNode);
						break;
					}
				}
				
			}
		}
		
		// Format output
		Assertive.assert(bestNode != null);
		var output = { cost: bestNode.cost, finalDistanceToTarget: bestNode.distanceToEnd, path: new List() };
		currentNode = bestNode;
		while (currentNode != null) {
			output.path.push(currentNode.node);
			currentNode = currentNode.parent;
		}
		output.path.pop();
		
		// Free pathnodes for reuse
		for (node in openList)
			pathNodes.free(node);		
		for (node in closedList)
			pathNodes.free(node);
		
		return output;
		
	}
	
}