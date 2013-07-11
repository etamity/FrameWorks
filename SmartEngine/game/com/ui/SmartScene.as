package com.ui
{
	import com.smart.core.SmartSystem;
	
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import starling.display.DisplayObject;
	
	public class SmartScene extends Screen
	{
		private var _header:Header;
		public var headerHeight:int=64;
		protected var leftItems:Vector.<DisplayObject>;
		protected var rightItems:Vector.<DisplayObject>;
		public function SmartScene()
		{
			super();
	
		}
		override protected function initialize():void{
			addHeader("test");
		}
		protected function addHeader(title:String):Header
		{
			if (_header == null)
			{
				_header=new Header();
				//_header.nameList.add(ThemeService.HEADER_PLAYERBAR);
				_header.height=headerHeight;
				_header.title=title;
				leftItems=new Vector.<DisplayObject>();
				rightItems=new Vector.<DisplayObject>();
				_header.leftItems=leftItems;
				_header.rightItems=rightItems;
				_header.width=960;
				addChild(_header);
			}
			
			return _header;
		}
		public function addPlugins(system:SmartSystem):void {
	
		}
	}
}