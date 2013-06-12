package switcher.models
{
	public class Node
	{
		
		public static const LEFT:String="LEFT";
		public static const UP:String="UP";
		public static const DOWN:String="DOWN";
		public static const RIGHT:String="RIGHT";
		
		public var left:Node;
		
		public var right:Node;
		
		public var up:Node;
		
		public var down:Node;
		
		public var data:Object;
		

		public function Node()
		{
		}
	
		public function next(direct:String):Node{
			var result:Node;
			switch (direct){
				case LEFT:
					result=left;
					break;
				case RIGHT:
					result=right;
					break;
				case UP:
					result=up;
					break;
				case DOWN:
					result=down;
					break;
			}
			return result;
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