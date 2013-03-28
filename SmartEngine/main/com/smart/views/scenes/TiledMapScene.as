package com.smart.views.scenes
{
	import com.smart.Engine;
	import com.smart.engine.MapEngine;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.plugins.CameraPlugin;
	import com.smart.engine.plugins.ViewportControlPlugin;
	import com.smart.engine.plugins.ViewportPlugin;
	import com.smart.engine.tmxdata.TMXMapModel;
	import com.smart.engine.utils.Point3D;
	import com.smart.tiled.TMXTileMap;
	
	public class TiledMapScene extends BaseScene
	{
		protected var tmxData:TMXMapModel;
		private var tmxmap:TMXTileMap;
		private var mapEngine:MapEngine;
		public function TiledMapScene()
		{

		}
		override protected function initialize():void{
			tmxmap = new TMXTileMap(stage);
			//tmxmap.y= 64;
			addChild(tmxmap)
		}
		public function loadMap(map:String):void{
			TMXMapModel.loadTMX(map, onTMXLoad);
			//tmxmap.load(map);
			
		}
		
		private function onTMXLoad(tmx:TMXMapModel):void {
			this.tmxData=tmx;
			start();
			//tmxPlugin.tmxData=tmx;
		}

		override public function addPlugins(engine:Engine):void {
			mapEngine= new MapEngine(tmxData);
			engine.addPlugin(mapEngine)
				.addPlugin(new ViewportPlugin(tmxData.orientation,tmxData.tileWidth, tmxData.tileHeight));
			
			engine.addPlugin(new CameraPlugin(new Point3D(0,0,1)))
				.addPlugin(new ViewportControlPlugin());
			
			
			mapEngine.onCompelete= setupSpirte;
			
			
			function setupSpirte():void{
				var sprite:SmartImage = SmartImage(mapEngine.getObjectByName("Joey"));
				//tmxPlugin.addPlugin(new SpriteControlPlugin(sprite));		
				
			}
		}
		
	}
}