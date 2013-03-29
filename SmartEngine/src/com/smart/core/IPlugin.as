//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {
	import flash.display.Stage;
	
	import starling.display.DisplayObject;
	import starling.display.Stage;

	
	public interface IPlugin{
		function get name():String;
		function set name(val:String):void;
		
		function onRegister(engine:IEngine):void;
	
		function dispose():void;
		function onTrigger(time:Number):void;
		
		function get enabled():Boolean;
		function set enabled(val:Boolean):void;
		
		function get stage():starling.display.Stage;
		function set stage(val:starling.display.Stage):void;
		
		
		function get stageWidth():int;
		function get stageHeight():int;
		function get nativeStage():flash.display.Stage;
		
		
		function get root():DisplayObject;
		function set root(val:DisplayObject):void;
		
	}

}

