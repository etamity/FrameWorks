package 
{
	import com.smart.SmartWorld;
	import com.smart.core.Device;
	import com.smart.core.SmartScene;
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
			var world:SmartWorld=new SmartWorld(this);
			world.loadAssets(AssetEmbeds_3x);
			world.setUIskin(MetalWorksMobileTheme);
			world.addScene("MainScene",SmartScene);
			world.start("MainScene");

			/*Starling.current.addEventListener(Event.ROOT_CREATED,function ():void{
				Starling.current.removeEventListeners(Event.ROOT_CREATED);
				_theme=new MetalWorksMobileTheme(Starling.current.stage);
			});*/
		}		
		
		
	}
}