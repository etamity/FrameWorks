//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.plugins {

	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.MapEngine;
	import com.smart.engine.map.utils.Point3D;

	public class CameraPlugin extends Plugin {
		private static const ZOOM_IN_LIMIT:Number  = 5;
		private static const ZOOM_OUT_LIMIT:Number = .1;

		private var engine:MapEngine;		
		public function CameraPlugin(position:Point3D = null) {
			super();
			this.position = position;
		}

		public var position:Point3D;

		override public function onRegister(engine:IEngine):void {
			this.engine = engine as MapEngine;
		}

		override public function onTrigger(time:Number):void {
			position.update(time); 

			engine.moveTo(-position.x, -position.y);
			position.z = Math.min(ZOOM_IN_LIMIT, position.z);
			position.z = Math.max(ZOOM_OUT_LIMIT, position.z);
			engine.currentZoom = position.z;
		}
	}

}

