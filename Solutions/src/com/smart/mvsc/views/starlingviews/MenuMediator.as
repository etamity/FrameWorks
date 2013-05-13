package com.smart.mvsc.views.starlingviews
{
	import com.smart.mvsc.model.Language;
	import com.smart.mvsc.model.ScreenConst;
	import com.smart.mvsc.views.starlingviews.screens.MenuScreen;
	
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class MenuMediator extends StarlingMediator
	{
		[Inject]
		public var view:MenuScreen;
		
		[Inject]
		public var _logger:ILogger;
		public function MenuMediator()
		{
			super();
		}
		override public function initialize():void 
		{
			super.initialize();
			init();
		}
		public function init():void{
			view.addMenuItem(Language.SOLUTION_1,ScreenConst.SOLUTION_ONE);
			view.addMenuItem(Language.SOLUTION_2,ScreenConst.SOLUTION_TWO);
			view.addMenuItem(Language.SOLUTION_3);
			view.addMenuItem(Language.SOLUTION_4);
		}
	}
}