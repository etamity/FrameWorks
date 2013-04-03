package com.smart.engine.physics.core
{
	import com.smart.core.SmartObject;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchEventHandler extends SmartObject
	{
		private var _target:DisplayObject;

		public var mouseUp:Function;
		public var mouseDown:Function;
		public var mouseMove:Function;
		public var mouseHover:Function;
		public var mouseClick:Function;

		private var _eventsHash:Dictionary;

		private var _mouseX:Number=0;
		private var _mouseY:Number=0;

		public function TouchEventHandler(target:DisplayObject)
		{
			super();
			_target=target;

			_target.addEventListener(TouchEvent.TOUCH, doTouchEvent);
			_eventsHash=new Dictionary();


		}

	   override public function dispose():void
		{
			_target.removeEventListener(TouchEvent.TOUCH, doTouchEvent);
			_target=null;
			clear();
		}

		public function clear():void
		{
			mouseUp=null;
			mouseDown=null;
			mouseMove=null;
			mouseHover=null;
			mouseClick=null;
		}

		public function get mouseX():Number
		{
			return _mouseX;
		}

		public function get mouseY():Number
		{
			return _mouseY;
		}

		private function doTouchEvent(evt:TouchEvent):void
		{
			var touch:Touch=evt.getTouch(_target);

			if (touch)
			{
				var currentPos:Point=touch.getLocation(_target);
				_mouseX=currentPos.x;
				_mouseY=currentPos.y;

				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						if (mouseDown!=null)
							mouseDown(currentPos);
						break;
					case TouchPhase.MOVED:
						if (mouseMove!=null)
							mouseMove(currentPos);
						break;
					case TouchPhase.ENDED:
						if (mouseUp!=null)
							mouseUp(currentPos);
						break;
					case TouchPhase.HOVER:
						if (mouseHover!=null)
							mouseHover(currentPos);
						break;
					case TouchPhase.STATIONARY:
						if (mouseClick!=null)
							mouseClick(currentPos);
						break;
				}
			}
		}

	}
}
