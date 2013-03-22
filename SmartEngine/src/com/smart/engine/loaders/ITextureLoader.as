//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.loaders {

	import com.smart.engine.display.SmartDisplayObject;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	public interface ITextureLoader {

		function getDisplay():DisplayObject;

		function get id():String;

		function get isLoaded():Boolean;

		function load():void;

		function setTexture(sprite:SmartDisplayObject):void;
	}

}

