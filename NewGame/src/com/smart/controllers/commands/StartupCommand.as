package com.smart.controllers.commands
{
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.model.SignalBus;
	

	public class StartupCommand extends BaseCommand
	{
		[Inject]
		public var signalBus:SignalBus;
		public function StartupCommand()
		{
			super();
		}
		override public function execute():void{
			trace("StartupCommandStartupCommand");
			signalBus.dispatch(SystemEvent.INIT_DATA);
		}
	}
}