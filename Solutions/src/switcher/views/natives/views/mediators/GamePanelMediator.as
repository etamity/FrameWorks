/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views.mediators
{
	import com.core.mvsc.controllers.signals.GameEvent;
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SMButton;
	import com.core.mvsc.model.SignalBus;
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
		[Inject]
		public var signalBus:SignalBus;
		
		private var timer:Timer=new Timer(1000);
		private var time:int=60;
		private var spinBtn:SMButton;
		
		private var score:int=0;
		public function GamePanelMediator()
		{
			super();
			timer.addEventListener(TimerEvent.TIMER,onTimerEvent);
		}
		private function doSpinEvent(evt:MouseEvent):void{
			var stoneGrids:Array= gameModel.getStonesInCell();
			
			animationService.spinGrids(stoneGrids,gameModel.rowCount,gameModel.colCount);
			
		}
		private function onTimerEvent(evt:TimerEvent):void{
			time--;
			refresh();
			if (time==0)
			{
				timer.stop();
				signalBus.dispatch(GameEvent.MESSAGEBOX,{score:view.scoreTxt.text});
				signalBus.dispatch(GameEvent.GAMEFINISHED);
			}
		
		}
		private function doAddScore(signal:BaseSignal):void{
			var point:int= signal.params.point;
			score += point;
			refresh();
		}
		private function doReplay(signal:BaseSignal):void{
			time=60;
			score=0;
			refresh();
			timer.start();
		}
		private function refresh():void{
			view.time=String(time);
			view.score=String(score);
			view.bombMc.gotoAndStop(60-time);
		}
		private function doAddTime(signal:BaseSignal):void{
			var seconds:int=signal.params.seconds;
			if (time+seconds<60)
				time+=seconds;
			else
				time=60;
			refresh();
		}
		override public function initialize():void 
		{	signalBus.add(GameEvent.REPLAY,doReplay);
			signalBus.add(GameEvent.ADDSCORE,doAddScore);
			signalBus.add(GameEvent.ADDTIME,doAddTime);
			
			spinBtn=new SMButton(view.spinBtn);
			spinBtn.label="SPIN";
			spinBtn.skin.addEventListener(MouseEvent.CLICK,doSpinEvent);
			timer.start();
		}
	}
}