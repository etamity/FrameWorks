package com.smart.engine.map.layer
{
	import com.smart.core.SmartSystem;
	import com.smart.engine.map.display.SmartDisplayObject;
	import com.smart.engine.map.utils.Point3D;
	
	import starling.display.DisplayObject;

	public interface ILayerDisplay
	{
		function add(val:SmartDisplayObject):SmartDisplayObject;
		//function remove(val:SmartDisplayObject):SmartDisplayObject;
		//function forceUpdate():void;

		function get name():String;
		function get display():DisplayObject;
		function getByName(name:String):SmartDisplayObject;
		function get numChildrenSprites():int;
		function get autoPosition():Boolean;
		function moveTo(x:Number, y:Number):void;
		function offset(x:Number, y:Number):void;
		function dispose():void;
/*		function screenToLayer(pt:Point):Point3D;
		function screenToGridPt(pt:Point):Point;
		function layerToGridPt(x:Number, y:Number):Point;*/
		function gridToLayerPt(gridX:int, gridY:int, z:int = 1):Point3D;
		//function gridToSreenPt(gridX:int, gridY:int, z:int = 1):Point;
		function onTrigger(time:Number, engine:SmartSystem):void;
		//function get layerData():Vector.<Vector.<SmartDisplayObject>>;
	}
}