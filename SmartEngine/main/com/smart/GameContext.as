package com.smart 
{
	import com.smart.controllers.commands.InitDataCommand;
	import com.smart.controllers.commands.StartupCommand;
	import com.smart.controllers.signals.SystemEventConst;
	import com.smart.loaders.ResourcesManager;
	import com.smart.logs.console.Console;
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.model.GameConfig;
	import com.smart.model.Language;
	import com.smart.model.SignalBus;
	import com.smart.services.ThemeService;
	import com.smart.views.MainMediator;
	import com.smart.views.MainView;
	import com.smart.views.ProgressBar;
	
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalStarlingContext;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	
	
	public class GameContext extends SignalStarlingContext 
	{
		
		private var _startup:Signal;
		private var assets:ResourcesManager;
		public function GameContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true) 
		{
			super(contextView, autoStartup);
		}
		

		override public function startup():void 
		{
			mapClasses()
			createInstance();
			mapSingletons();
			mapViews();
			mapSignals();	

		}
		
		
		private function mapClasses():void{
			injector.mapClass(GameConfig,GameConfig);
			
		}

		private function mapViews():void{
			mediatorMap.mapView(MainView, MainMediator);
		}
		
		public function start():void{
			_startup.dispatch();
			var main:MainView= new MainView();
	
			contextView.addChild(main);
	
			contextView.addChild(new Console());
		}
		private function createInstance():void{
			
			var mLoadingProgress:ProgressBar = new ProgressBar(175, 20);
			mLoadingProgress.x = (Starling.current.nativeStage.stageWidth  - mLoadingProgress.width) / 2;
			mLoadingProgress.y = (Starling.current.nativeStage.stageHeight - mLoadingProgress.height) / 2;
			mLoadingProgress.y = Starling.current.nativeStage.stageHeight * 0.7;
			this.contextView.addChild(mLoadingProgress);
			
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight), 
				new Rectangle(0, 0, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; 
			assets =ResourcesManager.instance;
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(AssetEmbeds_3x);
			
			
			assets.loadQueue(function(ratio:Number):void
			{
				mLoadingProgress.ratio = ratio;
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						mLoadingProgress.removeFromParent(true);
						mLoadingProgress = null;
						start();
						
					}, 0.15);
			});
			

		}
		private function mapSingletons():void {
			injector.mapSingleton(SignalBus);
			injector.mapSingleton(Language);
			injector.mapValue(ConsoleCommand,ConsoleCommand.getInstance());
			injector.mapValue(ResourcesManager,ResourcesManager.instance);
			injector.mapSingleton(ThemeService);
		}
		private function mapSignals():void{
			var signalBus:SignalBus=injector.getInstance(SignalBus);
			_startup= signalBus.signal(SystemEventConst.STARTUP_SIGNAL);
			signalCommandMap.mapSignal(signalBus.signal(SystemEventConst.INIT_DATA),InitDataCommand);
			signalCommandMap.mapSignal(_startup,StartupCommand,true);
		}
		
		
		
	}

}