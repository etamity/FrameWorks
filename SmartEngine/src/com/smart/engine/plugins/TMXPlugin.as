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
	import com.smart.engine.display.LayerDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartMovieClip;
	import com.smart.engine.loaders.SpriteSheetLoader;
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


	public class TMXPlugin extends Plugin implements IPlugin {
		private static const TILE_PROPERTY_HIT_MAP:String       = "hitmap";
		private static const TILE_PROPERTY_HIT_MAP_VALUE:String = "true";

		
		private var layers:Vector.<ILayerDisplay>; 
		private var layersHash:Dictionary; 
		private var container:Sprite;
		private var position:Point;
		private var iSprite:int                                 = 0;
		private var linkedLayer:Vector.<LayerDisplay>;
		private var steps:int                                   = 0; 
		private var tmx:TMXParser;

		
		public function TMXPlugin(tmx:TMXParser = null) {
			super();
			this.tmx = tmx;
			container= new Sprite();
			layers = new <ILayerDisplay>[];
			layersHash = new Dictionary();
			linkedLayer = new <LayerDisplay>[];
		}


		public function addObjects():void {

			for each (var objectGroup:TMXObjectgroup in tmx.objectsArray) {
				if (objectGroup == null) {
					continue;
				}
				var layer:LayerDisplay = linkedLayer[0];

				addObjectsToLayer(layer, objectGroup);
			}
		}
		public function moveTo(x:Number, y:Number):void {
			position.setTo(x, y);
		}
		
		public function get positionY():Number {
			return position.y;
		}
		
		public function set positionY(val:Number):void {
			position.y = val;
		}
		
		
		public function offset(x:Number, y:Number):void {
			position.offset(x, y);
		}
		public function get currentZoom():Number {
			return container.scaleX;
		}
		
		public function set currentZoom(val:Number):void {
			container.scaleX = container.scaleY = val;
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
	
		public function addObjectsToLayer(grid:LayerDisplay, group:TMXObjectgroup):void {
			for each (var obj:TMXObject in group.objects) {
				var tile:TMXTileset       = tmx.tilesets[obj.gid];
				var name:String           = tmx.getImgSrc(obj.gid) + "_" + "1";
				var assetID:String        = tmx.getImgSrc(obj.gid);
				var sprite:SmartMovieClip = new SmartMovieClip(assetID, name, new Point3D(obj.x, obj.y));
				if (obj.name == "") {
					obj.name = name;
				}
				sprite.name = obj.name;
				sprite.type = obj.type;
				sprite.currentFrame = tmx.getImgFrame(obj.gid);
				grid.add(sprite);
			}
		}

		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):LayerDisplay {

			var layer:LayerDisplay = new LayerDisplay(name, tmx.width, tmx.height, tmx.tileWidth, tmx.tileHeight, tmx.orientation);
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

		public function get tmxData():TMXParser {
			return tmx;
		}
		public function set tmxData(data:TMXParser):void{
			tmx=data;
			if (this.tmx!=null){
				//removeAllLayers();
				makeEmptyGrid();
				loadTiles();
				makeLayer();
				addObjects();
			}
		}
		private function loadTiles():void {
			for each (var tile:TMXTileset in tmx.uniqueTilesets) {
				var loader:SpriteSheetLoader = new SpriteSheetLoader(tmx.getImgSrc(tile.firstgid), tile.areas, null, tile.getPropsByID(TILE_PROPERTY_HIT_MAP) == TILE_PROPERTY_HIT_MAP_VALUE);
				AssetsManager.instance.addLoader(loader);
			}
		}

		private function makeEmptyGrid():void {
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				var layer:TMXLayer    = tmx.layersArray[i];
				var layerName:String  = layer.name;
				var grid:LayerDisplay = makeEmptyGridOfSize(i, layerName);
				grid.flatten(); 
				addLayer(i, grid); 
			}

		}

		private function makeTiles(cellX:int, cellY:int):void {
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				var layer:TMXLayer        = tmx.layersArray[i];
				if (layer == null) {
					continue;
				}
				var _cell:int             = layer.getCell(cellX, cellY); 
				if (_cell == 0 || isNaN(_cell)) {
					continue;
				}
				var grid:LayerDisplay     = linkedLayer[i];
				var pt3:Point3D           = grid.gridToLayerPt(cellX, cellY);
				var name:String           = tmx.getImgSrc(_cell) + "_" + (iSprite++);
				var assetID:String        = tmx.getImgSrc(_cell);
				var sprite:SmartMovieClip = new SmartMovieClip(assetID, name, pt3, new State("", 0, 0, true)); 
				sprite.currentFrame = tmx.getImgFrame(_cell);

				grid.add(sprite);
			}
		

		}
	}

}

