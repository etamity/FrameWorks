package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import solutions.srceens.SolutionsOne;
	
	public class SolutionsOneTest
	{		
		private var solutionsOne:SolutionsOne;
		[Before]
		public function setUp():void
		{
			solutionsOne=new SolutionsOne();
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
		public function testAdd():void
		{
			
			Assert.assertEquals(solutionsOne.add(5,5),10);
			//Assert.fail("Test method Not yet implemented");
		}
	}
}