//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins {

	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.Plugin;
	import com.smart.engine.utils.Point3D;
	
	import flash.ui.Keyboard;
	
	import starling.animation.Tween;
	import starling.display.Stage;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	
	public class ViewportControlPlugin extends Plugin {
		
		public var speed:Number;
		public var zoom:Number       = .05;
		private var hitArea:Number;
		private var tw:Tween;
		private var velocity:Point3D;
		private var zoomDelta:Number = 0.006;
		private var engine:CameraPlugin;
		public function ViewportControlPlugin(hitArea:Number = 40, speed:Number = 8) {
			super();
			this.hitArea = hitArea;
			this.speed = speed;
			velocity = new Point3D(0, 0, 0);
		}

		override public function onRegister(engine:IPlugin):void {
			this.engine =engine as CameraPlugin;  //this.EngineClass(engine);
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addEventListener("mouseLeave", onMouseOut);
			stage.addEventListener("mouseOut", onMouseOut);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			//stage.addEventListener(WheelEvent.SCROLL, onMouseWheel);
		}

		override public function onRemove():void {
		}

		override public function onTrigger(time:Number):void {
			var fasterPanWithZoom:Number = Math.max(engine.position.z, 1);
			engine.position.x += velocity.x;
			engine.position.y += velocity.y;
			engine.position.z += velocity.z;
			if (velocity.z > 0) {
				velocity.z -= zoomDelta;
			}
			if (velocity.z < 0) {
				velocity.z += zoomDelta;
			}
			if (velocity.z < zoomDelta && velocity.z > 0) {
				velocity.z = 0;
			}
			if (velocity.z > -zoomDelta && velocity.z < 0) {
				velocity.z = 0;
			}
		}

		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.A) {
				velocity.z = zoom;
			}
			else if (e.keyCode == Keyboard.Z) {
				velocity.z = -zoom;
			}
		}

		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.A) {
				velocity.z = 0;
			}
			else if (e.keyCode == Keyboard.Z) {
				velocity.z = 0;
			}
		}

		private function onMouseOut(e:*):void {
			velocity.x = 0;
			velocity.y = 0;
		}

		/*private function onMouseWheel(e:WheelEvent):void {
			if (e.delta > 0) {
				velocity.z = -zoom;
			}
			else if (e.delta < 0) {
				velocity.z = +zoom;

			}

		}*/

		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch == null) {
				return;
			}
			var _x:Number   = touch.globalX;
			var _y:Number   = touch.globalY;

			if (_x > stage.stageWidth - hitArea) {
				velocity.x = speed;
			}
			else if (_x < hitArea) {
				velocity.x = -speed;
			}
			else {
				velocity.x = 0;
			}

			if (_y > stage.stageHeight - hitArea) {
				velocity.y = speed;
			}
			else if (_y < hitArea) {
				velocity.y = -speed;
			}
			else {
				velocity.y = 0;
			}

		}
	}

}

