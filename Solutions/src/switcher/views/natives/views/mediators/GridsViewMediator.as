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
	import switcher.models.Node;
	import switcher.models.Stone;
	import switcher.views.natives.views.CellView;
	import switcher.views.natives.views.GridsView;
	public class GridsViewMediator extends Mediator
	{
		
		public function GridsViewMediator()
		{
			super();
		
			
		}
		
		[Inject]
		public var contextView:ContextView;
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var signalBus:SignalBus;
		
		[Inject]
		public var view:GridsView;
		
		
		private var _currentSelected:Stone;
		
		
		private var _selectMc :SelectAsset =new SelectAsset();

		override public function destroy():void
		{
			
		}
		public function generateCells(row:int=8,col:int=8):void{
			var cell:CellView;
			var stoneIndex:int;
			var stoneMc:MovieClip;
			for (var b:int=0;b<col;b++)
				for (var a:int=0;a<row;a++)
				{
					cell=new CellView();
					stoneIndex= Math.random()* gameModel.stoneData.length;
					cell.stone=new Stone(gameModel.getStone(stoneIndex));
					cell.stone.x= a* 43+5;
					cell.stone.y= b* 43+5;
					cell.x= a* 43+5;
					cell.y= b* 43+5;
					cell.cellx=a;
					cell.celly=b;
					cell.node.data=cell;
					cell.index=gameModel.getIndex(a,b);
					cell.addEvents(cell);
					gameModel.grids[a][b]=cell.node;
					gameModel.cells.push(cell);
					view.addChild(cell.stone);
					view.addChild(cell);
			
					
				}
			linkNodes(row,col);
			view.addChild(_selectMc);
			_selectMc.visible=false;
		}

		override public function initialize():void 
		{
			signalBus.add(SystemEvent.DATA_LOADED, doSetupModel);
			signalBus.add(GameEvent.SWITCH, doSwitchEvent);
			signalBus.add(GameEvent.SELECTED, doSelectEvent);

		
		}
		private function doSelectEvent(signal:BaseSignal):void{
			var cell:CellView= signal.params.cell;
			_currentSelected= cell.stone;
			_selectMc.x=_currentSelected.x;
			_selectMc.y=_currentSelected.y;
			_selectMc.visible=true;
			enableBlink(false);
			enableMouseStones(cell.node);
		
		}
		private function doSetupModel(signal:BaseSignal):void {
			generateCells(gameModel.rowCount,gameModel.colCount);
		}
		

		private function doSwitchEvent(signal:BaseSignal):void{
			function onFinished():void{
				view.mouseEnabled=true;
				view.mouseChildren=true;
				enableBlink(false);
				_selectMc.visible=false;
				last.exchangeStone(gameModel.selectedCell.node);
				gameModel.selectedCell=null;
				_currentSelected=null;
			}
			view.mouseEnabled=false;
			view.mouseChildren=false;
			var last:CellView=signal.params.last;
			var currentPt:Point=new Point(_currentSelected.x,_currentSelected.y);
			Tweener.addTween(last.stone,{x:currentPt.x,y:currentPt.y,time:0.5});
			Tweener.addTween(_currentSelected,{x:last.stone.x,y:last.stone.y,time:0.5,onComplete:onFinished});
		}
		private function enableBlink(val:Boolean=true):void{
			var cell:CellView;
			for (var i:int=0;i<gameModel.cells.length;i++)
			{
				cell=gameModel.cells[i].node.data;
				cell.blinking(val);
				
			}
		}
		
		private function enableEvents(val:Boolean=true):void{
			var cell:CellView;
			for (var i:int=0;i<gameModel.cells.length;i++)
			{
				cell=gameModel.cells[i].node.data;
				cell.enableEvents(val);
				
			}
		}
		private function enableMouseStones(node:Node):void{
			var stone:CellView;
			var left :CellView= (node.left!=null)?node.left.data as CellView :null;
			var up :CellView= (node.up!=null)?node.up.data as CellView:null;
			var down :CellView= (node.down!=null)?node.down.data as CellView:null;
			var right :CellView=(node.right!=null)?node.right.data as CellView:null;
	
			if (left!=null)
				left.enableEvents(true);
			if (up!=null)
				up.enableEvents(true);
			if (down!=null)
				down.enableEvents(true);
			if (right!=null)
				right.enableEvents(true);
		}
		
		private function linkNodes(row:int=8,col:int=8):void{
			var node:Node;
			for (var b:int=0;b<col;b++)
				for (var a:int=0;a<row;a++)
				{
					node= gameModel.grids[a][b];
					setupLinks(a,b,node);
				}
		}
		
		private function setupLinks(a:int,b:int,node:Node):void{

			var left :Node= gameModel.checkBoundsValid(a,b,"LEFT")?gameModel.grids[a-1][b]:null;
			var up :Node= gameModel.checkBoundsValid(a,b,"UP")?gameModel.grids[a][b-1]:null;
			var down :Node= gameModel.checkBoundsValid(a,b,"DOWN")?gameModel.grids[a][b+1]:null;
			var right :Node= gameModel.checkBoundsValid(a,b,"RIGHT")?gameModel.grids[a+1][b]:null;
			
			node.left=left;
			node.right=right;
			node.up=up;
			node.down=down;
		}
	}
}