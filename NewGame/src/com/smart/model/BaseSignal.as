package com.smart.model 
{
	import org.osflash.signals.Signal;
	
	public class BaseSignal extends Signal
	{
	
		private var _type:String;
		
		private var _params:Object={};
		
		public function BaseSignal(...parameters)
		{
			super(parameters);
		}
		
		public function get type():String{
			return _type;
		}
		
		public function set type(val:String):void{
			_type=val;
		}
		
		
		public function get params():Object{
			return _params;
		}
		
		public function set params(val:Object):void{
			_params=val;
		}
	}
}