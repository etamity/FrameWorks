//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.views {

	import com.smart.engine.SmartEngine;
	import com.smart.engine.core.PluginCenter;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.plugins.CameraPlugin;
	import com.smart.engine.plugins.SpriteControlPlugin;
	import com.smart.engine.plugins.TMXQuadPlugin;
	import com.smart.engine.plugins.ViewportControlPlugin;
	import com.smart.engine.plugins.ViewportPlugin;
	import com.smart.engine.tmxdata.TMXMap;
	import com.smart.engine.utils.Point3D;
	import com.smart.tiled.TMXTileMap;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class BaseScene extends Sprite {
		protected var engine:SmartEngine;
		protected var pluginCenter:PluginCenter
		protected var tmx:TMXMap;
		private var _assets:AssetManager;
		private var tmxmap:TMXTileMap;
		private var tmxPlugin:TMXQuadPlugin;
		public function BaseScene(assets:AssetManager) {
			_assets = assets
			pluginCenter = PluginCenter.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded); 
		}

		public function onStageAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			tmxmap = new TMXTileMap(stage);
			//tmxmap.y= 64;
			addChild(tmxmap);
			
		}
		public function loadMap(map:String):void{
			TMXMap.loadTMX(map, onTMXLoad);
			//tmxmap.load(map);
			
		}
		
		private function onTMXLoad(tmx:TMXMap):void {
			this.tmx=tmx;
			setup();
			//tmxPlugin.tmxData=tmx;
		}

		private function setup():void {
			
			if (engine != null)
				engine.dispose();

				engine = new SmartEngine(this);
				addPlugins(engine);
				engine.start();
			
	
			
		}

		private function addPlugins(engine:SmartEngine):void {
			tmxPlugin= new TMXQuadPlugin(tmx);
			engine.addPlugin(tmxPlugin)
				  .addPlugin(new ViewportPlugin(tmx.orientation,tmx.tileWidth, tmx.tileHeight));
			
			engine.addPlugin(new CameraPlugin(new Point3D(0,0,1)))
			      .addPlugin(new ViewportControlPlugin());
	
	
			tmxPlugin.onCompelete= setupSpirte;

			
			function setupSpirte():void{
				var sprite:SmartImage = SmartImage(tmxPlugin.getObjectByName("Joey"));
				//tmxPlugin.addPlugin(new SpriteControlPlugin(sprite));		
			
			}
		}
		

	}
}

