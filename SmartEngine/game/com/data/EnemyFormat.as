package com.data 
{
	import com.event.LoadEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.Main;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class EnemyFormat extends EventDispatcher
	{
		public static const MOVE_00:int = 0;
		public static const MOVE_90:int = 3;
		public static const MOVE_180:int = 6;
		public static const DEATH_COMMON_00:int = 7;
		public static const DEATH_COMMON_90:int = 8;
		public static const DEATH_COMMON_180:int = 9;
		public static const DEATH_SHOCK_00:int = 10;
		public static const DEATH_SHOCK_90:int = 11;
		public static const DEATH_SHOCK_180:int = 12;
		public static const DEATH_COMMON_270:int = 13;
		public static const DEATH_SHOCK_270:int = 14;
		public static const MOVE_270:int = 15;
		
		private var _bmpData:Array;//处理好的BitmapData
		private var _bmps:Array;//加载进来的原始位图
		private var _info:Array;//位图的处理信息
		private var _loadedNum:int;//加载的位图数量
		private var _url:String;//加载xml的地址
		private var _points:Array;//单个BitmapData的对应位置
		
		public function EnemyFormat(xmlUrl:String)
		{
			_bmps = new Array();
			_bmpData = new Array();
			_points = new Array();
			_url = xmlUrl;
			
			Load.from(Load.LOAD_TXT, xmlUrl, xmlLoaded);
		}
		
		private function xmlLoaded(str:String):void//xml加载完成
		{
			var arr:Array = str.match(/unit_.+png/g);
			for each(var url:String in arr)
			{
				Load.from(Load.LOAD_BMP, "Data/Enemies/" + url, bmpLoaded, bmpLoading);//开始加载位图
			}
			
			formatInfo(str);
		}
		
		private function formatInfo(str:String):void//解析xml
		{
			_info = str.split("file ");
			_info.shift();
			for (var i:int = 0; i < _info.length; i++)
			{
				_info[i] = _info[i].split("anim ");
				for (var j:int = 0; j < _info[i].length; j++)
				{
					if (getIndex(_info[i][j]) == -1)
					{
						_info[i].splice(j, 1);
						j--;
					}
					else
					{
						_info[i][j] = _info[i][j].split(/\n\s/);
					}
				}
			}
		}
		
		private function getIndex(str:String):int//根据名称获取索引
		{
			if (str.search("move_000") != -1) return 0;
			if (str.search("move_030") != -1) return 1;
			if (str.search("move_060") != -1) return 2;
			if (str.search("move_090") != -1) return 3;
			if (str.search("move_120") != -1) return 4;
			if (str.search("move_150") != -1) return 5;
			if (str.search("move_180") != -1) return 6;
			if (str.search("death_common01_000") != -1) return 7;
			if (str.search("death_common01_090") != -1) return 8;
			if (str.search("death_common01_180") != -1) return 9;
			if (str.search("death_shock01_000") != -1) return 10;
			if (str.search("death_shock01_090") != -1) return 11;
			if (str.search("death_shock01_180") != -1) return 12;
			
			return -1;
		}
		
		private function formatBmp(id:int):void//处理位图，把原始位图切成一块块的BitmapData
		{
			var datas:BitmapData = _bmps[id].bitmapData;
			
			for (var i:int = 0; i < _info[id].length; i++)
			{
				var index:int = getIndex(_info[id][i][0]);
				_bmpData[index] = new Array();
				_points[index] = new Array();
				for (var j:int = 1; j < _info[id][i].length; j++)
				{
					var str:String = _info[id][i][j];
					if (str.length < 3) break;
					var arr:Array = str.split(/\s/);
					arr.shift();
					var data:BitmapData = new BitmapData(arr[3], arr[4]);
					data.copyPixels(datas, new Rectangle(arr[1], arr[2], arr[3], arr[4]), new Point());
					_bmpData[index].push(data);
					_points[index].push(new Point(arr[8], arr[9]));
				}
			}
		}
		
		private function bmpLoaded(e:Loader):void//单个位图加载完成
		{
			var str:String = e.contentLoaderInfo.url;
			var id:int = int(str.substr(str.length - 5, 1));
			_bmps[id] = e.content as Bitmap;
			formatBmp(id);
			_loadedNum++;
			if (_loadedNum == _info.length)
			{
				flipBmpDatas(8, 13);
				flipBmpDatas(11, 14);
				flipBmpDatas(3, 15);
				this.dispatchEvent(new LoadEvent(LoadEvent.LOADED, { data:_bmpData, url:_url, points:_points  } ));
			}
		}
		
		private function flipBmpDatas(id1:int, id2:int):void//原始位图只有0~180，0~-180靠这个函数产生
		{
			_bmpData[id2] = [];
			_points[id2] = [];
			var num:int;
			for each(var bmpData:BitmapData in _bmpData[id1])
			{
				_bmpData[id2].push(flipHorizontal(bmpData));
				_points[id2].push(new Point(bmpData.width - _points[id1][num].x, _points[id1][num].y));
				num++;
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
		
		private function bmpLoading(e:ProgressEvent):void//位图的加载进度
		{
			this.dispatchEvent(new LoadEvent(LoadEvent.LOADING, { progress:e, url:_url } ));
		}
	}

}