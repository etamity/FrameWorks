package 
{
	import com.map.Control;
	import com.smart.SmartWorld;
	import com.smart.core.Device;
	import com.smart.game.tower.scenes.GameScene;
	import com.smart.game.tower.scenes.MenuScene;
	import com.smart.game.tower.skins.MetalWorksMobileTheme;
	
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	public class GameMain extends Sprite
	{
		private var _device:Device;
		private var _Starling:Starling;
		private var _theme:MetalWorksMobileTheme;
		public function GameMain()
		{

			start();
		}
		
		private function start():void{
			var world:SmartWorld=new SmartWorld(this);
			world.loadAssets(AssetEmbeds_3x);
			world.setUIskin(MetalWorksMobileTheme);
			world.addScene("MainScene",MenuScene)
				 .addScene("GameScene",GameScene);
			world.start("MainScene");

		}
		
	}
}