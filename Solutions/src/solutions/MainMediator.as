package solutions
{
	import solutions.srceens.SolutionsOne;
	import solutions.srceens.SolutionsTwo;
	import com.smart.loaders.ResourcesManager;
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.mvsc.model.ScreenConst;
	import com.smart.mvsc.model.SignalBus;
	import com.smart.mvsc.views.MainScreen;
	import com.smart.mvsc.views.MenuScreen;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class MainMediator extends StarlingMediator
	{
		[Inject]
		public var view:MainScreen;
		[Inject]
		public var assets:ResourcesManager;
		[Inject]
		public var signalBus:SignalBus;
		[Inject]
		public var commandManager:ConsoleCommand;


		public function MainMediator()
		{
			super();
		}

		override public function initialize():void 
		{
			super.initialize();
			init();
		}
		override public function destroy():void
		{
			super.destroy();
		}
		
		public function init():void{
			view.addScreen(ScreenConst.MENU_SCREEN,MenuScreen);
			view.addScreen(ScreenConst.SOLUTION_ONE,SolutionsOne);
			view.addScreen(ScreenConst.SOLUTION_TWO,SolutionsTwo);
			view.showScreen(ScreenConst.MENU_SCREEN);	
		}

		
	}
}