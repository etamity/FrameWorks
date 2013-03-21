//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.starling {

	import flash.geom.Point;
	import com.smart.engine.utils.GridBool;
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class HitImage extends starling.display.Image {

		public function HitImage(texture:Texture) {
			super(texture);
		}

		private var _hitMap:GridBool;

		public function set hitMap(val:GridBool):void {
			_hitMap = val;
		}

		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject {
			var hitCase:DisplayObject = super.hitTest(localPoint, forTouch);
			if (hitCase == null || _hitMap == null) {
				return hitCase;
			}
			var x:int                 = Math.round(localPoint.x);
			var y:int                 = Math.round(localPoint.y);
			return _hitMap.getCell(x, y) == true ? hitCase : null;
		}
	}

}

