package switcher.views.natives.views.mediators
{
	import com.core.mvsc.controllers.signals.GameEvent;
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SignalBus;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import caurina.transitions.Tweener;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	import robotlegs.bender.extensions.contextView.ContextView;
	
	import switcher.models.GameModel;
	import switcher.models.StoneType;
	import switcher.views.natives.views.CellsView;
	import switcher.views.natives.views.StoneView;
	
	public class CellsViewMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var view:CellsView;
		
		[Inject]
		public var signalBus:SignalBus;
		
		[Inject]
		public var contextView:ContextView;
		private var _stones:Array=new Array();
		
		private var _currentSelected:StoneView;
		
		
		private var _selectMc :SelectAsset =new SelectAsset();
		
		public function CellsViewMediator()
		{
			super();
		
			
		}

		override public function initialize():void 
		{
			signalBus.add(SystemEvent.DATA_LOADED, setupModel);
			signalBus.add(GameEvent.SWITCH, switchStone);
			signalBus.add(GameEvent.SELECTED, selectStone);

		
		}
		private function selectStone(signal:BaseSignal):void{
			var id:int= signal.params.id;
			_currentSelected= _stones[id];
			_selectMc.x=_currentSelected.x;
			_selectMc.y=_currentSelected.y;
			_selectMc.visible=true;
			var switchAbleArrary:Array= gameModel.getSideStones(id);
			enableMouseStones(switchAbleArrary);
		}
		
		private function enableEvents(val:Boolean=true):void{
			var stone:StoneView;
			for (var i:int=0;i<_stones.length;i++)
			{
				stone=_stones[i];
				stone.enableEvents(val);
				
			}
		}
		private function enableMouseStones(arr:Array,enable:Boolean=true):void{
			var stone:StoneView;
			enableEvents(false);
			for (var i:int=0;i<arr.length;i++)
			{
				stone=_stones[arr[i]];
				stone.enableEvents(enable);
				
			}
		}
		
		private function switchStone(signal:BaseSignal):void{
			var id2:int=signal.params.id2;
			var switchStone:StoneView= _stones[id2];
			var currentPt:Point=new Point(_currentSelected.x,_currentSelected.y);
			Tweener.addTween(switchStone,{x:currentPt.x,y:currentPt.y,time:0.5});
			Tweener.addTween(_currentSelected,{x:switchStone.x,y:switchStone.y,time:0.5});
		}
		private function setupModel(signal:BaseSignal):void {
			generateCells(gameModel.rowCount,gameModel.colCount);
		}
		override public function destroy():void
		{
			
		}
		public function generateCells(row:int=8,col:int=8):void{
			var stone:StoneView;
			var stoneIndex:int;
			var stoneMc:MovieClip;
			for (var b:int=0;b<col;b++)
				for (var a:int=0;a<row;a++)
				{
					stone=new StoneView();
					stone.index=gameModel.getIndex(a,b);
					stoneIndex= Math.random()* gameModel.stoneData.length;
					stone.type= gameModel.getStone(stoneIndex);
					stoneMc=createStoneMc(stone.type);
					stone.addChild(stoneMc);
					stone.x= a* 40 +10;
					stone.y= b* 40 +10;
					stone.addEvents(stone);
					view.addChild(stone);

					gameModel.grids[a][b]=stone;
					_stones.push(stone);
				}
			view.addChild(_selectMc);
			_selectMc.visible=false;
		}
		
		public function createStoneMc(stone:String):MovieClip{
			var mc:MovieClip;
			switch (stone){
				case StoneType.BLUE:
					mc= new BlueAsset();
					break;
				case StoneType.GREEN:
					mc= new GreenAsset();
					break;
				case StoneType.PURPLE:
					mc= new PurpleAsset();
					break;
				case StoneType.RED:
					mc= new RedAsset();
					break;
				case StoneType.YELLOW:
					mc=new YellowAsset();
					break;
			}
			return mc;
		}
	}
}