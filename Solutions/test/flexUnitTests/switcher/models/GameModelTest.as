package flexUnitTests.switcher.models
{
	import flexunit.framework.Assert;
	
	import switcher.models.GameModel;
	
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
		public static function setUpBeforeClass():void
		{

		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function getIndexTest():void
		{
			
			Assert.assertEquals("(4,5) = 44",gameModel.getIndex(4,5),44);
			Assert.assertEquals("(0,1) = 8",gameModel.getIndex(0,1),8);
			Assert.assertEquals("(3,0) = 3",gameModel.getIndex(3,0),3);
			Assert.assertEquals("(7,2) = 23",gameModel.getIndex(7,2),23);
			Assert.assertEquals("(6,3) = 30",gameModel.getIndex(6,3),30);
			//Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function getStoneTest():void
		{
			Assert.assertEquals("(0) = BLUE",gameModel.getStone(0),"BLUE");
			Assert.assertEquals("(3) = PURPLE",gameModel.getStone(3),"PURPLE");
			Assert.assertEquals("(4) = YELLOW",gameModel.getStone(4),"YELLOW");
			//Assert.fail("Test method Not yet implemented");
		}
		
	}
}