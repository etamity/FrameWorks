//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.loaders {

	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.starling.HitMovieClip;
	import com.smart.engine.tmxdata.TMXTileset;
	import com.smart.engine.utils.GridBool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	public class TextureAtlasLoader implements ITextureLoader {
		private static var proxyTexture:Vector.<Texture>;

		public function TextureAtlasLoader(url:String, tile:TMXTileset, offset:Point = null, hitMapTest:Boolean = true) {
			this.url = url;
			_tile=tile;
			this.frames = tile.areas;
			_tileWidth=tile.tileWidth;
			_tileHeight=tile.tileHeight;
			_startID=tile.firstgid;
			this.offset = offset ? offset : new Point();
			if (hitMapTest) {
				hitMap = new Vector.<GridBool>();
			}
		}
		
		private function loadAtlas():void
		{
			/*trace("loading atlas");
			var numRows:uint = _sheet.height / _tileHeight;
			var numCols:uint = _sheet.width / _tileWidth;
			
			var id:int = _startID;
			
			var xml:XML = <Atlas></Atlas>;
			
			xml.appendChild(<TextureAtlas imagePath={url}></TextureAtlas>);
			
			for (var i:int = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numCols; j++)
				{
					id++;
					xml.child("TextureAtlas").appendChild(<SubTexture name={id} x = {j * _tileWidth} y={i * _tileHeight } width={_tileWidth} height={_tileHeight}/>);
				}
			}
			
			var newxml:XML = XML(xml.TextureAtlas);
			
			trace(newxml);
			
			_textureAtlas = new TextureAtlas(Texture.fromBitmap(_sheet), newxml);
			trace("done with atlas, dispatching");*/
			//dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}

		public var url:String;
		private var _startID:int;
		private var frames:Vector.<Rectangle>;
		private var hitMap:Vector.<GridBool>;
		private var offset:Point;
		private var textures:Vector.<Texture>;
		private var _tileWidth:int;
		private var _tileHeight:int;
		private var _textureAtlas:TextureAtlas;
		private var _tile:TMXTileset;
		public function getDisplay():DisplayObject {
			if (proxyTexture == null) {
				proxyTexture = new <Texture>[Texture.empty(25, 25)];
			}
			var mc:HitMovieClip = new HitMovieClip(proxyTexture);
			mc.smoothing = TextureSmoothing.NONE;
		
			return mc;
		
		}

		public function getImage():Image {
			if (proxyTexture == null) {
				proxyTexture = new <Texture>[Texture.empty(25, 25)];
			}
			var image:Image = new Image(proxyTexture[0]);
			image.smoothing = TextureSmoothing.NONE;
			return image;
		}
		public function get id():String {
			return url;
		}

	
		public function get isLoaded():Boolean {
			return textures !== null;
		}

	
		public function load():void {
			trace(url);
			ImgLoader.instance.getBitmapData(url, onLoad);
		}

		public function setTexture(sprite:SmartDisplayObject):void {
			SmartImage(sprite).setImageTexture(offset, _textureAtlas);
			
			//SmartImage(sprite).display= new Image(_textureAtlas.getTexture(SmartImage(sprite).name));
			//SmartImage(sprite).setHitmap(hitMap[0]);
		}

		private function onLoad(bd:BitmapData):void {
			if (textures) {
				return;
			}
			var bigTexture:Texture = Texture.fromBitmapData(bd);
			var i: int = 0;
			
			trace("loading atlas");
			var numRows:uint = bd.height / _tileHeight;
			var numCols:uint = bd.width / _tileWidth;
			trace("bd.width :",bd.width );
			var id:int = _startID;
			
			var xml:XML = <Atlas></Atlas>;
			
			xml.appendChild(<TextureAtlas imagePath={url}></TextureAtlas>);
			
		for (i = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numCols; j++)
				{
					id++;
					xml.child("TextureAtlas").appendChild(<SubTexture name={id} x = {j * _tileWidth} y={i * _tileHeight } width={_tileWidth} height={_tileHeight}/>);
					//xml.child("TextureAtlas").appendChild(<SubTexture name={id} x = {_tile.areas[i*j].x} y={_tile.areas[i*j].y} width={_tile.areas[i*j].width} height={_tile.areas[i*j].height}/>);
				}
			}
			
			
			/*	
			for (i = 0; i < _tile.areas.length; i++){
				id+=i;
				xml.child("TextureAtlas").appendChild(<SubTexture name={id} x = {_tile.areas[i].x} y={_tile.areas[i].y} width={_tile.areas[i].width} height={_tile.areas[i].height}/>);
			}*/
			
			var newxml:XML = XML(xml.TextureAtlas);
			
			trace(newxml);
			
			_textureAtlas = new TextureAtlas(bigTexture, newxml);
			
			
			trace("done with atlas, dispatching");
			trace("names:"+_tile.name);
			
			
			
			

			/*textures = new <Texture>[];
			var texture:Texture;
			for each (var frame:Rectangle in frames) {
				texture = Texture.fromTexture(bigTexture, frame);
				textures.push(texture);
				if (hitMap != null) {
					hitMap.push(GridBool.fromBitMapDataAlpha(bd, frame));
				}
				i++;
			}*/
			bd.dispose();
		}
	}

}

