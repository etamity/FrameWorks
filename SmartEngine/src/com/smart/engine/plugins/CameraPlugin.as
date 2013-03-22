//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins {

	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.IPluginEngine;
	import com.smart.engine.core.Plugin;
	import com.smart.engine.utils.Point3D;

	public class CameraPlugin extends Plugin implements IPlugin {
		public static var instance:CameraPlugin;

		private static const ZOOM_IN_LIMIT:Number  = 5;
		private static const ZOOM_OUT_LIMIT:Number = .1;

		
		public function CameraPlugin(position:Point3D = null) {
			super();
			this.position = position;
			CameraPlugin.instance = this;
		}

		public var position:Point3D;

		override public function onRegister(engine:IPluginEngine):void {
			super.onRegister(engine);
		}

		override public function onRemove():void {
			super.onRemove();
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

