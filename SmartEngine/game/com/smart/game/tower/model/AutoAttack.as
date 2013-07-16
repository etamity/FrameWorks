/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.model 
{
	import com.smart.game.tower.data.Load;
	import com.smart.game.tower.enemy.ArmyBase;
	import com.smart.game.tower.enemy.Bike;
	import com.smart.game.tower.enemy.Blimp;
	import com.smart.game.tower.enemy.Chopper;
	import com.smart.game.tower.enemy.EnemyBase;
	import com.smart.game.tower.enemy.HazmatSoldier;
	import com.smart.game.tower.enemy.HeavyBike;
	import com.smart.game.tower.enemy.HeavySoldier;
	import com.smart.game.tower.enemy.Jeep;
	import com.smart.game.tower.enemy.LightSoldier;
	import com.smart.game.tower.enemy.Plane;
	import com.smart.game.tower.enemy.Robot;
	import com.smart.game.tower.enemy.Tank;
	import com.smart.game.tower.event.DisappearEvent;
	import com.smart.game.tower.tower.Flame;
	import com.smart.game.tower.tower.Gatling;
	import com.smart.game.tower.tower.Goo;
	import com.smart.game.tower.tower.Lightning;
	import com.smart.game.tower.tower.Missile;
	import com.smart.game.tower.tower.Mortar;
	import com.smart.game.tower.tower.TowerBase;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import com.smart.game.tower.ui.Control;

	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class AutoAttack
	{
		public static var route:Array;
		public static var lastRoute:Array;
		public static var onRun:Boolean;
		public static var moveFast:Boolean;
		
		private static var _towers:Array;
		private static var _enemy:Array;
	
		private var _info:XML;
		private var _timer1:Timer;
		private var _timer2:Timer;
		private var _timer3:Timer;
		private var _index:int;
		private var _enemyNum:int;
		private var _runTimer:Array;
		private var _modifier:int;
		
		public function AutoAttack() 
		{
			Load.from(Load.LOAD_XML, "Data/List.xml", loaded);
			
			_timer1 = new Timer(0);
			_timer1.addEventListener(TimerEvent.TIMER, onTimer);
			_timer2 = new Timer(0);
			_timer2.addEventListener(TimerEvent.TIMER, onTimer);
			_timer3 = new Timer(0, 1);
			_timer3.addEventListener(TimerEvent.TIMER, delayStart);
			reset();
		}
		
		public function reStart():void
		{
			for each(var enemy:EnemyBase in _enemy)
			{
				enemy.removeFromMap();
			}
			for each(var tower:TowerBase in _towers)
			{
				tower.removeFromMap();
			}
			reset();
			start();
		}
		
		public function save():void
		{
			var share:SharedObject = SharedObject.getLocal("TowerGame20130715");
			var arr:Array = share.data.data = [];
			
			for each(var tower:TowerBase in _towers)
			{
				arr.push(tower.save());
			}
			if (Map.map.parent)
			Map.map.parent.removeChild(Map.map);
		}
		
		public function recover():void
		{
			var share:SharedObject = SharedObject.getLocal("TowerGame20130715");
			var arr:Array = share.data.data;
			if (!arr) return;
			for each(var obj:Object in arr)
			{
				var towerClass:Class = nameToClass(obj.towerClass);
				var tower:TowerBase = new towerClass();
				tower.recover(obj);
			}
			hasWay();
			setWay();
			_index = share.data.round - 2;
			Control.control.recover();
		}
		
		private function reset():void
		{
			_enemy = [];
			_towers = [];
			lastRoute = [];
			route = [];
			_runTimer = [];
			_index = -1;
			onRun = true;
			_modifier = 1;
			moveFast = false;
			hasWay();
			setWay();
		}
		
		public function play():void
		{
			for each(var enemy:EnemyBase in _enemy)
			{
				enemy.play();
			}
			for each(var tower:TowerBase in _towers)
			{
				tower.play();
			}
			for each(var timer:Timer in _runTimer)
			{
				timer.start();
			}
			onRun = true;
		}
		
		public function changeSpeed(fast:Boolean):void
		{
			moveFast = fast;
			changeRate(fast);
			for each(var enemy:EnemyBase in _enemy)
			{
				enemy.changeSpeed(fast);
			}
			for each(var tower:TowerBase in _towers)
			{
				tower.changeSpeed(fast);
			}
		}
		
		private function changeRate(fast:Boolean):void
		{
			_modifier = fast?5:1;
			for each(var timer:Timer in _runTimer)
			{
				if (fast)
				{
					timer.delay /= 5;
				}
				else
				{
					timer.delay *= 5;
				}
			}
		}
		
		public function stop():void
		{
			for each(var enemy:EnemyBase in _enemy)
			{
				enemy.stop();
			}
			for each(var tower:TowerBase in _towers)
			{
				tower.stop();
			}
			for each(var timer:Timer in _runTimer)
			{
				timer.stop();
			}
			onRun = false;
		}
		
		private function onTimer(e:TimerEvent, timer:Timer = null):void
		{
			timer = timer?timer:e.currentTarget as Timer;
			if (timer.currentCount == timer.repeatCount) return;
			if (timer == _timer1)
			{
				if (_timer1.currentCount == _timer1.repeatCount - 1)_runTimer.splice(_runTimer.indexOf(_timer1), 1);
				createEnemy(0);
			}
			else
			{
				if (_timer2.currentCount == _timer2.repeatCount - 1)_runTimer.splice(_runTimer.indexOf(_timer2), 1);
				createEnemy(1);
			}
		}
		
		private function disappearFun(e:DisappearEvent):void
		{
			var enemy:EnemyBase = e.info;
			_enemy.splice(_enemy.indexOf(enemy), 1);
			_enemyNum--;
			if (_enemyNum == 0) start();
		}
		
		private function createEnemy(i:int):void
		{
			var name:String = _info.Wave[_index].HorizontalStream[i].@enemyFile;
			var enemyClass:Class = nameToClass(name);
			var startId:int = String(_info.Wave[_index].HorizontalStream[i].@path).length == 18?0:1;
			var num:Number = Number(_info.Wave[_index].HorizontalStream[i].@healthModifier);
			if (_index > 40) num *= 1.5;
			if (_index > 80) num *= 2;
			var enemy:EnemyBase = new enemyClass(startId, num);
			enemy.addEventListener(DisappearEvent.DISAPPEAR, disappearFun);
			_enemy.push(enemy);
		}
		
		private function start():void
		{
			_index++;
			if (_index == 100)
			{
				Control.control.gameOver(true);
				return;
			}
			Control.control.changeRound(_index + 1);
			_timer1.reset();
			_timer1.delay = Number(_info.Wave[_index].HorizontalStream[0].@spawnRate) * 1000 / _modifier;
			_timer1.repeatCount = Number(_info.Wave[_index].HorizontalStream[0].@count);
			_enemyNum = _timer1.repeatCount;
			_timer1.start();
			_runTimer.push(_timer1);
			onTimer(null, _timer1);
			if (_info.Wave[_index].HorizontalStream.length() == 1) return;
			_timer2.reset();
			_timer2.delay = Number(_info.Wave[_index].HorizontalStream[1].@spawnRate) * 1000 / _modifier;
			_timer2.repeatCount = Number(_info.Wave[_index].HorizontalStream[1].@count);
			_enemyNum += _timer2.repeatCount;
			_timer3.reset();
			_timer3.delay = Number(_info.Wave[_index].HorizontalStream[1].@delayStart) * 1000 / _modifier;
			_timer3.start();
			_runTimer.push(_timer3);
		}
		
		private function delayStart(e:TimerEvent):void 
		{
			 _timer2.start();
			 _runTimer.push(_timer2);
			 _runTimer.splice(_runTimer.indexOf(_timer3), 1);
			 onTimer(null, _timer2);
		}
		
		private function loaded(xml:XML):void 
		{
			_info = xml;
			start();
		}
		
		private function nameToClass(name:String):Class
		{
			if (name == "unit_bike") return Bike;
			if (name == "unit_blimp") return Blimp;
			if (name == "unit_chopper") return Chopper;
			if (name == "unit_hazmat_soldier") return HazmatSoldier;
			if (name == "unit_heavy_bike") return HeavyBike;
			if (name == "unit_heavy_soldier") return HeavySoldier;
			if (name == "unit_jeep") return Jeep;
			if (name == "unit_light_soldier") return LightSoldier;
			if (name == "unit_plane") return Plane;
			if (name == "unit_robot") return Robot;
			if (name == "unit_tank") return Tank;
			if (name == "Flame") return Flame;
			if (name == "Gatling") return Gatling;
			if (name == "Goo") return Goo;
			if (name == "Lightning") return Lightning;
			if (name == "Missile") return Missile;
			if (name == "Mortar") return Mortar;
			
			return null;
		}
		
		public static function addTower(tower:TowerBase):void
		{
			_towers.push(tower);
		}
		
		public static function removeTower(tower:TowerBase):void
		{
			_towers.splice(_towers.indexOf(tower), 1);
		}
		
		public static function setWay():void
		{
			lastRoute[0] = route[0].slice();
			lastRoute[1] = route[1].slice();
			for each(var i:Object in _enemy)
			{
				if (i is ArmyBase) i.setRoute();
			}
		}
		
		public static function hasWay():Boolean
		{
			route[0] = RoadAI.doPlan(new Point(1, 6));
			route[1] = RoadAI.doPlan(new Point(1, 7));
			if (!route[0]) return false;
			for each(var i:Object  in _enemy)
			{
				if ((i is ArmyBase) && !i.hasWay()) return false;
			}
			return true;
		}
	}

}