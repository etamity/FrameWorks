package com.smart.views.srceens
{

	import com.smart.model.Language;
	import com.smart.services.ThemeService;
	import com.smart.views.scenes.BaseScene;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.controls.Screen;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;




	public class BaseScreen extends Screen
	{
		private var _assets:AssetManager;
		protected var leftItems:Vector.<DisplayObject>;
		protected var rightItems:Vector.<DisplayObject>;
		protected const LEFT:String="LEFT";
		protected const RIGHT:String="RIGHT";
		private var _header:Header;
		public var headerHeight:int=64;

		public function BaseScreen()
		{

		}

		public function get header():Header{
			return _header;
		}
		protected function addHeader(title:String):Header
		{
			if (_header == null)
			{
				_header=new Header();
				_header.nameList.add(ThemeService.HEADER_PLAYERBAR);
				_header.height=headerHeight;
				_header.title=title;
				leftItems=new Vector.<DisplayObject>();
				rightItems=new Vector.<DisplayObject>();
				_header.leftItems=leftItems;
				_header.rightItems=rightItems;
				_header.width=this.stage.width;
				addChild(_header);
			}

			return _header;
		}

		protected function newProgressBar(value:Number):ProgressBar
		{
			var _progressbar:ProgressBar=new ProgressBar();
			_progressbar.value=value;
			return _progressbar;
		}

		protected function newLabel(label:String):Label
		{
			var _label:Label=new Label();
			_label.nameList.add(ThemeService.HEADER_MONEY_LABEL);
			_label.text=label;
			return _label;
		}

		protected function newButton(label:String,func:Function=null):Button
		{
			var _newBtn:Button=new Button();
			_newBtn.height=headerHeight - 20;
			if (func!=null)
				_newBtn.addEventListener(Event.TRIGGERED, func);
				else
				_newBtn.addEventListener(Event.TRIGGERED, button_TriggeredHandler);
			_newBtn.paddingRight=30;
			_newBtn.label=label;
			return _newBtn;
		}

		protected function newImage(textureName:String):Image
		{
			var image:Image=new Image(assets.getTexture(textureName));
			return image;
		}

		private function button_TriggeredHandler(event:Event):void
		{
			const button:Button=Button(event.currentTarget);
			trace(button.label + " Button Click");
			this.dispatchEventWith(button.label, false, button.label);

		}

		public function addScene(scene:BaseScene):void{
			scene.assets=assets;
			addChild(scene);
			scene.start();
		}
		public function addItem(display:DisplayObject, direct:String=LEFT):void
		{
			addHeader("");
			if (direct == LEFT)
				leftItems.push(display);
			else if (direct == RIGHT)
				rightItems.push(display);

		}

		public function set assets(val:AssetManager):void
		{
			_assets=val;
		}

		public function get assets():AssetManager
		{
			return _assets;
		}
	}
}
