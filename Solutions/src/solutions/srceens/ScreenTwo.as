package solutions.srceens
{
	import com.smart.mvsc.model.Language;
	import com.smart.mvsc.model.ScreenConst;
	import com.smart.mvsc.views.BaseScreen;
	
	import feathers.controls.Button;
	
	public class ScreenTwo extends BaseScreen
	{
		public function ScreenTwo()
		{
			super();

		}
		override public function initUI():void{
			this.addHeader(Language.SOLUTION_2);
			var exitBtn:Button=newButton(Language.EXIT,exitToMainMenu);
			this.addItem(exitBtn,RIGHT);
		}
		
		public function exitToMainMenu():void{
			this.dispatchEventWith(ScreenConst.MENU_SCREEN);
		}
	}
}