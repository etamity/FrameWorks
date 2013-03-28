//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.scenes {

	import com.smart.SmartSystem;
	import com.smart.loaders.AssetsManager;
	
	import feathers.controls.Screen;

	public class BaseScene extends Screen {
		protected var system:SmartSystem;
		private var _assets:AssetsManager;
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
	
		public function set assets(val:AssetsManager):void
		{
			_assets=val;
		}
		
		public function get assets():AssetsManager
		{
			return _assets;
		}
	}
}

