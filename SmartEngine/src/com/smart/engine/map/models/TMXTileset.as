//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.models {

	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class TMXTileset {
		public var areas:Vector.<Rectangle>;
		
		
		public var firstgid:int;
		public var loaded:Boolean;
		public var name:String;
		
		public var source:TMXSource;
		public var tileHeight:int;
		public var tileWidth:int;
		
		private var tileProperties:Object = {};

		public function TMXTileset(data:XML) {
			firstgid = int(data.@firstgid);
			name = data.@name;
			tileWidth = int(data.@tilewidth);
			tileHeight = int(data.@tileheight);
			source = new TMXSource(XML(data.image[0]));

			areas = new <Rectangle>[];
			var rect:Rectangle;
			for (var y:int = 0; y < source.height; y += tileHeight) {
				for (var x:int = 0; x < source.width; x += tileWidth) {
					rect = new Rectangle(x, y, tileWidth, tileHeight);
					areas.push(rect);
				}
			}

			var tilePropBlocks:XMLList = data.elements('tile');
			for each (var tilePropBlock:XML in tilePropBlocks) {
				var id:String          = tilePropBlock.@id;
				var propBlocks:XMLList = tilePropBlock.properties[0].elements('property');
				var name:String;
				var val:String;
				for each (var prop:XML in propBlocks) {
					name = prop.@name.toString();
					val  = prop.@name.toString();
					if (tileProperties[id] == null) {
						tileProperties[id] = {};
					}
					tileProperties[id][name] = val;
				}
			}
		}

		
		public function getProps(gid:int):Object {
			return getPropsByID(int(gid - firstgid).toString());
		}

		public function getPropsByID(id:String):Object {
			var val:Dictionary = tileProperties[id];
			return val ? val : {};
		}
	}

}

