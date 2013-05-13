package com.smart.mvsc.views
{
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class MenuScreen extends BaseScreen
	{

		private var buttonGroup:ButtonGroup;

		private var buttonsData:ListCollection;
	
		private var eventHash:Dictionary=new Dictionary();
		public function MenuScreen()
		{
			super();
			buttonGroup = new ButtonGroup();
			buttonsData =new ListCollection();
			buttonGroup.dataProvider = buttonsData;
			addChild(buttonGroup);
		}
		public function addMenuItem(label:String,eventName:String=null):void{
			eventHash[label]=eventName;
			var menuItem:Object={label: label, event:eventName, triggered: button_triggeredHandler};
			buttonsData.push(menuItem);
		}
		
		override protected function draw():void
		{
			buttonGroup.validate();
			buttonGroup.x = (actualWidth - buttonGroup.width) / 2;
			buttonGroup.y =  (actualHeight - buttonGroup.height) / 2;
		}
		
		private function button_triggeredHandler(event:Event):void
		{
			const button:Button = Button(event.currentTarget);
			dispatchEventWith(eventHash[button.label]);

		}
	}
}