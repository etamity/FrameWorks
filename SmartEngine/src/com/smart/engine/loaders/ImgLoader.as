//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.loaders {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class ImgLoader {

		public static var instance:ImgLoader = new ImgLoader(); // singleton access

		public function ImgLoader() {

		}

		private var loaderHash:Dictionary    = new Dictionary(false); // cache
		private var loaderURLHash:Dictionary = new Dictionary(false); // cache

		public function getBitmapData(url:String, onLoad:Function):void {
			var onComplete:Function = function(loader:Loader):void {
				var bitmap:Bitmap = loader.content as Bitmap;
				if (bitmap == null) {
					throw new Error("not a bitmap");
				}
				onLoad(bitmap.bitmapData);
			}
			var loader:Loader       = getLoader(url, onComplete);
		}

	
		public function getLoader(url:String, addOnComplete:Function = null):Loader {
			if (loaderHash[url] != null) {
				if (addOnComplete !== null) {
					addOnComplete(loaderHash[url]);
				}
				return loaderHash[url];
			}
			var loader:Loader = new Loader();
			if (addOnComplete !== null) {
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
					addOnComplete(loader);
				});
			}
			loader.load(new URLRequest(url));
			loaderHash[url] = loader;
			return loader;
		}


		public function getMovieClip(url:String, linkage:String, onLoad:Function):void {
			var onComplete:Function = function(loader:Loader):void {
				onLoad(getMovieClipFromLoader(loader, linkage));
			}
			var loader:Loader       = getLoader(url, onComplete);
		}


		public function getURLLoader(url:String, addOnComplete:Function = null):URLLoader {
			if (loaderURLHash[url] != null) {
				if (addOnComplete !== null) {
					addOnComplete(loaderURLHash[url]);
				}
				return loaderHash[url];
			}
			var loader:URLLoader = new URLLoader();
			if (addOnComplete !== null) {
				loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					addOnComplete(loader);
				});
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				trace("URL:" + url, e.text)
			});
			loader.load(new URLRequest(url));
			loaderURLHash[url] = loader;
			return loader;
		}

		public function getXML(url:String, onLoad:Function):void {
			var onComplete:Function = function(loader:URLLoader):void {
				var data:* = loader.data;
				onLoad(new XML(data));
			}
			getURLLoader(url, onComplete);
		}


		private function getMovieClipFromLoader(loader:Loader, linkage:String = ""):MovieClip {
			if (loader.content == null) {
				throw new Error("invalid asset loaded");
			}
			if (linkage == "" || linkage == null) {
				if (loader.content.width == 0 || loader.content.height == 0) {
					throw new Error("image size is zero");
				}
				var mc:MovieClip = new MovieClip();
				mc.addChild(loader.content);
				return mc;
			}
			var Def:Class         = loader.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var display:MovieClip = new Def();
			if (display.width == 0 || display.height == 0) {
				throw new Error("image asset size is zero of linkage: " + linkage);
			}
			if (display == null) {
				throw new Error("not a bitmap");
			}
			return display;
		}
	}
}

