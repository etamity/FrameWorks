package com.smart.tiled
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.extensions.QuadtreeSprite;

	/**
	 * @author shaun.mitchell
	 */
	public class TMXLayer extends QuadtreeSprite
	{
		private var _layerData:Array = new Array();
		private static const WORLD_BOUND:int = 10000;
		
		private var _worldBounds:Rectangle;
		public function TMXLayer(worldSpace:Rectangle=null)
		{
			_worldBounds = new Rectangle(-WORLD_BOUND, -WORLD_BOUND, WORLD_BOUND * 2, WORLD_BOUND * 2);
			super(_worldBounds);
			visibleViewport=new Rectangle(100,110,660,440);
			
			
		}
		
		public function get worldBounds():Rectangle{
			return _worldBounds;
		}
		public function setData(data:Array):void
		{
			_layerData = data;
		}
		public function getData():Array
		{
			return _layerData;
		}
		public function add(image:Image):void{
			this.addChild(image);
		}
	}
}
