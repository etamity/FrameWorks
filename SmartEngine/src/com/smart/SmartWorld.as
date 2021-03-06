package com.smart
{
	import com.smart.core.Device;
	import com.smart.core.SmartGame;
	import com.smart.loaders.ResourcesManager;
	import com.smart.logs.Debug;
	import com.smart.uicore.starlingui.ProgressBar;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	import feathers.core.DisplayListWatcher;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class SmartWorld
	{
		private var _device:Device;
		private var _starling:Starling;
		private var _assetResources:*;
		private var _root:Sprite
		private var _scenesList:Array;
		
		private var _game:SmartGame;
		private var _startScene:String;
		private var _theme:DisplayListWatcher;
		private var _themeClass:*;
		
		private  var _instance:SmartWorld;
		public function SmartWorld(root:Sprite)
		{
			_root=root;
			_scenesList=[];
			_instance=this;
		}
		
		public function getSceneClassByName(name:String):*{
			var obj:Object;
			var result:Class;
			for (var i:int=0; i<_scenesList.length;i++)
			{
				obj= _scenesList[i];
				if (obj.name==name)
					result = obj.classtype; 
			}
			return result;
		}
		public function getSceneTypeByName(name:String):String{
			var obj:Object;
			var result:String;
			for (var i:int=0; i<_scenesList.length;i++)
			{
				obj= _scenesList[i];
				if (obj.name==name)
					result = obj.classname; 
			}
			return result;
		}
		
		public function setUIskin(skin:*):void{
			_themeClass=skin;
		}
		
		public function start(sceneName:String=""):void{
			_startScene=sceneName;
			_root.graphics.clear();
			if(_root.stage)
			{
				_root.stage.align = StageAlign.TOP_LEFT;
				_root.stage.scaleMode = StageScaleMode.SHOW_ALL;
			}
			_device= new Device(_root.stage);
			_device.setDevice(Device.IPHONE);
			//pretends to be an iPhone Retina screen
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			
			Debug.CONSOLE_OUTPUT = true;
			Debug.log("Smart Engine Version:"+ "1.02");
			
			_starling = new Starling(SmartGame, _root.stage);
			_starling.antiAliasing = 1;
			_starling.showStatsAt("right","top",2);
			_starling.addEventListener(Event.ROOT_CREATED,onRootCreated);
			_starling.start();
			
		}
		
		public function addScene(name:String,scene:*):SmartWorld{
				_scenesList.push({name:name,classname:getQualifiedClassName(scene),classtype:scene});
				return this;
		}
		public function clearScenes():void{
			_scenesList=[];
		}
		public function onRootCreated(event:Event, game:SmartGame):void
		{
			var themeClass:Class = _themeClass as Class;
			_theme = new themeClass(game.stage);
			
			
			_starling.removeEventListener(Event.ROOT_CREATED,onRootCreated);
			loadResources(_assetResources);
			_game=game;
		}

		public function loadAssets(...assetResources):void{
			_assetResources=assetResources;
		}
		private function loadResources(...assetResources):void{
			var mLoadingProgress:ProgressBar = new ProgressBar(175, 20);
			mLoadingProgress.x = (Starling.current.nativeStage.stageWidth  - mLoadingProgress.width) / 2;
			mLoadingProgress.y = (Starling.current.nativeStage.stageHeight - mLoadingProgress.height) / 2;
			mLoadingProgress.y = Starling.current.nativeStage.stageHeight * 0.7;
			Starling.current.stage.addChild(mLoadingProgress);
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight), 
				new Rectangle(0, 0, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2;
			
			var assets:ResourcesManager;
			assets =ResourcesManager.instance;
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(assetResources);
			
			
			assets.loadQueue(function(ratio:Number):void
			{
				mLoadingProgress.ratio = ratio;
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						mLoadingProgress.removeFromParent(true);
						mLoadingProgress = null;
						_game.start(_instance,assets);
						_game.showScene(_startScene);
					}, 0.15);
			});
			
		}
		
	}
}