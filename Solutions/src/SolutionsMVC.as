package
{
	import flash.display.Sprite;
	
	import configs.NativeStartup;
	//import configs.StarlingStartup;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	public class SolutionsMVC extends Sprite
	{
		public const STARLING_MODE:String="STARLING";
		public const NATIVE_MODE:String="NATIVE";
		
		
		public const renderMode:String= NATIVE_MODE;   // Default Starling Rendering
		

		
		public function SolutionsMVC()
		{
			switch (renderMode){
				case STARLING_MODE: 
					//addChild(new StarlingStartup()); // Starling Hardware Rendering
					break;
				case NATIVE_MODE:
					addChild(new NativeStartup()); // Native Displayobject Rendering
					break;
			}
		}
	}
}