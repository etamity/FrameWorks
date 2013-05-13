package com.smart.mvsc.views
{

	import com.smart.SmartSystem;
	import com.smart.loaders.ResourcesManager;
	import com.smart.mvsc.services.ThemeService;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;




	public class BaseScreen extends Screen
	{
		private var _assets:ResourcesManager;
		protected var leftItems:Vector.<DisplayObject>;
		protected var rightItems:Vector.<DisplayObject>;
		protected const LEFT:String="LEFT";
		protected const RIGHT:String="RIGHT";
		private var _header:Header;
		public var headerHeight:int=64;
		protected var system:SmartSystem;
		private var _data:Object;

		public function BaseScreen()
		{
		}
		
		override protected function initialize():void{
			initUI();
			initData();
			start();
		}
		public function get header():Header{
			return _header;
		}
		
		override public function dispose():void{
			super.dispose();
			if (system != null)
				system.dispose();
		}
		public function initUI():void{
			
		}
		
		public function initData():void{
			
		}
		public function addPlugins(system:SmartSystem):void {
			
		}
		
		public function start():void{
			if (system != null)
				system.dispose();
			
			system = new SmartSystem(this);
			addPlugins(system);
			system.start();
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
		
		protected function newTextInput(label:String=null):TextInput
		{
			var textInput:TextInput=new TextInput();
			textInput.nameList.add(ThemeService.HEADER_MONEY_LABEL);
			textInput.text=label;
			return textInput;
		}

		protected function newLabel(label:String=null):Label
		{
			var _label:Label=new Label();
			_label.nameList.add(ThemeService.HEADER_MONEY_LABEL);
			_label.text=label;
			return _label;
		}

		protected function newButton(label:String=null,func:Function=null):Button
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
			this.dispatchEventWith(button.label, false, button.label);

		}

		public function addItem(display:DisplayObject, direct:String=LEFT):void
		{
			addHeader("");
			if (direct == LEFT)
				leftItems.push(display);
			else if (direct == RIGHT)
				rightItems.push(display);

		}

		public function set assets(val:ResourcesManager):void
		{
			_assets=val;
		}

		public function get assets():ResourcesManager
		{
			return _assets;
		}
	}
}
