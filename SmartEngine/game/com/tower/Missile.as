package com.tower 
{
	import com.data.BmpData;
	import com.enemy.EnemyBase;
	import com.map.Map;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Missile extends TowerBase 
	{
		private var _bmp:Sprite;
		private var _timer:Timer;
		private var _enemy:EnemyBase;
		private var _canFire:Boolean = true;
		
		public function Missile() 
		{
			this.defense = 120;
			this.damage = [105, 195, 285];
			this.cost = [20, 15, 15];
			this.bmpData = BmpData.bmpDatas[BmpData.MISSILE];
			this.bmpPoint = BmpData.bmpPoints[BmpData.MISSILE];
			this.reloadTime = 1.5;
			
			_bmp = new Sprite();
			_bmp.scaleX = 0.6;
			_bmp.scaleY = 0.6;
			_bmp.visible = false;
			Map.map.addBulletChild(_bmp);
			createBmp();
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			super();
		}
		
		override public function changeSpeed(fast:Boolean):void
		{
			super.changeSpeed(fast);
			_timer.delay = fast?20:100;
		}
		
		private function onTimer(e:Event):void 
		{
			var angle:Number = Math.atan2 ((_enemy.y - _bmp.y), (_enemy.x - _bmp.x)) * 180 / Math.PI + 90;
			_bmp.rotation = angle;
			angle *= Math.PI / 180;
			var xx:Number = 5 * Math.sin(angle);
			var yy:Number = 5 * Math.cos(angle) * -1;
			_bmp.x += xx;
			_bmp.y += yy;
			if (_bmp.hitTestObject(_enemy) || !_enemy.isLife)
			{
				_bmp.visible = false;
				_canFire = true;
				_timer.stop();
				if (_enemy.isLife)_enemy.destroy(this.damage[this.level - 1], EnemyBase.DEATH_COMMON);
			}
		}
		
		override protected function fire(mc:EnemyBase, angle:Number):void
		{
			if (!_canFire) return;
			_bmp.x = this.x;
			_bmp.y = this.y;
			_bmp.rotation = angle;
			_enemy = mc;
			_bmp.visible = true;
			_canFire = false;
			_timer.start();
		}
		
		private function createBmp():void
		{
			var data:BitmapData = new BitmapData(17, 45);
			//data.copyPixels(new projectile_missile(), new Rectangle(0, 0, 17, 45), new Point);
			var bmp:Bitmap = new Bitmap(data);
			bmp.x = -8;
			bmp.y = -22;
			_bmp.addChild(bmp);
		}
	}

}