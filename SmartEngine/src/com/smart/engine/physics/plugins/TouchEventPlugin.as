package com.smart.engine.physics.plugins
{
	import com.smart.core.Plugin;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class TouchEventPlugin extends Plugin
	{
		private var _target:DisplayObject;
		
		private var upFunctions:Vector.<Function>;
		private var downFunctions:Vector.<Function>;
		private var moveFunctions:Vector.<Function>;
		private var hoverFunctions:Vector.<Function>;
		private var clickFunctions:Vector.<Function>;
		
		private var _mouseX:Number=0;
		private var _mouseY:Number=0;
		
		public function TouchEventPlugin(target:DisplayObject)
		{
			super();
			_target= target;
			
			upFunctions=new Vector.<Function>();
			downFunctions =new Vector.<Function>();
			moveFunctions =new Vector.<Function>();
			hoverFunctions =new Vector.<Function>();
			clickFunctions =new Vector.<Function>();
			
			_target.addEventListener(TouchEvent.TOUCH,doTouchEvent);
			
			
			
		}
		
		override public function dispose():void{
			_target.removeEventListener(TouchEvent.TOUCH,doTouchEvent);
			clear();
		}
		public function clear():void{
			upFunctions=new Vector.<Function>();
			downFunctions =new Vector.<Function>();
			moveFunctions =new Vector.<Function>();
			hoverFunctions =new Vector.<Function>();
			clickFunctions =new Vector.<Function>();
		}
		
		public function get mouseX():Number{
			return _mouseX;
		}
		public function get mouseY():Number{
			return _mouseY;
		}
		private function doTouchEvent(evt:TouchEvent):void{
			var touch:Touch = evt.getTouch(_target);
			var func:Function;
	
			if (touch)
			{
				var currentPos:Point = touch.getLocation(_target);
				_mouseX=currentPos.x;
				_mouseY=currentPos.y;
				switch (touch.phase){
					case TouchPhase.BEGAN:
						for each(func in downFunctions)
							func(currentPos);
						break;
					case TouchPhase.MOVED:
						for each(func in moveFunctions)
							func(currentPos);
						break;
					case TouchPhase.ENDED:
						for each(func in upFunctions)
							func(currentPos);
						break;
					case TouchPhase.HOVER:
						for each(func in hoverFunctions)
							func(currentPos);
						break;
					case TouchPhase.STATIONARY:
						for each(func in clickFunctions)
							func(currentPos);
						break;
				}
			}
		}
		public function addTouchUp(func:Function):void{
			upFunctions.push(func);
		}
		public function addTouchDown(func:Function):void{
			downFunctions.push(func);
		}
		public function addTouchMove(func:Function):void{
			moveFunctions.push(func);
		}
		public function addTouchHover(func:Function):void{
			hoverFunctions.push(func);
		}
		public function addTouchClick(func:Function):void{
			clickFunctions.push(func);
		}
		
		public function removeTouchUp(func:Function):void{
			var index:int=upFunctions.indexOf(func);
			if (index != -1)
			{
				upFunctions.splice(index, 1);
			}
	
		}
		public function removeTouchDown(func:Function):void{
			var index:int=downFunctions.indexOf(func);
			if (index != -1)
			{
				downFunctions.splice(index, 1);
			}
		
		}
		public function removeTouchMove(func:Function):void{
			var index:int=moveFunctions.indexOf(func);
			if (index != -1)
			{
				moveFunctions.splice(index, 1);
			}
	
		}
		public function removeTouchHover(func:Function):void{
			var index:int=hoverFunctions.indexOf(func);
			if (index != -1)
			{
				hoverFunctions.splice(index, 1);
			}
		}
		public function removeTouchClick(func:Function):void{
			var index:int=clickFunctions.indexOf(func);
			if (index != -1)
			{
				clickFunctions.splice(index, 1);
			}
	
		}
		
	}
}