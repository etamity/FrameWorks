//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart {

	import com.smart.core.Engine;
	import com.smart.core.IEngine;
	import com.smart.core.IPlugin;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class SmartSystem extends Engine implements IAnimatable {
		
		private var _juggler:Juggler;

		private var displayArea:Sprite;
		
		private var position:Point;

		protected var engines:Vector.<IEngine>;
		protected var enginesHash:Dictionary;
		
		public function SmartSystem(root:Sprite) {
			
			this.stage=root.stage;
			this.root=root;
			displayArea= new Sprite();

			_juggler = new Juggler();

			position = new Point(1, 1);
			
			engines=new <IEngine>[];
			enginesHash=new Dictionary();
			
			root.addChild(displayArea);
		}

	   public function addDisplay(child:DisplayObject):DisplayObject{
			displayArea.addChild(child);
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
	   
	   override public function dispose():void{
		   super.dispose();
		   this.stop();
		   if (displayArea.parent!=null)
			   displayArea.parent.removeChild(displayArea);
		   displayArea.dispose();
		   _juggler = null;
	   }
	   public function get display():DisplayObject{
		   return displayArea;
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

	}

}

