package com.smart.core
{
	import com.data.Language;
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	
	import starling.display.DisplayObject;
	
	public class SmartScene extends Screen
	{
		private var _header:Header;
		public var headerHeight:int=64;
		protected var leftItems:Vector.<DisplayObject>;
		protected var rightItems:Vector.<DisplayObject>;
		protected const LEFT:String="LEFT";
		protected const RIGHT:String="RIGHT";
		private var _buttonsData:ListCollection;
		public function SmartScene()
		{
			super();
	
		}
		public function addItem(display:DisplayObject, direct:String=LEFT):void
		{
			addHeader("");
			if (direct == LEFT)
				leftItems.push(display);
			else if (direct == RIGHT)
				rightItems.push(display);
			
		}
		override protected function initialize():void{
			addHeader("test");
			var _buttonGroup:ButtonGroup = new ButtonGroup();
			_buttonsData= new ListCollection(
				[
					{ label: Language.STARTGAME },
					{ label: Language.CONTINUE},
					{ label: Language.LEADERBOARD},
					{ label: Language.SHOP },
					{ label: Language.EXIT},
				]);
			_buttonGroup.dataProvider = _buttonsData;
			addChild(_buttonGroup);

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