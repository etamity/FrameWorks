package com.smart.engine.physics.core
{
	import starling.display.Graphics;
	import starling.display.DisplayObjectContainer;
	public class Canvas extends DisplayObjectContainer
	{
		private var _graphics :Graphics;
		
		public function Canvas()
		{
			_graphics = new Graphics(this);
		}
		
		public function get graphics():Graphics
		{
			return _graphics;
		}
	}
}


