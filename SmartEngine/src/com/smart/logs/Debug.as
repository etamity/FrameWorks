package com.smart.logs  
{
	import com.smart.logs.console.Log;
	
	public class Debug {
		
		public static var CONSOLE_OUTPUT:Boolean = false;
	
		public static function log(... arguments):void 
		{

			
			trace(arguments);
			
			if (CONSOLE_OUTPUT)
				Log(arguments);
			
		}
	}
}