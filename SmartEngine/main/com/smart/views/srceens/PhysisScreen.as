package com.smart.views.srceens
{
	import com.smart.SmartSystem;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.plugins.DebugDrawPlugin;
	import com.smart.engine.physics.plugins.DrawBodyPlugin;
	import com.smart.engine.physics.plugins.HandJointPlugin;
	import com.smart.engine.physics.plugins.PhysicsObjectFactoryPlugin;
	import com.smart.engine.physics.core.TouchEventHandler;
	import com.smart.model.Language;
	import com.smart.model.ScreenConst;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import starling.events.Event;

	public class PhysisScreen extends BaseScreen
	{	
		private var _navigator:ScreenNavigator;
		
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		public function PhysisScreen()
		{
			super();
		
		}

		
		override public function initUI():void{
			_navigator = new ScreenNavigator();
			addChild(_navigator);
			var eventObject:Object=new Object();
			eventObject[Language.STARTGAME]=ScreenConst.GAME_SCREEN;
			eventObject[Language.EXIT]=showMainMenu;
			eventObject[Language.CONTINUE]=ScreenConst.PHYSIS_SCREEN;
			var properties :Object = {"assets":assets};
			_navigator.addScreen(ScreenConst.MAINMENU_SCREEN, new ScreenNavigatorItem(MenuScreen,eventObject,properties));
			_navigator.addScreen(ScreenConst.GAME_SCREEN, new ScreenNavigatorItem(GameScreen,eventObject,properties));
			_navigator.addScreen(ScreenConst.PHYSIS_SCREEN, new ScreenNavigatorItem(PhysisScreen,eventObject,properties));
			
			var _newBtn:Button=newButton(Language.GAMETITLE);
			addItem(_newBtn,LEFT);
			var _backBtn:Button=newButton(Language.EXIT,showMenu);
			addItem(_backBtn,RIGHT);
			
			addChild(_navigator);
			
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
		}
		
		override public function addPlugins(system:SmartSystem):void{
			system.addEngine(new PhysicsEngine(0,600))
				.addPlugin(new PhysicsObjectFactoryPlugin())
				.addPlugin(new HandJointPlugin())
				.addPlugin(new DrawBodyPlugin())
				.addPlugin(new DebugDrawPlugin());
			
		}
		
		
		public function showMainMenu(evt:Event):void{
			this.dispatchEventWith(Language.EXIT);
		}
		public function showMenu(evt:Event):void{
			_navigator.showScreen(ScreenConst.MAINMENU_SCREEN);
		}
	}
}