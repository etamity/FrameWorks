package
{
	import com.smart.Game;
	import com.smart.device.Device;
	import com.smart.logs.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	import starling.events.Event;
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f", mode="direct")]
	public class Main extends Sprite
	{

		private var mStarling:Starling;
		private var _device:Device;

		public function Main()
		{

			if (stage) start();
			else
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(e:Object):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			start();


		}
		
		public function onRootCreated(event:Event, game:Game):void
		{
			// set framerate to 30 in software mode

			// game will first load resources, then start menu
		
		}

		
		
		private function start():void
		{
			
			this.graphics.clear();
			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.SHOW_ALL;
			}
			_device= new Device(stage);
			_device.setDevice(Device.IPHONE);
			//pretends to be an iPhone Retina screen
			
			Debug.CONSOLE_OUTPUT = true;
			Debug.log("Smart Engine Version:"+ "1.02");
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			mStarling = new Starling(Game, stage);
			mStarling.antiAliasing = 1;
			mStarling.showStatsAt("right","top",2);
			mStarling.start();

			
		}
		
		
	}
}