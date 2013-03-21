//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.utils {

	import flash.geom.Point;

	public class Point3D extends Point {

		public function Point3D(x:Number = 1, y:Number = 1, z:Number = 1) {
			super(x, y);
			this.z = z;
		}

		public var z:Number;

		public function update(time:Number):void {
		}
	}

}

