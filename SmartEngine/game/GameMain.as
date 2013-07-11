package 
{
	import com.smart.SmartWorld;
	import com.smart.core.Device;
	import com.ui.SmartScene;
	
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	public class GameMain extends Sprite
	{
		private var _device:Device;
		private var _Starling:Starling;

		public function GameMain()
		{
			var world:SmartWorld=new SmartWorld(this);
			world.loadAssets(AssetEmbeds_3x);
			world.addScene("MainScene",SmartScene);
			world.start("MainScene");
		
		}
		
		
	}
}