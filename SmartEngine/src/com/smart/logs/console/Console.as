package com.smart.logs.console
{
	import com.smart.logs.Debug;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.ResizeEvent;
	import starling.text.BitmapFont;

	
	public class Console extends Screen
	{
		private static var _console:Console;
		private static var _archiveOfUndisplayedLogs:Array = [];
		
		private var _consoleConfig:ConsoleConfig;
		private var _defaultFont:BitmapFont;
		private var _consoleContainer:Sprite;
		private var _consoleHeight:Number;
		private var _isShown:Boolean;
		private var _quad:Quad;
		private var _list:List;
		
		private var _input:TextInput;
		private const VERTICAL_PADDING:Number = 5;
		private const HORIZONTAL_PADDING:Number = 5;
		
		private var commandManager:ConsoleCommand;
		
		private var logList:ListCollection;
		
		public function Console(consoleConfig:ConsoleConfig = null)
		{
			_consoleConfig = consoleConfig ? consoleConfig : new ConsoleConfig();
			
			_console = _console ? _console : this;
			
			commandManager = ConsoleCommand.getInstance();
			
			commandManager.registerObject("console",this);
			
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer();
			};
			
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		private function keyDownHandler(evt:KeyboardEvent):void {
			var code:uint = evt.keyCode;
			switch(code) {
				case Keyboard.TAB:
					_console.isShown = !_console.isShown;
					break;
				case Keyboard.UP:
					_console.previousCmd();
					break;
				case Keyboard.DOWN:
					_console.nextCmd();
					
					break;
			}
		}
		
		
		public function get isShown():Boolean
		{
			return _isShown;
		}
		
		public function set isShown(value:Boolean):void
		{
			if (_isShown == value)
			{
				return;
			}
			
			_isShown = value;
			
			if (_isShown)
			{
				show();
			}
			else
			{
				hide();
			}
		}
		
		protected function initializeHandler(e:Event):void
		{
			
			_consoleHeight = this.stage.stageHeight * _consoleConfig.consoleSize;
		
			
			_consoleContainer = new FeathersControl();
			_consoleContainer.alpha = 0;
			_consoleContainer.y = -_consoleHeight;
			
			this.addChild(_consoleContainer);
			
			_list = new List();
			_list.x = HORIZONTAL_PADDING;
			_list.y = VERTICAL_PADDING;
			logList = new ListCollection();
			_list.dataProvider = logList;
			_list.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			_list.itemRendererFactory = function():IListItemRenderer
			{
				var consoleItemRenderer:ConsoleItemRenderer = new ConsoleItemRenderer(_consoleConfig);
				consoleItemRenderer.width = _list.width;
				return consoleItemRenderer;
			};
			
			_input = new TextInput();
			_input.addEventListener(FeathersEventType.ENTER, doEnterKeyEvent);
			
			_quad = new Quad(this.stage.stageWidth, _consoleHeight + _input.height, _consoleConfig.consoleBackground);
			_quad.alpha = _consoleConfig.consoleTransparency;
			
			_consoleContainer.addChild(_quad);
			_consoleContainer.addChild(_list);
			this._consoleContainer.addChild(_input);
			
			this.setScreenSize(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			
			stage.addEventListener(ResizeEvent.RESIZE, function(e:ResizeEvent):void
				{
					setScreenSize(stage.stageWidth, stage.stageHeight);
				});
			
			for each (var undisplayedMessage:*in _archiveOfUndisplayedLogs)
			{
				log(undisplayedMessage);
			}
			
			_archiveOfUndisplayedLogs = [];
			
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
			
			hide();
		}
		
		public function get text():String{
			return _input.text;
		}
		public function set text(val:String):void{
			 _input.text=val;
			 _input.selectRange(_input.text.length,_input.text.length);
		}
		
		public function previousCmd():void{
			text=commandManager.getPreviousHistoryCmd();
		}
		public function nextCmd():void{
			text=commandManager.getNextHistoryCmd();
		}
		public function currentCmd():void{
			text=commandManager.getCurrentCmd();
		}
		private function doEnterKeyEvent(evt:Event):void
		{
			Debug.log(["->" +_input.text]);
			var result:String = commandManager.execute(_input.text);
			if (result != "NaN")
				Debug.log(result);
			
			_input.text = "";
		}
		
		private function setScreenSize(width:Number, height:Number):void
		{
			_consoleContainer.width = width;
			_consoleContainer.height = height;
			
			_consoleHeight = height * _consoleConfig.consoleSize;
			_quad.width = width;
			_quad.height = _consoleHeight;
			
			_list.width = this.stage.stageWidth - HORIZONTAL_PADDING * 2;
			_list.height = _consoleHeight - (VERTICAL_PADDING * 2);
			_input.width = this.stage.stageWidth;
			_input.y = _consoleHeight;
			
			this.alpha = _consoleConfig.consoleTransparency;
		
		}
		
		private function show():void
		{
			visible = true;
			_input.setFocus();
			var __tween1:Tween = new Tween(_consoleContainer, _consoleConfig.animationTime);
			__tween1.animate("y", 0);
			__tween1.fadeTo(1);
			Starling.juggler.add(__tween1);
			_isShown = true;
		}
		
		private function hide():void
		{
			var __tween1:Tween = new Tween(_consoleContainer, _consoleConfig.animationTime);
			__tween1.animate("y", -_consoleHeight);
			__tween1.fadeTo(0);
			Starling.current.nativeStage.focus = null;
			__tween1.onComplete = function():void
			{
				visible = false;
			
			};
			Starling.juggler.add(__tween1);
			
			_isShown = false;
		}
		
		public function getLogData():String
		{
			var text:String = "";
			
			for each (var object:Object in _list.dataProvider.data)
			{
				text += object.data + "\n";
			}
			
			return text;
		}
		
		private function copy(button:Button):void
		{
			var text:String = this.getLogData();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
		}
		
		public function addMessage(message:String):void
		{
			
			var text:String = message;
			
			logList.addItem({label: text, data: message});
			
			_list.verticalScrollPosition = Math.max(_list.dataProvider.length * 24 - _list.height, 0);
		
		}
		
		public static function getMainConsoleInstance():Console
		{
			return _console;
		}
		
		public static function log(... arguments):void
		{
			var message:String = "";
			var firstTime:Boolean = true;
			for each (var argument:*in arguments)
			{
				var description:String;
				
				if (argument == null)
				{
					description = "[null]"
				}
				else if (!("toString" in argument))
				{
					description = "[object " + getQualifiedClassName(argument) + "]";
				}
				else
				{
					description = argument;
				}
				
				if (firstTime)
				{
					message = description;
					firstTime = false;
				}
				else
				{
					message += ":: " + description;
				}
			}
			
			if (Console.getMainConsoleInstance() == null)
			{
				_archiveOfUndisplayedLogs.push(message);
			}
			else
			{
				Console.getMainConsoleInstance().addMessage(message);
			}
		}
	}
}