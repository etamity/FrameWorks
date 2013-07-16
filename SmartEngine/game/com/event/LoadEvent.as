/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.event 
{
	import flash.events.Event;
	
	public class LoadEvent extends Event 
	{
		public static const LOADED:String = "loaded";
		public static const LOADING:String = "loading";
		
		private var _info:Object;
		
		public function LoadEvent(type:String, info:Object) 
		{ 
			super(type, false, false);
			
			_info = info;
		} 
		
		public function get info():Object 
		{
			return _info;
		}
	}
	
}