/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.smart.game.tower.tower 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Shape;

	public class Fire extends Shape 
	{
		private static const colors:Array = [0xffff00, 0xffff00, 0xffff00, 0xffff00, 0xff0000];
		
		private var _w:int;
		private var _h:int;
		private var _timer:Timer;
		
		public var isPlay:Boolean;

		public function Fire(w:int, h:int) 
		{
			_w = w;
			_h = h / 2;
			
			_timer = new Timer(200);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			this.visible = false;
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			drawFire();
		}
		
		public function start():void
		{
			this.visible = true;
			_timer.start();
			isPlay = true;
		}
		
		public function stop():void
		{
			this.visible = false;
			_timer.stop();
			isPlay = false;
		}
		
		private function drawFire():void
		{
			this.graphics.clear();
			for (var i:int = 0; i < _w; i++)
			{
				var num1:int = Math.abs(i - 15) - Math.random() * 5;
				var num2:int = _h - Math.abs(i - _w / 2) + Math.random() * 20;
				for (var j:int = num1; j < num2; j++)
				{
					this.graphics.beginFill(colors[int(Math.random() * 5)], 0.3);
					this.graphics.drawCircle(i - _w / 2, j * 2, 2);
					this.graphics.endFill();
				}
			}
		}
	}

}