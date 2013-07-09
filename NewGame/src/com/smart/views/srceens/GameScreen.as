package com.smart.views.srceens
{
	import com.smart.SmartSystem;
	import com.smart.engine.MapEngine;
	import com.smart.engine.map.models.TMXMapModel;
	import com.smart.engine.map.plugins.CameraPlugin;
	import com.smart.engine.map.plugins.ViewportControlPlugin;
	import com.smart.engine.map.plugins.ViewportPlugin;
	import com.smart.engine.map.utils.Point3D;
	import com.smart.model.Language;
	
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
		protected var tmxData:TMXMapModel;
		

		public function GameScreen()
		{
			super();
		}
		

		override public function initUI():void{

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
			var _mapgirdBtn:Button=newButton(Language.MAPGRID,loadMapGridMap);
			var _mapiosBtn:Button=newButton(Language.MAPISO,loadMapISOMap);
			
			addItem(_mapgirdBtn,RIGHT);
			addItem(_mapiosBtn,RIGHT);
			addItem(_reloadBtn,RIGHT);
			addItem(_exitBtn,RIGHT);
		
		}
		override public function addPlugins(system:SmartSystem):void {
			
			if (tmxData!=null)
			{
				system.addEngine(new MapEngine(tmxData))
					.addPlugin(new ViewportPlugin(tmxData.orientation,tmxData.tileWidth, tmxData.tileHeight))
					.addPlugin(new CameraPlugin(new Point3D(0,0,1)))
					.addPlugin(new ViewportControlPlugin());
			}
			
		}
		
		private function onTMXLoad(tmx:TMXMapModel):void {
			this.tmxData=tmx;
			start();
		}
		
		private function loadMapGridMap(event:Event):void
		{
			TMXMapModel.loadTMX("./TiledMap/map0.tmx",onTMXLoad);
		}
		private function loadMapISOMap(event:Event):void
		{
			TMXMapModel.loadTMX("./Monopoly/map3.tmx",onTMXLoad);
		}
		private function loadMap(event:Event):void
		{
			TMXMapModel.loadTMX("./TiledMap/map0.tmx",onTMXLoad);
		}
	}
}