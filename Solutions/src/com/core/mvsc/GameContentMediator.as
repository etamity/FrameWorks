package com.core.mvsc
{
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.smart.logs.console.Console;
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SignalBus;
	import solutions.views.starling.screens.MainScreen;
	
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
			signalBus.add(SystemEvent.SETUPVIEW,init);
		}
		public function init(signal:BaseSignal):void{
			view.addChild(new MainScreen());
			view.addChild(new Console());
		}	
	
	}
}