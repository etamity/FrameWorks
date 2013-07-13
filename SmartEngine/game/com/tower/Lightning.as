package com.tower 
{
	import com.data.BmpData;
	import com.enemy.EnemyBase;
	import com.map.Map;
	
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import starling.display.Shape;
	import starling.display.Sprite;

	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Lightning extends TowerBase 
	{
		private var _light:Shape;
		private var _timer:Timer;
		
		public function Lightning() 
		{
			this.defense = 90;
			this.damage = [525, 1050, 1575];
			this.cost = [70, 50, 50];
			this.bmpData = BmpData.Textures[BmpData.LIGHTNING];
			this.bmpPoint = BmpData.bmpPoints[BmpData.LIGHTNING];
			this.reloadTime = 1.5;
			
			_light = new Shape();
			Map.map.addBulletChild(_light);
			
			super();
		}
		
		private function createLight(mc:EnemyBase, angle:Number):void
		{
			//_light.rotation = angle;
			_light.x = this.x;
			_light.y = this.y;
			_light.graphics.lineStyle(2, 0xffffff);
			_light.graphics.moveTo(0, -30);
			_light.graphics.lineTo(mc.x - this.x, mc.y - this.y);
		}
		
		override protected function fire(mc:EnemyBase, angle:Number):void
		{
			this.changeState(true);
			createLight(mc, angle);
			mc.destroy(this.damage[this.level - 1], EnemyBase.DEATH_SHOCK);
			setTimeout(timeOut, 100);
		}
		
		protected function timeOut():void 
		{
			this.changeState(false);
			_light.graphics.clear();
		}
	}

}