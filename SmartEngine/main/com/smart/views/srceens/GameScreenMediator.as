package com.smart.views.srceens
{
	import com.smart.model.SignalBus;
	import com.smart.views.signals.ScreenEventConst;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.utils.AssetManager;
	
	public class GameScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view:GameScreen;
	
		[Inject]
		public var assets:AssetManager;
		
		[Inject]
		public var signalBus:SignalBus;
		public function GameScreenMediator()
		{
			super();
		}
		override public function onRegister():void 
		{
			
			//view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//view.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			view.initAssets(assets);
			//signalBus.dispatchSignal(ScreenEventConst.LOADMAP_EVENT,"./TiledMap/map0.tmx");
		}
	}
}