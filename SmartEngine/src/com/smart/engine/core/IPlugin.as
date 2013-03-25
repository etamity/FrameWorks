//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {
	import starling.display.Stage;

	
	public interface IPlugin extends IPluginEngine{
		function get name():String;
		function set name(val:String):void;
		
		function onRegister(engine:IPlugin):void;
	
		function onRemove():void;
		function removeAllPlugins():void;
		function onTrigger(time:Number):void;
		
		function get enabled():Boolean;
		function set enabled(val:Boolean):void;
		
		function get stage():Stage;
		function set stage(val:Stage):void;
	}

}

