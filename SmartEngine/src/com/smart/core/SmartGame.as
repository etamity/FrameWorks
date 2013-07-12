package com.smart.core
{
	import com.smart.SmartWorld;
	import com.smart.loaders.ResourcesManager;
	
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;

	public class SmartGame extends Sprite
	{
		private var _system:SmartSystem;

		private var _assets:ResourcesManager;
		private var _world:SmartWorld;
		private var _currentScene:SmartScene;
		private var _sceneList:Dictionary;
		public function SmartGame()
		{
			super();
			_sceneList=new Dictionary();

		}

		override public function dispose():void
		{
			super.dispose();
			if (_system != null)
				_system.dispose();
		}

		public function showScene(name:String):void{
			var sceneClass:Class=_world.getSceneClassByName(name);
			if (sceneClass != null)
			{	
				closeScene();
				_currentScene=new sceneClass(this) as SmartScene;
				_currentScene.name=name;
				_sceneList[_currentScene.name]=_currentScene;
				addChild(_currentScene);
			}
		}

		public function closeScene():void
		{
			if (_currentScene!=null){
			_sceneList[_currentScene.name]=null;
			_currentScene.removeFromParent(true);
			_currentScene=null;
			}
		
		}

		public function start(world:SmartWorld,resources:ResourcesManager):void
		{
			_world=world;
			_assets=resources;
			if (_system != null)
				_system.dispose();
			_system=new SmartSystem(this);
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
