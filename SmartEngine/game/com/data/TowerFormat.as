package com.data 
{
	import com.event.LoadEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class TowerFormat extends EventDispatcher
	{
		public static const IDLE_LEVEL1:int = 0;
		public static const IDLE_LEVEL2:int = 1;
		public static const IDLE_LEVEL3:int = 2;
		public static const ATTACK_LEVEL1:int = 3;
		public static const ATTACK_LEVEL2:int = 4;
		public static const ATTACK_LEVEL3:int = 5;
		
		private var _bmpData:Array;
		private var _points:Array;
		private var _bmps:Array;
		private var _info:Array;
		private var _loadedNum:int;
		private var _url:String;
		//这个注释同EnemyFormat,和EnemyFormat的变量方法基本一样，但实现过程不同，所以没有用继承
		public function TowerFormat(xmlUrl:String)
		{
			_bmps = new Array();
			_bmpData = new Array();
			_points = new Array();
			_url = xmlUrl;
			
			Load.from(Load.LOAD_TXT, xmlUrl, xmlLoaded);
		}
		
		private function xmlLoaded(str:String):void
		{
			var arr:Array = str.match(/tower_.+png/g);
			for each(var url:String in arr)
			{
				Load.from(Load.LOAD_BMP, "Data/Towers/" + url, bmpLoaded, bmpLoading);
			}
			
			formatInfo(str);
		}
		
		private function formatInfo(str:String):void
		{
			_info = str.split("file ");
			_info.shift();
			for (var i:int = 0; i < _info.length; i++)
			{
				_info[i] = _info[i].split("anim ");
				if (_info[i][0].length < 60)_info[i].shift();
				for (var j:int = 0; j < _info[i].length; j++)
				{
					_info[i][j] = _info[i][j].split(/\n\s/);
				}
				if (_info[i][0][0].search(".png") != -1)_info[i][0].shift();
			}
		}
		
		private function getIndex(str:String):int
		{
			if (str.search("idle_level1") != -1) return 0;
			if (str.search("idle_level2") != -1) return 1;
			if (str.search("idle_level3") != -1) return 2;
			if (str.search("attack_level1") != -1) return 3;
			if (str.search("attack_level2") != -1) return 4;
			if (str.search("attack_level3") != -1) return 5;
			
			return -1;
		}
		
		private function formatBmp(id:int):void
		{
			var datas:BitmapData = _bmps[id].bitmapData;
			
			for (var i:int = 0; i < _info[id].length; i++)
			{
				var bool:Boolean = _info[id][i][0].search("level") != -1;
				var index:int = getIndex( bool?_info[id][i][0]:_info[id - 1][_info[id - 1].length - 1][0]);
				if (!_bmpData[index])_bmpData[index] = new Array();
				if (!_points[index])_points[index] = new Array();
				var arr1:Array = bool && _bmpData[index].length != 0?[]:null;
				var arr2:Array = arr1?[]:null;
				for (var j:int = 1; j < _info[id][i].length; j++)
				{
					var str:String = _info[id][i][j];
					if (str.length < 3) break;
					var arr:Array = str.split(/\s/);
					arr.shift();
					var data:BitmapData = new BitmapData(arr[3], arr[4]);
					data.copyPixels(datas, new Rectangle(arr[1], arr[2], arr[3], arr[4]), new Point());
					if (arr1)
					{
						arr1.push(data);
						arr2.push(new Point(arr[8], arr[9]));
					}
					else
					{
						_bmpData[index].push(data);
						_points[index].push(new Point(arr[8], arr[9]));
					}
				}
				if (arr1)_bmpData[index] = arr1.concat(_bmpData[index]);
				if (arr2)_points[index] = arr2.concat(_points[index]);
			}
		}
		
		private function bmpLoaded(e:Loader):void
		{
			var str:String = e.contentLoaderInfo.url;
			var id:int = int(str.substr(str.length - 5, 1));
			_bmps[id] = e.content as Bitmap;
			formatBmp(id);
			_loadedNum++;
			if (_loadedNum == _info.length)
			{
				for (var i:int = 0; i < 6; i++)
				{
					flipBmpDatas(i);
				}
				this.dispatchEvent(new LoadEvent(LoadEvent.LOADED, { data:_bmpData, url:_url, points:_points} ));
			}
		}
		
		private function flipBmpDatas(id:int):void
		{
			var arr:Array = _bmpData[id];
			var arr1:Array = _points[id];
			if (!arr) return;
			var num:int = arr.length;
			for (var i:int = num - 2; i > 0; i--)
			{
				arr.push(flipHorizontal(arr[i]));
				arr1.push(new Point(arr[i].width - arr1[i].x, arr1[i].y));
			}
		}
		
		private function flipHorizontal(bmpData:BitmapData):BitmapData//水平翻转位图数据
        {
            var matrix:Matrix = new Matrix();
            matrix.a = -1;
            matrix.tx = bmpData.width;
            var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0);
            bmpData_.draw(bmpData, matrix);
            return bmpData_;
        }
		
		private function bmpLoading(e:ProgressEvent):void 
		{
			this.dispatchEvent(new LoadEvent(LoadEvent.LOADING, { progress:e, url:_url } ));
		}
	}

}