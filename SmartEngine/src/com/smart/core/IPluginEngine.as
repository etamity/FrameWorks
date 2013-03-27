//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {
	public interface IPluginEngine {
		
		function getPluginByName(val:String):*;
		
		function getPlugin(val:*):*;
		
		function removePlugin(plugin:IPlugin):void;
		
		function addPlugin(plugin:IPlugin):IPlugin;
		
		function get EngineClass():Class;
		
		function getClassName(val:*):String;
		
	}
}
