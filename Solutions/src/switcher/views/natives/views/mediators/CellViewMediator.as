package switcher.views.natives.views.mediators
{
	import com.core.mvsc.controllers.signals.GameEvent;
	import com.core.mvsc.model.SignalBus;
	import com.core.mvsc.services.AnimationService;
	
	import caurina.transitions.Tweener;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import switcher.models.GameModel;
	import switcher.models.Node;
	import switcher.views.natives.views.CellView;
	
	public class CellViewMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var view:CellView;
		
		[Inject]
		public var signalBus:SignalBus;
		
		[Inject]
		public var animationService:AnimationService;
		
		public function CellViewMediator()
		{
			super();
		}
		override public function initialize():void 
		{
			view.clickSignal.add(dispathSelected);
			
		}
		public function checkSwitchAble():Boolean{
			var first:Node=gameModel.selectedCell.node;
			var last:Node= node;
			var result:Boolean=false;
			if (first.left==last)
				result=true;
			if (first.right==last)
				result=true;
			if (first.up==last)
				result=true;
			if (first.down==last)
				result=true;
			return result;
		}
		private function get node():Node{
			return view.node;
		}
	
		public function blinking(val:Boolean):void{
			if (val)
				animationService.blink(view.stone);
			else
			{
				Tweener.removeTweens(view.stone);
				view.stone.alpha=1;
			}
		}

		private function dispathSelected():void{
			if (gameModel.selectedCell==null)
			{
				gameModel.selectedCell= view;
				signalBus.dispatch(GameEvent.SELECTED,{cell:view});
			}
			else
			{
				if (checkSwitchAble()==true)
				{
					signalBus.dispatch(GameEvent.SWITCH,{last:view});
				}
				else{
					gameModel.selectedCell= view;
					signalBus.dispatch(GameEvent.SELECTED,{cell:view});
				}
			}
			
		}
	}
}