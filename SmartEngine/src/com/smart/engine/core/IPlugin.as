//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {

	import com.smart.engine.SmartEngine;

	public interface IPlugin {
		function get name():String;
		function set name(val:String):void;
		
		function onRegister(engine:IPluginEngine):void;
	
		function onRemove():void;

		function onTrigger(time:Number):void;
	}

}

