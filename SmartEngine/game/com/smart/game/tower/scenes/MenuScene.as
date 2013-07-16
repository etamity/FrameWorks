/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.smart.game.tower.scenes
{
	import com.data.BmpData;
	import com.data.Language;
	import com.event.LoadEvent;
	import com.event.ScreenEventConst;
	import com.smart.core.SmartGame;
	import com.smart.core.SmartScene;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	
	import starling.events.Event;
	
	public class MenuScene extends SmartScene
	{
		private var _buttonGroup:ButtonGroup;
		private var _buttonsData:ListCollection;
		
		public function MenuScene(game:SmartGame)
		{
			super(game);
		}
		private function loadData():void
		{
			if (BmpData.bmpDatas) 
			{
				loaded(null);
				return;
			}
			//_progressBar.visible = true;
			//_progressMask.scaleX = 0;
			var bmpData:BmpData = new BmpData();
			//bmpData.addEventListener(LoadEvent.LOADING, loading);
			bmpData.addEventListener(LoadEvent.LOADED, loaded);
		}
		private function loaded(e:LoadEvent):void
		{
			game.showScene("GameScene");
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
			this._buttonGroup.x = (this.stage.stageWidth - this._buttonGroup.width) / 2;
			this._buttonGroup.y =  (this.stage.stageHeight - this._buttonGroup.height) / 2;
		}
		
		private function button_triggeredHandler(event:Event):void
		{
			
			const button:Button = Button(event.currentTarget);
			trace("button_triggeredHandler,",button.label);

			switch (button.label){
				case Language.STARTGAME:
					loadData();
					break;
			}
			
		}
	}

}