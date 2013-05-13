package solutions.srceens
{
	import com.smart.mvsc.model.Language;
	import com.smart.mvsc.model.ScreenConst;
	import com.smart.mvsc.views.BaseScreen;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	
	public class SolutionsOne extends BaseScreen
	{
		public function SolutionsOne()
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