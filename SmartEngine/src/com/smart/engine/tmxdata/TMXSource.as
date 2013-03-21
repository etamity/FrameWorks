//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.tmxdata {

	import flash.display.BitmapData;

	public class TMXSource {

		public function TMXSource(element:XML) {
			source = element.@source;
			width = int(element.@width);
			height = int(element.@height);
		}

		public var height:int;
		public var source:String;
		public var width:int;
	}

}

