package com.tower 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
		private var _txt:TextField;
		private var _txtY:int;
		private var _canUse:Boolean;
		
		public function Starter(mc:MovieClip, money:int, clickFun:Function, dragFun:Class, txtY:int)
		{
			_canUse = mc.numChildren == 1;
			_money = money;
			_txtY = txtY;
			_click = clickFun;
			_drag = dragFun;
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
			_txt = new TextField();
			var tf:TextFormat = new TextFormat(null, 30);
			_txt.defaultTextFormat = tf;
			_txt.text = _money.toString() + "$";
			_mc.addChild(_txt);
			_txt.x = 115;
			_txt.y = _txtY;
		}
		
		private function maxed():void
		{
			_txt.text = "MAX";
			_canUse = false;
			_mc.gotoAndStop(1);
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
			_txt.text = money.toString() + "$";
		}
		
		public function changeState(money:int):void
		{
			if (_txt.text == "MAX") return;
			_canUse = money >= _money;
			var num:int = !_canUse?1:2;
			_mc.gotoAndStop(num);
		}
	}

}