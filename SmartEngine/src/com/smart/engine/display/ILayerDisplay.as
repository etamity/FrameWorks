package com.smart.engine.display
{
	import flash.geom.Point;
	
	import com.smart.engine.SmartEngine;
	import com.smart.engine.utils.Point3D;
	
	import starling.display.DisplayObject;
	public interface ILayerDisplay
	{
		function add(val:SmartDisplayObject):SmartDisplayObject;
		function remove(val:SmartDisplayObject):SmartDisplayObject;
		function forceUpdate():void;
		function screenToGridPt(pt:Point):Point;
		function get name():String;
		function get display():DisplayObject;
		function getByName(name:String):SmartDisplayObject;
		function get numChildrenSprites():int;
		function get autoPosition():Boolean;
		function moveTo(x:Number, y:Number):void;
		function screenToLayer(pt:Point):Point3D;
		function layerToGridPt(x:Number, y:Number):Point;
		function gridToLayerPt(gridX:int, gridY:int, z:int = 1):Point3D;
		function gridToSreenPt(gridX:int, gridY:int, z:int = 1):Point;
		function onTrigger(time:Number, engine:SmartEngine):void;
	}
}