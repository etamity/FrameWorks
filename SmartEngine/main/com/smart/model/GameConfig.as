package com.smart.model
{
	public class GameConfig
	{
		public var _name:String="zhongyu";
		public function GameConfig()
		{ 
		}
		public function set name(val:String):void{
			_name=val;
		}
		public function get name():String{
			return _name;
		}
	}
}