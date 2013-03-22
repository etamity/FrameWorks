//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {

	import com.smart.engine.SmartEngine;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Plugin implements IPlugin {
		
		protected var _name:String = "Plugin";
		protected var engine:SmartEngine;
		protected var _enabled:Boolean=true;
		public function Plugin() {
			name= className;
		}
		
		
		
		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(val:Boolean):void {
			_enabled = val;
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
		public function get className():String{
			var val:String =getQualifiedClassName(this);
			return val;
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

