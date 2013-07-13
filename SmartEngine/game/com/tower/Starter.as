package com.tower 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Starter extends Sprite 
	{
		private var _money:int;
		private var _mc:MovieClip;
		private var _click:Function;
		private var _drag:Class;
		private var _onDown:Boolean;
		private var _canUse:Boolean;
		
		public function Starter(mc:MovieClip, money:int, clickFun:Function, dragFun:Class)
		{
			_canUse = mc.numChildren == 1;
			_money = money;
			_click = clickFun;
			_drag = dragFun;
			_mc = mc;
			//_mc.gotoAndStop(1);
			createTxt();
			//_mc.mouseChildren = false;
			
			if (_click != null)_mc.addEventListener(MouseEvent.CLICK, onClick);
			if (_drag != null)
			{
				_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				_mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
				_mc.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
		}
		
		public function removeLister():void
		{
			if (_click != null)_mc.removeEventListener(MouseEvent.CLICK, onClick);
			if (_drag != null)
			{
				_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				_mc.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
		}
		
		private function onOut(e:MouseEvent):void 
		{
			if (_onDown && _canUse) new _drag();
			_onDown = false;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			_onDown = false;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			_onDown = true;
		}
		
		private function createTxt():void
		{
			
			_mc.label=_money.toString() + "$";
		}
		
		private function maxed():void
		{
			_mc.label = "MAX";
			_canUse = false;
			//_mc.gotoAndStop(1);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_canUse)_click();
		}
		
		public function setMoney(money:int):void
		{
			if (money == 0) 
			{
				maxed();
				return;
			}
			_money = money;
			_mc.label = money.toString() + "$";
		}
		
		public function changeState(money:int):void
		{
			if (_mc.label == "MAX") return;
			_canUse = money >= _money;
			var num:int = !_canUse?1:2;
			//_mc.gotoAndStop(num);
		}
	}

}