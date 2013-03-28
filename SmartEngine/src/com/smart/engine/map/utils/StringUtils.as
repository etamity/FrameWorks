//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.utils
{
	import flash.display.Stage;
	import flash.net.FileReference;

	public class StringUtils
	{
		public static function padIntWithLeadingZeros(value:int, len:uint):String
		{
			var paddedValue:String=value.toString();

			if (paddedValue.length < len)
			{
				for (var i:int=0, numOfZeros:int=(len - paddedValue.length); i < numOfZeros; i++)
				{
					paddedValue="0" + paddedValue;
				}
			}

			return paddedValue;
		}

		public static function getLocalPath(stage:Stage):String
		{
			var _file:String=stage.loaderInfo.url;
			var _path:String=_file.substring(0, _file.lastIndexOf("/")) + "/";
			return _path;
		}

		public static function getPath(file:String):String
		{
			var _path:String=file.substring(0, file.lastIndexOf("/")) + "/";
			return _path;
		}

		public static function getName(name:String):String
		{
			var matches:Array;
			name=name.replace(/%20/g, " "); // URLs use '%20' for spaces
			matches=/(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(name);

			if (matches && matches.length == 4)
				return matches[2];
			else
				throw new ArgumentError("Could not extract name from String '" + name + "'");
		}


	}

}

