//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.display {

	import com.smart.engine.SmartEngine;
	import com.smart.engine.starling.HitMovieClip;
	import com.smart.engine.utils.GridBool;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.utils.State;
	
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class SmartMovieClip extends SmartDisplayObject {
		public function SmartMovieClip(id:String, name:String, pt:Point3D = null, state:State = null) {
			super(id, name, pt, state);
			_display.stop();
			frameCallbacks = new Dictionary();
			frameCallbacks[-1] = []; 
		}

		private var _currentFrame:int = -1; 
		private var _display:HitMovieClip;
		private var frameCallbacks:Dictionary; 
		private var loaded:Boolean;

		public function addFrameCallback(frame:int, callback:Function):void {
			if (!frameCallbacks[frame]) {
				frameCallbacks[frame] = [];
			}
			frameCallbacks[frame].push(callback);
		}


		public function addLastFrameCallback(callback:Function):void {
			frameCallbacks[-1].push(callback);
		}


		override public function changeTo(assetID:String):void {
			if (_display) {
				currentFrame = 0;
				stop();
			}
			super.changeTo(assetID);
		}


		public function get currentFrame():int {
			return _display.currentFrame;
		}


		public function set currentFrame(val:int):void {
			if (val < _display.numFrames) {
				_display.currentFrame = val;
				_currentFrame = -1;
			}
			else {
				_currentFrame = val;
			}
		}

		override public function get display():DisplayObject {
			return _display;
		}


		override public function set display(val:DisplayObject):void {
			if (val == null) {
				throw new Error("img is null");
			}
			if (!(val is HitMovieClip)) {
				throw new Error("Starling DisplayObject is not a MovieClip");
			}
			if (_display != null && val != display) {
				if (_display.parent) {
					_display.parent.removeChild(_display);
				}
			}

			_display = HitMovieClip(val);
		}

		public function get isPlaying():Boolean {
			return _display.isPlaying;
		}

		public function get numFrames():int {
			return _display.numFrames;
		}


		override public function onTrigger(time:Number):void {
			if (!_display.isPlaying && _currentFrame != -1) {
				currentFrame = _currentFrame;
			}
			super.onTrigger(time);
			if (_display.isPlaying) {
				_display.advanceTime(time);
			}
			var cb:Function;
			if (loaded) {
				if (frameCallbacks[currentFrame]) {
					for each (cb in frameCallbacks[currentFrame]) {
						cb(this);
					}
				}
				if (currentFrame == numFrames - 1) {
					for each (cb in frameCallbacks[-1]) {
						cb(this);
					}
				}
			}
		}


		public function pause():void {
			_display.pause();
		}


		public function play():void {
			if (_display.isPlaying) {
				return;
			}
			_display.play();
			SmartEngine.engine.juggler.add(_display);
		}

	
		override public function remove():void {
			frameCallbacks = new Dictionary(); 
			super.remove();
		}


		public function removeFrameCallback(frame:int, callback:Function):void {
			if (!frameCallbacks[frame]) {
				return;
			}
			var index:int = frameCallbacks[frame].indexOf(callback);
			if (index == -1) {
				return;
			}
			frameCallbacks[frame].splice(index, 1);
		}


		public function setHitmap(hitMap:Vector.<GridBool>):void {
			_display.hitMap = hitMap;
		}


		public function setTexture(offset:Point, textures:Vector.<Texture>, durations:Vector.<Number> = null, snds:Vector.<Sound> = null):void {
			if (textures == null) {
				throw new Error("Textures were null");
			}
			else if (_display == null) {
				throw new Error("starling.display.MovieClip was null");
			}

			while (_display.numFrames > 1) {
				_display.removeFrameAt(0);
			} 

			var num:int = textures.length;
			for (var i:int = 0; i < num; i++) {
				_display.addFrameAt(i, textures[i], snds ? snds[i] : null, durations != null ? durations[i] : -1);
			}
			_display.currentFrame = _display.currentFrame; 
			if (!offset.y) {
				offset.y = 0;
			}
			if (!offset.x) {
				offset.x = 0;
			}

			_display.readjustSize();

			_display.pivotY = _display.height + offset.y;
			_display.pivotX = 0 + offset.x;

			if (layer) {
				layer.forceUpdate();
			}
			loaded = true;
		}


		public function stop():void {
			_display.stop();
			SmartEngine.engine.juggler.remove(_display);
		}
	}

}

