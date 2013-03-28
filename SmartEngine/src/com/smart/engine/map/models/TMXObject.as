//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.models {

	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class TMXObject {

		public function TMXObject() {

		}

		public var gid:int;
		public var name:String;

		public var properties:Dictionary = new Dictionary();
		public var type:String;
		public var x:Number;
		public var y:Number;
	}

}

