package com.smart 
{

	import starling.display.Sprite;
	import starling.events.Event;

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