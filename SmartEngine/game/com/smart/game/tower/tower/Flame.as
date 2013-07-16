/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/


package com.smart.game.tower.tower 
{
	import com.smart.game.tower.data.GraphicsData;
	import flash.display.Shape;
	import com.smart.game.tower.enemy.EnemyObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import com.smart.game.tower.model.Map;

	public class Flame extends TowerObject 
	{
		private var _flame:Fire;
		private var _timeId:int;
		
		public function Flame() 
		{
			this.defense = 72;
			this.damage = [400, 800, 1200];
			this.cost = [50, 40, 40];
			this.bmpData = GraphicsData.Textures[GraphicsData.FLAME];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.FLAME];
			this.reloadTime = 1;
			
			_flame = new Fire(30, 30);
			Map.map.addBulletChild(_flame);
			
			super();
		}
		
		override protected function fire(mc:EnemyObject, angle:Number):void
		{
			mc.destroy(this.damage[this.level - 1], EnemyObject.DEATH_COMMON);
			changeFireDirection(mc, angle);
			if (!_flame.isPlay)
			{
				_flame.start();
				this.changeState(true);
			}
			clearTimeout(_timeId);
			_timeId = setTimeout(timeOut, 1000);
		}
		
		private function changeFireDirection(mc:EnemyObject, angle:Number):void
		{
	
			angle *= Math.PI / 180;
			_flame.rotation = angle;
			_flame.x = 80 * Math.sin(angle) + this.x;
			_flame.y = -80 * Math.cos(angle) + this.y - 20;
		}
		
		private function timeOut():void
		{
			_flame.stop();
			this.changeState(false);
		}
	}

}