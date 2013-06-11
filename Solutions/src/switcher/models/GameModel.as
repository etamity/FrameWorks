package switcher.models
{
	import flash.geom.Point;


	public class GameModel
	{
		private var _mapSize:Point=new Point(8,8);
		
		private var _gameTime:int=60;  // 1 minute
		
		private var _grids:Array=[[]];
		
		public var stoneFirst:int=-1;
		public var stoneLast:int=-1;
		
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
			createCells();
		}
		
		public function getSideStones(id:int):Array{
			var stones:Array=new Array();
			if (checkBoundsValid(id+1)==true)
				stones.push(id+1);
			if (checkBoundsValid(id-1)==true)
				stones.push(id-1);
			if (checkBoundsValid(id+rowCount)==true)
				stones.push(id+rowCount);
			if (checkBoundsValid(id-rowCount)==true)
				stones.push(id-rowCount);
			return stones;
		}
		
		private function createCells():void{
			for(var b:uint=0;b<_mapSize.y;b++){
				_grids[b]=new Array();
				for(var a:uint=0;a<10;a++){
					_grids[b][a]=0;
				}   
			}
		}
		public function get grids():Array{
			return _grids;
		}
		public function get stoneData():Array{
			return _stoneData;
		}
		public function getStone(index:int):String{
			return _stoneData[index];
		}
		
		public function switchStoneData(a:int,b:int):Boolean{
			var result:Boolean= false;
			//var obj:Object= 
			
			return result;
		}
		public function getIndex(x:int,y:int):int{
			var index:int=y*_mapSize.y+x;
			return index;
		}
		
		public function checkBoundsValid(id:int):Boolean{
			var result:Boolean=false;
			if ((id>=0) && (id <=cellCount))
				result = true;
			return result;
			
		}
	}
}