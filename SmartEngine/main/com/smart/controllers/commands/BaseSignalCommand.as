package com.smart.controllers.commands
{
	import org.robotlegs.mvcs.StarlingSignalCommand;
	
	public class BaseSignalCommand extends StarlingSignalCommand
	{
		public function BaseSignalCommand()
		{
			super();
		}
		
		public function undo():void{
			
		}
	}
}