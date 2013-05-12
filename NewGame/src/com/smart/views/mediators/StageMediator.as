package com.smart.views.mediators
{
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.loaders.ResourcesManager;
	import com.smart.model.SignalBus;
	import com.smart.views.ProgressBar;
	
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class StageMediator extends StarlingMediator
	{	
		[Inject]
		public var signalBus:SignalBus;
		[Inject]
		public var assets:ResourcesManager;
		
		[Inject]
		public var view:Stage;
		
		public function StageMediator()
		{
			super();
		}
		override public function initialize():void 
		{
			loadResources();
		}
		private function start():void{
			signalBus.dispatch(SystemEvent.STARTUP_SIGNAL);
		}

		private function loadResources():void{
			
			var mLoadingProgress:ProgressBar = new ProgressBar(175, 20);
			mLoadingProgress.x = (Starling.current.nativeStage.stageWidth  - mLoadingProgress.width) / 2;
			mLoadingProgress.y = (Starling.current.nativeStage.stageHeight - mLoadingProgress.height) / 2;
			mLoadingProgress.y = Starling.current.nativeStage.stageHeight * 0.7;
			view.addChild(mLoadingProgress);
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
	}
}