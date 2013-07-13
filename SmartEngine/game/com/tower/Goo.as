package com.tower 
{
	import com.data.BmpData;
	import com.enemy.EnemyBase;
	import com.map.Map;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Goo extends TowerBase 
	{
		private var _timer:Timer;
		private var _bmp:Sprite;
		private var _moveX:Number;
		private var _moveY:Number;
		private var _canFire:Boolean = true;
		private var _enemy:EnemyBase;
		
		public function Goo() 
		{
			this.defense = 90;
			this.damage = [35, 50, 65];
			this.cost = [10, 5, 5];
			this.bmpData = BmpData.Textures[BmpData.GOO];
			this.bmpPoint = BmpData.bmpPoints[BmpData.GOO];
			this.reloadTime = 1.2;
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_bmp = new Sprite();
			_bmp.scaleX = 0.6;
			_bmp.scaleY = 0.6;
			_bmp.visible = false;
			Map.map.addBulletChild(_bmp);
			createBmp();
			
			super();
		}
		
		override public function changeSpeed(fast:Boolean):void
		{
			super.changeSpeed(fast);
			_timer.delay = fast?20:100;
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			_bmp.x += _moveX;
			_bmp.y += _moveY;
			if (_bmp.hitTest(new Point(_enemy.pivotX,_enemy.y)) || _timer.currentCount == 20)
			{
				_timer.reset();
				_canFire = true;
				_bmp.visible = false;
				if ( _timer.currentCount != 20)
				_enemy.moderate(this.damage[3 - this.level] / 100);
			}
		}
		
		private function createBmp():void
		{
			var data:BitmapData = new BitmapData(18, 39);
			//data.copyPixels(new projectile_goo(), new Rectangle(0, 0, 18, 39), new Point);
			var texture:Texture = Texture.fromBitmapData(data);
			var image :Image= new Image(texture);
			image.x = -9;
			image.y = -20;
			_bmp.addChild(image);
		}
		
		override protected function fire(mc:EnemyBase, angle:Number):void
		{
			if (!_canFire) return;
			startFire(mc, angle);
		}
		
		private function startFire(mc:EnemyBase, angle:Number):void
		{
			_bmp.rotation = angle;
			angle *= Math.PI / 180;
			_moveX = 5 * Math.sin(angle);
			_moveY = 5 * Math.cos(angle) * -1;
			_bmp.x = _moveX * 6 + this.x;
			_bmp.y = _moveY * 6 + this.y - 12;
			_bmp.visible = true;
			_canFire = false;
			_enemy = mc;
			_timer.start();
		}
	}

}