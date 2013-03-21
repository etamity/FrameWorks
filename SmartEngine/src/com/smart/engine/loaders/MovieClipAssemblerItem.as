//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.loaders {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import com.smart.engine.utils.DynamicMovieClip;
	import com.smart.engine.utils.StringUtils;

	public class MovieClipAssemblerItem {

		public static function make(o:Object):MovieClipAssemblerItem {
			var item:MovieClipAssemblerItem = new MovieClipAssemblerItem();
			if (o.x) {
				item.x = Number(o.x);
			}
			if (o.y) {
				item.y = Number(o.y);
			}
			if (o.scaleX) {
				item.scaleX = Number(o.scaleX);
			}
			if (o.scaleY) {
				item.scaleY = Number(o.scaleY);
			}
			if (o.rotation) {
				item.rotation = o.rotation;
			}
			if (o.file) {
				item.file = String(o.file);
			}
			if (o.mc && o.mc is MovieClip) {
				item.mc = o.mc;
			}
			if (o.linkage) {
				item.linkage = String(o.linkage);
			}
			if (o.alpha) {
				item.alpha = Number(o.alpha);
			}
			if (o.red || o.green || o.blue) {
				var filter:ColorMatrixFilter = new ColorMatrixFilter(getBasicMatrix(o.red, o.green, o.blue));
				var filters:Array = new Array();
				item.filters.push(filter);
			}
			if (o.blur) {
				var blur:BlurFilter = new BlurFilter(o.blur, o.blur);
				item.filters.push(blur);
			}
			if (o.children) {
				for each (var child:Object in o.children) {
					item.addItem(make(child), child.name);
				}
			}
			return item;
		}

		private static function getBasicMatrix(red:Array = null, green:Array = null, blue:Array = null):Array {
			var matrix:Array = new Array();
			matrix = matrix.concat(red ? red : [1, 0, 0, 0, 0]); // red
			matrix = matrix.concat(green ? green : [0, 1, 0, 0, 0]); // green
			matrix = matrix.concat(blue ? blue : [0, 0, 1, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			return matrix;
		}

		public function MovieClipAssemblerItem() {
			children = new <MovieClipAssemblerItem>[];
		}

		public var alpha:Number              = 1;
		public var file:String;
		public var filters:Array             = new Array();
		public var linkage:String;
		public var mc:MovieClip;
		public var rotation:Number;
		public var scaleX:Number             = 1;
		public var scaleY:Number             = 1;
		public var x:Number                  = 0;
		public var y:Number                  = 0;

		private var children:Vector.<MovieClipAssemblerItem>;
		private var childrenNames:Dictionary = new Dictionary();
		private var onLoaderCallback:Function;
		private var parseChild:int           = 0;


		public function addItem(item:MovieClipAssemblerItem, names:String = null):void {
			childrenNames[children.length] = names ? names.split(".") : null;
			children.push(item);
		}

	
		public function get id():String {
			var _id:String = "";
			_id += file + linkage;
			for each (var child:MovieClipAssemblerItem in children) {
				_id += "," + child.id;
			}
			return _id;
		}


		public function load(onLoaderCallback:Function):void {
			this.onLoaderCallback = onLoaderCallback;
			if (this.mc) {
				onLoad(mc);
			} 
			else if (processMultipleFiles(file)) {
				getFrameFiles(file, onLoad);
			}
			else {
				ImgLoader.instance.getMovieClip(file, linkage, onLoad);
			}
		}

		private function getFilesArray(fileDirective:String):Array {
			var split:Array      = fileDirective.split("...");
			if (split.length > 2) {
				throw new Error("Cannot have multple ... file directives: " + fileDirective);
			}
			var start:String     = split[0];
			var end:String       = split[1];
			if (start == end) {
				return [start];
			}
			var startMatch:Array = start.match(/[0-9]+/);
			if (startMatch == null || startMatch.length == 0) {
				throw new Error("Could not find file numbers in starting file: " + start);
			}
			var endMatch:Array   = end.match(/[0-9]+/);
			if (endMatch == null || endMatch.length == 0) {
				throw new Error("Could not find file numbers in ending file: " + end);
			}
			var startNum:int     = int(startMatch[0]);
			var endNum:int       = int(endMatch[0]);
			var files:Array      = [];
			for (var i:int = startNum; i <= endNum; i++) {
				files.push(end.replace(endNum, StringUtils.padIntWithLeadingZeros(i, endNum.toString().length)));
			}
			return files;
		}

		private function getFrameFiles(fileDirective:String, onLoad:Function):void {
			var dMC:DynamicMovieClip = new DynamicMovieClip();
			var files:Array          = getFilesArray(fileDirective);

			var loaded:int           = 0;
			var onFrameLoad:Function = function(loader:Loader):void {
				if (++loaded == files.length) {
					onLoad(dMC);
				}
			}
			for (var i:int = 0; i < files.length; i++) {
				dMC.addToFrame(i, ImgLoader.instance.getLoader(files[i], onFrameLoad));
			}
		}

		private function loadChild(index:int):void {
			if (index >= children.length) {
				onLoaderCallback(mc);
				return;
			}
			var child:MovieClipAssemblerItem = children[index];
			child.load(onChildLoad);
		}

		private function onChildLoad(childMC:MovieClip):void {
			var location:Array      = childrenNames[parseChild];
			var container:MovieClip = mc;
			if (location != null && location.length > 0) {
				childMC.name = String(location.pop());
				for each (var linkage:String in location) {
					var nestedChild:* = container.getChildByName(linkage);
					if (nestedChild != null && nestedChild is MovieClip) {
						container = nestedChild;
					}
					else {
						throw new Error("Child " + linkage + " was null or not a MovieClip");
					}
				}
			}
			container.addChild(childMC);

			loadChild(++parseChild);
		}

	
		private function onLoad(mc:MovieClip):void {
			mc.x = x;
			mc.y = y;
			mc.alpha = alpha;
			mc.scaleX = scaleX;
			mc.scaleY = scaleY;
			mc.rotation = rotation;
			this.mc = mc;
			mc.filters = filters;
			loadChild(parseChild);
		}


		private function processMultipleFiles(file:String):Boolean {
			return file.indexOf("...") != -1;
		}
	}

}

