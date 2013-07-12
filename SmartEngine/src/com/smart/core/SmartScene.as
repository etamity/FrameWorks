package com.smart.core
{
	import feathers.controls.Screen;
	
	public class SmartScene extends Screen
	{
		protected var game:SmartGame;
		public function SmartScene(game:SmartGame)
		{
			super();
			this.game=game;
		}

		public function addPlugins(system:SmartSystem):void {
	
		}
	}
}