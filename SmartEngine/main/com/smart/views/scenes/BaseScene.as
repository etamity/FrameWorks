//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.views.scenes {

	import com.smart.Engine;
	
	import feathers.controls.Screen;
	
	import starling.utils.AssetManager;

	public class BaseScene extends Screen {
		protected var engine:Engine;
		private var _assets:AssetManager;
		public function BaseScene() {
		}
		
		override protected function initialize():void{
		}

		override public function dispose():void{
			super.dispose();
			if (engine != null)
				engine.dispose();
		}

		public function start():void{
			if (engine != null)
				engine.dispose();
			
			engine = new Engine(this);
			addPlugins(engine);
			engine.start();
		}
		
		public function addPlugins(engine:Engine):void {
			
		}
	
		public function set assets(val:AssetManager):void
		{
			_assets=val;
		}
		
		public function get assets():AssetManager
		{
			return _assets;
		}
	}
}

