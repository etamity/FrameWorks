package com.smart.core
{
	import com.smart.logs.Debug;

	
	import flash.display.Stage;
	
	import feathers.system.DeviceCapabilities;

	public class Device
	{
		private var _stage:Stage;
		
		public static const IPHONE:String="IPHONE";
		public static const TABLET:String="TABLET";
		public static const LAPTOP_PC:String="LAPTOP_PC";

		
		public function Device(stage:Stage)
		{
			if (stage!=null)
			{
				_stage=stage;
				autoDevice(stage);
			}else{
				Debug.log(this,"[Error]: Stage is Null!");
			}
		}

		public function setDevice(device:String):void{
			switch (device){
				case IPHONE:
					DeviceCapabilities.dpi =326;
					break;
				case TABLET:
					DeviceCapabilities.dpi =131.96;
					break;
				case LAPTOP_PC:
					DeviceCapabilities.dpi = 100;
					break;
			}
			DeviceCapabilities.screenPixelWidth = _stage.stageWidth;
			DeviceCapabilities.screenPixelHeight =  _stage.stageHeight;
		}
		
		public function autoDevice(stage:Stage):void{
			
			if (DeviceCapabilities.isPhone(stage))
			{
				setDevice(IPHONE);
			}
			else
			if (DeviceCapabilities.isTablet(stage)){
				
				setDevice(TABLET);
			}
			else
				setDevice(LAPTOP_PC);

		}
	}
}
