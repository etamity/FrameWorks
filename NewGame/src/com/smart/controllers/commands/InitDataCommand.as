package com.smart.controllers.commands
{
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.model.SignalBus;
	import com.smart.services.ThemeService;
	
	public class InitDataCommand extends BaseCommand
	{
		[Inject]
		public var themeManager:ThemeService;
		[Inject]
		public var signalBus:SignalBus;
		
		public function InitDataCommand()
		{
			super();
		}
		override public function execute():void{
			themeManager.update();
			signalBus.dispatch(SystemEvent.INIT_DATA_FINISHED);
		}

	}
}