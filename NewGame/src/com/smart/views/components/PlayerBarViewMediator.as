package com.smart.views.components
{
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.model.BaseSignal;
	import com.smart.model.SignalBus;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.utils.AssetManager;
	
	public class PlayerBarViewMediator extends StarlingMediator
	{
		[Inject]
		public var view:PlayerBarView;
		
		[Inject]
		public var assets:AssetManager;
		
		[Inject]
		public var signalBus:SignalBus;
		public function PlayerBarViewMediator()
		{
			super();
		}
		
		override public function initialize():void 
		{
			//signalBus.add(SystemEvent.SETUP_LAYOUT,init);
			//view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//view.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			view.initAssets(assets);
		}
		public function init(signal:BaseSignal):void
		{ 
			//view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);


		}
		
	}
}