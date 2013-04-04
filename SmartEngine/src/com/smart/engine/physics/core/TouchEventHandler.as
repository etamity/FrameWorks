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

		private var _mouseUp:Function;
		private var _mouseDown:Function;
		private var _mouseMove:Function;
		private var _mouseHover:Function;
		private var _mouseClick:Function;

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
		public function stop():void{
			_target.removeEventListener(TouchEvent.TOUCH, doTouchEvent);
		}
		
		public function start():void{
			_target.addEventListener(TouchEvent.TOUCH, doTouchEvent);
		}
		
		public function set mouseUp(val:Function):void{
			_mouseUp=val;
		}
		public function set mouseDown(val:Function):void{
			_mouseDown=val;
		}
		public function set mouseMove(val:Function):void{
			_mouseMove=val;
		}
		public function set mouseHover(val:Function):void{
			_mouseHover=val;
		}
		public function set mouseClick(val:Function):void{
			_mouseClick=val;
		}
	   override public function dispose():void
		{
		   	clear();
			_target.removeEventListener(TouchEvent.TOUCH, doTouchEvent);
			_target=null;
		}

		public function clear():void
		{
			_target.removeEventListener(TouchEvent.TOUCH, doTouchEvent);
			_mouseUp=null;
			_mouseDown=null;
			_mouseMove=null;
			_mouseHover=null;
			_mouseClick=null;
			_target.addEventListener(TouchEvent.TOUCH, doTouchEvent);
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
						if (_mouseDown!=null)
							_mouseDown(currentPos);
						break;
					case TouchPhase.MOVED:
						if (_mouseMove!=null)
							_mouseMove(currentPos);
						break;
					case TouchPhase.ENDED:
						if (_mouseUp!=null)
							_mouseUp(currentPos);
						break;
					case TouchPhase.HOVER:
						if (_mouseHover!=null)
							_mouseHover(currentPos);
						break;
					case TouchPhase.STATIONARY:
						if (_mouseClick!=null)
							_mouseClick(currentPos);
						break;
				}
			}
		}

	}
}
