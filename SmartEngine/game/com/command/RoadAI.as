/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.command 
{
	import flash.geom.Point;
	import com.tower.TowerBase;
	import com.map.Map;

	public class RoadAI 
	{
		
		private const AROUND_POINT:Array = [[ -1, 0], [0, -1], [0, 1], [1, 0]];
		
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _place:Array;
		private var _pendingList:Array;
		private var _parentList:Array;
		private var _hasWay:Boolean;
		
		public function RoadAI(startPoint:Point)
		{
			_startPoint = startPoint;
			_place = createPlace();
			_parentList = createList();
			_pendingList = [new Point(_startPoint.x, _startPoint.y)];
			findWay();
		}
		
		private function findWay():void
		{
			var x:int, y:int;
			while (_pendingList.length != 0 && !_hasWay)
			{
				x = _pendingList[0].x;
				y = _pendingList[0].y;
				testGrid(x, y);
			}
		}
		
		private function getTrail():Array
		{
			if (!_hasWay) return null;
			
			var arr:Array = [];
			var x:int = _endPoint.x;
			var y:int = _endPoint.y;
			while (x != _startPoint.x || y != _startPoint.y)
			{
				var point:Point = _parentList[x][y];
				arr.unshift(point);
				x = point.x;
				y = point.y;
			}
			arr.push(_endPoint);
			return arr;
		}
		
		private function testGrid(x:int, y:int):void
		{
			_pendingList.shift();
			_place[x][y] = false;
			var xx:int, yy:int;
			for (var i:int = 3; i > -1; i--)
			{
				xx = AROUND_POINT[i][0] + x;
				yy = AROUND_POINT[i][1] + y;
				if (_place[xx])
				if (_place[xx][yy])
				{
					if (xx != 21 || (yy != 6 && yy != 7))
					{
						addPandingGrid(xx, yy, x, y);
					}
					else
					{
						_hasWay = true;
						_endPoint = new Point(xx, yy);
						_parentList[xx][yy] = new Point(x, y);
						return;
					}
				}
			}
		}
		
		private function addPandingGrid(x:int, y:int, pX:int, pY:int):void
		{
			_pendingList.push(new Point(x, y));
			_place[x][y] = false;
			_parentList[x][y] = new Point(pX, pY);
		}
		
		private function createPlace():Array
		{
			var arr:Array = [];
			var n:int = Map.place.length;
			var m:int = Map.place[0].length;
			for (var i:int = 0; i < n; i++)
			{
				arr[i] = [];
				for (var j:int = 0; j < m; j++)
				{
	
					arr[i][j] = (i < 2 || i == 21 || j < 1 || j == 12 || hasBlock(i, j))?false:true;
				}
			}
			arr[1][6] = true;
			arr[1][7] = true;
			arr[21][6] = true;
			arr[21][7] = true;
			return arr;
		}
		
		private function hasBlock(x:int, y:int):Boolean
		{
			for each(var i:Object in Map.place[x][y])
			{
				if (i is TowerBase) return true;
			}
			return false;
		}
		
		private function createList():Array
		{
			var arr:Array = [];
			for (var i:int = 0; i < Map.place.length; i++)
			{
				arr[i] = [];
			}
			return arr;
		}
		
		public static function doPlan(startPoint:Point):Array
		{
			var plan:RoadAI = new RoadAI(startPoint);
			return plan.getTrail();
		}
	}
}