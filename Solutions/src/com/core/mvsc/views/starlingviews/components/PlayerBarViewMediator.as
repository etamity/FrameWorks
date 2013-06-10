package com.core.mvsc.views.starlingviews.components
{
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SignalBus;
	
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
			view.initAssets(assets);
		}
		public function init(signal:BaseSignal):void
		{ 


		}
		
	}
}