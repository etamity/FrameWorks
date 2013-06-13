/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package
{
	import flash.display.Sprite;
	
	import configs.NativeStartup;

	[SWF(width="755",height="600",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	
	public class Switcher extends Sprite
	{	
		public const STARLING_MODE:String="STARLING";
		public const NATIVE_MODE:String="NATIVE";
		
		public const renderMode:String= NATIVE_MODE;   // Default Starling Rendering
		public function Switcher()
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