package com.smart.mvsc.views
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import starling.events.Event;

	public class MainScreen extends BaseScreen
	{
		
		private var _navigator:ScreenNavigator;
		
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		
		private var properties :Object;
		private var eventObject:Object=new Object();
		public function MainScreen()
		{
			super();
			properties= {"assets":assets};
			
			_navigator = new ScreenNavigator();
			addChild(_navigator);
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
			

		}
		
		public function addScreen(screenName:String,screen:Object):void{
			eventObject[screenName]=gotoScreen;
			_navigator.addScreen(screenName, new ScreenNavigatorItem(screen,eventObject,properties));
			
		}
		
		public function showScreen(screenName:String):void{
			_navigator.showScreen(screenName);
		}
		private function gotoScreen(evt:Event):void{
			var screenName:String= String(evt.type);
			_navigator.showScreen(screenName);
		}
	}
}