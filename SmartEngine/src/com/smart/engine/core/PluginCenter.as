//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class PluginCenter {
		private static var PluginClass:Dictionary;
		private static var instance:PluginCenter;

		public static function getInstance():PluginCenter {
			if (PluginCenter.instance == null) {
				PluginCenter.instance = new PluginCenter(new SingletonEnforcer());
			}
			return PluginCenter.instance;
		}

		public function PluginCenter(enforcer:SingletonEnforcer) {
			PluginClass = new Dictionary();
		}

		public function getPluginByName(name:String):IPlugin {
			var plugin:IPlugin = new PluginClass[name]();
			return plugin;
		}

		public function getPluginDefineByName(name:String):Class {

			return PluginClass[name];
		}

		public function register(plugin:Class):void {

			var classNameDef:String = getQualifiedClassName(plugin);
			var className:String    = classNameDef.split("::")[1];

			PluginClass[className] = plugin;
		}

		public function remove(plugin:Class):void {
			var className:String = getQualifiedClassName(plugin);
			delete PluginClass[className];
		}
	}
}

class SingletonEnforcer {
}

