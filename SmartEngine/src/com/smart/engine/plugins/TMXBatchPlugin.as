//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins {

	import com.smart.engine.core.AssetsManager;
	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.IPluginEngine;
	import com.smart.engine.core.Plugin;
	import com.smart.engine.display.LayerBatchDisplay;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.loaders.TextureAtlasLoader;
	import com.smart.engine.tmxdata.TMXLayer;
	import com.smart.engine.tmxdata.TMXObject;
	import com.smart.engine.tmxdata.TMXObjectgroup;
	import com.smart.engine.tmxdata.TMXParser;
	import com.smart.engine.tmxdata.TMXTileset;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.utils.State;

	public class TMXBatchPlugin extends Plugin implements IPlugin {
		private static const TILE_PROPERTY_HIT_MAP:String       = "hitmap";
		private static const TILE_PROPERTY_HIT_MAP_VALUE:String = "true";

		public function TMXBatchPlugin(tmx:TMXParser = null) {
			super();
			name = "TMXBatchPlugin";
			this.tmx = tmx;
			linkedLayer = new <LayerBatchDisplay>[];
		}

		private var iSprite:int                                 = 0;
		private var linkedLayer:Vector.<LayerBatchDisplay>;
		private var steps:int                                   = 0; 
		private var tmx:TMXParser;

		public function addObjects():void {
			var layer:LayerBatchDisplay;
			for each (var objectGroup:TMXObjectgroup in tmx.objectsArray) {
				if (objectGroup == null) {
					continue;
				}
				 layer = linkedLayer[0];

				addObjectsToLayer(layer, objectGroup);
			}
		}

	
		public function addObjectsToLayer(grid:LayerBatchDisplay, group:TMXObjectgroup):void {
			var tile:TMXTileset;
			var name:String;
			var assetID:String;
			var sprite:SmartImage;
			for each (var obj:TMXObject in group.objects) {
				 tile       = tmx.tilesets[obj.gid];
				 name           = tmx.getImgSrc(obj.gid) + "_" + "1";
				 assetID        = tmx.getImgSrc(obj.gid);
				 sprite = new SmartImage(assetID, name, new Point3D(obj.x, obj.y));
				if (obj.name == "") {
					obj.name = name;
				}
				sprite.name = obj.name;
				sprite.type = obj.type;
				//sprite.currentFrame = tmx.getImgFrame(obj.gid);
				grid.add(sprite);
			}
		}

		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):LayerBatchDisplay {

			var layer:LayerBatchDisplay = new LayerBatchDisplay(name, tmx.width, tmx.height, tmx.tileWidth, tmx.tileHeight, tmx.orientation);
			for (var i:int = 0; i <= tmxLayerIndex; i++) {
				if (i == linkedLayer.length) {
					linkedLayer.push(null);
				}
			}
			return linkedLayer[tmxLayerIndex] = layer;
		}

		public function makeLayer():void {
			for (var x:int = 0; x < tmx.width; x++) {
				for (var y:int = 0; y < tmx.height; y++) {
					makeTiles(x, y);
				}
			}
		}

		override public function onRegister(engine:IPluginEngine):void {
			super.onRegister(engine);
			makeEmptyGrid();
			loadTiles();
			makeLayer();
			addObjects();
		}


		override public function onRemove():void {
			super.onRemove();
		}

	
		override public function onTrigger(time:Number):void {

		}

		public function get tmxData():TMXParser {
			return tmx;
		}

		private function loadTiles():void {
			var loader:TextureAtlasLoader;
			var i:int;
			for each (var tile:TMXTileset in tmx.uniqueTilesets) {
				loader = new TextureAtlasLoader(tmx.getImgSrc(tile.firstgid), tile, null, tile.getPropsByID(TILE_PROPERTY_HIT_MAP) == TILE_PROPERTY_HIT_MAP_VALUE);
				AssetsManager.instance.addLoader(loader);
			}
		}

		private function makeEmptyGrid():void {
			var layer:TMXLayer;
			var layerName:String;
			var grid:LayerBatchDisplay;
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				layer    = tmx.layersArray[i];
				layerName  = layer.name;
				grid = makeEmptyGridOfSize(i, layerName);
				grid.flatten(); 
				engine.addLayer(i, grid); 
			}

		}

		private function makeTiles(cellX:int, cellY:int):void {
			var layer:TMXLayer;
			var _cell:int;
			var grid:LayerBatchDisplay;
			var pt3:Point3D;
			//var name:String           = tmx.getImgSrc(_cell) + "_" + (iSprite++);
			var name:String;
			var assetID:String;
			var sprite:SmartImage;
			
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				layer      = tmx.layersArray[i];
				if (layer == null) {
					continue;
				}
				_cell             = layer.getCell(cellX, cellY); 
				if (_cell == 0 || isNaN(_cell)) {
					continue;
				}
				grid     = linkedLayer[i];
				pt3           = grid.gridToLayerPt(cellX, cellY);
				//var name:String           = tmx.getImgSrc(_cell) + "_" + (iSprite++);
				name           = String(iSprite++);
				assetID        = tmx.getImgSrc(_cell);
				sprite = new SmartImage(assetID, name, pt3, new State("", 0, 0, true)); 
				//sprite.currentFrame = tmx.getImgFrame(_cell);

				grid.add(sprite);
			}
		

		}
	}

}

