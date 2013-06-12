package switcher.models
{
	import flash.geom.Point;
	
	import switcher.views.natives.views.CellView;


	public class GameModel
	{
		private var _mapSize:Point=new Point(8,8);
		
		private var _gameTime:int=60;  // 1 minute
		
		private var _grids:Array=[[]];
		
		private var _cells:Array=[];
		
		private var _bulletList:Array=[];
		
		public var selectedCell:CellView;
		
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
		
		private function createCells():void{
			for(var b:uint=0;b<colCount;b++){
				_grids[b]=new Array();
				for(var a:uint=0;a<rowCount;a++){
					_grids[b][a]=new CellView();
				}   
			}
		}
		public function set bulletList(val:Array):void{
			_bulletList=val;
		}
		public function get bulletList():Array{
			return _bulletList;
		}
		public function get grids():Array{
			return _grids;
		}
		public function get cells():Array{
			return _cells;
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

		
		public function checkBoundsValid(a:int,b:int,direct:String):Boolean{
			var result:Boolean=false;
			switch (direct){
				case "LEFT":
					if (a-1>=0)
						result = true;
					break;
				case "RIGHT":
					if (a+1<rowCount)
						result = true;
					break;
				case "DOWN":
					if (b+1<colCount)
						result = true;
					break;
				case "UP":
					if (b-1>=0)
						result = true;
					break;
				
			}

			return result;
			
		}
	}
}