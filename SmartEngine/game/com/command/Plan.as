package com.command 
{
	import flash.geom.Point;
	import com.tower.TowerBase;
	import com.map.Map;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Plan 
	{
		
		private const AROUND_POINT:Array = [[ -1, 0], [0, -1], [0, 1], [1, 0]];//当前点与四周点的差值
		
		private var _startPoint:Point;//起点位置
		private var _endPoint:Point;//终点位置
		private var _place:Array;//地图数据，一个二维数组，存的布尔值，假为不能通过
		private var _pendingList:Array;//待处理的点
		private var _parentList:Array;//父节点,一个二维数组
		private var _hasWay:Boolean;//是否找到路
		
		public function Plan(startPoint:Point)
		{
			_startPoint = startPoint;
			_place = createPlace();
			_parentList = createList();
			_pendingList = [new Point(_startPoint.x, _startPoint.y)];
			findWay();
		}
		
		private function findWay():void//寻路的主体，不断处理待处理的点，直到找到路或者没有处理待处理的点
		{
			var x:int, y:int;
			while (_pendingList.length != 0 && !_hasWay)
			{
				x = _pendingList[0].x;
				y = _pendingList[0].y;
				testGrid(x, y);
			}
		}
		
		private function getTrail():Array//当寻路结束后，计算出路线，是一个子元素为Point的数组
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
		
		private function testGrid(x:int, y:int):void//测试一个点的上下左右是否有可以搜索的点
		{
			_pendingList.shift();//把它从待检测列表移除
			_place[x][y] = false;//防止它再次被搜索
			var xx:int, yy:int;
			for (var i:int = 3; i > -1; i--)
			{
				xx = AROUND_POINT[i][0] + x;
				yy = AROUND_POINT[i][1] + y;
				if (_place[xx][yy])
				{
					if (xx != 21 || (yy != 6 && yy != 7))//判断是否找到路
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
		
		private function addPandingGrid(x:int, y:int, pX:int, pY:int):void//把一个点添加到_pendingList，并设置_parentList
		{
			_pendingList.push(new Point(x, y));//把它添加到待检测列表
			_place[x][y] = false;//防止它再次被搜索
			_parentList[x][y] = new Point(pX, pY);//设置父节点
		}
		
		private function createPlace():Array//处理地图数据
		{
			var arr:Array = [];
			var n:int = Map.place.length;
			var m:int = Map.place[0].length;
			for (var i:int = 0; i < n; i++)
			{
				arr[i] = [];
				for (var j:int = 0; j < m; j++)
				{
					//是否为障碍就是在这里判断的
					arr[i][j] = (i < 2 || i == 21 || j < 1 || j == 12 || hasBlock(i, j))?false:true;
				}
			}
			arr[1][6] = true;
			arr[1][7] = true;
			arr[21][6] = true;
			arr[21][7] = true;
			return arr;
		}
		
		private function hasBlock(x:int, y:int):Boolean//判断是否有障碍
		{
			for each(var i in Map.place[x][y])
			{
				if (i is TowerBase) return true;
			}
			return false;
		}
		
		private function createList():Array//创造一个二维数组，主要用于_parentList
		{
			var arr:Array = [];
			for (var i:int = 0; i < Map.place.length; i++)
			{
				arr[i] = [];
			}
			return arr;
		}
		
		public static function doPlan(startPoint:Point):Array//一个静态方法，方便使用
		{
			var plan:Plan = new Plan(startPoint);
			return plan.getTrail();
		}
	}
}