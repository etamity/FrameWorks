package com.smart.views.srceens
{
	import com.smart.SmartSystem;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.PhysicsObject;
	import com.smart.engine.physics.plugins.DebugDrawPlugin;
	import com.smart.engine.physics.plugins.DrawBodyPlugin;
	import com.smart.engine.physics.plugins.HandJointPlugin;
	import com.smart.engine.physics.plugins.PhysicsObjectFactoryPlugin;
	import com.smart.engine.physics.plugins.PhysicsRenderPlugin;
	import com.smart.model.Language;
	import com.smart.model.ScreenConst;
	
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import nape.phys.Body;
	
	import starling.display.Image;
	import starling.events.Event;

	public class PhysisScreen extends BaseScreen
	{	
		private var _navigator:ScreenNavigator;
		
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var bodyGraphics:Dictionary;
		
		public function PhysisScreen()
		{
			super();
			bodyGraphics = new Dictionary();
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
			
			var _newBtn:Button=newButton(Language.GAMETITLE,clearEngine);
			addItem(_newBtn,LEFT);
			var _backBtn:Button=newButton(Language.EXIT,showMenu);
			addItem(_backBtn,RIGHT);
			
			
			var _circle:Button=newButton("Circle",drawPoly);
			addItem(_circle,LEFT);
			var _draw:Button=newButton("Draw",drawPoly);
			addItem(_draw,LEFT);
			
			var _box:Button=newButton("Box",drawPoly);
			addItem(_box,LEFT);
			
			var _Regular:Button=newButton("Regular",drawPoly);
			addItem(_Regular,LEFT);
			
			var _none:Button=newButton("",drawPoly);
			addItem(_none,LEFT);
			
			var _Pivot:Button=newButton("Pivot",drawPoly);
			addItem(_Pivot,LEFT);
			
			
			addChild(_navigator);
			
			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;

		}
		override public function initData():void{
			
			bodyGraphics["box0"]=new Image(assets.getTexture("IconMoney"));
			bodyGraphics["box1"]=new Image(assets.getTexture("icon-snow-small"));
			bodyGraphics["box2"]=new Image(assets.getTexture("icon-coin-small"));
			bodyGraphics["box3"]=new Image(assets.getTexture("icon-snow-small"));
			bodyGraphics["box4"]=new Image(assets.getTexture("IconClock"));
			bodyGraphics["box5"]=new Image(assets.getTexture("icon-snow-small"));
			bodyGraphics["box"]=new Image(assets.getTexture("icon-snow-small"));
		}
		public function test1():void{
			var engine:PhysicsEngine= system.getEngine(PhysicsEngine);
			var physicsObjectFactoryPlugin:PhysicsObjectFactoryPlugin= engine.getPlugin(PhysicsObjectFactoryPlugin);
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			var objects:Array=[];
			var b:PhysicsObject;
			for (var i:int = 0; i < 6; i++) {
				b=physicsObjectFactoryPlugin.createBox(24,24,{"name":"box"+String(i)},(w / 2), ((h - 50) - 32 * (i + 0.5)));
				objects.push(b);
			}
			var b1:Body=objects[0].body;
			var b2:Body=objects[1].body;
			var b3:Body=objects[2].body;
			var b4:Body=objects[3].body;
			var b5:Body=objects[4].body;
			var b6:Body=objects[5].body;
			b2.position.setxy(400,500);
			physicsObjectFactoryPlugin.makeWeldJoint(b1,b2,b1.position.x,b1.position.y-100);
			physicsObjectFactoryPlugin.makePivotJoint(b3,b4,b3.position.x,b3.position.y-100);
			physicsObjectFactoryPlugin.makeMotorJoint(b5,b6,b5.position.x,b5.position.y);
			b5.position.setxy(200,100);
			objects[4].pinned=true;
			var box:PhysicsObject=physicsObjectFactoryPlugin.createBox(40,50,{"name":"box"},300,300);
			box.pinned=true;
			
		}
		
		public function setImages():void{
			var engine:PhysicsEngine= system.getEngine(PhysicsEngine);
			var physicsRenderPlugin:PhysicsRenderPlugin= engine.getPlugin(PhysicsRenderPlugin);
			physicsRenderPlugin.setImage();
		}
		
		override public function addPlugins(system:SmartSystem):void{
			system.addEngine(new PhysicsEngine(0,600))
				.addPlugin(new PhysicsObjectFactoryPlugin())
				.addPlugin(new HandJointPlugin())
				.addPlugin(new DrawBodyPlugin())
				.addPlugin(new DebugDrawPlugin())
				.addPlugin(new PhysicsRenderPlugin(bodyGraphics));
		
		}
		

		public function drawPoly(evt:Event):void{
			const button:Button=Button(evt.currentTarget);
			var engine:PhysicsEngine= system.getEngine(PhysicsEngine);
			var drawBodyPlugin:DrawBodyPlugin= engine.getPlugin(DrawBodyPlugin);
			var physicsObjectFactoryPlugin:PhysicsObjectFactoryPlugin= engine.getPlugin(PhysicsObjectFactoryPlugin);
			switch (button.label){
				case "Circle":
					drawBodyPlugin.state=drawBodyPlugin.DRAW_CIRCLE;
					break;
				case "Draw":
					drawBodyPlugin.state=drawBodyPlugin.DRAW_GEOMPOLY;
					break;
				case "Box":
					drawBodyPlugin.state=drawBodyPlugin.DRAW_BOX;
					break;
				case "Regular":
					drawBodyPlugin.state=drawBodyPlugin.DRAW_REGULAR;
					break;
				case "Pivot":
					//physicsObjectFactoryPlugin.test2();
					test1();
					setImages();
					break;
				default:
					drawBodyPlugin.state=drawBodyPlugin.NONE;
					break;
			}
			
		}
		
		public function clearEngine(evt:Event):void{
			start();
		}
		public function showMainMenu(evt:Event):void{
			this.dispatchEventWith(Language.EXIT);
		}
		public function showMenu(evt:Event):void{
			_navigator.showScreen(ScreenConst.MAINMENU_SCREEN);
		}
	}
}