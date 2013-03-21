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
	import com.smart.engine.display.SmartSprite;
	import com.smart.engine.plugins.CameraPlugin;
	import com.smart.engine.plugins.SpriteControlPlugin;
	import com.smart.engine.plugins.TMXBatchPlugin;
	import com.smart.engine.plugins.ViewPortControlPlugin;
	import com.smart.engine.plugins.XRayLayersPlugin;
	import com.smart.engine.tmxdata.TMXParser;
	import com.smart.engine.utils.Point3D;
	import com.smart.tiled.TMXTileMap;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class BaseScene extends Sprite {
		protected var engine:SmartEngine;
		protected var pluginCenter:PluginCenter
		protected var tmx:TMXParser;

		private var tmxmap:TMXTileMap;
		public function BaseScene() {
			pluginCenter = PluginCenter.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded); 
		}

		public function onStageAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			tmxmap = new TMXTileMap();
			tmxmap.y= 64;
			addChild(tmxmap);
		}
		
		public function loadMap(map:String):void{
			TMXParser.loadTMX(map, onTMXLoad);
			//tmxmap.load(map);
		}
		
		private function onTMXLoad(tmx:TMXParser):void {
			this.tmx = tmx;
			setup();
		}
		protected function registerPlugin(pluginClass:Class):void {
			pluginCenter.register(BaseScene);
		}
		private function addPlugins(engine:SmartEngine):void {
			
			addChild(engine);
			
			var tmxPlugin:TMXBatchPlugin= new TMXBatchPlugin(tmx);
			engine.addPlugin(tmxPlugin);
			
			/*var sprite:SmartMovieClip = SmartMovieClip(engine.getSpriteByLayerName("Ground", "Joey"));
			trace("sprite.name::" + sprite);
			engine.addPlugin(new SpriteControlPlugin(sprite));*/
			
			engine.addPlugin(new CameraPlugin(new Point3D(0,0,1)));
			
			engine.addPlugin(new ViewPortControlPlugin());
			
			
			
			
			
			
			
			
			var sprite:SmartSprite =new  SmartSprite("./Monopoly/tileSet.png","12");
			addChild(sprite.display);
			
			for (var a:int= 1; a<=10 ;a ++)
				for (var b:int =1 ; b<=10;b++)
				{
					var index:int = a*b;
					if (index<30)
					{
						sprite =new  SmartSprite("./Monopoly/tileSet.png",String(index));
						sprite.x= a*32;
						sprite.y= b*32;
						addChild(sprite.display);
					}
					
					
				}
			
			
			
			
		}
		private function registerPlugins():void {
			registerPlugin(TMXBatchPlugin);
			registerPlugin(CameraPlugin);
			registerPlugin(XRayLayersPlugin);
			registerPlugin(SpriteControlPlugin);
		}
		
		private function setup():void {
			engine = new SmartEngine();
			addPlugins(engine);
			engine.start();
			
		}
	}
}

