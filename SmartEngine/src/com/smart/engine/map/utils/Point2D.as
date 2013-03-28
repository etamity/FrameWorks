//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.utils {

	import starling.display.*;

	public class Point2D extends Point3D {

		public function Point2D(display:DisplayObject) {
			super();
			sprite = display;
		}

		private var sprite:DisplayObject;

		override public function update(time:Number):void {
			x = sprite.x;
			y = sprite.y;
		}
	}
}

