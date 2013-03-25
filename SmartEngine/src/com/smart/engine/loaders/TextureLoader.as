//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.loaders {

	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartSprite;
	import com.smart.engine.starling.HitImage;
	import com.smart.engine.utils.GridBool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class TextureLoader implements ITextureLoader {
		private static var proxyTexture:Texture;

		public function TextureLoader(url:String, offet:Point = null, hitMapTest:Boolean = true) {
			this.url = url;
			this.offset = offset ? offset : new Point();
			this.hitMapTest = hitMapTest;
		}

		private var hitMap:GridBool;
		private var hitMapTest:Boolean;
		private var offset:Point;
		private var texture:Texture;
		private var url:String;


		public function getDisplay():DisplayObject {
			if (proxyTexture == null) {
				proxyTexture = Texture.empty(15, 15);
			}
			var image:HitImage = new HitImage(proxyTexture);
			image.smoothing = TextureSmoothing.NONE;
			return image;
		}

		public function getImage():HitImage {
			if (proxyTexture == null) {
				proxyTexture = Texture.empty(15, 15);
			}
			var image:HitImage = new HitImage(proxyTexture);
			image.smoothing = TextureSmoothing.NONE;
			return image;
		}
	
		public function get id():String {
			return url;
		}


		public function get isLoaded():Boolean {
			return texture !== null;
		}

	
		public function load():void {
			ImgLoader.instance.getBitmapData(url, onLoad);
		}

		
		public function setTexture(sprite:SmartDisplayObject):void {
			if (texture == null) {
				return;
			}
			if (!(sprite is SmartSprite)) {
				throw new Error("sprite " + sprite.textureName + " was created as a " + sprite + " but it's asset was for an SmartSprite");
			}
			SmartSprite(sprite).setTexture(offset, texture);
			SmartSprite(sprite).setHitmap(hitMap);
		}

		private function onLoad(bd:BitmapData):void {
			texture = Texture.fromBitmapData(bd);
			if (hitMapTest) {
				hitMap = GridBool.fromBitMapDataAlpha(bd);
			}
			bd.dispose();
		}
	}

}

