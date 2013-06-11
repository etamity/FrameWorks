package switcher.views.natives.views.mediators
{
	import com.core.mvsc.controllers.signals.GameEvent;
	import com.core.mvsc.model.SignalBus;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import switcher.models.GameModel;
	import switcher.views.natives.views.StoneView;
	
	public class StoneViewMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var view:StoneView;
		
		[Inject]
		public var signalBus:SignalBus;
		public function StoneViewMediator()
		{
			super();
		}
		override public function initialize():void 
		{
			view.clickSignal.add(dispathSelected);
		}
		private function dispathSelected(stone:StoneView):void{
			if (gameModel.stoneFirst==-1)
			{
				gameModel.stoneFirst= stone.index;
				signalBus.dispatch(GameEvent.SELECTED,{id:gameModel.stoneFirst});
			}
			else
			{
				gameModel.stoneLast=stone.index;
				signalBus.dispatch(GameEvent.SWITCH,{id1:gameModel.stoneFirst,id2:gameModel.stoneLast});
			}
			
		}
	}
}