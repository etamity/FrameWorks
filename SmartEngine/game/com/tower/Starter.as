/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.tower 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Starter extends Sprite 
	{
		private var _cost:int;
		private var _mc:MovieClip;
		private var _click:Function;
		private var _drag:Class;
		private var _onDown:Boolean;
		private var _canUse:Boolean;
		
		public function Starter(mc:MovieClip, cost:int, clickFun:Function, dragClass:Class)
		{
			_canUse = mc.numChildren == 1;
			_cost = cost;
			_click = clickFun;
			_drag = dragClass;
			_mc = mc;
			_mc.gotoAndStop(1);
			createTxt();
			_mc.mouseChildren = false;
			
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
			
			_mc.label.text=_cost.toString() + "$";
		}
		
		private function maxed():void
		{
			_mc.label.text = "MAX";
			_canUse = false;
			_mc.gotoAndStop(1);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_canUse)_click();
		}
		
		public function setMoney(cost:int):void
		{
			if (cost == 0) 
			{
				maxed();
				return;
			}
			_cost = cost;
			_mc.label.text = cost.toString() + "$";
		}
		
		public function changeState(cost:int):void
		{
			if (_mc.label.text == "MAX") return;
			_canUse = cost >= _cost;
			var num:int = !_canUse?1:2;
			_mc.gotoAndStop(num);
		}
	}

}