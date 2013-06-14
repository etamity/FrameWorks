/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.models
{
	import flash.display.Shape;
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
		
		public var cellWidth:int =43;
		public var cellHeight:int =43;
		public var cellOffetX:int =8;
		public var cellOffetY:int =5;
		
		public static var stoneDict:Array=[
			StoneType.BLUE,
			StoneType.RED,
			StoneType.GREEN,
			StoneType.PURPLE,
			StoneType.YELLOW
		];
		
		public function getCellX(val:int):int{
			var x:int;
			x=val * cellWidth+cellOffetX;
			return x;
		}
		public function getCellY(val:int):int{
			var y:int;
			y=val * cellHeight+cellOffetY;
			return y;
		}
		
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
		
		private function get2Dgirds():Array{
			var temp:Array=[[]];
			for(var b:uint=0;b<colCount;b++){
				temp[b]=new Array();
				for(var a:uint=0;a<rowCount;a++){
					temp[b][a]=0;
				}   
			}
			return temp;
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
			return stoneDict;
		}
		public function getStone(index:int):String{
			return stoneDict[index];
		}
		
		public function getIndex(x:int,y:int):int{
			var index:int=y*_mapSize.y+x;
			return index;
		}
		public function getGridColStone(index:int):Array{
			var tem:Array=[];
			for (var i:int=0;i<colCount;i++)
			{
				tem.push(grids[i][index].stone);
			}
			return tem;
		}
		public function getGridRowStone(index:int):Array{
			var tem:Array=[];
			for (var i:int=0;i<rowCount;i++)
			{
				tem.push(grids[index][i].stone);
			}
			return tem;
		}
		public function getGridCol(index:int):Array{
			  return grids[index];
		}
		public function getGridRow(index:int):Array{
			var tem:Array=[];
			for (var i:int=0;i<rowCount;i++)
			{
				tem.push([index][i]);
			}
			return tem;
		}
		public function getStonesInCell():Array{
			var stones:Array=get2Dgirds();
			var cell:CellView;
			for(var b:uint=0;b<colCount;b++){
				for(var a:uint=0;a<rowCount;a++){
					cell=_grids[b][a];
					stones[b][a]=cell.stone;
				}
			}
			
			return stones;
		}
		public function generateMask(id:String, w:int=360, h:int=355):Shape {
			var rectMask:Shape = new Shape();
			rectMask.name = "mask" + id;
			rectMask.graphics.beginFill(0xFF0000, 1);
			rectMask.graphics.drawRect(0, 0, w, h);
			rectMask.graphics.endFill();
			return rectMask;
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