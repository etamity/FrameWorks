package com.smart.controllers.commands
{
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.model.SignalBus;
	
	
	public class InitFinishedCommand extends BaseCommand
	{	[Inject]
		public var signalBus:SignalBus;

		public function InitFinishedCommand()
		{
			super();
		}
		override public function execute():void{
			signalBus.dispatch(SystemEvent.SETUP_LAYOUT);
		}
	}
}