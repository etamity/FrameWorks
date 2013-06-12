package switcher.views.natives.views.mediators
{
	import com.core.mvsc.controllers.signals.GameEvent;
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SignalBus;
	import com.core.mvsc.services.AnimationService;
	
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
		
		[Inject]
		public var contextView:ContextView;
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var signalBus:SignalBus;
		
		[Inject]
		public var view:GridsView;
		
		
		[Inject]
		public var animationService:AnimationService;
		
		private var _currentSelected:Stone;
	
		private var _selectMc :SelectAsset =new SelectAsset();
		
		
		public function GridsViewMediator()
		{
			super();
			
			
		}
		
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
					cell=gameModel.grids[b][a];
					stoneIndex= Math.random()* gameModel.stoneData.length;
					cell.stone=new Stone(gameModel.getStone(stoneIndex));
					cell.x= a* 43+8;
					cell.y= b* 43+5;
					cell.stone.x= a* 43+8;
					cell.stone.y= b* 43+5;
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
			checkReGenerate();
		}
	
		private function checkReGenerate():void{
			var cells:Array=getClearList();
			if (cells)
				reGenerateCell(cells);
		}
		
		private function reGenerateCell(cells:Array):void{
			var cell:CellView;
			var stoneIndex:int;
			for (var i:int=0;i<cells.length;i++)
			{
				cell=cells[i];
				stoneIndex= Math.random()* gameModel.stoneData.length;
				view.removeChild(cell.stone);
				cell.stone=new Stone(gameModel.getStone(stoneIndex));
				view.addChild(cell.stone);
			}
			checkReGenerate();
		}
		
		override public function initialize():void 
		{
			signalBus.add(SystemEvent.DATA_LOADED, doSetupModel);
			signalBus.add(GameEvent.SWITCH, doSwitchEvent);
			signalBus.add(GameEvent.SELECTED, doSelectEvent);
		}
		public function getClearList():Array{
			function addClearList(clearList:Array,checkList:Array):Array{
				if(checkList.length >= 3){
					clearList = clearList.concat(checkList)
				}
				return clearList;
			}
			var i:int;
			var j:int;
			var checkList:Array=[];
			var stone:Stone;
			var clearList:Array = [];
			var list:Array= gameModel.grids;
			//check left to right
			for(i=0;i<gameModel.colCount;i++){
				checkList = [list[i][0]];
				for(j=1;j<gameModel.rowCount;j++){
					if(checkList[checkList.length - 1].stone.type == list[i][j].stone.type ){
						checkList.push(list[i][j]);
					}else{
						clearList = addClearList(clearList,checkList);
						checkList = [list[i][j]];
					}
				}
				clearList = addClearList(clearList,checkList);
			}
			// check up to down
			for(i=0;i<gameModel.colCount;i++){
				checkList = [list[0][i]];
				for(j=1;j<gameModel.rowCount;j++){
					if(checkList[checkList.length - 1].stone.type  == list[j][i].stone.type ){
						checkList.push(list[j][i]);
					}else{
						clearList = addClearList(clearList,checkList);
						checkList = [list[j][i]];
					}
				}
				clearList = addClearList(clearList,checkList);
			}
			/*if(typeof direction == UNDEFINED || direction == ""){
				return clearList;
			}
			if(clearList.length == 0){
				mouse_down_obj.isMouseDown = false;
				return;
			}
			preMove = {};
			for(i=0;i<clearList.length;i++){
				gem = clearList[i];
				addBullet(gem,i==clearList.length-1);
			}
			
			var plot = 1 + 0.5 * continuous;
			continuous++;
			var get = clearList.length*10;
			if(clearList.length >= 4){
				get += 10;
			}
			if(clearList.length >= 6){
				get += 20;
			}
			if(clearList.length >= 8){
				get += 30;
			}
			get = get*plot >>> 0;
			var getpoint = new GetPoint(get,200,300);
			getLayer.addChild(getpoint);
			point.setPoint(point.num + get);
			bulletLayer.addEventListener(LEvent.ENTER_FRAME,onBullet);*/
			
			return clearList;
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
			var cells:Array=getClearList();
			var cell:CellView;
			gameModel.bulletList=cells;
			for (var i:int=0;i<cells.length;i++)
			{
				cell=cells[i];
				cell.stone.visible=false;
				//cell.stone.parent.removeChild(cell.stone);
				//cell.stone=null;
			}
			//sortList();
			moveDownStone();
		}
		
		private function moveDownStone():void{
	
		}
		
		private function checkHasMove():Boolean
		{
			var stone:Stone;
			var wCount:int=8;
			var hCount:int=8;
			var hasmove:Boolean = false;
			var stoneArr:Array=gameModel.grids;
			
			if (!hasmove)
			for (var i:int = 0; i<hCount; i++) {
				if (!hasmove)
				for (var j:int = 0; j<wCount; j++) {
					if (i<hCount-1){
						stone = stoneArr[j];
						stoneArr[j]=stoneArr[i+1][j];
						stoneArr[i+1][j] = stone;
						
						stone = stoneArr[j];
						stoneArr[j]=stoneArr[i+1][j];
						stoneArr[i+1][j] = stone;

						if (stoneArr.length > 0) {
							hasmove = true;
							break;
						}
					}
				}
			}
		
			
			return hasmove;
		}

		public function sortList():void{
			var i:int;
			var j:int;
			var k:int;
			var list:Array= gameModel.grids;
			var cell:CellView;
			for(i=0;i<8;i++){
				for(j=0;j<7;j++){
					for(k=j+1;k<8;k++){
						cell=list[j][i];
						if(cell.stone.visible==false){
							cell.stone = list[j][i].stone;
							list[j][i].stone = list[k][i].stone;
							list[k][i].stone = cell.stone;
						}
					}
				}
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
			animationService.switchPosition(_currentSelected,last.stone,onFinished);
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
					cell=gameModel.grids[b][a];
					node=cell.node;
					setupLinks(a,b,node);
					view.addChild(cell);
				}
		}
		
		private function setupLinks(a:int,b:int,node:Node):void{

			var left :Node= gameModel.checkBoundsValid(a,b,Node.LEFT)?gameModel.grids[b][a-1].node:null;
			var up :Node= gameModel.checkBoundsValid(a,b,Node.UP)?gameModel.grids[b-1][a].node:null;
			var down :Node= gameModel.checkBoundsValid(a,b,Node.DOWN)?gameModel.grids[b+1][a].node:null;
			var right :Node= gameModel.checkBoundsValid(a,b,Node.RIGHT)?gameModel.grids[b][a+1].node:null;
			
			node.left=left;
			node.right=right;
			node.up=up;
			node.down=down;
		}
	}
}