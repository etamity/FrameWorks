//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {

	public interface IPluginEngine {
		
		function getPluginByName(val:String):IPlugin;
		
		function removePlugin(plugin:IPlugin):void;
		
		function addPlugin(plugin:IPlugin):void;
		
		function get EngineClass():Class;
	}
}
