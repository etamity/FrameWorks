//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.utils {

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class GridBool {

		public static function fromBitMapDataAlpha(data:BitmapData, area:Rectangle = null):GridBool {
	
			var result:GridBool;
			var sx:int = area ? Math.floor(area.x) : 0;
			var sy:int = area ? Math.floor(area.y) : 0;
			var sw:int = area ? Math.ceil(area.width) : data.width;
			var sh:int = area ? Math.ceil(area.height) : data.height;
			for (var x:int = 0; x < sw; x++) {
				for (var y:int = 0; y < sh; y++) {
					var val:uint   = data.getPixel32(x + sx, y + sy);
					var alpha:uint = val >> 24 & 0xFF;
					if (alpha !== 0) {
						if (result === null) {
							result = new GridBool(data.width, data.height);
						}
						result.setCell(x, y, true);
					}
				}
			}

			return result;
		}

		public function GridBool(gridWidth:int, gridHeight:int) {
			_width = gridWidth;
			_height = gridHeight;
			if (gridWidth == 0 || gridHeight == 0) {
				throw new Error("Invalid starting size of 0,0");
			}
			_width = Math.max(gridWidth, 1); 
			_height = Math.max(gridHeight, 1); 
			data = new Vector.<Boolean>(gridWidth * gridHeight, true); 
		}

		private var _height:int = 0;
		private var _width:int  = 0;
		private var data:Vector.<Boolean>;

		public function getCell(x:int, y:int):Boolean {
			var index:int = y * width + x; 
			if (index >= data.length) {
				return false;
			}

			return data[index];
		}

		public function get height():int {
			return _height;
		}

		public function setCell(x:int, y:int, value:Boolean):Boolean {
			var index:int = y * width + x; 
			return data[index] = value;
		}

		public function setGrid(data:Vector.<Boolean>):void {
			this.data = data;
		}

		public function toString():String {
			var result:String = "";
			for (var y:int = 0; y < height; y++) {
				for (var x:int = 0; x < width; x++) {
					result += getCell(x, y) == true ? 1 : 0;
				}
				result += "\n";
			}
			return result;
		}

		public function get width():int {
			return _width;
		}
	}

}

