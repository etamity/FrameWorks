//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.display {

	import com.smart.engine.starling.HitImage;
	import com.smart.engine.utils.GridBool;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.utils.State;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class SmartSprite extends SmartDisplayObject {
		public function SmartSprite(name:String, pt:Point3D = null, state:State = null) {
			super(name, pt, state);
		}

		private var _display:HitImage;

		override public function get display():DisplayObject {
			return _display;
		}

	
		override public function set display(val:DisplayObject):void {
			if (val == null) {
				throw new Error("img is null");
			}
			if (!(val is HitImage)) {
				throw new Error("Starling DisplayObject is not an Image.");
			}
			if (_display != null && val != _display) {
				if (_display.parent) {
					_display.parent.removeChild(_display);
				}
			}
			_display = HitImage(val);
		}


		public function setHitmap(hitMap:GridBool):void {
			_display.hitMap = hitMap;
		}


		public function setTexture(offset:Point, val:Texture):void {
			_display.texture = val;
			if (!offset.y) {
				offset.y = 0;
			}
			if (!offset.x) {
				offset.x = 0;
			}
			_display.readjustSize();
			_display.pivotY = _display.height + offset.y;
			_display.pivotX = 0 + offset.x;
			/*if (layer) {
				layer.forceUpdate();
			}*/
		}
	}
}

