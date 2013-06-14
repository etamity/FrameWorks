package flexUnitTests.switcher.views.natives.views.mediators
{
	import com.core.mvsc.model.SignalBus;
	import com.core.mvsc.services.AnimationService;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	import switcher.models.GameModel;
	import switcher.models.Node;
	import switcher.models.Stone;
	import switcher.models.StoneType;
	import switcher.views.natives.views.CellView;
	import switcher.views.natives.views.GridsView;
	import switcher.views.natives.views.mediators.GridsViewMediator;

	public class GridsViewMediatorTest
	{		
		private var gameModel:GameModel;
		private var mediator:GridsViewMediator;
		[Before]
		public function setUp():void
		{
			var signalBus:SignalBus=new SignalBus();
			var view:GridsView=new GridsView();
			
			gameModel=new GameModel();
			mediator=new GridsViewMediator();
			mediator.gameModel=gameModel;
			mediator.signalBus=signalBus;
			mediator.eventDispatcher=new EventDispatcher();
			mediator.view=view;

			var animationService:AnimationService=new AnimationService();
			mediator.animationService=animationService;
			
			mediator.initialize();
			mediator.generateCells(gameModel.rowCount,gameModel.colCount);
			Assert.assertEquals(" Grids: 8X8 row=8",gameModel.rowCount,gameModel.grids.length);
			Assert.assertEquals(" Grids: 8X8 col=8",gameModel.rowCount,gameModel.grids[0].length);
		}
		
		[Test]
		public function testGenerateCells():void {
			var clearList:Array=mediator.getClearList();
			var cell:CellView=gameModel.grids[3][5];
			Assert.assertEquals("New Generate Grids 8X8: (grid[3][5]==null) = false ",false,(gameModel.grids[3][5]==null));
			Assert.assertEquals("New Generate Grids 8X8: (grid[5][7].stone==null) = false ",false,(gameModel.grids[5][7].stone==null));
			Assert.assertEquals("Mathch Grids: 0",0,clearList.length);
			
		}

		[Test]
		public function testFillEmptyGridWithStone():void {
			gameModel.grids[3][5].stone= null;
			gameModel.grids[4][5].stone= null;
			gameModel.grids[5][5].stone= null;
			Assert.assertEquals("Grids[3][5] = Null",(gameModel.grids[3][5].stone==null),true);
			Assert.assertEquals("Mathch Grids= Null",(gameModel.grids[4][5].stone==null),true);
			Assert.assertEquals("Mathch Grids= Null",(gameModel.grids[5][5].stone==null),true);
			mediator.fillEmptyGridWithStone();
			
			Assert.assertEquals("Grids[3][5] not Null",(gameModel.grids[3][5].stone!=null),true);
			Assert.assertEquals("Mathch Grids not Null",(gameModel.grids[4][5].stone!=null),true);
			Assert.assertEquals("Mathch Grids not Null",(gameModel.grids[5][5].stone!=null),true);
		}
		[Test]
		public function testLinkNodes():void {
			
			var cells:Array=gameModel.createCells();
			mediator.linkNodes(cells,8,8);
			var node:Node;
			var index:int=0;
			node= cells[0][0].node;
			do
			{
				Assert.assertEquals("Grids index: "+ node.data.index,index,node.data.index);
				node=node.right;

				index++;
			}while (node!=null)
			
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
	}
}