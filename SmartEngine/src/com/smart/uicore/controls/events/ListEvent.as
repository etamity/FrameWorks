package com.smart.uicore.controls.events
{
	import com.smart.uicore.controls.interfaces.IListItemRender;
	
	import flash.events.Event;

	public class ListEvent extends Event
	{
		public static  const CHANGE:String = "change";
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
		
		public var targetItem:IListItemRender;
		
		public function ListEvent(type:String,itemObj:IListItemRender=null)
		{
			targetItem = itemObj;
			super(type);
		}
		
	}
}