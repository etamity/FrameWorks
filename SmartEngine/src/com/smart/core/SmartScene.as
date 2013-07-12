package com.smart.core
{
	import com.smart.loaders.ResourcesManager;
	
	import feathers.controls.Screen;
	
	public class SmartScene extends Screen
	{
		protected var game:SmartGame;
		public function SmartScene(game:SmartGame)
		{
			super();
			this.game=game;
		}
		
		public function get assets():ResourcesManager{
			return game.assets;
		}
		public function get system():SmartSystem{
			return game.system;
		}
	}
}