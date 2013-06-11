package switcher.models
{
	public class Node
	{
		
		public var left:Node;
		
		public var right:Node;
		
		public var up:Node;
		
		public var down:Node;
		
		public var data:Object;
		

		public function Node()
		{
		}
	

		public function clone():Node{
			var node:Node=new Node();
			node.data=data;
			node.left=left;
			node.right=right;
			node.up=up;
			node.down=down;
			return node;
		}
		
	}
}