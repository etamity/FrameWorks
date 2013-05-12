package com.smart.views
{
	import com.smart.logs.console.Console;
	
	import starling.display.Sprite;

	public class MainView extends Sprite
	{

		public function MainView()
		{
			super();
			
			addChild(new Console());
		}
	}
}