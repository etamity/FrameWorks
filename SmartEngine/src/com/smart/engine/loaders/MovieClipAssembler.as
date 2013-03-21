//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.loaders {

	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartMovieClip;
	import com.smart.engine.starling.HitMovieClip;
	import com.smart.engine.utils.GridBool;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class MovieClipAssembler implements ITextureLoader {
		private static var proxyTexture:Vector.<Texture>;

	
		public static function getTextures(mc:MovieClip, hitMap:Vector.<GridBool> = null):Vector.<Texture> {
			var target:MovieClip          = mc;
			var textures:Vector.<Texture> = new Vector.<Texture>();
		
			var frames:int                = findLongestFrame(mc);
			var matrix:Matrix             = new Matrix();
			var rect:Rectangle            = findBiggestFrame(mc, frames);
			if (rect.width < 1 || rect.height < 1) {
				throw new Error("Empty MC assembled object (zero width or zero height)");
			}
			for (var i:int = 1; i <= frames; i++) {
				nextFrame(mc);

				var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				matrix.tx = -rect.x;
				matrix.ty = -rect.y;
				bmd.draw(mc, matrix, null, null, null, true);
				textures.push(Texture.fromBitmapData(bmd));
				if (hitMap != null) {
					var hitMapItem:GridBool = GridBool.fromBitMapDataAlpha(bmd);
					hitMap.push(hitMapItem);
				}
				bmd.dispose();
			}
			return textures;
		}

		private static function findBiggestFrame(mc:MovieClip, frames:int):Rectangle {
			var rect:Rectangle = new Rectangle();
			var lastRect:Rectangle;
			for (var i:int = 1; i <= frames; i++) {
				nextFrame(mc);
				lastRect = mc.getBounds(mc);
				rect = rect.union(lastRect);
			}
			resetFrame(mc);
			return rect;
		}

		private static function findLongestFrame(mc:MovieClip):int {
			var current:int = mc.totalFrames;
			for (var i:int = 0; i < mc.numChildren; i++) {
				var child:flash.display.DisplayObject = mc.getChildAt(i);
				if (child is MovieClip) {
					current = Math.max(current, findLongestFrame(MovieClip(child)));
				}
			}
			return current;
		}

		private static function nextFrame(mc:MovieClip):void {
			mc.nextFrame();
			for (var i:int = 0; i < mc.numChildren; i++) {
				var child:flash.display.DisplayObject = mc.getChildAt(i);
				if (child is MovieClip) {
					nextFrame(MovieClip(child));
				}
			}
		}

		private static function resetFrame(mc:MovieClip):void {
			mc.gotoAndStop(0);
			for (var i:int = 0; i < mc.numChildren; i++) {
				var child:flash.display.DisplayObject = mc.getChildAt(i);
				if (child is MovieClip) {
					resetFrame(MovieClip(child));
				}
			}
		}

		public function MovieClipAssembler(items:MovieClipAssemblerItem, fps:int = 12, hitMapTest:Boolean = true) {
			this.items = items;
			_id = items.id;
			this.fps = fps;
			offset = new Point(items.x, items.y);
			if (hitMapTest) {
				hitMap = new Vector.<GridBool>();
			}
		}

		private var _id:String;
		private var fps:int;
		private var hitMap:Vector.<GridBool>;
		private var items:MovieClipAssemblerItem;
		private var offset:Point;
		private var textures:Vector.<Texture>;

		public function getDisplay():DisplayObject {
			if (proxyTexture == null) {
				proxyTexture = new <Texture>[Texture.empty(15, 15)];
			}
			return new HitMovieClip(proxyTexture, fps);
		}

		public function get id():String {
			return _id;
		}

		public function get isLoaded():Boolean {
			return textures !== null;
		}

		public function load():void {
			items.load(onLoad);
		}

		public function setTexture(sprite:SmartDisplayObject):void {
			SmartMovieClip(sprite).setTexture(offset, textures);
			SmartMovieClip(sprite).setHitmap(hitMap);
		}

		private function onLoad(mc:MovieClip):void {
			if (mc == null) {
				throw new Error("failed to load MovieClipAssemblerItem");
			}

			var container:MovieClip = new MovieClip();
			container.addChild(mc);
			textures = getTextures(container, hitMap);
		}
	}

}

