package com.core.mvsc.model
{
	import flash.display.Shape;

	public class Utils
	{
		public function Utils()
		{
		}
		public static function generateMask(id:String, w:int=360, h:int=345):Shape {
			var rectMask:Shape = new Shape();
			rectMask.name = "mask" + id;
			rectMask.graphics.beginFill(0xFF0000, 1);
			rectMask.graphics.drawRect(0, 0, w, h);
			rectMask.graphics.endFill();
			return rectMask;
		}
	}
}