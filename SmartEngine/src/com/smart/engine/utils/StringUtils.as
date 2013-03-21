//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.utils {

	public class StringUtils {
		public static function padIntWithLeadingZeros(value:int, len:uint):String {
			var paddedValue:String = value.toString();

			if (paddedValue.length < len) {
				for (var i:int = 0, numOfZeros:int = (len - paddedValue.length); i < numOfZeros; i++) {
					paddedValue = "0" + paddedValue;
				}
			}

			return paddedValue;
		}
	}

}

