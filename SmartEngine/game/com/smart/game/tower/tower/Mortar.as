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

	public class Mortar extends TowerObject 
	{
		private var _bmp:Sprite;
		private var _timer:Timer;
		private var _enemy:EnemyObject;
		private var _canFire:Boolean = true;
		
		public function Mortar() 
		{
			this.defense = 145;
			this.damage = [1300, 2600, 3900];
			this.cost = [120, 90, 90];
			this.bmpData = GraphicsData.Textures[GraphicsData.MORTAR];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.MORTAR];
			this.reloadTime = 2;
			
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
			var angle:Number = Math.atan2 ((_enemy.y - _bmp.y), (_enemy.x - _bmp.x)) +  Math.PI / 2;
			_bmp.rotation=angle;
			var xx:Number = 10 * Math.sin(angle);
			var yy:Number = 10 * Math.cos(angle) * -1;
			_bmp.x += xx;
			_bmp.y += yy -2;
			if (_timer.currentCount < 6) this.fireAni(_timer.currentCount-1);
			if (_bmp.hitTest(new Point(_enemy.pivotX,_enemy.y)) || !_enemy.isLife)
			{
				_bmp.visible = false;
				_canFire = true;
				_timer.reset();
				if (_enemy.isLife)_enemy.destroy(this.damage[this.level - 1], EnemyObject.DEATH_COMMON);
				this.changeState(false);
			}
		}
		
		override protected function fire(mc:EnemyObject, angle:Number):void
		{
			if (!_canFire) return;
			_bmp.x = this.x;
			_bmp.y = this.y;
			_enemy = mc;
			_bmp.visible = true;
			_canFire = false;
			this.changeState(true);
			_timer.start();
		}
		
		private function createBmp():void
		{
			var data:BitmapData = new BitmapData(31, 60);
			data.copyPixels(new projectile_mortar(), new Rectangle(0, 0, 31, 60), new Point);
			var texture:Texture = Texture.fromBitmapData(data);
			var image :Image= new Image(texture);
			image.x = -15;
			image.y = -50;
			_bmp.addChild(image);
		}
	}

}