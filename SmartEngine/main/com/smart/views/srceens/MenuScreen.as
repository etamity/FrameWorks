package com.smart.views.srceens
{
	import com.smart.model.Language;
	import com.smart.model.SignalBus;
	import com.smart.views.signals.ScreenEventConst;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class MenuScreen extends BaseScreen
	{
		private var _header:Header;
		private var _backButton:Button;
		private var _buttonGroup:ButtonGroup;

		private var _buttonsData:ListCollection;
	
		
		public function MenuScreen()
		{
			super();
		}
		override protected function initialize():void{
			this._buttonGroup = new ButtonGroup();
			_buttonsData= new ListCollection(
				[
					{ label: Language.STARTGAME, event:ScreenEventConst.STARTGAME_EVENT , triggered: button_triggeredHandler },
					{ label: Language.CONTINUE, event:ScreenEventConst.PLAYANIMATION_EVENT, triggered: button_triggeredHandler },
					{ label: Language.LEADERBOARD,event:ScreenEventConst.STOPANIMATION_EVENT, triggered: button_triggeredHandler },
					{ label: Language.SHOP, event:ScreenEventConst.PLAYANIMATION_EVENT,triggered: button_triggeredHandler },
					{ label: Language.EXIT, event:ScreenEventConst.PLAYANIMATION_EVENT,triggered: button_triggeredHandler },
				]);
			this._buttonGroup.dataProvider = _buttonsData;
			this.addChild(this._buttonGroup);
			
			/*this._header = new Header();
			this._header.title = Language.GAMETITLE;
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
				[
					
				];
			*/
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			/*this._header.width = this.actualWidth;
			this._header.validate();*/
			
			this._buttonGroup.validate();
			this._buttonGroup.x = (this.actualWidth - this._buttonGroup.width) / 2;
			//this._buttonGroup.y = this._header.height + (this.actualHeight - this._header.height - this._buttonGroup.height) / 2;
			this._buttonGroup.y =  (this.actualHeight - this._buttonGroup.height) / 2;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
		
		private function button_triggeredHandler(event:Event):void
		{

			
			const button:Button = Button(event.currentTarget);
			this.dispatchEventWith(button.label);

		}
	}
}