package
{
	import com.smart.mvsc.GameContent;
	import configs.StarlingBundle;
	import configs.StarlingConfig;
	import com.smart.device.Device;
	import com.smart.logs.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	
	public class Solutions extends Sprite
	{	
		private var device:Device;
		public function Solutions()
		{
			stage.align 		= StageAlign.TOP_LEFT;
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			
			init();
		}
		private function init():void
		{
			const starling:Starling = new Starling(GameContent, stage);
			device= new Device(stage);
			device.setDevice(Device.IPHONE);
			Debug.CONSOLE_OUTPUT = true;
			const context:IContext = new Context()
				.install( StarlingBundle )
				.configure( StarlingConfig, 
					new ContextView(this),
					starling);
			
			starling.showStats = true;
			starling.antiAliasing = 1;
			starling.start();
		}
		
	
	}
}