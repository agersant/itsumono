package itsumono.path;
import massive.munit.Assert;

/**
 * @author agersant
 */

typedef Pint = {
	var x: Int;
	var y: Int;
};
 
class PathfinderTest {
	
	var heuristic1D : Int->Int->Int;
	var heuristic2D : Pint->Pint->Int;
	var explore1D : Int->List<Move<Int>>;
	var explore2D : Pint->List<Move<Pint>>;
	var map2DEmpty : Array<Array<Int>>;
	var map2DUShape : Array<Array<Int>>;
	var map2DSplit : Array<Array<Int>>;

	public function new() { }
	
	@Before
	public function setup() : Void {
		
		heuristic1D = function(i : Int, j : Int) : Int {
			return Math.round(Math.abs(i - j));
		}
		explore1D = function(i) : List<Move<Int>> {
			var moves : List<Move<Int>> = new List();
			moves.push({ to:i - 1, cost:1 });
			moves.push({ to:i + 1, cost:1 });
			return moves;
		}
		
		heuristic2D = function(i : Pint, j : Pint) : Int {
			return heuristic1D(i.x, j.x) + heuristic1D(i.y, j.y);
		}
		
		explore2D = function(p) : List<Move<Pint>> {
			var moves : List<Move<Pint>> = new List();
			for (i in -1...2) {
				for (j in -1...2) {
					if (i * j != 0 || i == j) continue;
					moves.push({ to:{ x: p.x + i, y: p.y + j}, cost:1 });
				}
			}
			return moves;
		}
		
		map2DEmpty =	[	[0, 0, 0, 0, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						];
						
		map2DUShape =	[	[0, 0, 0, 0, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						,	[0, 1, 0, 1, 0, 0]
						,	[0, 1, 0, 1, 0, 0]
						,	[0, 1, 1, 1, 0, 0]
						,	[0, 0, 0, 0, 0, 0]
						];
						
		map2DSplit =	[	[0, 0, 1, 0, 0, 0]
						,	[0, 0, 1, 0, 0, 0]
						,	[0, 0, 1, 0, 0, 0]
						,	[0, 0, 1, 0, 0, 0]
						,	[0, 0, 1, 0, 0, 0]
						,	[0, 0, 1, 0, 0, 0]
						];
	}
	
	@Test
	public function pathfind1D() : Void {
		var pathfinder = new Pathfinder(heuristic1D, explore1D);
		var result = pathfinder.findPath(40, 45);
		Assert.areEqual(0, result.finalDistanceToTarget);
		Assert.areEqual(5, result.cost);
		var i = 40;
		while (!Lambda.empty(result.path))
			Assert.areEqual(++i, result.path.pop());
	}
	
	@Test
	public function pathfind2DEmpty() : Void {
		var pathfinder = new Pathfinder(heuristic2D, function(p) {
			return Lambda.filter(explore2D(p), function(m : Move<Pint>) {
				if (m.to.x < 0 || m.to.x > 5) return false;
				if (m.to.y < 0 || m.to.y > 5) return false;
				if (map2DEmpty[m.to.y][m.to.x] != 0) return false;
				return true;
			});
		});
		var result = pathfinder.findPath({x: 1, y: 1}, {x: 5, y: 4});
		Assert.areEqual(0, result.finalDistanceToTarget);
		Assert.areEqual(7, result.cost);
	}
	
	@Test
	public function pathfind2DUShape() : Void {
		var pathfinder = new Pathfinder(heuristic2D, function(p) {
			return Lambda.filter(explore2D(p), function(m : Move<Pint>) {
				if (m.to.x < 0 || m.to.x > 5) return false;
				if (m.to.y < 0 || m.to.y > 5) return false;
				if (map2DUShape[m.to.y][m.to.x] != 0) return false;
				return true;
			});
		});
		var result = pathfinder.findPath({x: 2, y: 3}, {x: 2, y: 5});
		Assert.areEqual(0, result.finalDistanceToTarget);
		Assert.areEqual(10, result.cost);
	}
	
	@Test
	public function pathfind2DSplit() : Void {
		var pathfinder = new Pathfinder(heuristic2D, function(p) {
			return Lambda.filter(explore2D(p), function(m : Move<Pint>) {
				if (m.to.x < 0 || m.to.x > 5) return false;
				if (m.to.y < 0 || m.to.y > 5) return false;
				if (map2DSplit[m.to.y][m.to.x] != 0) return false;
				return true;
			});
		});
		var result = pathfinder.findPath({x: 0, y: 0}, {x: 5, y: 5});
		Assert.areEqual(4, result.finalDistanceToTarget);
		Assert.areEqual(6, result.cost);
	}
	
}