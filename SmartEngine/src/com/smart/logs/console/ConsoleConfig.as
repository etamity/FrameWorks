package com.smart.logs.console
{
	import flash.text.TextFormat;

	public class ConsoleConfig
	{
		public var animationTime:Number = 0.2;
		public var consoleSize:Number = 0.3;
		public var textColor:int = 0xdddddd;
		public var textBackgroundColor:int = 0x555555;
		public var highlightColor:int = 0x999999;
		public var errorColor:int = 0xFF0000;
		public var consoleBackground:int = 0x000000;
		public var consoleTransparency:Number = 0.7;
		public var logItemHeight:int = 24;

		public var defaultTextFormat:TextFormat;
		public var highLightTextFormat:TextFormat;
		public var errorTextFormat:TextFormat;
		
		public function ConsoleConfig() {
			defaultTextFormat = new TextFormat( "Arial", 20, textColor );
			highLightTextFormat = new TextFormat( "Arial", 20, highlightColor );
			errorTextFormat = new TextFormat( "Arial", 20, errorColor );
		}
	}
}