//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.plugins {

	import com.smart.engine.map.layer.ILayerDisplay;
	import com.smart.engine.map.display.SmartDisplayObject;
	import com.smart.engine.map.utils.Point3D;
	
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

