package com.smart.tiled
{
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;

	/**
	 * @author shaun.mitchell
	 */
	public class TMXLayer extends QuadBatch
	{
		private var _layerData:Array = new Array();
		
		public function TMXLayer(data:Array):void
		{
			_layerData = data;
		}
		
		public function getData():Array
		{
			return _layerData;
		}
		public function add(image:Image):void{
			this.addImage(image);
		}
	}
}
