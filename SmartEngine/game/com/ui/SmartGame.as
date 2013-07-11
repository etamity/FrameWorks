package com.ui
{
	import com.smart.SmartWorld;
	import com.smart.core.SmartSystem;
	import com.smart.loaders.ResourcesManager;
	
	import starling.display.Sprite;
	
	public class SmartGame extends Sprite
	{
		protected var system:SmartSystem;
		
		private var _assets:ResourcesManager;
		private var _world:SmartWorld;
		private var _currentScene:SmartScene;
		public function SmartGame()
		{
			super();
	
			

		}
		override public function dispose():void{
			super.dispose();
			if (system != null)
				system.dispose();
		}
		
		public function showScene(scene:*):void
		{
			if (_currentScene && scene==null) return;
			
			var sceneClass:Class = scene as Class;
			_currentScene = new sceneClass() as SmartScene;
			addChild(_currentScene);
		}
		
		public function closeScene():void
		{
			_currentScene.removeFromParent(true);
			_currentScene = null;
		}
		
		public function start(scene:*,resourceManager:ResourcesManager):void{
			_assets =resourceManager;
			showScene(scene);
			if (system != null)
				system.dispose();
			system = new SmartSystem(_currentScene);
			_currentScene.addPlugins(system);
			system.start();

		}
		public function get assets():ResourcesManager{
			return _assets;
		}

	}
}