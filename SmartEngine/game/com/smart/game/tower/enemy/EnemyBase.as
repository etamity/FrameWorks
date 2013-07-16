/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy
{
	import com.smart.game.tower.data.EnemyFormat;
	import com.smart.game.tower.event.DisappearEvent;
	import com.smart.game.tower.model.AutoAttack;
	import com.smart.game.tower.ui.Control;
	import com.smart.game.tower.model.MapUnit;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;

	public class EnemyBase extends MapUnit
	{
		public static const DEATH_COMMON:String="death_common";
		public static const DEATH_SHOCK:String="death_shock";

		private static const STARTPOINT1:Point=new Point(0, 7 * 36);
		private static const STARTPOINT2:Point=new Point(0, 7 * 36);

		public var isLife:Boolean; 

		protected var speed:Number=0; 
		protected var healthTotal:int; 
		protected var bmpData:Array; 
		protected var bmpPoint:Array; 
		protected var startPoint:int; //startPoint(1,6)||(1,7)
		protected var score:int; 
		protected var modifier:Number=0; 

		private var _startPoint:Point; 
		private var _haemalStrand:Shape; 
		private var _timeoutId:int; 
		private var _timer:Timer;
		private var _animation:MovieClip; 
		private var _healthNow:int; 
		private var _speed:Number; 
		private var _moderateId:int; 
		private var _display:MovieClip;

		private var _healthBar:Shape;
		
		public function EnemyBase()
		{
			super();
			_startPoint=startPoint == 0 ? STARTPOINT1 : STARTPOINT2;
			this.x=_startPoint.x;
			this.y=_startPoint.y;
			isLife=true;
			_speed=speed;

			_healthNow=healthTotal;

			creatAnimation(EnemyFormat.MOVE_90);

			creatHaemalStrand();

			_timer=new Timer(100);
			changeSpeed(AutoAttack.moveFast);
			_timer.addEventListener(TimerEvent.TIMER, move);
			_timer.start();


		}

		public function get display():MovieClip
		{
			return _display;
		}

		
		public function play():void{
			_timer.start();
			_display.play();
		}
		
		
		public function stop():void{
			_timer.stop();
			_display.stop();
		}
		protected function move(e:TimerEvent):void 
		{
			if (this.x >= 900)
			{
				arriveEnd();
			}
			else
			{
				playAnimation();
			}
		}

		public function moderate(size:Number):void 
		{
			clearTimeout(_moderateId);
			speed=_speed * size;
			_moderateId=setTimeout(recoverTime, _timer.delay * 20);
		}

		protected function recoverTime():void 
		{
			speed=_speed;
		}
		
		private function arriveEnd():void 
		{
			over(null);
			Control.control.changeLife();
		}

		public function changeSpeed(fast:Boolean):void 
		{
			_timer.delay=fast ? 20 : 100;
		}

		protected function creatAnimation(id:int):void  
		{
			var vectorTextures:Vector.<Texture>=Vector.<Texture>(bmpData[id]);
			if (vectorTextures==null) return;
			if (_display != null)
			{
				this.removeChild(_display);
				Starling.juggler.remove(_display);
			}

			_display=null;

			_display=new MovieClip(vectorTextures, 22);
			_display.readjustSize();
			this.addChild(_display);
			_display.addEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
			
			Starling.juggler.add(_display);
			playAnimation();


		}
		private function onFrame(evt:EnterFrameEvent):void
		{
			MovieClip(evt.target).readjustSize();
		}
		
		protected function playAnimation():void 
		{
			_display.play();
		}

		private function creatHaemalStrand():void 
		{
			_haemalStrand=new Shape();
			addChild(_haemalStrand);
			drawRect(_haemalStrand, 0xff0000);

			_healthBar=new Shape();
			drawRect(_healthBar, 0x00ff00);
			addChild(_healthBar);
			//_haemalStrand.x=-10;
			//_haemalStrand.y=this.height * -0.8;
			_haemalStrand.visible=false;
		}

		private function changeHaemalStrand():void 
		{
			clearTimeout(_timeoutId);
			var num:Number=_healthNow / healthTotal;
			_healthBar.scaleX=num < 0 ? 0 : num;
			_timeoutId=setTimeout(hideHaemalStrand, 2000);
			_haemalStrand.visible=true;
		}

		private function hideHaemalStrand():void  
		{
			_haemalStrand.visible=false;
		}

		private function drawRect(sp:Shape, color:uint):void 
		{
			sp.graphics.clear();
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(0, 0, 20, 2);
			sp.graphics.endFill();
		}

		public function destroy(size:int, mode:String):void 
		{
			_healthNow-=size;
			if (_healthNow <= 0)
			{
				over(mode);
				Control.control.changeScore(this.score * this.modifier);
				Control.control.changeCost(this.score / 100, true);
			}
			changeHaemalStrand();
		}

		private function over(mode:String):void 
		{
			_timer.stop();
			isLife=false;
			_haemalStrand.visible=false;
			this.dispatchEvent(new DisappearEvent(DisappearEvent.DISAPPEAR, this));
			if (mode == DEATH_COMMON)
			{
				deathAnimation(EnemyFormat.DEATH_COMMON_90);
			}
			else if (mode == DEATH_SHOCK)
			{
				deathAnimation(EnemyFormat.DEATH_SHOCK_90);
			}
			else
			{
				this.removeFromMap();
			}
		}

		private function deathAnimation(id:int):void 
		{
			creatAnimation(id);
			var timer:Timer=new Timer(20, bmpData.length);
			timer.addEventListener(TimerEvent.TIMER, onTomer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			timer.start();
		}

		private function onComplete(e:TimerEvent):void 
		{
			this.removeFromMap();
		}

		private function onTomer(e:TimerEvent):void 
		{
			playAnimation();
		}
	}

}
