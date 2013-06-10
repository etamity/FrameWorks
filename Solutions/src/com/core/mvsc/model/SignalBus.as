package com.core.mvsc.model
{
	import flash.utils.Dictionary;
	
	import robotlegs.bender.framework.api.ILogger;
	
	public class SignalBus
	{
		
		[Inject]
		public var _logger:ILogger;
		
		private var _signalDictionory:Dictionary =new Dictionary();
		
		public function SignalBus()
		{
		}
		
		public function signal(signalName:String):BaseSignal{
			var signalObject:BaseSignal=_signalDictionory[signalName];
			if (signalObject==null){
				signalObject = new BaseSignal(BaseSignal);
				signalObject.type=signalName;
				_signalDictionory[signalName]=signalObject;
			}
			
			return signalObject;
		}
		public function dispatch(event:String,parameters:Object=null):void{
			var sign:BaseSignal = signal(event);
			debug("[dispatch]:"+event);
			sign.params=parameters;
			sign.dispatch(sign);
		}
		public function add(event:String,func:Function,addOnce:Boolean=false):void{
			if (addOnce)
				signal(event).addOnce(func);
			else
				signal(event).add(func);
			
		}
		private function debug(...args):void {
			//GameUtils.log(this, args);
			_logger.debug(args);
		}
	}
}