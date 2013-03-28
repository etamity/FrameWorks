//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.utils {

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class DynamicMovieClip extends MovieClip {

		public function DynamicMovieClip() {
			frameClips = new Dictionary();
		}

		private var _current:int  = 0;
		private var frameClips:Dictionary; 
		private var lastFrame:int = 0;
		private var maxFrames:int = 0;

		public function addToFrame(frame:int, clip:DisplayObject):void {
			
			if (!frameClips[frame]) {
				frameClips[frame] = [];
			}
			frameClips[frame].push(clip);
			if (frame > maxFrames) {
				maxFrames = frame;
			}
			if (frame == _current) {
				onFrameChange();
			} 
		}

		override public function gotoAndPlay(frame:Object, scene:String = null):void {
			throw new Error("Method not implemented, not required for implementation uses");
		}

		override public function gotoAndStop(frame:Object, scene:String = null):void {
			if (!(frame is int)) {
				throw new Error("Frame number must be an int");
			}
			var frameNum:int = int(frame);
			if (frameNum >= maxFrames) {
				frameNum = maxFrames - 1;
			}
			if (frameNum < 0) {
				frameNum = 0;
			}
			_current = frameNum;
			super.gotoAndStop(frameNum, scene);
			if (_current != lastFrame) {
				onFrameChange();
			}
		}

		override public function nextFrame():void {
			_current = Math.min(maxFrames, ++_current);
			super.nextFrame();
			if (_current != lastFrame) {
				onFrameChange();
			}
		}

		override public function play():void {
			throw new Error("Method not implemented, not required for implementation uses");
		}

		override public function prevFrame():void {
			_current = Math.max(0, --_current);
			super.prevFrame();
			if (_current != lastFrame) {
				onFrameChange();
			}
		}

		override public function stop():void {
			super.stop();
		}

		override public function get totalFrames():int {
			var total:int = super.totalFrames;
			return total > maxFrames ? total : maxFrames;
		}

		private function onFrameChange():void {
			var child:DisplayObject;

			if (lastFrame >= 0 && frameClips[lastFrame]) {
				for each (child in frameClips[lastFrame]) {
					if (child.parent) {
						child.parent.removeChild(child);
					}
				}
			}
			if (frameClips[_current]) {
				for each (child in frameClips[_current]) {
					addChild(child);
				}
			}
			lastFrame = _current;
		}
	}

}

