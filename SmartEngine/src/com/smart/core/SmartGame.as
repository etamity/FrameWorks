package com.smart.core
{
	import com.smart.SmartWorld;
	import com.smart.loaders.ResourcesManager;
	
	import starling.display.Sprite;

	public class SmartGame extends Sprite
	{
		private var _system:SmartSystem;

		private var _assets:ResourcesManager;
		private var _world:SmartWorld;
		private var _currentScene:SmartScene;

		public function SmartGame()
		{
			super();

		}

		override public function dispose():void
		{
			super.dispose();
			if (_system != null)
				_system.dispose();
		}

		public function showScene(scene:*):void
		{
			if (_currentScene && scene == null)
				return;

			var sceneClass:Class=scene as Class;
			_currentScene=new sceneClass(this) as SmartScene;
			addChild(_currentScene);
		}

		public function closeScene():void
		{
			_currentScene.removeFromParent(true);
			_currentScene=null;
		}

		public function start(scene:*, resources:ResourcesManager):void
		{
			_assets=resources;
			showScene(scene);
			if (_system != null)
				_system.dispose();
			_system=new SmartSystem(_currentScene);
			_currentScene.addPlugins(_system);
			_system.start();

		}
		public function get system():SmartSystem{
			return _system;
		}

		public function get assets():ResourcesManager
		{
			return _assets;
		}

	}
}
