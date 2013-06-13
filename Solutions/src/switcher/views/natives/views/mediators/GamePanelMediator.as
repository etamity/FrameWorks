package switcher.views.natives.views.mediators
{
	import com.core.mvsc.services.AnimationService;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import switcher.models.GameModel;
	import switcher.views.natives.views.GamePanelView;
	
	public class GamePanelMediator extends Mediator
	{
		[Inject]
		public var view:GamePanelView;
		
		[Inject]
		public var animationService:AnimationService;
		[Inject]
		public var gameModel:GameModel;
		
		private var timer:Timer=new Timer(1000);
		private var time:int=60;
		
		public function GamePanelMediator()
		{
			super();
			timer.addEventListener(TimerEvent.TIMER,onTimerEvent);
			view.spinBtn.addEventListener(MouseEvent.CLICK,doSpinEvent);
		}
		private function doSpinEvent(evt:MouseEvent):void{
			var stoneGrids:Array= gameModel.getStonesInCell();
			
			animationService.spinGrids(stoneGrids,gameModel.rowCount,gameModel.colCount);
			
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