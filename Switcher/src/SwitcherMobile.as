/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package
{
	import flash.display.Sprite;
	
	import configs.MobileStartup;

	[SWF(width="640",height="960",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	
	public class SwitcherMobile extends Sprite
	{	
		public const STARLING_MODE:String="STARLING";
		public const NATIVE_MODE:String="NATIVE";
		
		public const renderMode:String= NATIVE_MODE;   // Default Starling Rendering

		public function SwitcherMobile()
		{
			switch (renderMode){
				case STARLING_MODE: 
					// Starling Hardware Rendering
					
					//addChild(new StarlingStartup()); 
					break;
				case NATIVE_MODE:
					addChild(new MobileStartup()); // Native Displayobject Rendering
					break;
			}
		}
	}
}