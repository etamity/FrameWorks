package com.smart.logs.console 
{
	import com.smart.logs.console.Console;
	/**
	 * ...
	 * @author Joey Etamity
	 */
	public function Log(... arguments):void
	{
			Console.log.apply(this,arguments);
	}

}