package com.smart.mvsc.controllers.commands
{
	import com.smart.mvsc.controllers.signals.SystemEvent;
	import com.smart.mvsc.model.SignalBus;
	
	public class DataInitCommand extends BaseCommand
	{
		[Inject]
		public var signalBus:SignalBus;
		
		public function DataInitCommand()
		{
			super();
		}
		override public function execute():void{
			signalBus.dispatch(SystemEvent.DATA_LOADED);
		}

	}
}