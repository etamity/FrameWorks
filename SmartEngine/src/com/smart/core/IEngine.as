//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {
	

	public interface IEngine extends IPlugin{
		
		function getPluginByName(val:String):*;
		
		function getPlugin(val:*):*;
		
		function removePlugin(plugin:IPlugin):void;
		
		function addPlugin(plugin:IPlugin):IEngine;
		
		function get EngineClass():Class;
		
		function getClassName(val:*):String;
		

	}
}
