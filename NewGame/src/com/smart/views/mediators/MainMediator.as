package com.smart.views.mediators
{
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.loaders.ResourcesManager;
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.model.BaseSignal;
	import com.smart.model.GameConfig;
	import com.smart.model.Language;
	import com.smart.model.ScreenConst;
	import com.smart.model.SignalBus;
	import com.smart.views.MainView;
	import com.smart.views.srceens.GameScreen;
	import com.smart.views.srceens.MenuScreen;
	import com.smart.views.srceens.PhysisScreen;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.events.Event;
	
	public class MainMediator extends StarlingMediator
	{
		[Inject]
		public var view:MainView;
		[Inject]
		public var assets:ResourcesManager;
		[Inject]
		public var signalBus:SignalBus;
		[Inject]
		public var commandManager:ConsoleCommand;
		[Inject]
		public var gameConfig:GameConfig;

		private var _navigator:ScreenNavigator;
		
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		public function MainMediator()
		{
			super();
		}

		override public function initialize():void 
		{
			super.initialize();
			init();
		}
		override public function destroy():void
		{
			super.destroy();
		}
		
		public function init():void{

			_navigator = new ScreenNavigator();
			
			view.addChild(_navigator);
			var eventObject:Object=new Object();
			eventObject[Language.STARTGAME]=ScreenConst.GAME_SCREEN;
			eventObject[Language.CONTINUE]=ScreenConst.PHYSIS_SCREEN;
			eventObject[Language.EXIT]=ScreenConst.MAINMENU_SCREEN;
			eventObject[Language.MAPGRID]=reloadMap;
			eventObject[Language.MAPISO]=reloadMap;
			
			var properties :Object = {"assets":assets};
			
			_navigator.addScreen(ScreenConst.MAINMENU_SCREEN, new ScreenNavigatorItem(MenuScreen,eventObject,properties));
			_navigator.addScreen(ScreenConst.GAME_SCREEN, new ScreenNavigatorItem(GameScreen,eventObject,properties));
			
			_navigator.addScreen(ScreenConst.PHYSIS_SCREEN, new ScreenNavigatorItem(PhysisScreen,eventObject,properties));
			
			_transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			_transitionManager.duration = 0.4;
			
			_navigator.showScreen(ScreenConst.MAINMENU_SCREEN);	
			
			
		}
		public function reloadMap(evt:Event):void{
			var name:String= String(evt.data);
			switch (name){
				case Language.MAPGRID:
					//signalBus.dispatchSignal(ScreenEventConst.LOADMAP_EVENT,"./TiledMap/map0.tmx");
					_navigator.showScreen(ScreenConst.PHYSIS_SCREEN);	
					break;
				case Language.MAPISO:
					_navigator.showScreen(ScreenConst.PHYSIS_SCREEN);	
					break;
			}
		}
		
	}
}