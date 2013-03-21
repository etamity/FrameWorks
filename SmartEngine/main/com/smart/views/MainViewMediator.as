package com.smart.views 
{

	import com.smart.controllers.signals.SystemEventConst;
	import com.smart.logs.Debug;
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.model.GameConfig;
	import com.smart.model.SignalBus;
	import com.smart.views.signals.ScreenEventConst;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class MainViewMediator extends StarlingMediator 
	{

		[Inject]
		public var view:MainView;
		[Inject]
		public var signalBus:SignalBus;
		[Inject]
		public var commandManager:ConsoleCommand;
		[Inject]
		public var gameConfig:GameConfig;
		[Inject]
		public var assets:AssetManager;
		
		private var _scene:BaseScene;
	
		public function MainViewMediator() 
		{
			super();
			
		}

		override public function onRegister():void 
		{

			init();
			signalBus.add(ScreenEventConst.LOADMAP_EVENT,loadScene,true);
			
		}
		
		public function registerCommand():void{
			commandManager.registerCmd("bird.stop",stop);
			//commandManager.registerCmd("bird.play",play);
		}
		
		public function loadScene(map:String):void{

			_scene.loadMap(map);
			
			
		}
		public function stop():void{
			view.stop();
			Debug.log("Bird Stop...！");
		}	

		public function init():void
		{  
			_scene= new BaseScene();
			view.addChild(_scene);
			registerCommand()
		}
		
		
	}

}