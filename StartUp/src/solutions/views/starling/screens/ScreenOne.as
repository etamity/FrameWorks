package solutions.views.starling.screens
{
	import com.smart.mvsc.model.Language;
	import com.smart.mvsc.model.ScreenConst;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import com.smart.mvsc.views.starlingviews.screens.BaseScreen;
	
	public class ScreenOne extends BaseScreen
	{
		public function ScreenOne()
		{
			super();

		}
		override public function initUI():void{
			this.addHeader(Language.SOLUTION_1);
			var exitBtn:Button=newButton(Language.EXIT,exitToMainMenu);
			this.addItem(exitBtn,RIGHT);
			var textInput:TextInput=newTextInput("Test");
			textInput.x= 5;
			textInput.y= this.headerHeight+5;
			addChild(textInput);
		}

		public function exitToMainMenu():void{
			
			this.dispatchEventWith(ScreenConst.MENU_SCREEN);
		}
		
	}
}