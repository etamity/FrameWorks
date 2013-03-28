//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.utils {

	import com.smart.engine.map.display.SmartSprite;

	public class State {

		public function State(name:String = "", start:int = 0, end:int = 0, collidable:Boolean = false) {
			this.name = name;
			this.start = start;
			this.end = end;
			this.collidable = collidable;
		}


		public var collidable:Boolean = false;

		public var end:int;
	
		public var name:String;

		public var start:int;

		public var target:SmartSprite;

		public var targetPt:Point3D;
	}

}

