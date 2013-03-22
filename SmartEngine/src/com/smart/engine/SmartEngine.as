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
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SmartEngine extends Sprite implements IAnimatable, IPluginEngine {
		
		private var _juggler:Juggler;

		private var displayArea:Sprite;

		private var plugins:Vector.<IPlugin>;
		private var pluginsHash:Dictionary;
		
		private var layers:Vector.<ILayerDisplay>; 
		private var layersHash:Dictionary; 

		private var position:Point;

		
		public function SmartEngine() {
			
			displayArea= new Sprite();

			plugins = new <IPlugin>[];
	
			pluginsHash = new Dictionary();
			_juggler = new Juggler();

			position = new Point(1, 1);
			addChild(displayArea);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
	   public function addDisplay(child:DisplayObject):DisplayObject{
			displayArea.addChild(child);
			return child;
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
	   public function get positionX():Number {
		   return position.x;
	   }
	   
	   public function set positionX(val:Number):void {
		   position.x = val;
	   }
	   
	   public function offset(x:Number, y:Number):void {
		   position.offset(x, y);
	   }
	   public function get currentZoom():Number {
		   return displayArea.scaleX;
	   }
	   
	   public function set currentZoom(val:Number):void {
		   displayArea.scaleX = displayArea.scaleY = val;
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
		public function getPlugin(val:*):*{
			var pluginName:String = getClassName(val);
			return getPluginByName(pluginName);
		}
		
		public function getClassName(val:*):String{
			var classPath:String = getQualifiedClassName(val);
			return classPath;
		}
		
		public function getPluginByName(val:String):* {
			var plugin:*= pluginsHash[val];
			if (plugin==null)
			{
					throw new Error(getQualifiedClassName(plugin) + "not found!");
			}
			return plugin;
		}

	

		public function get juggler():Juggler {
			return _juggler;
		}


		

		public function onTrigger(time:Number):void {
			juggler.advanceTime(time);
			for each (var plugin:IPlugin in plugins) {
				if (plugin.enabled)
					plugin.onTrigger(time);
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

