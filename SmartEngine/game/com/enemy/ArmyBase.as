package com.enemy 
{
	import com.map.AutoAttack;
	import flash.geom.Point;
	import com.command.Plan;
	import com.data.EnemyFormat;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class ArmyBase extends EnemyBase 
	{
		private var _route:Array;//需要走的路线
		private var _gapX:Number;//用于转弯
		private var _gapY:Number;
		private var _way:Array;//可能需要走的路线
		private var _direction:int;//方向
		
		public function ArmyBase(startId:int) 
		{
			this.speed *= 2;
			this.startPoint = startId;
			_route = AutoAttack.lastRoute[this.startPoint].slice();
			_direction = 1;
			_gapX = this.speed;
			_gapY = 0;
			super();
		}
		
		override protected function move(e:TimerEvent):void//移动
		{
			changeDirection();
			this.setPoint(this.x + _gapX, this.y + _gapY);
			super.move(e);
		}
		
		override public function moderate(size:Number):void//移动速度变慢
		{
			super.moderate(size);
			changeGap();
		}
		
		override protected function recoverTime():void 
		{
			super.recoverTime();
			changeGap();
		}
		
		private function changeDirection():void//改变方向
		{
			var bool:Boolean;
			if (_route[0].x == 21)
			{
				_gapX = this.speed;
				_gapY = 0;
				return;
			}
			if (_direction == 0)
			{
				bool = this.y <= _route[0].y * 36;
			}
			else if (_direction == 1)
			{
				bool = this.x >= _route[0].x * 36;
			}
			else if (_direction == 2)
			{
				bool = this.y >= _route[0].y * 36;
			}
			else
			{
				bool = this.x <= _route[0].x * 36;
			}
			if (!bool) return;
			_route.shift();
				
			var id:int = _direction;
			if (_route[0].y < this.mapY)_direction = 0;
			if (_route[0].x > this.mapX)_direction = 1;
			if (_route[0].y > this.mapY)_direction = 2;
			if (_route[0].x < this.mapX)_direction = 3;
			if (_direction == id) return;
			//this.setPoint(this.mapX * 36, this.mapY * 36);
			changeGap();
			
		}
		
		private function changeGap():void//改变_gapX,_gapY
		{
			switch(_direction)
			{
				case 0:
					_gapX = 0
					_gapY = this.speed * -1;
					this.creatAnimation(EnemyFormat.MOVE_00);
					break;
				case 1:
					_gapX = this.speed;
					_gapY = 0;
					this.creatAnimation(EnemyFormat.MOVE_90);
					break;
				case 2:
					_gapX = 0;
					_gapY = this.speed;
					this.creatAnimation(EnemyFormat.MOVE_180);
					break;
					case 3:
					_gapX = this.speed * -1;
					_gapY = 0;
					this.creatAnimation(EnemyFormat.MOVE_270);
					break;
			}
		}
		
		public function setRoute():void//设置路线
		{
			if (!_way) hasWay();
			_route = _way.slice();
		}
		
		public function hasWay():Boolean//是否有路
		{
			var route:Array = AutoAttack.route[this.startPoint];
			if (!route) return false;
			for (var i:int = 0; i < route.length; i++)
			{
				var point:Point = route[i];
				if ((point.x == this.mapX && point.y == this.mapY) || this.mapX == 0)
				{
					_way = route.slice(i + 1);
					return true;
				}
			}
			_way = Plan.doPlan(new Point(this.mapX, this.mapY));
			if (_way) return true;
			
			return false;
		}
	}

}