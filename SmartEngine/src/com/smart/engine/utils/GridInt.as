//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.utils {

	public class GridInt {

		public function GridInt(width:int, height:int) {
			this.width = width;
			this.height = height;
			if (width == 0 && height == 0) {
				throw new Error("Invalid starting size of 0,0");
			}
			width = Math.max(width, 1); 
			height = Math.max(height, 1);
			data = new Vector.<int>(width * height, true); 
		}

		private var data:Vector.<int>;
		private var height:int = 0;
		private var width:int  = 0;


		public function getCell(x:int, y:int):int {
			var index:int = y * width + x; 
			return data[index];
		}
		public function getCellIndex(x:int, y:int):int {
			var index:int = y * width + x; 
			return index;
		}

		public function setCell(x:int, y:int, value:int):int {
			var index:int = y * width + x; 
			return data[index] = value;
		}

		public function toString():String {
			var result:String = "";
			for (var y:int = 0; y < height; y++) {
				for (var x:int = 0; x < width; x++) {
					result += getCell(x, y).toString();
				}
				result += "\n";
			}
			return result;
		}
	}

}

