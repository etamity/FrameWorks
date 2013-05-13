package com.smart.uicore.controls.interfaces
{
	import com.smart.uicore.controls.List;

	public interface IListItemRender
	{
		function set data(value:Object):void;
		function get data():Object;
		function get itemHeight():Number;
		function setSize(newWidth:Number, newHeight:Number):void;
		function set list(value:List):void;
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		function set index(value:int):void;
	}
}