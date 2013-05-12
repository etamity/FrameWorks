//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.signalCommandMap.impl
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.osflash.signals.ISignal;
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class SignalCommandMap implements ISignalCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _triggerMap:CommandTriggerMap;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		private var signalMap:Dictionary = new Dictionary();
		private var signalClassMap:Dictionary = new Dictionary();
		private var verifiedCommandClasses:Dictionary = new Dictionary();
		/**
		 * @private
		 */
		public function SignalCommandMap(context:IContext)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			_triggerMap = new CommandTriggerMap(getKey, createTrigger);
			
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function map(signalClass:Class):ICommandMapper
		{
			return getTrigger(signalClass).createMapper();
		}

		public function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean
		{
			var callbacksByCommandClass:Dictionary = signalMap[signal];
			if ( callbacksByCommandClass == null ) return false;
			var callback:Function = callbacksByCommandClass[commandClass];
			return callback != null;
		}
		
		public function unmapSignal(signal:ISignal, commandClass:Class):void
		{
			var callbacksByCommandClass:Dictionary = signalMap[signal];
			if ( callbacksByCommandClass == null ) return;
			var callback:Function = callbacksByCommandClass[commandClass];
			if ( callback == null ) return;
			signal.remove( callback );
			delete callbacksByCommandClass[commandClass];
		}
		public function mapSignal(signal:ISignal, commandClass:Class, oneShot:Boolean = false):void
		{
			verifyCommandClass( commandClass );
			if ( hasSignalCommand( signal, commandClass ) )
				return;
			const callback:Function = function():void
			{
				routeSignalToCommand( signal, arguments, commandClass, oneShot );
			};
			const callbacksByCommandClass:Dictionary = signalMap[signal] ||= new Dictionary( false );
			callbacksByCommandClass[commandClass] = callback;
			signal.add( callback );
		}
		protected function createCommandInstance(commandClass:Class):Object 
		{
			return _injector.getOrCreateNewInstance(commandClass);
		}
		private function verifyCommandClass(commandClass:Class):void
		{
			if (verifiedCommandClasses[commandClass]) return;
			if (describeType(commandClass).factory.method.(@name == "execute").length() != 1)
			{
				throw new Error("ERROR : Command Class didn't implement execute() function " + ' - ' + commandClass);
			}
			verifiedCommandClasses[commandClass] = true;
		}
		
		protected function routeSignalToCommand(signal:ISignal, valueObjects:Array, commandClass:Class, oneShot:Boolean):void
		{
			mapSignalValues( signal.valueClasses, valueObjects );
			var command:* = createCommandInstance( commandClass );
			unmapSignalValues( signal.valueClasses, valueObjects );
			command.execute();
			if ( oneShot )
				unmapSignal( signal, commandClass );
		}
		protected function mapSignalValues(valueClasses:Array, valueObjects:Array):void 
		{
			for (var i:uint = 0; i < valueClasses.length; i++) 
			{
				_injector.map(valueClasses[i]).toValue(valueObjects[i]);
			}
		}
		
		protected function unmapSignalValues(valueClasses:Array, valueObjects:Array):void 
		{
			for (var i:uint = 0; i < valueClasses.length; i++) 
			{
				_injector.unmap(valueClasses[i]);
			
			}
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(signalClass:Class):ICommandUnmapper
		{
			return getTrigger(signalClass).createMapper();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createTrigger(signalClass:Class):ICommandTrigger
		{
			return new SignalCommandTrigger(_injector, signalClass);
		}

		private function getTrigger(signalClass:Class):SignalCommandTrigger
		{
			return _triggerMap.getTrigger(signalClass) as SignalCommandTrigger;
		}

		private function getKey(signalClass:Class):Object
		{
			return signalClass;
		}
	}
}
