//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.loaders
{

	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.starling.HitMovieClip;
	import com.smart.engine.tmxdata.TMXTileset;
	import com.smart.engine.utils.GridBool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	public class TextureAtlasLoader implements ITextureLoader
	{
		private static var proxyTexture:Vector.<Texture>;
		public var url:String;
		private var _startID:int;
		private var frames:Vector.<Rectangle>;
		private var hitMap:Vector.<GridBool>;
		private var offset:Point;
		private var _tileWidth:int;
		private var _tileHeight:int;
		private var _textureAtlas:TextureAtlas;
		private var _tile:TMXTileset;

		public function TextureAtlasLoader(url:String, tile:TMXTileset, offset:Point=null, hitMapTest:Boolean=true)
		{
			this.url=url;
			_tile=tile;
			this.frames=tile.areas;
			_tileWidth=tile.tileWidth;
			_tileHeight=tile.tileHeight;
			_startID=tile.firstgid;
			this.offset=offset ? offset : new Point();
			if (hitMapTest)
			{
				hitMap=new Vector.<GridBool>();
			}
		}



		public function getDisplay():DisplayObject
		{
			if (proxyTexture == null)
			{
				proxyTexture=new <Texture>[Texture.empty(25, 25)];
			}
			var image:Image=new Image(proxyTexture[0]);
			image.smoothing=TextureSmoothing.NONE;
			return image;
		}

		public function get id():String
		{
			return url;
		}


		public function get isLoaded():Boolean
		{
			return _textureAtlas !== null;
		}


		public function load():void
		{
			trace("mapfile:", url);
			ImgLoader.instance.getBitmapData(url, onLoad);
		}

		public function setTexture(sprite:SmartDisplayObject):void
		{
			SmartImage(sprite).setImageTexture(offset, _textureAtlas);

		}

		private function onLoad(bd:BitmapData):void
		{
			if (_textureAtlas)
			{
				return;
			}
			var bigTexture:Texture=Texture.fromBitmapData(bd);
			var i:int=0;
			var imageSrc:String=_tile.source.source;
			var id:int=_startID;

			var xml:XML=<Atlas></Atlas>;

			xml.appendChild(<TextureAtlas imagePath={url}></TextureAtlas>);



			for (i=0; i < _tile.areas.length; i++)
			{
				xml.child("TextureAtlas").appendChild(<SubTexture name={imageSrc + "_" + id} x = {_tile.areas[i].x} y={_tile.areas[i].y} width={_tile.areas[i].width} height={_tile.areas[i].height}/>);
				id++;
			}

			var newxml:XML=XML(xml.TextureAtlas);
			var typeXml:XML = describeType(newxml);
			trace(typeXml);

			_textureAtlas=new TextureAtlas(bigTexture, newxml);

			bd.dispose();
		}
	}

}

