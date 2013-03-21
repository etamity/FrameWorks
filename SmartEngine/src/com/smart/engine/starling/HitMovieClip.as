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

	public class HitMovieClip extends starling.display.MovieClip {

		public function HitMovieClip(textures:Vector.<Texture>, fps:int = 12) {
			super(textures, fps);
		}

		private var _hitMap:Vector.<GridBool>;

		public function set hitMap(val:Vector.<GridBool>):void {
			_hitMap = val;
		}

		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject {
			var hitCase:DisplayObject = super.hitTest(localPoint, forTouch);
			if (hitCase == null || _hitMap == null) {
				return hitCase;
			}
			var x:int                 = Math.round(localPoint.x);
			var y:int                 = Math.round(localPoint.y);
			var grid:GridBool         = _hitMap[currentFrame];
			return (grid != null && grid.getCell(x, y) == true) ? hitCase : null;
		}
	}

}

