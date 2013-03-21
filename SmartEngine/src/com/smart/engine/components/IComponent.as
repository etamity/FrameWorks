//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.components {

	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartSprite;

	public interface IComponent {
		function onRegister(sprite:SmartDisplayObject):void;
		function onRemove():void;
		function onTrigger(time:Number):void;
	}

}

