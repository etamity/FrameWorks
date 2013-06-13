package switcher.views.natives.views.mediators
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import switcher.views.natives.views.GamePanelView;
	
	public class GamePanelMediator extends Mediator
	{
		[Inject]
		public var view:GamePanelView;
		
		private var timer:Timer=new Timer(1000);
		
		private var time:int=60;
		public function GamePanelMediator()
		{
			super();
			timer.addEventListener(TimerEvent.TIMER,onTimerEvent);
			
		}
		private function onTimerEvent(evt:TimerEvent):void{
			time--;
			view.time(String(time));
			view.bombMc.gotoAndStop(60-time);
			if (time==0)
			{
				timer.stop();
			}
		
		}
		override public function initialize():void 
		{
			timer.start();
		}
	}
}