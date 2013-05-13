package com.smart.uicore.controls.support
{
	import com.smart.uicore.controls.CheckBox;
	import com.smart.uicore.controls.List;
	import com.smart.uicore.controls.events.DataGridChangeEvent;
	import com.smart.uicore.controls.interfaces.IListItemRender;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class CheckBoxItemRender extends Sprite implements IListItemRender
	{
		private var _data:Object;
		private var cb:CheckBox;
		private var _list:List;
		
		public function CheckBoxItemRender()
		{
			cb = new CheckBox();
			this.addChild(cb);
		}
		
		protected function disPathChange(event:Event):void
		{
			_data.selected = cb.selected;
			_list.dispatchEvent(new DataGridChangeEvent(DataGridChangeEvent.EDIT_CHANGE,DataGridItemRender(this.parent).index,DataGridItemRender(this.parent).getRenderIndex(this)));
		}
		
		public function set data(value:Object):void{
			_data = value;
			cb.selected = value.selected;
			cb.label = value.label;
			cb.addEventListener(Event.CHANGE,disPathChange);
		}
		
		public function set index(value:int):void
		{
			
		}
		
		public function get data():Object{
			return _data;
		}
		
		public function get itemHeight():Number{
			return 23;
		}
		
		public function set list(value:List):void{
			_list = value;
		}
		
		 public function set selected(value:Boolean):void{
		
		}
		 
		 public function get selected():Boolean{
			return false;
		}
		 
		 public function setSize(newWidth:Number, newHeight:Number):void{
			 cb.setSize(newWidth,newHeight);
		 }
		 
	}
}