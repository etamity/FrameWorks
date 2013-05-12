package com.smart.model
{
	import flash.utils.Dictionary;
	
	public class Player extends Actor
	{
	
		public var title:String="";
		public var money:Number=0.0;
		public var goods:Dictionary;
		public var skills:Dictionary;
		public var heath:int=100;
		
		public function Player()
		{
			super();
		}
	}
}