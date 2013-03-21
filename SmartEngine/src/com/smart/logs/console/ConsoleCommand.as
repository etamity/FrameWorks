package com.smart.logs.console
{


	import flash.net.SharedObject;

	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Joey Etamity
	 */
	public class ConsoleCommand
	{
		private var _shared:SharedObject;
		private var _commandDelegates:Dictionary;
		private var _commandHistory:Array;
		private var _currHistoryIndex:int;
		private static var instance:ConsoleCommand;
		private var _numCommandsInHistory:uint;
		private var _historyMax:Number;
		private var _objectDelegates:Dictionary;
		
		public function ConsoleCommand(enforcer:SingletonEnforcer=null)
		{
			_shared = SharedObject.getLocal("CommandHistory");
			
			if (_shared.data.history)
			{
				_commandHistory = _shared.data.history as Array;
				_numCommandsInHistory = _commandHistory.length;
				_currHistoryIndex=_numCommandsInHistory;
			}
			else
			{
				_commandHistory = new Array();
				_shared.data.history = _commandHistory;
			}
			_commandDelegates = new Dictionary();
			_objectDelegates = new Dictionary();
			iniCmds();
		}
		
		private function iniCmds():void {
			registerCmd("echo", echo);
		}

		public static function getInstance():ConsoleCommand {
			if (ConsoleCommand.instance == null) {
				ConsoleCommand.instance = new ConsoleCommand(new SingletonEnforcer());
			}
			return ConsoleCommand.instance;
		}
		public function registerCmd(name:String, func:Function):void
		{
			_commandDelegates[name] = func;
		}
		public function registerObject(name:String, obj:*):void
		{
			_objectDelegates[name] = obj;
		}
		public function addToHistory(command:String):void
		{
			var commandIndex:int = _commandHistory.indexOf(command);
			if (commandIndex != -1)
			{
				_commandHistory.splice(commandIndex, 1);
				_numCommandsInHistory--;
			}
			
			_commandHistory.push(command);
			_numCommandsInHistory++;
			
			if (_commandHistory.length > _historyMax)
			{
				_commandHistory.shift();
				_numCommandsInHistory--;
			}
			_shared.flush();
		}
		
		public function getPreviousHistoryCmd():String
		{
			if (_currHistoryIndex > 0)
				_currHistoryIndex--;
			
			return getCurrentCmd();
		}
		
		public function getNextHistoryCmd():String
		{
			if (_currHistoryIndex < _numCommandsInHistory)
				_currHistoryIndex++;
			
			return getCurrentCmd();
		}
				
		
		private function echo(cmd:String):String {
			var args:Array = cmd.split(".");
			var name:String = args.shift();  
			var obj:*= _objectDelegates[name];
			var result:String;
			if (obj != null)
			{
				if (args.length > 0)
				{
					
					for (var i:int = 0 ; i < args.length; i++ )
					{
						obj = obj[args[i]];
						if (obj == null)
						break;
					}
					
				
				}
				result = obj.toString();
			}
			return result;
		}
		
		public function execute(cmd:String):String
		{
			addToHistory(cmd);
			
			var args:Array = cmd.split(" ");
			var command:String = args.shift();
			var result:String;
			var func:Function = _commandDelegates[command];
			if (func != null)
			{
				try
				{
					var str:String= String(func.apply(this, args));
					result="["+ cmd +"] return: " +str;
				}
				catch (e:ArgumentError)
				{
					if (e.errorID == 1063) //Argument count mismatch on [some function]. Expected [x], got [y]
					{
					
						result = e.message;
						var expected:Number = Number(e.message.slice(e.message.indexOf("Expected ") + 9, e.message.lastIndexOf(",")));
						var lessArgs:Array = args.slice(0, expected);
						func.apply(this, lessArgs);
					}
				}
			} else
			{
				result = "NaN";
			}
			
			return result;
			
		}
		
		public function getCurrentCmd():String
		{
			var command:String = _commandHistory[_currHistoryIndex];
			
			if (!command)
			{
				return "";
			}
			return command;
		}
	
	}

}
class SingletonEnforcer {
}
