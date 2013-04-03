package com.smart.views.srceens
{
	import com.smart.model.Language;
	import com.smart.views.signals.ScreenEventConst;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class MenuScreen extends BaseScreen
	{

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

		}
		
		override protected function draw():void
		{

			this._buttonGroup.validate();
			this._buttonGroup.x = (this.actualWidth - this._buttonGroup.width) / 2;
			this._buttonGroup.y =  (this.actualHeight - this._buttonGroup.height) / 2;
		}
		
		private function button_triggeredHandler(event:Event):void
		{
			
			const button:Button = Button(event.currentTarget);
			this.dispatchEventWith(button.label);

		}
	}
}