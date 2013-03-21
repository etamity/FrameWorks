package com.smart 
{

	import com.smart.views.ProgressBar;
	
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	public class Game extends Sprite 
	{	
	
		private static const CONSOLE_SCREEN:String = "CONSOLE_SCREEN";
		public function Game() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
	
		}

		private function startContent():void{
			var context:GameContext = new GameContext(this);
		}
		
		private function addedHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);

			startContent();
		
		
			
		}
	}

}