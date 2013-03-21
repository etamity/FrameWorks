package com.smart.views 
{


	
	import com.smart.views.components.PlayerBarView;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainView extends Sprite 
	{


		private var _playerBar:PlayerBarView;
		
		public function MainView() 
		{
			super();	
	
		}
		
		
		public function onAddedToStage():void
		{

		}

		public function onRemovedFromStage():void
        {
		
        }
        
        public override function dispose():void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            super.dispose();
        }
		
		public function stop():void 
		{

		}
		public function play():void 
		{

		}
	}

}