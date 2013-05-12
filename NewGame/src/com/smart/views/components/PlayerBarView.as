package com.smart.views.components
{
	import com.smart.logs.Debug;
	import com.smart.model.Language;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class PlayerBarView extends Sprite
	{
		public var _header:Header;
		public var _money:Label;
		public var _health:ProgressBar;
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

			_money = new Label();
			_health= new ProgressBar();
			_money.text= "1000.00";
			leftItems=new Vector.<DisplayObject>();
			_header.leftItems=leftItems;
			
			addChild(_header);
			this._header.width = this.stage.width;
	
			var image:Image=new Image(assets.getTexture("IconMoney"));
			addItem(image);
			addItem(_money);
			image =new Image(assets.getTexture("icon-snow-small"));
			_health.value=100;
			addItem(image);
			addItem(_health);
			
		
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
			Debug.log(button,button.label, event.data, " triggered.");
			this.dispatchEventWith(button.label);
			
		}
		public function addItem(display:DisplayObject):void {
			leftItems.push(display);
		}
	}
}