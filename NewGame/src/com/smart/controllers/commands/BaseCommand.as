package com.smart.controllers.commands
{
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class BaseCommand extends Command
	{
		public function BaseCommand()
		{
			super();
			trace(this);
		}
		
	}
}