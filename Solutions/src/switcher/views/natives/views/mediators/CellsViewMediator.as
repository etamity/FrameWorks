package switcher.views.natives.views.mediators
{
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	import switcher.models.Cell;
	import switcher.models.GameModel;
	import switcher.views.natives.views.CellsView;
	
	public class CellsViewMediator extends Mediator
	{
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var view:CellsView;
		public function CellsViewMediator()
		{
			super();
		}
		public function createCells():void{
			var length:int=gameModel.cellCount;
			var cell:Cell;
			var stoneIndex:int= Math.random()* gameModel.stoneData.length;
			for (var i :int =0 ; i<=length; i++)
			{
				
				cell=new Cell();
				cell.index=i;
				cell.stone= gameModel.getStone(stoneIndex);
				cell.mc=view.createStones(cell.stone);
				gameModel.cellsData.push(cell);
			}
		}
		
		override public function initialize():void 
		{
			
		}
		override public function destroy():void
		{
			
		}
	}
}