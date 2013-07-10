//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {

	
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class SmartSystem extends Engine implements IAnimatable {
		
		private var _juggler:Juggler;

		protected var engines:Vector.<IEngine>;
		protected var enginesHash:Dictionary;
		private var container:Sprite;
		public function SmartSystem(root:Sprite) {
			super();
			this.stage=root.stage;
			container=new Sprite();
			this.root=container;
			_juggler = new Juggler();
			root.addChild(container);
			engines=new <IEngine>[];
			enginesHash=new Dictionary();
		}

	   public function addDisplay(child:DisplayObject):DisplayObject{
		    display.addChild(child);
			return child;
		}
	   
	   public function addEngine(engine:IEngine):IEngine{
		   engine.stage=stage;
		   engine.root=root;
		   engines.push(engine);
		   engine.onRegister(this);
		   enginesHash[engine.name]=engine;
		   return engine;
	   }
	   
	   public function getEngine(engine:*):*{
		  var pluginName:String=getClassName(engine);
		  return  enginesHash[pluginName];

	   }
	   
	   public function removeEngine(engine:IEngine):void
	   {
		   var index:int=engines.indexOf(engine);
		   if (index != -1)
		   {
			   engines.splice(index, 1);
		   }
		   engine.dispose();
		   delete enginesHash[engine.name];
	   }

	   public function removeAllEngines():void{
		   while (engines.length>0)
		   {
			   removeEngine(engines[engines.length-1]);
		   }
		   
		   engines=new <IEngine>[];
		   enginesHash=new Dictionary();
	   }
	   
	   override public function dispose():void{
		   stop();
		   removeAllEngines();
		   display.removeChildren();
		   _juggler = null;
		   gc();
	   }
	   public function get display():Sprite{
		   return container;
	   }
	   
		public function advanceTime(time:Number):void {
			onTrigger(time);
		}

		public function get juggler():Juggler {
			return _juggler;
		}

		override public function onTrigger(time:Number):void {
			juggler.advanceTime(time);
			for each (var engine:IEngine in engines) {
				if (engine.enabled)
					engine.onTrigger(time);
			}
			
			for each (var plugin:IPlugin in plugins) {
				if (plugin.enabled)
					plugin.onTrigger(time);
			}
			
		}

		public function setSize(width:Number, height:Number):void {
			display.x = width * .5;
			display.y = height * .5;
		}

		public function start():void {
			Starling.juggler.remove(this);
			Starling.juggler.add(this);
		}

		public function gc():void{
			System.gc();
		}
		
		public function stop():void {
			Starling.juggler.remove(this);
		}

		private function get isComplete():Boolean {
			return false;
		}

	}

}

