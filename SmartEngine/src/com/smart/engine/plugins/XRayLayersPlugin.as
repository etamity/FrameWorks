//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins {

	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.Plugin;

	public class XRayLayersPlugin extends Plugin implements IPlugin {
		public static const SPEED:int = 2;
		public static const DEFAULT_XRAYLAYERS_PLUGIN: String="DEFAULT_XRAYLAYERS_PLUGIN";
		
		private var engine:TMXPlugin;
		public function XRayLayersPlugin() {
			super();
			name = DEFAULT_XRAYLAYERS_PLUGIN;
			layerIndex = -1; 
		}

		public var alpha:Number       = 1;
		public var counter:int;
		public var layerIndex:int;
		public var paused:Boolean     = true;

		override public function onRegister(engine:IPlugin):void {
			this.engine = engine as TMXPlugin //this.EngineClass(engine)
			
		}

		override public function onRemove():void {
			super.onRemove();
		}

		override public function onTrigger(time:Number):void {
			if (layerIndex == -1) {
				layerIndex = engine.numberOfLayers - 1;
				alpha = 1;
				return;
			}
			
			engine.getLayerByIndex(layerIndex).display.alpha = alpha;
			counter += 1;
			if (paused && counter < SPEED) {
				return;
			}
			paused = false;
			counter = 0;
			alpha -= .01;
			if (alpha <= -.4) {
				engine.getLayerByIndex(layerIndex).display.alpha = 1;
				layerIndex--;
				alpha = 1;
				paused = true;
			}
		}
	}

}

