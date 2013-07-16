/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.data
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	import flash.events.ProgressEvent;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	public class Load 
	{
		public static const  LOAD_BMP:int=0;
		public static const  LOAD_SWF:int=1;
		public static const  LOAD_TXT:int=2;
		public static const  LOAD_XML:int=3;
		
		private var _load:Loader;
		private var _urlLoad:URLLoader;
		private var _urlRequest:URLRequest;
		private var _loadedFunc:Function;
		private var _loadingFunc:Function;
		private var _type:int;
	
		public function Load(type:int,url:String,loadedFunc:Function,loadingFunc:Function=null) 
		{
			_type=type;
			if(loadedFunc!=null) _loadedFunc=loadedFunc;
			if(loadingFunc!=null) _loadingFunc=loadingFunc;
			
			 _urlRequest=new URLRequest(url);
			
			if(type<2)
			{
				_load=new Loader();
				_load.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
				_load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoading);
				_load.load(_urlRequest);
			}else
			{
				_urlLoad=new URLLoader();
				_urlLoad.addEventListener(Event.COMPLETE,onLoaded);
				_urlLoad.addEventListener(ProgressEvent.PROGRESS,onLoading);
				_urlLoad.load(_urlRequest);
			}
		}
		public static function from(type:int,url:String,loadedFunc:Function,loadingFunc:Function=null):Load
		{
			return new Load(type,url,loadedFunc,loadingFunc);
		}
		private function onLoaded(e:Event):void
		{
			switch(_type)
			{
				case LOAD_BMP:
					if(_loadedFunc!=null)_loadedFunc(_load);
					break;
				case LOAD_SWF:
					var swf:MovieClip=_load.content as MovieClip;
					if(_loadedFunc!=null)_loadedFunc(swf);
					break;
				case LOAD_TXT:
					if(_loadedFunc!=null)_loadedFunc(_urlLoad.data);
					break;
				case LOAD_XML:
					if(_loadedFunc!=null)_loadedFunc(new XML(_urlLoad.data));
					break;
			}
		}
		private function onLoading(e:ProgressEvent):void
		{
			if (_loadingFunc != null) _loadingFunc(e);
		}

	}
	
}
