//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins {

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import com.smart.engine.SmartEngine;
	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.IPluginEngine;
	import com.smart.engine.core.Plugin;
	import com.smart.engine.display.LayerDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartMovieClip;
	import com.smart.engine.utils.Point3D;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SpriteControlPlugin extends Plugin implements IPlugin {

		private var _mapWidth: int =0;
		private var _mapHeight: int =0;

		private var currentDirection:int       = 1;
		private var currentFrame:int           = 1;
		private var distance:Number;

		private var imageFrame:int             = 1;
		private var lastDirection:int          = 1;

		private var moving:Boolean             = false;
		private var speed:Number               = 1;
		private var sprite:SmartMovieClip;

		private var spritePt:Point3D;

		private var stage:Stage;
		private var stepLong:int               = 2;
		private var targetPt:Point3D;
		private var totalFrame:int;
		private var walkSteps:int              = 0;
		
		private var touchPoint :Point;
		
		public function SpriteControlPlugin(obj:SmartMovieClip = null) {
			super();
			name = "SpriteControlPlugin";
			sprite = obj;
			targetPt = sprite.position;
			spritePt = sprite.position;

			
		}
		
		private function get frameLength():int{
			return sprite.numFrames / 8;
		}
		
		private function get DIRECTION_DOWN():int {
			return frameLength * 4;
		}
		private function get DIRECTION_LEFT():int{
			return frameLength * 6;
		}
		private function get DIRECTION_RIGHT():int {
			return frameLength * 5;
		}
		private function get DIRECTION_UP():int{
			return frameLength * 7;
		}
		
		public function get currentInGrid():Point{
			return engine.objectInGridPt(sprite.position);
		}
		
		
		public function get mapWidth():int{
			return _mapWidth;
		}
		public function get mapHeight():int{
			return _mapHeight;
		}
		public function move(direction:int):void {
			switch (direction) {
				case DIRECTION_UP:
					if (currentInGrid.y - 1 >= 0) {
						moveOneStep(direction, stepLong);
					}

					break;
				case DIRECTION_DOWN:
					if (currentInGrid.y + 1 < mapHeight) {
						moveOneStep(direction, stepLong);
					}

					break;
				case DIRECTION_LEFT:
					if (currentInGrid.x - 1 >= 0) {
						moveOneStep(direction, stepLong);
					}

					break;
				case DIRECTION_RIGHT:
					if (currentInGrid.x + 1 < mapWidth) {
						moveOneStep(direction, stepLong);
					}
					break;

			}

			totalFrame = distance / stepLong;
			var newPt3D:Point3D   = engine.gridInLayerPt(currentInGrid);

			targetPt = newPt3D;
		}

		override public function onRegister(engine:IPluginEngine):void {
			super.onRegister(engine);
			stage = this.engine.stage;
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			var plugin:TMXPlugin  = getClass(getPlugin("TMXPlugin"))(getPlugin("TMXPlugin"));
			_mapWidth  = plugin.tmxData.width - 1;
			_mapHeight  = plugin.tmxData.height - 1;
			touchPoint = this.engine.objectInGridPt(sprite.position);
			
		}

		override public function onRemove():void {
			super.onRemove();
		}

		override public function onTrigger(time:Number):void {
			var xpt:Number = targetPt.x;
			var ypt:Number = targetPt.y;

			SmartMovieClip(sprite).currentFrame = imageFrame;
			if (moving) {
				//move(currentDirection);
				moveTo(touchPoint.x,touchPoint.y);
			}
		
	
		}

		private function doAnimation(evt:TimerEvent):void {

			if (imageFrame < currentDirection + frameLength - 1) {
				imageFrame++;
			}
			else {
				imageFrame = currentDirection;
			}

		}

		private function moveTo(x:int, y:int):void{
			if (currentInGrid.y != y || currentInGrid.x!=x)
			{
				if (currentInGrid.y > y ){
					currentDirection=DIRECTION_UP;
					move(currentDirection);
				}else
				if (currentInGrid.y < y )
				{
					currentDirection=DIRECTION_DOWN;
					move(currentDirection);
				}else
				if (currentInGrid.x > x )
				{
					currentDirection=DIRECTION_LEFT;
					move(currentDirection);
				}else
				if (currentInGrid.x < x )
				{
					currentDirection=DIRECTION_RIGHT;
					move(currentDirection);
				}
				
				moving = true;
			}else
			{
				imageFrame = currentDirection;
				moving = false;
			}
		}
	

		private function getMoveImageFrame(frame:int):int {
			var sd:Number  = stepLong / frameLength;
			var pos:Number = frame * distance / sd;
			var t:int      = Math.round(pos / stepLong);
			var m:Number   = (pos - t * stepLong) * 100 / 100;
			var f:int      = Math.round((frameLength) * m);

			return currentDirection + Math.abs(f);
		}

		private function moveOneStep(direction:int, steplong:int = 1):void {
			if (lastDirection != direction) {
				lastDirection = direction;
				imageFrame = direction;

			}
			else {
				walkSteps++;
			}
			switch (direction) {
				case DIRECTION_UP:
					sprite.position.y -= stepLong;

					break;
				case DIRECTION_DOWN:
					sprite.position.y += stepLong;

					break;
				case DIRECTION_LEFT:
					sprite.position.x -= stepLong;

					break;
				case DIRECTION_RIGHT:
					sprite.position.x += stepLong;
					break;

			}
			var afterSteps:int = frameLength / stepLong;
			frameChangeAfterSteps(afterSteps);
		}
		
		private function frameChangeAfterSteps(afterSteps:int):void {
			if (walkSteps % (stepLong * afterSteps) == 0) {
				if (imageFrame < currentDirection + frameLength - 1) {
					imageFrame++;
				}
				else {
					imageFrame = currentDirection;
				}
			}
		}
		private function nextGrid(direction:int,gridStep:int=5):Point{

			var newGrid:Point = new Point(0,0);
			newGrid.copyFrom(currentInGrid);
			switch (direction) {
				case DIRECTION_UP:
					if (currentInGrid.y - 1 >= 0) {
						newGrid.y -=gridStep;
					}
					
					break;
				case DIRECTION_DOWN:
					if (currentInGrid.y + 1 < mapHeight) {
						newGrid.y +=gridStep;
					}
					
					break;
				case DIRECTION_LEFT:
					if (currentInGrid.x - 1 >= 0) {
						newGrid.x -=gridStep;
					}
					
					break;
				case DIRECTION_RIGHT:
					if (currentInGrid.x + 1 < mapWidth) {
						newGrid.x +=gridStep;
					}
					break;
			}
			return newGrid;
		}

		private function onKeyDown(e:KeyboardEvent):void {

			switch (e.keyCode) {
				case Keyboard.UP:
					currentDirection = (DIRECTION_UP);
					touchPoint = nextGrid(DIRECTION_UP);
					moving = true;
					break;
				case Keyboard.DOWN:
					currentDirection = (DIRECTION_DOWN);
					touchPoint = nextGrid(DIRECTION_DOWN);
					moving = true;
					break;
				case Keyboard.LEFT:
					currentDirection = (DIRECTION_LEFT);
					touchPoint = nextGrid(DIRECTION_LEFT);
					moving = true;
					break;
				case Keyboard.RIGHT:
					currentDirection = (DIRECTION_RIGHT);
					touchPoint = nextGrid(DIRECTION_RIGHT);
					moving = true;
					break;
			}
		

		}

		private function onKeyUp(e:KeyboardEvent):void {
			imageFrame = currentDirection;
			moving = false;
		}

		private function onTouch(e:TouchEvent):void {
			var touch:Touch   = e.getTouch(stage);
			var pt:Point      = touch.getLocation(stage);
			var mouseX:Number = pt.x;
			var mouseY:Number = pt.y;
			if (touch.phase == TouchPhase.BEGAN) {
				var ptgo:Point3D = engine.getLayerByIndex(0).screenToLayer(pt);
				//engine.sprites.getSpriteAt(0).pt=
				//engine.getLayerByIndex(0).fromScreenToLayerPt(ptgo.x,ptgo.y);
				//engine.sprites.getSpriteAt(0).addComponent(new
				//SpriteXRayLayers());	
				var ptva1:Point  = engine.getLayerByIndex(0).layerToGridPt(mouseX, mouseY);
				
				var ptva:Point3D = engine.getLayerByIndex(0).gridToLayerPt(ptva1.x, ptva1.y);
				
				var screen:Point = engine.getLayerByIndex(0).gridToSreenPt(ptva1.x, ptva1.y);
				
				touchPoint = engine.getLayerByIndex(0).screenToGridPt(pt);
				
				var spriteGrid: Point = engine.objectInGridPt(sprite.position);
				if (spriteGrid.equals(touchPoint)==false)
				{
					moving = true;
				}else
				{
					moving = false;
				}
				
			}
		}

		private function stopAnimation(evt:TimerEvent):void {
			imageFrame = currentDirection;
		}
	}

}

