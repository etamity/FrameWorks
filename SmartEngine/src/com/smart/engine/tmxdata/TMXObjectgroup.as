//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.tmxdata {

	import flash.utils.Dictionary;

	public class TMXObjectgroup {

		public function TMXObjectgroup() {

		}

		public var height:Number;
		public var name:String;
		public var objects:Vector.<TMXObject> = new <TMXObject>[];
		public var objectsHash:Dictionary     = new Dictionary();

		public var properties:Dictionary      = new Dictionary();
		public var width:Number;
	}

}

