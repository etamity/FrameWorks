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
	import com.smart.engine.display.ILayerDisplay;
	import com.smart.engine.display.LayerBatchDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.loaders.TextureAtlasLoader;
	import com.smart.engine.tmxdata.TMXLayer;
	import com.smart.engine.tmxdata.TMXObject;
	import com.smart.engine.tmxdata.TMXObjectgroup;
	import com.smart.engine.tmxdata.TMXParser;
	import com.smart.engine.tmxdata.TMXTileset;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.utils.State;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;

	public class TMXBatchPlugin extends Plugin implements IPlugin {
		private static const TILE_PROPERTY_HIT_MAP:String       = "hitmap";
		private static const TILE_PROPERTY_HIT_MAP_VALUE:String = "true";
		
		private var layers:Vector.<ILayerDisplay>; 
		private var layersHash:Dictionary; 
		private var container:Sprite;

		private var iSprite:int                                 = 1;
		private var linkedLayer:Vector.<LayerBatchDisplay>;
		private var steps:int                                   = 0; 
		private var tmx:TMXParser;
		
		public function TMXBatchPlugin(tmx:TMXParser = null) {
			super();
			layers = new <ILayerDisplay>[];
			layersHash = new Dictionary();
			container= new Sprite();
		
			this.tmx = tmx;
			linkedLayer = new <LayerBatchDisplay>[];
		}

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
		
	
		
		public function getLayerByIndex(index:int):ILayerDisplay {
			return layers[index];
		}
		
		public function getLayerByName(name:String):ILayerDisplay {
			return layersHash[name];
		}
		public function getSpriteByLayerIndex(layerIndex:int, spriteName:String):SmartDisplayObject {
			var layer:ILayerDisplay = layers[layerIndex];
			return layer.getByName(spriteName);
		}
		public function getSpriteByLayerName(layerName:String, spriteName:String):SmartDisplayObject {
			var layer:ILayerDisplay        = getLayerByName(layerName);
			if (layer == null) {
				return null;
			}
			var result:SmartDisplayObject = layer.getByName(spriteName);
			return result;
		}
		public function gridInLayerPt(pt:Point):Point3D {
			var currentGrid:Point3D = this.layers[0].gridToLayerPt(pt.x, pt.y);
			return currentGrid;
		}
		public function get numChildrenSprites():int {
			var num:int = 0;
			for each (var layer:ILayerDisplay in layers) {
				num += layer.numChildrenSprites;
			}
			
			return num;
		}
		
		public function get numberOfLayers():int {
			return layers.length;
		}
		
		public function objectInGridPt(val:Point3D):Point {
			var pt:Point3D        = val;
			var currentGrid:Point = this.layers[0].layerToGridPt(pt.x, pt.y);
			return currentGrid;
		}
		public function addLayer(index:int, layer:ILayerDisplay):void {
			if (layer.name == "" || layer.name == null) {
				throw new Error("invalid layer name");
			}
			if (layersHash[layer.name] != null) {
				throw new Error("layer " + layer.name + " already added");
			}
			for (var i:int = 0; i <= index; i++) {
				if (i == index) {
					layers[i] = layer;
					break;
				}
				else if (i == layers.length) {
					layers.push(null);
				}
			}
			layersHash[layer.name] = layer;
			if (layer != null) {
				container.addChild(layer.display);
			}
		}
		public function addObjectsToLayer(grid:LayerBatchDisplay, group:TMXObjectgroup):void {
			var tile:TMXTileset;
			var name:String;
			var assetID:String;
			var sprite:SmartImage;
			for each (var obj:TMXObject in group.objects) {
				 tile       = tmx.tilesets[obj.gid];
				// name           = tmx.getImgSrc(obj.gid) + "_" + "1";
				 
				 name           =  String(obj.gid);
				 assetID        = tmx.getImgSrc(obj.gid);
				 
				 //trace("Objs: "+assetID, name, new Point3D(obj.x, obj.y));
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
			this.engine.addDisplay(this.container);
			if (this.tmx!=null){
			makeEmptyGrid();
			loadTiles();
			makeLayer();
			addObjects();
			}
		}


		override public function onRemove():void {
			super.onRemove();

			removeAllLayers();

			
		}

	
		override public function onTrigger(time:Number):void {
			
			
			container.x=engine.positionX;
			container.y=engine.positionY;
			for each (var layer:ILayerDisplay in layers) {
				if (layer != null) {
					if (layer.autoPosition) {
						layer.moveTo(engine.positionX, engine.positionY);
					}
					layer.onTrigger(time, engine);
				}
			}
		}

		public function removeLayer(layer:ILayerDisplay):void {
			var index:int = layers.indexOf(layer);
			layers.splice(index, 1);
			delete layersHash[layer.name];
			container.removeChild(layer.display);
		}
		
		public function removeAllLayers():void{
			
			for each(var layer:ILayerDisplay in layers) {
				removeLayer(layer);
			}
		}
		public function get tmxData():TMXParser {
			return tmx;
		}

		public function set tmxData(data:TMXParser):void{
			tmx=data;
			if (this.tmx!=null){
				removeAllLayers();
				makeEmptyGrid();
				loadTiles();
				makeLayer();
				addObjects();
			}
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
				addLayer(i, grid); 
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
				grid = linkedLayer[i];
				pt3  = grid.gridToLayerPt(cellX, cellY);
				name= tmx.getImgSrc(_cell) + "_" + (iSprite++);
				//name           =  String(_cell);   //String(iSprite++);
				assetID=  tmx.getImgSrc(_cell);
				
				//trace(assetID, name, pt3, new State("", 0, 0, true));
				
				sprite = new SmartImage(assetID, name, pt3, new State("", 0, 0, true)); 
				//sprite.currentFrame = tmx.getImgFrame(_cell);
				grid.add(sprite);
			}
		}
	}

}

