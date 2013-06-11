package com.core.mvsc.controllers.commands
{
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.core.mvsc.model.SignalBus;
	
	public class DataLoadCommand extends BaseCommand
	{
		[Inject]
		public var signalBus:SignalBus;
		
		public function DataLoadCommand()
		{
			super();
		}
		override public function execute():void{
			signalBus.dispatch(SystemEvent.DATA_LOADED);
		}

	}
}