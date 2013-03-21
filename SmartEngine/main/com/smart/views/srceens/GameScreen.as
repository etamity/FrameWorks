package com.smart.views.srceens
{
	import com.smart.logs.Debug;
	import com.smart.model.Language;
	import com.smart.services.ThemeService;
	import com.smart.views.BaseScene;
	import com.smart.views.components.PlayerBarView;
	
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.Color;

	public class GameScreen extends BaseScreen
	{	
	
		public var _assets:AssetManager;
		public var _header:Header;
		public var _money:Label;
		public var _health:ProgressBar;
		public var leftItems:Vector.<DisplayObject>;
		public var rightItems:Vector.<DisplayObject>;
		public var _exitBtn:Button;
		
		public const LEFT:String="LEFT";
		public const RIGHT:String="RIGHT";
		public function GameScreen()
		{
			super();
		
		}
		
		public function initAssets(assets:AssetManager):void{
			_assets= assets;
			_header =new Header();
			_header.nameList.add(ThemeService.HEADER_PLAYERBAR);
			_header.height=64;
			_money = new Label();
			_money.nameList.add(ThemeService.HEADER_MONEY_LABEL);
			_health= new ProgressBar();
			_money.text= "1000.00";

			_exitBtn=new Button();
			
			leftItems=new Vector.<DisplayObject>();
			rightItems=new Vector.<DisplayObject>();
			_header.leftItems=leftItems;
			_header.rightItems=rightItems;
			addChild(_header);
			this._header.width = this.stage.width;
			
			var image:Image=new Image(assets.getTexture("IconMoney"));
			addItem(image);
			addItem(_money);
			image =new Image(assets.getTexture("icon-snow-small"));
			_health.value=100;
			addItem(image);
			addItem(_health);
			
			
			//_exitBtn.height=_header.height-20;
			_exitBtn.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			//_exitBtn.paddingRight=30;
			_exitBtn.label= Language.EXIT;
	
			
			
			addItem(_exitBtn,RIGHT);
			
			/*var mQuadBatch:QuadBatch = new QuadBatch();
			mQuadBatch.y=200;
			addChild(mQuadBatch);
			var image1:Image = new Image(assets.getTexture("icon-snow-small"));
			
			var image2:Image=new Image(assets.getTexture("IconMoney"));
			image1.x+=100;
			mQuadBatch.addImage(image1);
			mQuadBatch.addImage(image2);*/
				
		}
		
		
		override protected function initialize():void{
	
			
			
			
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			const button:Button = Button(event.currentTarget);
			Debug.log(button,button.label, event.data, " triggered.");
			this.dispatchEventWith(button.label);
			
		}
		public function addItem(display:DisplayObject,direct:String=LEFT):void {
			if (direct==LEFT)
			leftItems.push(display);
			else if (direct==RIGHT)
			rightItems.push(display);
		}
	}
}