package itsumono.ds;
import haxe.ds.BalancedTree.TreeNode;
import massive.munit.Assert;

/**
 * @author agersant
 */

class PoolTest {

	var pool : Pool<TreeNode<Int,Int>>;
	
	public function new() { }
	
	@Before
	public function setup() : Void {
		pool = new Pool(
			function() { return new TreeNode(null, 0, 0, null); }
		,	function(o) { o.value = 0; }
		);
	}
	
	@After
	public function tearDown() : Void {
		pool = null;
	}
	
	@Test
	public function getInstance() : Void {
		var node = pool.get();
		Assert.isNotNull(node);
	}
	
	@Test
	public function reuseFreeInstance() : Void {
		var node1 = pool.get();
		pool.free(node1);
		var node2 = pool.get();
		Assert.areEqual(node1, node2);
	}
	
	@Test
	public function resetBeforeReuse() : Void {
		var node1 = pool.get();
		node1.value = 64;
		pool.free(node1);
		var node2 = pool.get();
		Assert.areEqual(node1.value, 0);
		Assert.areEqual(node2.value, 0);
	}
	
}