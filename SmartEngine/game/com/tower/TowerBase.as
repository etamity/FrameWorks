package com.tower 
{
	import com.enemy.EnemyBase;
	import com.map.AutoAttack;
	import com.map.Control;
	import com.map.Map;
	import com.map.MapUnit;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class TowerBase extends MapUnit 
	{
		protected var defense:int;//攻击范围
		protected var damage:Array;//攻击威力
		protected var cost:Array;//值的金币
		protected var bmpData:Array;
		protected var bmpPoint:Array;
		protected var level:int;//等级
		protected var reloadTime:Number = 0;//重新开火的时间的倍数
		
		protected var _tower:Sprite;//显示素材
		private var _timer:Timer;
		private var _canUse:Boolean;//能否放置
		private var _indicator:Indicator;//范围显示器
		private var _enemy:EnemyBase;//发现的敌人
		private var _angle:Number;//当前的角度
		private var _timeId:int;
		private var _attack:MovieClip;
		private var _idle:MovieClip;
		
		
		private var currentIndex:int=0;
		private var currentIdle:int=0;
		public function TowerBase() 
		{
			super();
			_tower = new Sprite();
			_tower.scaleX = 0.7;
			_tower.scaleY = 0.7
			this.addChild(_tower);
			
			createTower(1);
			
			_timer = new Timer(1000);
			changeSpeed(AutoAttack.moveFast);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			this.addEventListener(TouchEvent.TOUCH, onUp);
			
			Map.map.addTopChild(this);
	
			_indicator = new Indicator(defense, this.cost[0]);
			Starling.current.nativeStage.addChild(_indicator);
			play();
		}

		public function save():Object// Save game
		{
			var obj:Object = new Object();
			obj.x = this.x;
			obj.y = this.y;
			obj.level = this.level;
			var str:String = String(this);
			str =str.substring(8, str.length - 1);
			obj.towerClass = str;
			return obj;
			
		}
		
		public function recover(obj:Object):void//恢复
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnter);
			this.removeEventListener(TouchEvent.TOUCH, onUp);
			this.addEventListener(TouchEvent.TOUCH, onClick);
			this.level = obj.level;
			createTower(this.level);
			this.setPoint(obj.x, obj.y);
			_indicator.changeState(2);
			_indicator.visible = false;
			if (AutoAttack.onRun)_timer.start();
			AutoAttack.setWay();
			Map.map.removeTopChild(this);
			_indicator.setMoney(this.cost[this.level], getCost());
			AutoAttack.addTower(this);
		}
		
		public function changeSpeed(fast:Boolean):void//改变速度
		{
			_timer.delay = fast?200 * reloadTime:1000 * reloadTime;
		}
		
		public function play():void//播放
		{
			//_idle.play();
			_timer.start();
		}
		
		public function stop():void//暂停
		{
			//_idle.stop();
			_timer.stop();
		}
		
		protected function createTower(level:int):void//构建塔防的素材
		{
			
			this.level = level;
			
		
			while (_tower.numChildren > 0)
			{
				_tower.removeChildAt(0);
			}
	
			var idleIndex:int = level - 1;
			var attackIndex:int = level + 2;
			
			
			var vectorTextures:Vector.<Texture>=Vector.<Texture>(bmpData[idleIndex]);
			_idle=new MovieClip(vectorTextures,60);
			
			//Starling.juggler.add(_idle);
			/*_idle.addEventListener(Event.ENTER_FRAME,function (evt:Event):void{
				if (_idle.currentFrame==currentIdle)
					_idle.stop();
				_idle.currentFrame=currentIdle;
			});*/
			_tower.addChild(_idle);
			
			if (!bmpData[attackIndex]){
				changeDisplay(0)
				return;
			}
			
			var attackTextures:Vector.<Texture>=Vector.<Texture>(bmpData[attackIndex]);
			_attack=new MovieClip(attackTextures,60);
			_attack.visible=false;
			_tower.addChild(_attack);
			
			//Starling.juggler.add(_attack);
			/*_attack.addEventListener(Event.ENTER_FRAME,function (evt:Event):void{
			  if (_attack.currentFrame==currentIndex)
				  _attack.stop();

			});*/
			
			
			changeDisplay(attackIndex);
	
		}
		
		private function changeDisplay(id:int):void//改变要显示的位图
		{

			currentIdle=id;
			if (_idle.currentFrame== currentIdle) return;
			_idle.currentFrame=currentIdle;
			//_idle.play();
			if (_attack == null) return;
			currentIndex=id * _attack.numFrames / _idle.numFrames;
			if (_attack.currentFrame== currentIndex) return;
			//_attack.play();
			_attack.currentFrame= currentIndex;
		}
		
		protected function fireAni(id:int):void//开火动画
		{
			if (_attack) _attack.visible = false;
			
			_attack.visible = true;
			currentIndex=id;
		}
		
		private function onUp(e:TouchEvent):void //塔被放置
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnter);
			this.removeEventListener(TouchEvent.TOUCH, onUp);
			this.addEventListener(MouseEvent.CLICK, onClick);
	

			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
					if (_canUse)
					{
						trace("onUp onUp");
						_indicator.changeState(2);
						_indicator.visible = false;
						if (AutoAttack.onRun)_timer.start();
						AutoAttack.setWay();
						Map.map.removeTopChild(this);
						Control.control.changeCost(this.cost[0], false);
						_indicator.setMoney(this.cost[this.level], getCost());
						AutoAttack.addTower(this);
					}
					else
					{
						this.removeFromMap();
					}
				
		}
		
		private function onClick(e:TouchEvent):void //单击塔
		{
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.stage.addEventListener(TouchEvent.TOUCH, stageClick);
		}
		
		private function getCost():int//获取塔的总价值
		{
			var num:int;
			for (var i:int = 0; i < this.level; i++)
			{
				num += this.cost[i];
			}
			num *= 0.8;
			return num;
		}
		
		public function reclaim():void//回收
		{
			_timer.stop();
			this.stage.removeEventListener(TouchEvent.TOUCH, stageClick);
			this.removeFromMap();
			AutoAttack.hasWay();
			AutoAttack.setWay();
			Control.control.changeCost(getCost(), true);
			AutoAttack.removeTower(this);
		}
		
		public function upgrade():void//升级
		{
			this.level++;
			createTower(this.level);
			_indicator.setMoney(this.cost[this.level], getCost());
			Control.control.changeCost(this.cost[this.level], false);
		}
		
		private function stageClick(e:TouchEvent):void //舞台被单击
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch){
				if (_indicator.visible)
				{
					_indicator.visible = false;
					if (!this.parent) return;
					Map.map.removeTopChild(this);
					this.addEventListener(MouseEvent.CLICK, onClick);
					this.stage.removeEventListener(MouseEvent.CLICK, stageClick);
					clearTimeout(_timeId);
		
				}
				else
				{
					_indicator.changeUpgradeState(Control.control.cost);
					_timeId = setInterval(inTime, 1000);
					_indicator.visible = true;
					Map.map.addTopChild(this);
					
				}
			}
		}
		
		private function inTime():void //检测能否升级
		{
			_indicator.changeUpgradeState(Control.control.cost);
		}
		
		private function onEnter(e:Event):void //未放置时
		{
			if (rectifyPosition())_canUse = testPlace();
		}
		
		private function onTimer(e:TimerEvent):void //开火和转向
		{
			//if (!_enemy || !_enemy.parent)
			_enemy = findEnemy();
			if (_enemy)
			{
				changOrientation(_enemy);
				fire(_enemy, _angle);
			}
		}
		
		protected function fire(mc:EnemyBase, angle:Number):void//开火,由子类重写
		{
			
		}
		
		private function changOrientation(mc:EnemyBase):void//根据敌人的位置改变方向
		{
			var xx:int = mc.x - this.x;
			var yy:int = mc.y - this.y;
			var angle:Number = Math.atan2(yy, xx);
			angle *= 180 / Math.PI;
			angle += 90;
			if (angle < 0) angle += 360;
			_angle = angle;
			var index:int = _idle.numFrames * angle / 360;
			changeDisplay(index);
		}
		
		protected function changeState(isFire:Boolean):void//改变状态
		{
			_attack.visible = isFire;
			_idle.visible = !isFire;
		}
		
		private function findEnemy():EnemyBase//寻找敌人
		{
			var xx:int, yy:int, num1:int, num2:int, enemy:EnemyBase;
			num1 = defense * 2 / 25;
			num1 = num1 % 2 == 0?num1 + 1:num1;
			num2 = int(num1 / 2);
			for (var i:int = 0; i < num1; i++)
			{
				xx = this.mapX - num2 + i;
				for (var j:int = Math.abs(i - num2); j <= num1 - Math.abs(i - num2)-1; j++)
				{
					yy = this.mapY - num2 + j;
					enemy = getEnemy(xx, yy);
					if (enemy) return enemy;
				}
			}
			return null;
		}
		
		private function getEnemy(x:int, y:int):EnemyBase//判断是否有障碍
		{
			if (!Map.place[x]) return null;
			for each(var i:Object in Map.place[x][y])
			{
				if ((i is EnemyBase) && i.isLife) return EnemyBase(i);
			}
			return null;
		}
		
		private function testPlace():Boolean//检验位置是否能放
		{
			if (this.mapX <= 1 || this.mapX == 21 || this.mapY == 0 || this.mapY == 12 || hasBlock(this.mapX, this.mapY) || !AutoAttack.hasWay())
			{
				_indicator.changeState(0);
				return false;
			}
			else
			{
				_indicator.changeState(1);
				return true;
			}
			return false;
		}
		
		private function hasBlock(x:int, y:int):Boolean//判断是否有障碍
		{
			for each(var i:Object in Map.place[x][y])
			{
				if (i is TowerBase && i != this) return true;
			}
			return false;
		}
		
		private function rectifyPosition():Boolean//矫正位置
		{
			var bool:Boolean;
			var point:Point = new Point(Starling.current.nativeStage.mouseX-width/2, Starling.current.nativeStage.mouseY-height/2);
			
			var xx:int = int(point.x / 36) * 36;
			var yy:int = int(point.y / 36) * 36;

			if (this.x != xx || this.y != yy)
			{
				this.setPoint(xx, yy);
				_indicator.x=xx+74*0.7;
				_indicator.y=yy+80*0.7;
				
				bool = true;
			}
			

			
			return bool;
		}
	}

}