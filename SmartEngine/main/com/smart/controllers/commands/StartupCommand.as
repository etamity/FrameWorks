package com.smart.controllers.commands
{
	import com.smart.logs.console.Console;
	import com.smart.model.SignalBus;
	import com.smart.controllers.signals.SystemEventConst;
	import com.smart.views.MainView;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;
	

	public class StartupCommand extends BaseSignalCommand
	{
		[Inject]
		public var signalBus:SignalBus;
		public function StartupCommand()
		{
			super();
		}
		override public function execute():void{
			signalBus.dispatchSignal(SystemEventConst.INIT_DATA);
		}
	}
}