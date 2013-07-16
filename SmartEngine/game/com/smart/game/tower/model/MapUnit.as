/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.smart.game.tower.model 
{
	import com.smart.game.tower.enemy.EnemyBase;
	
	import starling.display.Sprite;

	public class MapUnit extends Sprite 
	{
		protected var mapX:int;
		protected var mapY:int;
		
		private var _w:int;
		private var _h:int;
		private var _place:Array;
		
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
		
		private function formatIntfo():void
		{
			mapX = Math.round(this.x / 36);
			if (mapX < 0) mapX = 0;
			if (mapX > 21) mapX = 21;
			
			mapY = Math.round(this.y / 36);
			if (mapY < 0) mapY = 0;
			if (mapY > 12) mapY = 12;
		}
		
		private function findGridInMap(fun:Function):void
		{
			for (var i:int = mapX; i < mapX + _w; i++)
			{
				for (var j:int = mapY; j < mapY + _h; j++)
				{
					fun(i, j);
				}
			}
		}
		
		protected function addToMap():void
		{
			Map.map.addChild(this);
			
			findGridInMap(addToMapFun);
		}
		
		private function addToMapFun(i:int, j:int):void
		{
			_place[i][j].push(this);
		}
		
		public function removeFromMap():void
		{
			this.parent.removeChild(this);
			
			findGridInMap(removeFromMapFun);
		}
		
		private function removeFromMapFun(i:int, j:int):void
		{
			_place[i][j].splice(_place[i][j].indexOf(this), 1);
		}
		
		protected function setPoint(xx:Number, yy:Number):void
		{
			findGridInMap(removeFromMapFun);
			
			this.x = xx;
			this.y = yy;
			
			formatIntfo();
			
			findGridInMap(addToMapFun);
		}
	}

}