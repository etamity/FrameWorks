//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.loaders {

	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartMovieClip;
	import com.smart.engine.starling.HitMovieClip;
	import com.smart.engine.utils.GridBool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class SpriteSheetLoader implements ITextureLoader {
		private static var proxyTexture:Vector.<Texture>;

		public function SpriteSheetLoader(url:String, frames:Vector.<Rectangle>, offset:Point = null, hitMapTest:Boolean = true) {
			this.url = url;
			this.frames = frames;
			this.offset = offset ? offset : new Point();
			if (hitMapTest) {
				hitMap = new Vector.<GridBool>();
			}
		}

		public var url:String;

		private var frames:Vector.<Rectangle>;
		private var hitMap:Vector.<GridBool>;
		private var offset:Point;
		private var textures:Vector.<Texture>;


		public function getDisplay():DisplayObject {
			if (proxyTexture == null) {
				proxyTexture = new <Texture>[Texture.empty(25, 25)];
			}
			var mc:HitMovieClip = new HitMovieClip(proxyTexture);
			mc.smoothing = TextureSmoothing.NONE;
			return mc;
		
		}

		public function get id():String {
			return url;
		}

	
		public function get isLoaded():Boolean {
			return textures !== null;
		}

	
		public function load():void {
			ImgLoader.instance.getBitmapData(url, onLoad);
		}

		public function setTexture(sprite:SmartDisplayObject):void {
			SmartMovieClip(sprite).setTexture(offset, textures);
			SmartMovieClip(sprite).setHitmap(hitMap);
		}

		private function onLoad(bd:BitmapData):void {
			if (textures) {
				return;
			}
			var bigTexture:Texture = Texture.fromBitmapData(bd);
			var i:int              = 0;
			textures = new <Texture>[];
			var texture:Texture;
			for each (var frame:Rectangle in frames) {
				texture = Texture.fromTexture(bigTexture, frame);
				textures.push(texture);
				if (hitMap != null) {
					hitMap.push(GridBool.fromBitMapDataAlpha(bd, frame));
				}
				i++;
			}
			bd.dispose();
		}
	}

}

