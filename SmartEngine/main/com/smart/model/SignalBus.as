package com.smart.model
{
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;

	public class SignalBus extends Actor
	{

		private var _signalDictionory:Dictionary =new Dictionary();
	
		public function SignalBus()
		{
		}
		
		public function signal(signalName:String):Signal{
			var signalObject:Signal=_signalDictionory[signalName];
			if (signalObject==null){
				signalObject = new Signal();
				_signalDictionory[signalName]=signalObject;
			}
				
			return signalObject;
		}
		public function dispatchSignal(event:String,... args):void{
			signal(event).dispatch(args);
		}
		public function add(event:String,func:Function,addOnce:Boolean=false):void{
			if (addOnce)
				signal(event).addOnce(func);
			else
				signal(event).add(func);
			
		}
	}

}