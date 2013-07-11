package com.data 
{
	import com.event.LoadEvent;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class BmpData extends EventDispatcher
	{
		public static const PLANE:int = 0;
		public static const HAZMATSOLDIER:int = 1;
		public static const HEAVYSOLDIER:int = 2;
		public static const BIKE:int = 3;
		public static const HEAVYBIKE:int = 4;
		public static const JEEP:int = 5;
		public static const TANK:int = 6;
		public static const LIGHTSOLDIER:int = 7;
		public static const CHOPPER:int = 8;
		public static const ROBOT:int = 9;
		public static const BLIMP:int = 10;
		public static const GATLING:int = 11;
		public static const GOO:int = 12;
		public static const MISSILE:int = 13;
		public static const FLAME:int = 14;
		public static const LIGHTNING:int = 15;
		public static const MORTAR:int = 16;
		
		public static var bmpDatas:Array;//所有处理好的素材
		public static var bmpPoints:Array;//所有的位图位置
		
		private var _towerUrl:Array;//所有塔的位图加载地址
		private var _enemyUrl:Array;//所有敌人位图的加载地址
		private var _total:Array;//总的加载量
		private var _loaded:Array;//已经加载的
		private var _loadedNum:int;//已经加载的个数
		
		public function BmpData() 
		{
			bmpDatas = new Array();
			bmpPoints = new Array();
			_total = new Array();
			_loaded = new Array();
			
			_enemyUrl = ["plane", "hazmat_soldier", "heavy_soldier", "bike", "heavy_bike", "jeep", "tank", "light_soldier", "chopper", "robot", "blimp"];
			_towerUrl = ["gatling", "goo", "missile", "flame", "lightning", "mortar"];
			
			load(_towerUrl, "Data/Towers/tower_");
			load(_enemyUrl, "Data/Enemies/unit_");
		}
		
		private function load(arr:Array, str:String):void//加载方法
		{
			for (var i:int; i < arr.length; i++)
			{
				var url:String = str + arr[i] + ".xml";
				var data:*;
				if (str.indexOf("tower") != -1)
				{
					data = new TowerFormat(url);
				}
				else
				{
					data = new EnemyFormat(url);
				}
				data.addEventListener(LoadEvent.LOADED, loaded);
				data.addEventListener(LoadEvent.LOADING, loading);
			}
		}
		
		private function loading(e:LoadEvent):void//加载时的回调函数
		{
			var str:String = e.info.url;
			str = str.substring(str.indexOf("_") + 1, str.length - 4);
			for (var i:int = 0; i < _enemyUrl.length; i++)
			{
				if (str == _enemyUrl[i])
				{
					_total[i] = e.info.progress.bytesTotal;
					_loaded[i] = e.info.progress.bytesLoaded;
					countPrt();
					return;
				}
			}
			for (i = 0; i < _towerUrl.length; i++)
			{
				if (str == _towerUrl[i])
				{
					_total[i + 12] = e.info.progress.bytesTotal;
					_loaded[i + 12] = e.info.progress.bytesLoaded;
					countPrt();
					return;
				}
			}
		}
		
		private function countPrt():void//计算加载的总量的百分比，貌似不准
		{
			var num1:int;
			var num2:int;
			for (var i:int = 0; i < _loaded.length; i++)
			{
				if (_loaded[i] != undefined)
				{
					num1 += _loaded[i];
					num2 += _total[i];
				}
			}
			this.dispatchEvent(new LoadEvent(LoadEvent.LOADING, num1 / num2));
		}
		
		private function loaded(e:LoadEvent):void //当单个素材处理好时调用
		{
			var str:String = e.info.url;
			str = str.substring(str.indexOf("_") + 1, str.length - 4);
			for (var i:int = 0; i < _enemyUrl.length; i++)
			{
				if (str == _enemyUrl[i])
				{
					bmpDatas[i] = e.info.data;
					bmpPoints[i] = e.info.points;
					_loadedNum++;
					if (_loadedNum == _towerUrl.length + _enemyUrl.length)
					this.dispatchEvent(new LoadEvent(LoadEvent.LOADED, null));
					return;
				}
			}
			for (i = 0; i < _towerUrl.length; i++)
			{
				if (str == _towerUrl[i])
				{
					bmpDatas[i + 11] = e.info.data;
					bmpPoints[i + 11] = e.info.points;
					_loadedNum++;
					if (_loadedNum == _towerUrl.length + _enemyUrl.length)
					this.dispatchEvent(new LoadEvent(LoadEvent.LOADED, null));
					return;
				}
			}
		}
	}

}