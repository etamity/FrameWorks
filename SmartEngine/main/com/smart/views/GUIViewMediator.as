package com.smart.views
{
	import com.smart.model.Language;
	import com.smart.model.ScreenConst;
	import com.smart.model.SignalBus;
	import com.smart.views.signals.ScreenEventConst;
	import com.smart.views.srceens.GameScreen;
	import com.smart.views.srceens.MainMenuScreen;
	import com.smart.views.srceens.MenuScreen;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class GUIViewMediator extends StarlingMediator
	{
		[Inject]
		public var view:GUIView;
		[Inject]
		public var assets:AssetManager;
		[Inject]
		public var signalBus:SignalBus;
		
		private var _navigator:ScreenNavigator;
		
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private var _scene:BaseScene;
		
		public function GUIViewMediator()
		{
			super();
		}
		override public function onRegister():void 
		{
			
			//view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//view.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			init();
			
			
		}
		
		
		public function init():void{
			
			view.initAssets(assets);
			

			
			
			_navigator = new ScreenNavigator();
			
			view.addChild(_navigator);
			var main:MainMenuScreen=new MainMenuScreen();
			var eventObject:Object=new Object();
			eventObject[Language.STARTGAME]=ScreenConst.GAME_SCREEN;
			eventObject[Language.EXIT]=ScreenConst.MAINMENU_SCREEN;
			eventObject[Language.MAPGRID]=reloadMap;
			eventObject[Language.MAPISO]=reloadMap;
			
			_navigator.addScreen(ScreenConst.MAINMENU_SCREEN, new ScreenNavigatorItem(MenuScreen,eventObject));
			_navigator.addScreen(ScreenConst.GAME_SCREEN, new ScreenNavigatorItem(GameScreen,eventObject));
			
			
			_transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			_transitionManager.duration = 0.4;
			
			_navigator.showScreen(ScreenConst.MAINMENU_SCREEN);	
			
		}
		
		public function reloadMap(evt:Event):void{
			var name:String= String(evt.data);
			switch (name){
				case Language.MAPGRID:
					signalBus.dispatchSignal(ScreenEventConst.LOADMAP_EVENT,"./TiledMap/map0.tmx");
					break;
				case Language.MAPISO:
					signalBus.dispatchSignal(ScreenEventConst.LOADMAP_EVENT,"./Monopoly/map0.tmx");
					break;
			}
		}
		
	}
}