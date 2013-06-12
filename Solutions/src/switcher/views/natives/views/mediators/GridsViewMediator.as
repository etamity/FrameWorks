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
					cell=gameModel.grids[a][b];
					stoneIndex= Math.random()* gameModel.stoneData.length;
					cell.stone=new Stone(gameModel.getStone(stoneIndex));
					cell.stone.x= a* 43+8;
					cell.stone.y= b* 43+5;
					cell.x= a* 43+5;
					cell.y= b* 43+5;
					cell.cellx=a;
					cell.celly=b;
					cell.node.data=cell;
					cell.index=gameModel.getIndex(a,b);
					cell.addEvents(cell);
					gameModel.cells.push(cell);
					view.addChild(cell.stone);
			
					
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
		
		public function getRemoveCollection():Array{
			var count:int=0;
			var result:Array=[];

			var nexttype:String;
			var currenttype:String;
			for (var b:int=0;b<gameModel.colCount;b++)
			{
				for (var a:int=0;a<gameModel.rowCount;a++)
				{
					nexttype=gameModel.grids[a][b].stone.type;
					if (currenttype!=nexttype){
						currenttype=nexttype;
						if (result.length<3)
						{
							result=[];
							//result.push(gameModel.grids[a][b]);
						}
			
					}
					else
					{
						count++;
						result.push(gameModel.grids[a][b]);
			
					}
			
						
				}
			}
			
			return result;
		}
		private function doSelectEvent(signal:BaseSignal):void{
			var cell:CellView= signal.params.cell;
		
			if (gameModel.selectedCell.stone!=_currentSelected)
			{
				_currentSelected= cell.stone;
				_selectMc.x=_currentSelected.x;
				_selectMc.y=_currentSelected.y;
				_selectMc.visible=true;
				enableBlink(false);
				enableMouseStones(cell.node);
			}
			else
			{
				unSelectCell();
			}
		
		}
		private function unSelectCell():void{
			enableBlink(false);
			gameModel.selectedCell=null;
			_currentSelected=null;
			_selectMc.visible=false;
		}
		private function doSetupModel(signal:BaseSignal):void {
			generateCells(gameModel.rowCount,gameModel.colCount);
		}
		
		private function removeSameStone():void{
			var cells:Array=getRemoveCollection();
			var cell:CellView;
			for (var i:int=0;i<cells.length;i++)
			{
				cell=cells[i];
				cell.stone.visible=false;
			}
			
		}
		
		private function doSwitchEvent(signal:BaseSignal):void{
			function onFinished():void{
				view.mouseEnabled=true;
				view.mouseChildren=true;
				last.exchangeStone(gameModel.selectedCell.node);
				unSelectCell();
				removeSameStone();
			}
			view.mouseEnabled=false;
			view.mouseChildren=false;
			_selectMc.visible=false;
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
			var cell:CellView;
			for (var b:int=0;b<col;b++)
				for (var a:int=0;a<row;a++)
				{
					cell=gameModel.grids[a][b];
					node=cell.node;
					setupLinks(a,b,node);
					view.addChild(cell);
				}
		}
		
		private function setupLinks(a:int,b:int,node:Node):void{

			var left :Node= gameModel.checkBoundsValid(a,b,Node.LEFT)?gameModel.grids[a-1][b].node:null;
			var up :Node= gameModel.checkBoundsValid(a,b,Node.UP)?gameModel.grids[a][b-1].node:null;
			var down :Node= gameModel.checkBoundsValid(a,b,Node.DOWN)?gameModel.grids[a][b+1].node:null;
			var right :Node= gameModel.checkBoundsValid(a,b,Node.RIGHT)?gameModel.grids[a+1][b].node:null;
			
			node.left=left;
			node.right=right;
			node.up=up;
			node.down=down;
		}
	}
}