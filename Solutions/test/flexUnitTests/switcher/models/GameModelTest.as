package flexUnitTests.switcher.models
{
	import flexunit.framework.Assert;
	
	import switcher.models.GameModel;
	import switcher.models.Node;
	import switcher.models.Stone;
	
	public class GameModelTest
	{		
		private var gameModel:GameModel;
		[Before]
		public function setUp():void
		{
			gameModel=new GameModel();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function  BeforeClass():void
		{

		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function getIndexTest():void
		{
			
			Assert.assertEquals("(5,4) = 44",gameModel.getIndex(5,4),44);
			Assert.assertEquals("(1,0) = 8",gameModel.getIndex(1,0),8);
			Assert.assertEquals("(0,3) = 3",gameModel.getIndex(0,3),3);
			Assert.assertEquals("(2,7) = 23",gameModel.getIndex(2,7),23);
			Assert.assertEquals("(3,6) = 30",gameModel.getIndex(3,6),30);

		}

		[Test]
		public function getStoneTest():void
		{
			Assert.assertEquals("(0) = BLUE",gameModel.getStone(0),"BLUE");
			Assert.assertEquals("(3) = PURPLE",gameModel.getStone(3),"PURPLE");
			Assert.assertEquals("(4) = YELLOW",gameModel.getStone(4),"YELLOW");

		}
		[Test]
		public function resetTest():void
		{
			gameModel.reset();
			
			Assert.assertEquals("Grids[0].stone = NULL",true,gameModel.grids[0][0].stone==null);

		}
		
		[Test]
		public function createCellsTest():void
		{
			var grids:Array=gameModel.createCells();
			
			Assert.assertEquals("Grids[0][0].stone != NULL",true,grids[0][0]!=null);
			Assert.assertEquals("Grids[4][5].stone != NULL",true,grids[4][5]!=null);
		}
		
		[Test]
		public function getStonesFromGridsTest():void
		{
			gameModel.grids[0][0].stone=new Stone();
			gameModel.grids[4][5].stone=new Stone();
			
			var stones:Array=gameModel.getStonesFromGrids();
			
			Assert.assertEquals("Grids[0][0].stone != NULL",true,stones[0][0]!=null);
			Assert.assertEquals("Grids[4][5].stone != NULL",true,stones[4][5]!=null);
		}
		
		[Test]
		public function checkBoundsValidTest():void
		{
			
			var grids:Array=gameModel.createCells();
			Assert.assertEquals("Grids[5][0]-> up= false",true,gameModel.checkBoundsValid(5,0,Node.UP));
			Assert.assertEquals("Grids[5][0]-> down= true",true,gameModel.checkBoundsValid(5,0,Node.DOWN));
			Assert.assertEquals("Grids[5][0]-> left= false",false,gameModel.checkBoundsValid(5,0,Node.LEFT));
			Assert.assertEquals("Grids[5][0]-> right= true",true,gameModel.checkBoundsValid(5,0,Node.RIGHT));
		}
	}
}