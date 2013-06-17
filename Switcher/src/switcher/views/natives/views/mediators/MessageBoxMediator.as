/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views.mediators
{
	import switcher.signals.GameEvent;
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SMButton;
	import com.core.mvsc.model.SignalBus;
	import com.core.mvsc.services.AnimationService;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import switcher.models.GameModel;
	import switcher.views.natives.views.MessageBoxView;
	
	public class MessageBoxMediator extends Mediator
	{
		[Inject]
		public var view:MessageBoxView;
		
		[Inject]
		public var animationService:AnimationService;
		
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var signalBus:SignalBus;
		
		private var replayBtn:SMButton;
		private var moreGamesBtn:SMButton;
		public function MessageBoxMediator()
		{
			super();
		}
		override public function initialize():void 
		{
			signalBus.add(GameEvent.MESSAGEBOX,doShowUp);
			
			
			replayBtn=new SMButton(view.replayBtn);
			moreGamesBtn=new SMButton(view.moreGamesBtn);
			
			replayBtn.label="REPLAY";
			moreGamesBtn.label="MORE GAMES";
			
			replayBtn.skin.addEventListener(MouseEvent.CLICK,doReplayEvent);
			moreGamesBtn.skin.addEventListener(MouseEvent.CLICK,doMoreGamesEvent);
		}
		private function doReplayEvent(evt:MouseEvent):void{
			view.visible=false;
			signalBus.dispatch(GameEvent.REPLAY);
		}
		private function doMoreGamesEvent(evt:MouseEvent):void{
			var url:URLRequest = new URLRequest("http://www.king.com");
				navigateToURL(url, "_blank");
		}
		
		private function doShowUp(signal:BaseSignal):void{
			var score:String= signal.params.score;
			view.score=score;
			view.x=view.stage.stageWidth/2;
			view.y=view.stage.stageHeight/2;
			animationService.fadeIn(view);
		}
	}
}