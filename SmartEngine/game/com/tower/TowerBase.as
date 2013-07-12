package com.tower 
{
	import com.enemy.EnemyBase;
	import com.map.AutoAttack;
	import com.map.Control;
	import com.map.Map;
	import com.map.MapUnit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
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
		
		private var _tower:Sprite;//显示素材
		private var _timer:Timer;
		private var _canUse:Boolean;//能否放置
		private var _last:Array;//上次显示的素材
		private var _back:Indicator;//范围显示器
		private var _enemy:EnemyBase;//发现的敌人
		private var _angle:Number;//当前的角度
		private var _timeId:int;
		
		public function TowerBase() 
		{
			_tower = new Sprite();
			_tower.scaleX = 0.7;
			_tower.scaleY = 0.7;
			this.addChild(_tower);
			
			_last = new Array();
			
			createTower(1);
			
			_timer = new Timer(1000);
			changeSpeed(AutoAttack.moveFast);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			Map.map.addTopChild(this);
			super();
			_back = new Indicator(defense, this.cost[0]);
			this.addChild(_back);
		}
		
		public function save():Object//保存
		{
			var obj:Object = new Object();
			/*obj.x = this.x;
			obj.y = this.y;
			obj.level = this.level;
			var str:String = this.toString();
			str =str.substring(8, str.length - 1);
			obj.towerClass = str;*/
			return obj;
			
		}
		
		public function recover(obj:Object):void//恢复
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnter);
			this.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.level = obj.level;
			createTower(this.level);
			this.setPoint(obj.x, obj.y);
			_back.changeState(2);
			_back.visible = false;
			if (AutoAttack.onRun)_timer.start();
			AutoAttack.setWay();
			Map.map.removeTopChild(this);
			_back.setMoney(this.cost[this.level], getCost());
			AutoAttack.addTower(this);
		}
		
		public function changeSpeed(fast:Boolean):void//改变速度
		{
			_timer.delay = fast?200 * reloadTime:1000 * reloadTime;
		}
		
		/*override public function play():void//播放
		{
			super.play();
			_timer.start();
		}
		
		override public function stop():void//暂停
		{
			super.stop();
			_timer.stop();
		}*/
		
		protected function createTower(level:int):void//构建塔防的素材
		{
			
			this.level = level;
			while (_tower.numChildren > 0)
			{
				_tower.removeChildAt(0);
			}
			var idle:Sprite = new Sprite();
			_tower.addChild(idle);
			var attack:Sprite = new Sprite();
			attack.visible = false;
			_tower.addChild(attack);
			
			var idleIndex:int = level - 1;
			var attackIndex:int = level + 2;
			var texture:Texture;
			var image:Image;
			for (var i:int = 0; i < bmpData[idleIndex].length; i++)
			{
				var bmpData1:BitmapData = bmpData[idleIndex][i];
				var bmp1:Bitmap = new Bitmap(bmpData1);
				var point:Point = bmpPoint[idleIndex][i];
				bmp1.x = point.x * -1;
				bmp1.y = point.y * -1;
				bmp1.visible = false;
				texture=Texture.fromBitmapData(bmpData1);
				image=new Image(texture);
				idle.addChild(image);
			}
			if (!bmpData[attackIndex]) 
			{
				changeDisplay(0);
				return;
			}
			for (var j:int = 0; j < bmpData[attackIndex].length; j++)
			{
				var bmpData2:BitmapData = bmpData[attackIndex][j];
				var bmp2:Bitmap = new Bitmap(bmpData2);
				point = bmpPoint[attackIndex][j];
				bmp2.x = point.x * -1;
				bmp2.y = point.y * -1;
				bmp2.visible = false;
				texture=Texture.fromBitmapData(bmpData2);
				image=new Image(texture);
				attack.addChild(image);
			}
			changeDisplay(0);
		}
		
		private function changeDisplay(id:int):void//改变要显示的位图
		{
			if (_last[0])_last[0].visible = false;
			var idle:Sprite = _tower.getChildAt(0) as Sprite;
			_last[0] = idle.getChildAt(id);
			_last[0].visible = true;
			
			if (_last[1])_last[1].visible = false;
			var attack:Sprite = _tower.getChildAt(1) as Sprite;
			if (attack.numChildren == 0) return;
			_last[1] = attack.getChildAt(int(id * attack.numChildren / idle.numChildren));
			_last[1].visible = true;
		}
		
		protected function fireAni(id:int):void//开火动画
		{
			if (_last[1])_last[1].visible = false;
			var attack:Sprite = _tower.getChildAt(1) as Sprite;
			_last[1] = attack.getChildAt(id);
			_last[1].visible = true;
		}
		
		private function onUp(e:MouseEvent):void //塔被放置
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnter);
			this.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			if (_canUse)
			{
				_back.changeState(2);
				_back.visible = false;
				if (AutoAttack.onRun)_timer.start();
				AutoAttack.setWay();
				Map.map.removeTopChild(this);
				Control.control.changeCost(this.cost[0], false);
				_back.setMoney(this.cost[this.level], getCost());
				AutoAttack.addTower(this);
			}
			else
			{
				this.removeFromMap();
			}
		}
		
		private function onClick(e:MouseEvent):void //单击塔
		{
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.stage.addEventListener(MouseEvent.CLICK, stageClick);
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
			this.stage.removeEventListener(MouseEvent.CLICK, stageClick);
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
			_back.setMoney(this.cost[this.level], getCost());
			Control.control.changeCost(this.cost[this.level], false);
		}
		
		private function stageClick(e:MouseEvent):void //舞台被单击
		{
			if (_back.visible)
			{
				_back.visible = false;
				if (!this.parent) return;
				Map.map.removeTopChild(this);
				this.addEventListener(MouseEvent.CLICK, onClick);
				this.stage.removeEventListener(MouseEvent.CLICK, stageClick);
				clearTimeout(_timeId);
			}
			else
			{
				_back.changeUpgradeState(Control.control.cost);
				_timeId = setInterval(inTime, 1000);
				_back.visible = true;
				Map.map.addTopChild(this);
			}
		}
		
		private function inTime():void //检测能否升级
		{
			_back.changeUpgradeState(Control.control.cost);
		}
		
		private function onEnter(e:Event):void //未放置时
		{
			if (rectifyPlace())_canUse = testPlace();
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
			var child:Sprite = _tower.getChildAt(0) as Sprite;
			var index:int = child.numChildren * angle / 360;
			changeDisplay(index);
		}
		
		protected function changeState(isFire:Boolean):void//改变状态
		{
			var child:Sprite = _tower.getChildAt(int(isFire)) as Sprite;
			child.visible = true;
			child = _tower.getChildAt(int(!isFire)) as Sprite;
			child.visible = false;
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
				_back.changeState(0);
				return false;
			}
			else
			{
				_back.changeState(1);
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
		
		private function rectifyPlace():Boolean//矫正位置
		{
			var bool:Boolean;
			var point:Point = this.localToGlobal(new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY));
			
			var xx:int = int(point.x / 36) * 36;
			var yy:int = int(point.y / 36) * 36;
			
			if (this.x != xx || this.y != yy)
			{
				this.setPoint(xx, yy);
				
				bool = true;
			}
			
			return bool;
		}
	}

}