//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.viewport {

	import flash.geom.Point;
	import com.smart.engine.display.LayerDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartSprite;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.display.ILayerDisplay;

	public interface IProjection {
		function layerToScreen(pt:Point3D):Point
		function onSetup(grid:ILayerDisplay):void;
		function perSprite(sprite:SmartDisplayObject):void;
		function screenToLayer(pt:Point):Point3D
	}

}

