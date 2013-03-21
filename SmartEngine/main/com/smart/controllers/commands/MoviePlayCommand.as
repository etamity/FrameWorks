package com.smart.controllers.commands 
{
	import com.smart.logs.Debug;
	import com.smart.model.SignalBus;
	import com.smart.controllers.signals.SystemEventConst;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.StarlingSignalCommand;

	public class MoviePlayCommand extends StarlingSignalCommand 
	{
		[Inject]
		public var signalBus:SignalBus;
		
		public function MoviePlayCommand() 
		{
			super();
		}

		override public function execute():void 
		{
			Debug.log("Bird Flying...！");
			var timer:Timer = new Timer(5000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start();
		}

		private function timerCompleteHandler(e:TimerEvent):void 
		{
			var timer:Timer = e.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
			signalBus.signal(SystemEventConst.STOP_SIGNAL).dispatch();
	
			//dispatch(new GameEvent(GameEvent.STOP_MOVIE));
		}
	}

}