//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.display {
	
	import com.smart.engine.SmartEngine;
	import com.smart.engine.plugins.IViewPort;
	import com.smart.engine.plugins.ViewportPlugin;
	import com.smart.engine.utils.Point3D;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.extensions.QuadtreeSprite;
	
	public class LayerQuadDisplay implements ILayerDisplay {
		
		public var _autoPosition:Boolean   = true; 
		
		//public var _display:Sprite;

		public var _quadBatch:QuadtreeSprite;
		
		public var _name:String;
		
		public var sort:Boolean           = true;
		public var data:Vector.<Vector.<SmartDisplayObject>>;
		//private var flatData:Vector.<SmartDisplayObject>;
		private var h:int                 = 0;
		
		//private var projection:IProjection;
		private var spriteHash:Dictionary = new Dictionary(true);
		private var spriteList:Vector.<SmartDisplayObject>;
		private var sqEdgeSize:Number;
		private var tileHeight:int        = 1;
		
		private var tileHeightOffset:int  = 1;
		private var tileWidth:int         = 1;
		
		private var tileWidthOffset:int   = 1;
		private var w:int                 = 0;
		private var _worldBounds:Rectangle;
		private static const WORLD_BOUND:int = 10000;
		private var ratio:Point = new Point(1, 1); 
		
		private var viewport:IViewPort;
		
		private var countNum:int=0;

		private var sortSprite:DisplayObject;
		public function LayerQuadDisplay(_name:String, w:int, h:int, cellwidth:Number, cellheight:Number, projectionType:String) {
			this._name = _name;
			this.w = w;
			this.h = h;
			this.tileWidth = cellwidth;
			this.tileHeight = cellheight;

			tileWidthOffset = tileWidth;
			tileHeightOffset = tileHeight;

			spriteList =new Vector.<SmartDisplayObject>();
			
			sqEdgeSize = tileHeightOffset;
			//_display = new Sprite();
			_worldBounds = new Rectangle(-WORLD_BOUND, -WORLD_BOUND, WORLD_BOUND * 2, WORLD_BOUND * 2);
			_quadBatch=new QuadtreeSprite(_worldBounds);
			_quadBatch.visibleViewport=new Rectangle(0,0,760,540);
			//_display.visibleViewport=new Rectangle(0,100,960,440);
			//_display.addChild(_quadBatch);
			data = new Vector.<Vector.<SmartDisplayObject>>(w * h, true);
			//flatData = new <SmartDisplayObject>[];
			
			/*this.projection = new MapViewport(projectionType, cellwidth, cellheight);
			this.projection.onSetup(this);*/
			//_display.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			viewport=new ViewportPlugin(projectionType,cellwidth, cellheight);
		}
	
		
		public function get name():String{
			return this._name;
		}
		public function get autoPosition():Boolean{
			return this._autoPosition;
		}
		public function get display():DisplayObject{
			return this._quadBatch;
		}
		public function add(val:SmartDisplayObject):SmartDisplayObject {
			if (val == null) {
				return val;
			}
			if (val.textureName == "" || val.textureName == null) {
				throw new Error("adding sprite with no _name");
			}
			//updateLocation(val);
			spriteHash[val.name] = val;
			spriteList.push(val);

			val.layer = this;
			
			viewport.perSprite(val);
			//updateLocation(val);
			//addStarlingChild(val);
			


			return val;
		}
		private function sortIndex(p1:SmartDisplayObject, p2:SmartDisplayObject): int
		{
			var index1:int =p1.index;
			var index2:int =p2.index;
			if (index1 < index2)
			{
				return -1;
			}
			else if (index1 >index2)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		public function render():void{
			//spriteList= spriteList.sort(sortIndex);
			for each (var sprite:SmartDisplayObject in spriteList) {
				if (sprite == null) {
					continue;
				}
				_quadBatch.addChild(sprite.display);


			}
		}
		
		

		public function addStarlingChild(val:SmartDisplayObject):void {
			/*var wasFlat:Boolean = _display.isFlattened;
			if (wasFlat) {
				_display.unflatten();
			}*/

				_quadBatch.addChild(val.display);	

			
			//_quadBatch.addChild(image);	
			//_display.unflatten();
			//forceUpdate();
			
		}
		/*public function flatten():void {
			 sort = false;
			_display.flatten();
		}
		
		public function forceUpdate():void {
			if (_display.isFlattened == false) {
				return;
			}
			_display.unflatten();
			_display.flatten();
		}
		*/
		public function getByName(_name:String):SmartDisplayObject {
			return spriteHash[_name];
		}
		
		/*
		public function getCell(x:int, y:int):Vector.<SmartDisplayObject> {
			if (x >= w) {
				x = w - 1;
			} 
			else if (x < 0) {
				x = 0;
			}
			if (y >= h) {
				y = h - 1;
			}
			else if (y < 0) {
				y = 0;
			}
			
			var index:int = (y * w) + x;
			return data[index];
		}
		
		public function getChildAtIndex(index:int):SmartDisplayObject {
			return flatData[index];
		}
		*/
		public function gridToLayerPt(gridX:int, gridY:int, z:int = 1):Point3D {
			return new Point3D(gridX * sqEdgeSize, gridY * sqEdgeSize, z * sqEdgeSize);
		}
		
		/*public function gridToSreenPt(gridX:int, gridY:int, z:int = 1):Point {
			var pt3d:Point3D = gridToLayerPt(gridX, gridY);
			var result:Point = layerToScreen(pt3d);
			return result;
		}*/
		
		public function get height():int {
			return h;
		}
		
		/*public function get isFlattened():Boolean {
			return _display.isFlattened;
		}*/
		
		public function layerToGridPt(x:Number, y:Number):Point {
			var pt:Point = new Point(Math.floor(x / sqEdgeSize), Math.floor(y / sqEdgeSize));
			return pt;
		}
		
		/*public function layerToScreen(pt:Point3D):Point {
			var answer:Point = projection.layerToScreen(pt);
			return _display.localToGlobal(answer);
		}*/
		
		public function moveTo(x:Number, y:Number):void {
			_quadBatch.x =x * ratio.x;
			_quadBatch.y =y * ratio.x;
	
		}
		private function updatePosition():void{
			
			
			//_quadBatch.x = Math.min(Math.max(_worldBounds.left + _quadBatch.stage.stageWidth, _quadBatch.x), _worldBounds.right);
			//_quadBatch.y = Math.min(Math.max(_worldBounds.top + _quadBatch.stage.stageHeight, _quadBatch.y), _worldBounds.bottom);
			var newViewPort:Rectangle = _quadBatch.visibleViewport.clone();
			//if (_worldBounds.containsRect(newViewPort))
			{

			newViewPort.x = -_quadBatch.x;
			newViewPort.y = -_quadBatch.y
			/*
			newViewPort.offset(-_quadBatch.x,-_quadBatch.y);;*/
			
			
			}
			_quadBatch.visibleViewport = newViewPort;
			
		}
		
		/*public function get numChildren():int {
			return flatData.length;
		}*/
		
		public function get numChildrenSprites():int {
			return _quadBatch.numChildren;
		}
		
		public function offset(x:Number, y:Number):void {
			_quadBatch.x += x * ratio.x;
			_quadBatch.y += y * ratio.y;
		}
		
		public function onTrigger(time:Number, engine:SmartEngine):void {
			var first:SmartDisplayObject;
			
			/*for each (var layer:Vector.<SmartDisplayObject> in data) {
				if (layer != null) {
					for each (var sprite:SmartDisplayObject in layer) {
						if (sprite == null) {
							continue;
						}
						//viewport.perSprite(sprite);
						updatePosition();
						updateLocation(sprite);
						sprite.onTrigger(time);
						
					}
				}
			}
			*/
			
			for each (var sprite:SmartDisplayObject in spriteList) {
				if (sprite == null) {
					continue;
				}
				updatePosition();
				//updateLocation(sprite);
				sprite.onTrigger(time);
				
			}
			/*if (sort) {
				sortSystem(time);
			}*/
		}
		/*	
		public function remove(val:SmartDisplayObject):SmartDisplayObject {
			if (val.layerIndex == -1 || val.layer == null) {
				return val;
			}
			_display.removeChild(val.display);
			
			removeFromGridData(val);
			val.layer = null;
			delete spriteHash[val.textureName];
			return val;
		}
	
		public function screenToGridPt(pt:Point):Point {
			var pt3d:Point3D = screenToLayer(pt);
			var result:Point = layerToGridPt(pt3d.x, pt3d.y);
			return result;
		}*/
		
		/*public function screenToLayer(pt:Point):Point3D {
			var localPt:Point = _display.globalToLocal(pt);
			var pt3:Point3D   = projection.screenToLayer(localPt);
			
			return pt3;
		}*/
		
		public function setCell(val:Vector.<SmartDisplayObject>):Vector.<SmartDisplayObject> {
			for each (var sprite:SmartDisplayObject in val) {
				add(sprite);
			}
			return val;
		}
		
		public function setMoveRatio(xRatio:Number = 1, yRatio:Number = 1):void {
			ratio.setTo(xRatio, yRatio);
		}
		
		/*public function toMap(func:Function):Array {
			if (func == null) {
				throw new Error("null function");
			}
			var map:Array = [];
			for (var y:int = 0; y < h; y++) {
				for (var x:int = 0; x < w; x++) {
					if (map[y] == null) {
						map[y] = [];
					}
					map[y][x] = func(getCell(x, y));
				}
			}
			return map;
		}
		
		public function toString():String {
			var result:String = "";
			for (var y:int = 0; y < h; y++) {
				for (var x:int = 0; x < w; x++) {
					result += getCell(x, y).toString();
				}
				result += "\n";
			}
			return result;
		}*/
		
		/*public function unflatten():void {
			sort = true;
			_display.unflatten();
		}*/
		
		public function get width():int {
			return w;
		}
		private function sorterDisplay(f:DisplayObject, s:DisplayObject):Boolean {
			var key:Number  = f.y;
			var key2:Number = s.y;
			return key > key2;
		}
		
		private function sortSystem(time:Number):void {
			var f:DisplayObject;
			var numSprites:int = _quadBatch.numChildren;
			var c:DisplayObject;
			for (var i:int = 0; i < numSprites; i++) {
				c = _quadBatch.getChildAt(i);
				if (f != null && sorterDisplay(f, c)) {
					_quadBatch.swapChildren(f, c);
				}
				f = c;
			}
		}
		
		private function sortAllSprite(sprite:DisplayObject):void {
			var c:DisplayObject=sprite;
				if (sortSprite != null && sorterDisplay(sortSprite, c)) {
					_quadBatch.swapChildren(sortSprite, c);
				}
				sortSprite = c;
			
		}
	
		private function removeFromGridData(val:SmartDisplayObject):void {
			if (val.layerIndex == -1) {
				return;
			}
			var arr:Vector.<SmartDisplayObject> = data[val.layerIndex];
			if (arr == null) {
				val.layerIndex = -1;
				return;
			}
			
			var index:int                       = arr.indexOf(val);
			if (index == -1) {
				trace("Sprite '" + val.textureName + "' not found on array layer: " + name + ",  hash has:" + spriteHash[val.textureName]);
				return;
			}
			arr.splice(index, 1);
			val.layerIndex = -1;
		}
   
		

		
		private function updateLocation(val:SmartDisplayObject):void {
			var x:int                                  = Math.floor(val.position.x / sqEdgeSize);
			var y:int                                  = Math.floor(val.position.y / sqEdgeSize);
			if (x >= w) {
				x = w - 1;
			} 
			else if (x < 0) {
				x = 0;
			}
			if (y >= h) {
				y = h - 1;
			}
			else if (y < 0) {
				y = 0;
			}
			
			var index:int                              = (y * w) + x;
			if (index == val.layerIndex) {
				return;
			} 
			removeFromGridData(val);
			
			var collection:Vector.<SmartDisplayObject> = data[index];
			if (collection == null) {
				collection = data[index] = new Vector.<SmartDisplayObject>();
			}
			collection.push(val);
			val.layerIndex = index;

		}
	}
	
}

