package com.smart.mvsc.views.starlingviews.components
{
	import com.smart.mvsc.model.Language;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class PlayerBarView extends Sprite
	{
		public var _header:Header;
		public var leftItems:Vector.<DisplayObject>;
		private var _assets:AssetManager;
		public var _exitBtn:Button=new Button();
		public function PlayerBarView()
		{
			super();
		}

		public function initAssets(assets:AssetManager):void{
			_assets=assets;
			_header =new Header();
			_header.height=50;
			_header.nameList.add("smart-header");

			leftItems=new Vector.<DisplayObject>();
			_header.leftItems=leftItems;
			
			addChild(_header);
			this._header.width = this.stage.width;
				
		
			_exitBtn.height=_header.height-20;
			_exitBtn.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			_exitBtn.paddingRight=30;
			_exitBtn.label= Language.EXIT;
			this._header.rightItems= new <DisplayObject>[
				_exitBtn
			];
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			const button:Button = Button(event.currentTarget);
			this.dispatchEventWith(button.label);
			
		}
		public function addItem(display:DisplayObject):void {
			leftItems.push(display);
		}
	}
}