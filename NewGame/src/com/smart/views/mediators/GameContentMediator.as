package com.smart.views.mediators
{
	import com.smart.GameContent;
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.model.BaseSignal;
	import com.smart.model.SignalBus;
	import com.smart.views.MainView;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class GameContentMediator extends StarlingMediator
	{
		[Inject]
		public var view:GameContent;
		[Inject]
		public var signalBus:SignalBus;
		public function GameContentMediator()
		{
			super();
		
		}
		override public function initialize():void 
		{
			signalBus.add(SystemEvent.SETUP_LAYOUT,init);
		}
		public function init(signal:BaseSignal):void{
			trace("GameContentMediator.init");
			view.addChild(new MainView())
		}
	
	}
}