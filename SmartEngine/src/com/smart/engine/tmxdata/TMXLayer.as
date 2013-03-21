//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.tmxdata {

	import com.smart.engine.utils.GridInt;

	public class TMXLayer extends GridInt {

		public static function fromCSV(layerBlock:XML, width:int, height:int):TMXLayer {
			var layerRaw:Array = layerBlock.data[0].toString().split(",");

			var layer:TMXLayer = new TMXLayer(width, height);
			var index:int      = 0;
			for each (var cell:String in layerRaw) {
				cell = cell.replace("\n", ""); 
				var cellVal:int = int(cell);
				layer.maxGid = Math.max(layer.maxGid, cellVal);
				layer.setCell(index % width, Math.floor(index / width), cellVal);
				index++;
			}
			trace("csv layer parsing done");
			return layer;
		}

		public function TMXLayer(w:int, h:int) {
			super(w, h);
		}

		public var maxGid:int = 0; 
		public var name:String;
	}

}

