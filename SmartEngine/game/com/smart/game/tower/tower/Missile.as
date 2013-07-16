/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/


package com.smart.game.tower.tower 
{
	import com.smart.game.tower.data.GraphicsData;
	import com.smart.game.tower.enemy.EnemyObject;
	import com.smart.game.tower.model.Map;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;


	public class Missile extends TowerObject 
	{
		private var _bmp:Sprite;
		private var _timer:Timer;
		private var _enemy:EnemyObject;
		private var _canFire:Boolean = true;
		
		public function Missile() 
		{
			this.defense = 120;
			this.damage = [105, 195, 285];
			this.cost = [20, 15, 15];
			this.bmpData = GraphicsData.Textures[GraphicsData.MISSILE];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.MISSILE];
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
			angle *= Math.PI / 180;
			_bmp.rotation = angle;
			var xx:Number = 5 * Math.sin(angle);
			var yy:Number = 5 * Math.cos(angle) * -1;
			_bmp.x += xx;
			_bmp.y += yy;
			if (_bmp.hitTest(new Point(_enemy.pivotX,_enemy.y))  || !_enemy.isLife)
			{
				_bmp.visible = false;
				_canFire = true;
				_timer.reset();
				if (_enemy.isLife)_enemy.destroy(this.damage[this.level - 1], EnemyObject.DEATH_COMMON);
			}
		}
		
		override protected function fire(mc:EnemyObject, angle:Number):void
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
			data.copyPixels(new projectile_missile(), new Rectangle(0, 0, 17, 45), new Point);
			var texture:Texture = Texture.fromBitmapData(data);
			var image :Image= new Image(texture);
			image.x = -8;
			image.y = -22;
			_bmp.addChild(image);
		}
	}

}