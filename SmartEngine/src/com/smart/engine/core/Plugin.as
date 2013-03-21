//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {

	import flash.utils.*;
	
	import com.smart.engine.SmartEngine;

	public class Plugin implements IPlugin {
		
		protected var _name:String = "Plugin";
		protected var engine:SmartEngine;
		
		public function Plugin() {

		}
		
		
		
		public function get name():String {
			return _name;
		}

		public function set name(val:String):void {
			_name = val;
		}

		public function onRegister(engine:IPluginEngine):void {
			this.engine = engine.EngineClass(engine);

		}

		public function onRemove():void {
		}
		
		protected function getPlugin(pluginName:String):IPlugin{
			
			var plug:IPlugin = engine.getPluginByName(pluginName);
			//var plugin:Class= getClass(plug)(plug);
			
			return plug;
		}

		protected function getClass(obj:Object):Class{
			var classPath:String = getQualifiedClassName(obj);
			var ClassDef:Class = getDefinitionByName(classPath) as Class;
			return ClassDef;
		}
		public function onTrigger(time:Number):void {
		}

		public function toString():String {
			return _name;
		}
	}
}

