package com.smart.views.components
{
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class PlayerBarViewMediator extends StarlingMediator
	{
		[Inject]
		public var view:PlayerBarView;
		
		[Inject]
		public var assets:AssetManager;
		
		public function PlayerBarViewMediator()
		{
			super();
		}
		
		override public function onRegister():void 
		{
			
			view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//view.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		public function onAddedToStage(event:Event):void
		{ 
			view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			view.initAssets(assets);

		}
		
	}
}