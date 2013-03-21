package com.smart.controllers.commands
{
	import com.smart.controllers.signals.SystemEventConst;
	import com.smart.services.ThemeService;
	
	import org.robotlegs.mvcs.StarlingSignalCommand;
	
	public class InitDataCommand extends StarlingSignalCommand
	{
		[Inject]
		public var themeManager:ThemeService;
		public function InitDataCommand()
		{
			super();
		}
		override public function execute():void{
			themeManager.update();
		}
	}
}