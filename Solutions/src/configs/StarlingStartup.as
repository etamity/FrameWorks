package configs
{
	import com.smart.device.Device;
	import com.smart.logs.Debug;
	import com.smart.mvsc.GameContent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	import starling.core.Starling;
	

	public class StarlingStartup extends Sprite
	{	
		private var device:Device;
		public function StarlingStartup()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
		}
		private function onAddtoStage(evt:Event):void{
			init();
		}
		private function init():void
		{
			stage.align 		= StageAlign.TOP_LEFT;
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			
			const starling:Starling = new Starling(GameContent, stage);
			device= new Device(stage);
			device.setDevice(Device.IPHONE);
			Debug.CONSOLE_OUTPUT = true;
			const context:IContext = new Context()
				.configure( StarlingConfig, 
					new ContextView(this),
					starling);
			
			starling.showStats = true;
			starling.antiAliasing = 1;
			starling.start();
		}
		
	
	}
}