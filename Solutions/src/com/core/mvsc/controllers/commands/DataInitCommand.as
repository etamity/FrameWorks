package com.core.mvsc.controllers.commands
{
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.core.mvsc.model.SignalBus;
	
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