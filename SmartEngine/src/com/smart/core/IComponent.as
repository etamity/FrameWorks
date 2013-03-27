//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {


	public interface IComponent {
		function onRegister(object:SmartObject):void;
		function onRemove():void;
		function onTrigger(time:Number):void;
	}

}

