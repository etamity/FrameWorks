/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package switcher.views.natives.views.mediators
{
	import com.core.mvsc.controllers.signals.GameEvent;
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.core.mvsc.model.BaseSignal;
	import com.core.mvsc.model.SignalBus;
	import com.core.mvsc.services.AnimationService;
	
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
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

		private var lastBullet:CellView;

		private var continuous:int=1;

		public function GridsViewMediator()
		{
			super();


		}

		override public function destroy():void
		{

		}
		public function generateCells(row:int=8,col:int=8):void{
			var cell:CellView;
			var stoneMc:MovieClip;
			for (var b:int=0;b<col;b++)
				for (var a:int=0;a<row;a++)
				{
					cell=gameModel.grids[b][a];
					cell.stone=new Stone();
					cell.x= gameModel.getCellX(a);
					cell.y= gameModel.getCellX(b);
					cell.stone.x= cell.x;
					cell.stone.y= cell.y;
					cell.cellx=a;
					cell.celly=b;
					cell.node.data=cell;
					cell.index=gameModel.getIndex(a,b);
					cell.addEvents(cell);
					gameModel.cells.push(cell);

				}


			checkAndReGenerate();
			linkNodes(gameModel.grids,row,col);

		}

		private function addToView():void{
			var cell:CellView;
			clearView();
			for (var i:int=0;i<gameModel.cells.length;i++)
			{
				cell=gameModel.cells[i];
				cell.stone.x= cell.x;
				cell.stone.y= cell.y;
				view.stoneView.addChild(cell.stone);
				view.cellsView.addChild(cell);
			}
			_selectMc.visible=false;
			view.cellsView.addChild(_selectMc);
		}

		private function clearView():void{
			view.cellsView.removeChildren();
			view.stoneView.removeChildren();
		}
		private function checkAndReGenerate():void{
			var cells:Array=getClearList();
			gameModel.bulletList=cells;
			var cell:CellView;
			if (cells.length>0){
				for (var i:int=0;i<cells.length;i++)
				{
					cell=cells[i];
					if (cell.stone !=null)
					{
						cell.stone=new Stone();
					}
				}
				checkAndReGenerate();
			}
		}


		override public function initialize():void 
		{
			signalBus.add(SystemEvent.DATA_LOADED, doSetupModel);
			signalBus.add(GameEvent.SWITCH, doSwitchEvent);
			signalBus.add(GameEvent.SELECTED, doSelectEvent);
			signalBus.add(GameEvent.GAMEFINISHED, doGameFinishedEvent);
			signalBus.add(GameEvent.REPLAY, doReplayEvent);
			signalBus.add(GameEvent.SPIN, doSpinEvent);
			

			view.addMask(gameModel.generateMask("GRIDSVIEWMASK"));
		}
		private function doGameFinishedEvent(signal:BaseSignal):void{
			view.mouseEnabled=false;
			view.mouseChildren=false;
			unSelectCell();
		}
		private function doReplayEvent(signal:BaseSignal):void{
			view.mouseEnabled=true;
			view.mouseChildren=true;
		}

		public function getClearList(matchCount:int=3):Array{
			function addClearList(clearList:Array,checkList:Array):Array{
				if(checkList.length >= matchCount){
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
			return clearList;
		}


		private function addScores(list:Array):void{
			var point:int=0;

			var plot:int = 1 + 0.5 * continuous;
			var hint:String="";
			var length:int=list.length;
			continuous++;

			point = length*10;
			if(length >= 4){
				point += 10;
			}
			if(length >= 6){
				point += 20;
				//For lucky man, when player macthed 6 or more, will get extra time
				signalBus.dispatch(GameEvent.ADDTIME,{seconds:length});  

				hint="+"+String(length)+" Seconds  ";
			}
			if(length >= 8){
				point += 30;
			}
			//point = point*plot >>> 0;
			point = point*plot;
			signalBus.dispatch(GameEvent.ADDSCORE,{point:point});

			var pointMc:PointsAsset=new PointsAsset();
			pointMc.label.text= hint+"+"+String(point);
			pointMc.x = 160;
			pointMc.y = 300;
			pointMc.alpha=0.3;
			view.addChild(pointMc);
			animationService.moveTo(pointMc,{y:150,alpha:1,time:1,onComplete:function ():void{
				animationService.moveTo(pointMc,{y:0,alpha:0,time:1,onComplete:function ():void{
					view.removeChild(pointMc);	
				}});

			}});

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
			startGame();
		}

		private function startGame():void{
			view.stoneView.removeChildren();
			view.cellsView.removeChildren();
			view.mouseEnabled=true;
			view.mouseChildren=true;
			generateCells(gameModel.rowCount,gameModel.colCount);
			addToView();
		}
		private function removeSameStone(complete:Function=null):void{
			var cells:Array=getClearList();
			gameModel.bulletList=cells;
			var cell:CellView;
			var finishedBool:Boolean=false;
			for (var i:int=0;i<cells.length;i++)
			{
				cell=cells[i];
				if (cell.stone !=null)
				{
					var highlightMc:HighLightAsset=new HighLightAsset();
					cell.stone.addChild(highlightMc);
					animationService.blink(highlightMc);
					setTimeout(function (stone:Stone):void{
						stone.parent.removeChild(stone);

						if (complete!=null && finishedBool==false)
						{

							if (cells.length>0)
								addScores(cells);

							complete();
							finishedBool=true;
						}
					},600,cell.stone);

					cell.stone=null;
				}
			}

		}

		private function checkAndAction():void{
			removeSameStone(function ():void{
				moveDownStone();
				fillEmptyGridWithStone();
			});

		}


		private function checkHasNodeWithStone(root:Node):Node{
			var result:Node=root;
			var up:Node=root.up;
			while (up!=null)
			{
				result=up;
				if (up.data.stone==null)
				{	
					up=up.up;
				}else{

					up=null;
				}


			}

			return result;
		}

		private function moveDownStone():void{
			var col:Array;
			var stone:Stone;
			var grid:Array=gameModel.grids;
			var cell:CellView;
			var next:Node;
			var upStone:Stone;
			var i:int;
			var j:int;


			//trace("=================");
			for(i=gameModel.colCount-1;i>=0;i--){

				for(j=gameModel.rowCount-1;j>=0;j--){
					cell=grid[j][i];
					stone=cell.stone;
					//trace("===cell ",cell.index);
					if(stone==null ){

						next =checkHasNodeWithStone(cell.node);
						upStone=next.data.stone;
						//trace("next",next.data.index);
						if (upStone!=null)
						{
							animationService.moveTo(upStone,{y: cell.y});
							cell.switchStone(next);
						}
						upStone=null;

					}else{

					}

				}
			}
		}

		public function fillEmptyGridWithStone():void{
			var grid:Array=gameModel.grids;
			var i:int;
			var j:int;
			var cell:CellView;
			var time:Number=0.8;
			var finishedBoolean:Boolean=false;
			for(i=0;i<gameModel.colCount;i++){
				for(j=0;j<gameModel.rowCount;j++){
					cell=grid[i][j];
					if (cell.stone==null)
					{

						cell.stone=new Stone();
						cell.stone.x= cell.x;
						cell.stone.y= gameModel.getCellY(-1);
						cell.stone.alpha=0;
						view.stoneView.addChild(cell.stone);
						//trace("generateStone.cell.index",cell.index);
						if (finishedBoolean==false)
						{
							animationService.moveTo(cell.stone,{y: cell.y,alpha:1,onComplete:function():void{
								var cells:Array=getClearList();
								//trace("animationService");
								if (cells.length>0)
									checkAndAction();
								else
								{
									view.mouseEnabled=true;
									view.mouseChildren=true;
								}
							}});
							finishedBoolean=true;
						} else
							animationService.moveTo(cell.stone,{y: cell.y,alpha:1});
					}
				}
			}


		}
		private function doSwitchEvent(signal:BaseSignal):void{
			function onFinished():void{	
				if (switchAble)
				{
					unSelectCell();
					checkAndAction();
				}else
				{

					animationService.switchPosition(_currentSelected,last.stone,function():void{
						unSelectCell();
						view.mouseEnabled=true;
						view.mouseChildren=true;
					});

				}


			}
			view.mouseEnabled=false;
			view.mouseChildren=false;
			_selectMc.visible=false;
			var last:CellView=signal.params.last;
			animationService.switchPosition(_currentSelected,last.stone,onFinished);
			last.switchStone(gameModel.selectedCell.node);
			var switchAble:Boolean=(getClearList().length>0)?true:false;
			if (switchAble==false)
				last.switchStone(gameModel.selectedCell.node);	
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

		public function linkNodes(grids:Array,row:int=8,col:int=8):void{
			var node:Node;
			var cell:CellView;
			for (var b:int=0;b<col;b++)
				for (var a:int=0;a<row;a++)
				{
					cell=grids[b][a];
					node=cell.node;
					setupLinks(a,b,node);
				}
		}

		public function setupLinks(a:int,b:int,node:Node):void{

			var left :Node= gameModel.checkBoundsValid(a,b,Node.LEFT)?gameModel.grids[b][a-1].node:null;
			var up :Node= gameModel.checkBoundsValid(a,b,Node.UP)?gameModel.grids[b-1][a].node:null;
			var down :Node= gameModel.checkBoundsValid(a,b,Node.DOWN)?gameModel.grids[b+1][a].node:null;
			var right :Node= gameModel.checkBoundsValid(a,b,Node.RIGHT)?gameModel.grids[b][a+1].node:null;

			node.left=left;
			node.right=right;
			node.up=up;
			node.down=down;
		}
		public function doSpinEvent(signal:BaseSignal):void{
			spinCol1(6);
		}
		public function spinCol1(index:int=0):void{
			view.stoneView.visible=false;
			var mc:MovieClip;
			var topmc:MovieClip;
			var newY:int;
			var length:int=-1;
			
					//animationService.moveTo(topmc,{y:gameModel.getCellY(i),time:1,onComplete:onFinished,onCompleteParams:[topmc]});
			
			moveStepDown(createMC());

			
			function createMC():MovieClip{
				var mc:MovieClip;
				mc=new Stone();
				mc.x=gameModel.getCellX(index);
				mc.y=gameModel.getCellY(-1);
				view.addChild(mc);
				return mc;
			}
			
			function moveStepDown(oneMc:MovieClip):void{
				animationService.moveTo(oneMc,{y:gameModel.getCellY(length),time:1,onComplete:onFinished,onCompleteParams:[oneMc]});
				
			}
			
			function onFinished(mc:MovieClip):void{
				moveStepDown(mc);
				if (length==9)
					view.removeChild(mc);
				else{
					moveStepDown(createMC());
				}
			}
		}
		
		public function spinCol(col:Array,index:int=0):void{
			var mc:MovieClip;
			var topmc:MovieClip;
			var newY:int;
			var length:int=col.length;
			function onFinished(mc:MovieClip):void{
				view.stoneView.removeChild(mc);
			}
			for (var i:int=0;i<length;i++)
			{
				mc=col[i];
				topmc=new Stone();
				topmc.x=gameModel.getCellX(index);
				topmc.y=gameModel.getCellY(i-length);
				view.stoneView.addChild(topmc);
				newY=gameModel.getCellY(i+8);
				animationService.moveTo(topmc,{y:gameModel.getCellY(i),time:0.3,onComplete:onFinished,onCompleteParams:[topmc]});
				//animationService.moveTo(mc,{y:newY,time:0.3,onComplete:onFinished});
			}
		}
	}
}

