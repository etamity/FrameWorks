//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.tmxdata
{

	import com.smart.engine.loaders.ImgLoader;
	import com.smart.engine.utils.Base64;
	import com.smart.engine.utils.StringUtils;
	
	import flash.utils.Dictionary;

	public class TMXMap
	{
		public var data:XML;

		public var layersArray:Vector.<TMXLayer>;
		public var layersHash:Dictionary;

		public var objectsArray:Vector.<TMXObjectgroup>;
		public var objectsHash:Dictionary;

		public var orientation:String;
		public var tileHeight:int=0;
		public var tileWidth:int=0;

		public var tilesets:Vector.<TMXTileset>;
		public var uniqueTilesets:Vector.<TMXTileset>;

		public var width:int=0;
		public var height:int=0;

		private var imgsURL:String;
		public var maxGid:int=0;

		public var backgroundcolor:uint;
		public static function loadTMX(file:String, tmxCallback:Function):void
		{

			var basePath:String=StringUtils.getPath(file);
			trace("mapfile:",file,basePath );
			ImgLoader.instance.getXML(file, function(val:XML):void
			{
				tmxCallback(new TMXMap(val, basePath));
			});
		}

		public function TMXMap(data:*, url:String)
		{
			this.data=XML(data);
			this.imgsURL=url;

			orientation=String(data.@orientation);
			if (orientation == "")
			{
				orientation="isometric";
			}
			width=int(data.@width);
			height=int(data.@height);
			tileWidth=int(data.@tilewidth);
			tileHeight=int(data.@tileheight);
			
			var colorStr:String =String(data.@backgroundcolor);
			colorStr=colorStr.replace("#","0x");
			backgroundcolor=uint(colorStr);
			
			parseLayers();
			parseObjects();
			parseTilesets();
		}


		public function dispose():void{
			layersArray=null;
			layersHash=null;
			
			objectsArray=null;
			objectsHash=null;

			data=null;
			tilesets=null;
			uniqueTilesets=null;
		}

		public function getImgFrame(gid:int):int
		{
			return gid - tilesets[gid].firstgid
		}

		public function getImgSrc(gid:int):String
		{
			return StringUtils.getName(tilesets[gid].source.source);
		}

		public function getImgPath(gid:int):String
		{
			return imgsURL + tilesets[gid].source.source;
		}

		public function getTileset(gid:int):TMXTileset{
			var tileset:TMXTileset=null;
			if (gid<=tilesets.length)
				tileset=tilesets[gid];
			
			return tileset;
		}
		
		public function hasFullyLoaded():Boolean
		{
			for each (var tile:TMXTileset in uniqueTilesets)
			{
				if (tile.loaded == false)
				{
					return false;
				}
			}
			return true;
		}

		private function parseLayers():void
		{
			var layerBlocks:XMLList=data.layer;
			layersArray=new Vector.<TMXLayer>(layerBlocks.length(), true);
			layersHash=new Dictionary();
			var y:int=0;
			var w:int;
			var h:int;
			var name:String;
			var encoding:String;
			var layer:TMXLayer;
			for each (var layerBlock:XML in layerBlocks)
			{
				w=int(layerBlock.@width);
				h=int(layerBlock.@height);
				name=layerBlock.@name;
				encoding=layerBlock.data.@encoding;

				if (encoding == "base64")
				{
					var compression:String=layerBlock.data.@compression;
					if (compression != "zlib" && compression.length > 0)
					{
						throw new Error("Invalid tmx compression type: " + compression);
					}
					layer=Base64.base64ToTMXLayer(layerBlock.data[0], w, h, compression == "zlib");
				}
				else if (encoding == "csv")
				{
					layer=TMXLayer.fromCSV(layerBlock, w, h);
				}
				else
				{
					throw new Error("Invalid tmx encoding: " + encoding);
				}

				maxGid=Math.max(layer.maxGid, maxGid);

				layersArray[y++]=layer;
				layersHash[name]=layer;
				layer.name=name;

			}
		}

		private function parseObjects():void
		{
			var layerObjectGroups:XMLList=data.objectgroup;
			objectsArray=new <TMXObjectgroup>[];
			objectsHash=new Dictionary();
			var group:TMXObjectgroup;
			var obj:TMXObject;
			for each (var groupBlock:XML in layerObjectGroups)
			{
				group=new TMXObjectgroup();
				group.height=groupBlock.@height;
				group.width=groupBlock.@width;
				group.name=groupBlock.@name;

				for each (var propBlock:XML in groupBlock.elements("properties").elements("property"))
				{
					group.properties[String(propBlock.@name)]=String(propBlock.@value);
				}

				for each (var objBlock:XML in groupBlock.elements("object"))
				{
					obj=new TMXObject();
					obj.gid=objBlock.@gid;
					maxGid=Math.max(obj.gid, maxGid);
					trace("obj.gid,maxGid", obj.gid,maxGid);
					obj.x=Number(objBlock.@x);
					obj.y=Number(objBlock.@y);
					obj.type=objBlock.@type;
					obj.name=objBlock.@name;
					for each (var propObjBlock:XML in objBlock.elements("properties").elements("property"))
					{
						obj.properties[String(propObjBlock.@name)]=String(propObjBlock.@value);
					}
					group.objects.push(obj);
					group.objectsHash[obj.name]=obj;
				}
				objectsArray.push(group);
				objectsHash[group.name]=group;
			}
		}

		private function parseTilesets():void
		{
			var tileSetBlocks:XMLList=data.tileset;
			uniqueTilesets=new Vector.<TMXTileset>(tileSetBlocks.length(), true);
			tilesets=new Vector.<TMXTileset>(maxGid + 1, true);
			var tileIndex:int=0;
			var tileset:TMXTileset;
			for each (var tileBlock:XML in tileSetBlocks)
			{
				tileset=uniqueTilesets[tileIndex++]=new TMXTileset(tileBlock);
			}
			var tilesetIndex:int=0;
			var tilesetReference:TMXTileset;
			var nextGid:int;

			for (var i:int=1; i <= maxGid; i++)
			{
				nextGid=(tilesetIndex < (uniqueTilesets.length - 1)) ? uniqueTilesets[tilesetIndex + 1].firstgid : -1;
				tilesetReference=uniqueTilesets[tilesetIndex];
				if (i == nextGid)
				{
					tilesetReference=uniqueTilesets[++tilesetIndex];
				}
				tilesets[i]=tilesetReference;


			}
		}
	}
}

