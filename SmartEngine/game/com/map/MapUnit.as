package com.map 
{
	import com.enemy.EnemyBase;
	
	import starling.display.Sprite;
	
	
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class MapUnit extends Sprite 
	{
		protected var mapX:int;//在“地图”的x
		protected var mapY:int;//在“地图”的y
		
		private var _w:int;//在“地图”的宽
		private var _h:int;//在“地图”的高
		private var _place:Array;//地图
		
		public function MapUnit() 
		{
			_place = Map.place;
			
			if (this is EnemyBase)
			{
				_w = this.width < 52?1:this.width / 52;
				_h = this.height < 52?1:this.height / 52;
			}
			else
			{
				_w = 1;
				_h = 1;
			}
			
			formatIntfo();
			
			addToMap();
		}
		
		private function formatIntfo():void//将对象的位置相关属性格式化
		{
			mapX = Math.round(this.x / 36);
			if (mapX < 0) mapX = 0;
			if (mapX > 21) mapX = 21;
			
			mapY = Math.round(this.y / 36);
			if (mapY < 0) mapY = 0;
			if (mapY > 12) mapY = 12;
		}
		
		private function findGridInMap(fun:Function):void//遍历在地图中的所占方格
		{
			for (var i:int = mapX; i < mapX + _w; i++)
			{
				for (var j:int = mapY; j < mapY + _h; j++)
				{
					fun(i, j);
				}
			}
		}
		
		protected function addToMap():void//添加到地图
		{
			Map.map.addChild(this);
			
			findGridInMap(addToMapFun);
		}
		
		private function addToMapFun(i:int, j:int):void//添加到地图位置数组
		{
			_place[i][j].push(this);
		}
		
		public function removeFromMap():void//从地图移除
		{
			this.parent.removeChild(this);
			
			findGridInMap(removeFromMapFun);
		}
		
		private function removeFromMapFun(i:int, j:int):void//移除在地图位置的数组引用
		{
			_place[i][j].splice(_place[i][j].indexOf(this), 1);
		}
		
		protected function setPoint(xx:Number, yy:Number):void//设置位置属性
		{
			findGridInMap(removeFromMapFun);
			
			this.x = xx;
			this.y = yy;
			
			formatIntfo();
			
			findGridInMap(addToMapFun);
		}
	}

}