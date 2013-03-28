package com.smart.views.srceens
{
	import com.smart.model.Language;
	import com.smart.scenes.TiledMapScene;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	
	import starling.display.Image;
	import starling.events.Event;

	public class GameScreen extends BaseScreen
	{	

		public var _money:Label;
		public var _health:ProgressBar;
		public var _exitBtn:Button;
		public var _scene:TiledMapScene;
		public function GameScreen()
		{
			super();
		
		}
		
		
		override protected function initialize():void{

			_money = newLabel("1000.00");
			_health= newProgressBar(100);
			_exitBtn=newButton(Language.EXIT);
			
			var image:Image=newImage("IconMoney");
			addItem(image);
			addItem(_money);
			
			image =newImage("icon-snow-small");
			addItem(image);
			addItem(_health);

			
			var _reloadBtn:Button=newButton(Language.RELOAD,loadMap);
			var _mapgirdBtn:Button=newButton(Language.MAPGRID);
			
			
			addItem(_mapgirdBtn,RIGHT);
			addItem(_reloadBtn,RIGHT);
			addItem(_exitBtn,RIGHT);
			_scene = new TiledMapScene();
			addScene(_scene);
		
		}

		override public function dispose():void{
			removeChild(_scene);
			_scene.dispose();
			super.dispose();
		}
		private function loadMap(event:Event):void
		{
			_scene.loadMap("./TiledMap/map0.tmx");
		}
	}
}