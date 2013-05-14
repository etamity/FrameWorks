package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import solutions.models.SolutionOne;
	
	public class SolutionOneTest
	{		
		private var solutionOne:SolutionOne;
		[Before]
		public function setUp():void
		{
			solutionOne=new SolutionOne();
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
			
			Assert.assertEquals("5 + 5 = 10",solutionOne.add(5,5),10);
			//Assert.fail("Test method Not yet implemented");
		}
	}
}