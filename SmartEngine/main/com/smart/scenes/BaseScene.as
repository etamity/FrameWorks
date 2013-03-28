//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.scenes {

	import com.smart.SmartSystem;
	
	import feathers.controls.Screen;
	
	import starling.utils.AssetManager;

	public class BaseScene extends Screen {
		protected var system:SmartSystem;
		private var _assets:AssetManager;
		public function BaseScene() {
		}
		
		override protected function initialize():void{
		}

		override public function dispose():void{
			super.dispose();
			if (system != null)
				system.dispose();
		}

		public function start():void{
			if (system != null)
				system.dispose();
			
			system = new SmartSystem(this);
			addPlugins(system);
			system.start();
		}
		
		public function addPlugins(system:SmartSystem):void {
			
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

