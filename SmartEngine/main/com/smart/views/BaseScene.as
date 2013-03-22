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
	import com.smart.engine.plugins.CameraPlugin;
	import com.smart.engine.plugins.SpriteControlPlugin;
	import com.smart.engine.plugins.TMXQuadPlugin;
	import com.smart.engine.plugins.ViewPortControlPlugin;
	import com.smart.engine.plugins.XRayLayersPlugin;
	import com.smart.engine.tmxdata.TMXParser;
	import com.smart.engine.utils.Point3D;
	import com.smart.tiled.TMXTileMap;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class BaseScene extends Sprite {
		protected var engine:SmartEngine;
		protected var pluginCenter:PluginCenter
		protected var tmx:TMXParser;
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
			tmxmap = new TMXTileMap();
			tmxmap.y= 64;
			addChild(tmxmap);
			setup();

		}
		
		public function loadMap(map:String):void{
			TMXParser.loadTMX(map, onTMXLoad);
			//tmxmap.load(map);
		}
		
		private function onTMXLoad(tmx:TMXParser):void {
			this.tmx = tmx;
			tmxPlugin.tmxData=tmx;
		
		}
		protected function registerPlugin(pluginClass:Class):void {
			pluginCenter.register(BaseScene);
		}
		private function addPlugins(engine:SmartEngine):void {
	
			tmxPlugin= new TMXQuadPlugin();
			engine.addPlugin(tmxPlugin);
			engine.addPlugin(new CameraPlugin(new Point3D(0,0,1)));
			engine.addPlugin(new ViewPortControlPlugin());
			
		}
		private function registerPlugins():void {
			registerPlugin(TMXQuadPlugin);
			registerPlugin(CameraPlugin);
			registerPlugin(XRayLayersPlugin);
			registerPlugin(SpriteControlPlugin);
		}
		
		private function setup():void {
			engine = new SmartEngine();
			addChild(engine);
			addPlugins(engine);
			engine.start();
		
		}
	}
}

