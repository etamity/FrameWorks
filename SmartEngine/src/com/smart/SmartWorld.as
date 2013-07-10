package com.smart
{
	import com.smart.core.Device;
	import com.smart.logs.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	public class SmartWorld extends Sprite
	{
		private var _device:Device;
		private var _starling:Starling;
		private var _gameContent:Class;
		public function SmartWorld(root:Class)
		{
			_gameContent=root;
		}
		public function start():void{
			graphics.clear();
			if(stage)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.SHOW_ALL;
			}
			_device= new Device(stage);
			_device.setDevice(Device.IPHONE);
			//pretends to be an iPhone Retina screen
			
			Debug.CONSOLE_OUTPUT = true;
			Debug.log("Smart Engine Version:"+ "1.02");
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			_starling = new Starling(_gameContent, stage);
			_starling.antiAliasing = 1;
			_starling.showStatsAt("right","top",2);
			_starling.start();
			
			
		}
	}
}