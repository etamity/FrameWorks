//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine {

	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.IPluginEngine;
	import com.smart.engine.display.ILayerDisplay;
	import com.smart.engine.display.LayerBatchDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.utils.Point3D;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SmartEngine extends Sprite implements IAnimatable, IPluginEngine {
		
		private var _juggler:Juggler;
		private var container:Sprite;
		private var displayArea:Sprite;

		private var layers:Vector.<ILayerDisplay>; 
		private var layersHash:Dictionary; 
		private var plugins:Vector.<IPlugin>;
		private var pluginsHash:Dictionary;
		private var position:Point;
		
		public static var engine:SmartEngine;
		
		public function SmartEngine() {
			
			container= new Sprite();
			displayArea= new Sprite();
			layers = new <ILayerDisplay>[];
			plugins = new <IPlugin>[];
			layersHash = new Dictionary();
			pluginsHash = new Dictionary();
			_juggler = new Juggler();
			engine = this;
			position = new Point(1, 1);
			addChild(displayArea);
			displayArea.addChild(container);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
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
		public function get EngineClass():Class{
			var classPath:String = getQualifiedClassName(this);
			var ClassDef:Class = getDefinitionByName(classPath) as Class;
			return ClassDef;
		}
		public function addPlugin(plugin:IPlugin):void {
			plugins.push(plugin);
			plugin.onRegister(this);
			pluginsHash[plugin.name] = plugin;
		}

		public function advanceTime(time:Number):void {
			onTrigger(time);
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

		public function getPluginByName(val:String):IPlugin {
			return pluginsHash[val];
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

		/*override public function globalToLocal(pt:Point):Point {
			return container.globalToLocal(pt);
		}*/

		public function gridInLayerPt(pt:Point):Point3D {
			var currentGrid:Point3D = this.layers[0].gridToLayerPt(pt.x, pt.y);
			return currentGrid;
		}

		public function get juggler():Juggler {
			return _juggler;
		}

		/*override public function localToGlobal(pt:Point):Point {
			return container.localToGlobal(pt);
		}*/

		public function moveTo(x:Number, y:Number):void {
			position.setTo(x, y);
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

		public function offset(x:Number, y:Number):void {
			position.offset(x, y);
		}

		public function onTrigger(time:Number):void {
			juggler.advanceTime(time);
			for each (var plugin:IPlugin in plugins) {
				plugin.onTrigger(time);
			}
			for each (var layer:ILayerDisplay in layers) {
				if (layer != null) {
					if (layer.autoPosition) {
						layer.moveTo(position.x, position.y);
					}
					layer.onTrigger(time, this);
				}
			}
		}

		public function get positionX():Number {
			return position.x;
		}

		public function set positionX(val:Number):void {
			position.x = val;
		}

		public function get positionY():Number {
			return position.y;
		}

		public function set positionY(val:Number):void {
			position.y = val;
		}

		public function removeLayer(layer:ILayerDisplay):void {
			var index:int = layers.indexOf(layer);
			layers.splice(index, 1);
			delete layersHash[layer.name];
			container.removeChild(layer.display);
		}
		
		public function removeAllLayers():void{
			
			for each(var alayer:ILayerDisplay in layersHash) {
				engine.removeLayer(alayer);
			}
		}
		

		public function removePlugin(plugin:IPlugin):void {
			var index:int = plugins.indexOf(plugin);
			if (index != -1) {
				plugins.splice(index, 1);
			}
			plugin.onRemove();
			delete pluginsHash[plugin.name];
		}

		public function setSize(width:Number, height:Number):void {
				displayArea.x = width * .5;
				displayArea.y = height * .5;
		}

		public function start():void {
			Starling.juggler.remove(this);
			Starling.juggler.add(this);
		}

		public function stop():void {
			Starling.juggler.remove(this);
		}

		private function get isComplete():Boolean {
			return false;
		}

		private function onStage(e:*):void {
			setSize(stage.stageWidth, stage.stageHeight);
		}
	}

}

