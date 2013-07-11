package com.enemy 
{
	import com.event.DisappearEvent;
	import com.map.AutoAttack;
	import com.map.MapPart;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.Timer;
	import com.data.EnemyFormat;
	import com.map.Control;
	
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class EnemyBase extends MapPart 
	{
		public static const DEATH_COMMON:String = "death_common";
		public static const DEATH_SHOCK:String = "death_shock";
		
		private static const STARTPOINT1:Point = new Point(0, 6 * 36);
		private static const STARTPOINT2:Point = new Point(0, 7 * 36);
		
		public var isLife:Boolean;//是否挂掉
		
		protected var speed:Number = 0;//当前移动速度
		protected var healthTotal:int;//总的血量
		protected var bmpData:Array;//处理好的位图
		protected var bmpPoint:Array;//位图数据对应的位置
		protected var startPoint:int;//起点(1,6)||(1,7)
		protected var score:int;//分数
		protected var modifier:Number = 0;//healthTotal的增加倍数
		
		private var _startPoint:Point;//起点
		private var _haemalStrand:Sprite;//血条
		private var _timeoutId:int;//用于clearTimeout
		private var _timer:Timer;//计时器
		private var _animation:MovieClip;//动画
		private var _healthNow:int;//当前的血量
		private var _speed:Number;//初始的移动速度
		private var _moderateId:int;//用于clearTimeout
		
		public function EnemyBase() 
		{
			_startPoint = startPoint == 0?STARTPOINT1:STARTPOINT2;
			this.x = _startPoint.x;
			this.y = _startPoint.y;
			isLife = true;
			_speed = speed;
			
			_healthNow = healthTotal;
			
			creatAnimation(EnemyFormat.MOVE_90);
			
			creatHaemalStrand();
			
			_timer = new Timer(100);
			changeSpeed(AutoAttack.moveFast);
			_timer.addEventListener(TimerEvent.TIMER, move);
			_timer.start();
			
			super();
		}
		
		protected function move(e:TimerEvent):void//移动
		{
			if (this.x >= 735) 
			{
				arriveEnd();
			}
			else
			{
				playAnimation();
			}
		}
		
		public function moderate(size:Number):void//减速
		{
			clearTimeout(_moderateId);
			speed = _speed * size;
			_moderateId = setTimeout(timee, _timer.delay * 20);
		}
		
		protected function timee():void //恢复速度
		{
			speed = _speed;
		}
		
		private function arriveEnd():void//到达终点
		{
			over(null);
			Control.control.changeLife();
		}
		
		public function changeSpeed(fast:Boolean):void//改变速度
		{
			_timer.delay = fast?20:100;
		}
		
		override public function play():void//播放
		{
			super.play();
			_timer.start();
		}
		
		override public function stop():void//暂停
		{
			super.stop();
			_timer.stop();
		}
		
		protected function creatAnimation(id:int):void//构建一个可以添加“帧”的movieclip
		{
			if (_animation)
			{
				while (_animation.numChildren > 0)
				{
					_animation.removeChildAt(0);
				}
			}
			else
			{
				_animation = new MovieClip();
				_animation.scaleX = 0.7;
				_animation.scaleY = 0.7;
				this.addChild(_animation);
			}
			var num:int;
			for each(var data:BitmapData in bmpData[id])
			{
				var bmp:Bitmap = new Bitmap(data);
				bmp.visible = false;
				bmp.x = bmpPoint[id][num].x * -1;
				bmp.y = bmpPoint[id][num].y * -1;
				num++;
				_animation.addChild(bmp);
			}
			if (_animation.numChildren == 0) return;
			_animation._currentFrame = 0;
			_animation._totalFrames = bmpData[id].length;
			_animation.getChildAt(0).visible = true;
		}
		
		protected function playAnimation():void//播放下一“帧”
		{
			if (_animation.numChildren == 0) return;
			var frame:int = _animation._currentFrame == _animation._totalFrames - 1?0:_animation._currentFrame + 1;
			_animation.getChildAt(frame).visible = true;
			_animation.getChildAt(_animation._currentFrame).visible = false;
			_animation._currentFrame = frame;
		}
		
		private function creatHaemalStrand():void//初始化血条
		{
			_haemalStrand = new Sprite();
			this.addChild(_haemalStrand);
			drawRect(_haemalStrand, 0xff0000);
			
			var back:Sprite = new Sprite();
			drawRect(back, 0x00ff00);
			_haemalStrand.addChild(back);
			_haemalStrand.x = -10;
			_haemalStrand.y = this.height * -0.8;
			_haemalStrand.visible = false;
		}
		
		private function changeHaemalStrand():void//改变血条状态
		{
			clearTimeout(_timeoutId);
			_haemalStrand.visible = true;
			var num:Number = _healthNow / healthTotal;
			_haemalStrand.getChildAt(0).scaleX = num < 0?0:num;
			_timeoutId = setTimeout(hideHaemalStrand, 2000);
		}
		
		private function hideHaemalStrand():void//1.5秒后隐藏血条 
		{
			_haemalStrand.visible = false;
		}
		
		private function drawRect(sp:Sprite, color:uint):void//绘制矩形
		{
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(0, 0, 20, 2);
			sp.graphics.endFill();
		}
		
		public function destroy(size:int, mode:String):void//受到攻击
		{
			_healthNow -= size;
			if (_healthNow <= 0) 
			{
				over(mode);
				Control.control.changeScore(this.score * this.modifier);
				Control.control.changeCost(this.score / 100, true);
			}
			changeHaemalStrand();
		}
		
		private function over(mode:String):void//挂掉了
		{
			_timer.stop();
			isLife = false;
			_haemalStrand.visible = false;
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
		
		private function deathAnimation(id:int):void//挂掉时的动画
		{
			creatAnimation(id);
			var timer:Timer = new Timer(10, _animation.numChildren);
			timer.addEventListener(TimerEvent.TIMER, onTomer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			timer.start();
		}
		
		private function onComplete(e:TimerEvent):void //彻底消失
		{
			this.removeFromMap();
		}
		
		private function onTomer(e:TimerEvent):void //播放挂掉的动画
		{
			playAnimation();
		}
	}

}