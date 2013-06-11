package switcher.models
{
	import flash.geom.Point;


	public class GameModel
	{
		private var _mapSize:Point=new Point(8,8);
		
		private var _gameTime:int=60;  // 1 minute
		
		private var _cellsData:Array=new Array();
		
		private var _stoneData:Array=[
			StoneType.BLUE,
			StoneType.RED,
			StoneType.GREEN,
			StoneType.PURPLE,
			StoneType.YELLOW
		];
		public function get rowCount():int{
			return _mapSize.x;
		}
		public function get colCount():int{
			return _mapSize.y;
		}
		public function get cellCount():int{
			return _mapSize.x*_mapSize.y;
		}
		public function GameModel()
		{
		}
		
		public function get cellsData():Array{
			return _cellsData;
		}
		public function get stoneData():Array{
			return _stoneData;
		}
		public function getStone(index:int):String{
			return _stoneData[index];
		}
	
		public function getIndex(x:int,y:int):int{
			var index:int=y*_mapSize.y+x;
			return index;
		}

		public function checkBounds(id:int):void{
			
			
		}
	}
}