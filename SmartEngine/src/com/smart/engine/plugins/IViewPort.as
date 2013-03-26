//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins {

	import com.smart.engine.display.ILayerDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.utils.Point3D;
	
	import flash.geom.Point;

	public interface IViewPort {
		function layerToScreen(pt:Point3D):Point;
		function onSetup(grid:ILayerDisplay):void;
		function update(sprite:SmartDisplayObject):void;
		function screenToLayer(pt:Point):Point3D;
		function get width():int;
		function get height():int;
		
		function get renderType():String;
		
	}

}

