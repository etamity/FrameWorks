package com.smart.engine.core
{
	import com.smart.engine.tmxdata.TMXMap;
	import com.smart.engine.tmxdata.TMXTileset;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class MapAssetsManager extends AssetManager
	{
		private var _tmx:TMXMap;
		private var _tilesetXML:Dictionary;
		public static var instance:MapAssetsManager=new MapAssetsManager();

		public function MapAssetsManager(tmx:TMXMap=null)
		{
			if (tmx)
				loadTmx(tmx);
		}

		public function loadTmx(tmx:TMXMap, onProgress:Function=null):void
		{   purge();
			_tilesetXML=new Dictionary();
			if (tmx != null)
			{
				_tmx=tmx;
				var atlasName:String;
				var atlasPath:String;
				for each (var tileset:TMXTileset in tmx.uniqueTilesets)
				{
					if (tileset.firstgid <= tmx.maxGid)
					{
					atlasName=_tmx.getImgSrc(tileset.firstgid);
					atlasPath=_tmx.getImgPath(tileset.firstgid);
					_tilesetXML[atlasName]=getAtlasXML(tileset);
					enqueue(atlasPath);
					}

				}
				loadQueue(function(ratio:Number):void
				{
					trace("Loading assets, progress:", ratio);
					if (ratio == 1.0)
						loadAtlas(_tilesetXML);
					if (onProgress != null)
					{
						onProgress(ratio);
					}
				});
			}
			else
				throw new Error(getQualifiedClassName(tmx) + "Object is Null: ");
			
			
			function loadAtlas(atlasXML:Dictionary):void
			{
				var atlas:TextureAtlas;
				var texture:Texture;

				for (var atlasName:String in _tilesetXML)
				{
			
					texture=getTexture(atlasName);
					atlas=new TextureAtlas(texture, XML(_tilesetXML[atlasName]));
					addTextureAtlas(atlasName, atlas);
				}
				/*var sNames:Vector.<String> = new <String>[];
				getTextureNames("",sNames);
				trace("ALLNAME:",sNames);*/
				
			}

			function getAtlasXML(tile:TMXTileset):XML
			{
				var xml:XML=<Atlas></Atlas>;

				var imagePath:String=_tmx.getImgPath(tile.firstgid);
				var imageSrc:String=_tmx.getImgSrc(tile.firstgid);
				xml.appendChild(<TextureAtlas imagePath={imagePath}></TextureAtlas>);
				var id:int=tile.firstgid;
				for (var i:int=0; i < tile.areas.length; i++)
				{
					//xml.child("TextureAtlas").appendChild(<SubTexture name={imageSrc + "_" + id} x = {tile.areas[i].x} y={tile.areas[i].y} width={tile.areas[i].width} height={tile.areas[i].height}/>);
					xml.child("TextureAtlas").appendChild(<SubTexture name={imageSrc+"_"+id} x = {tile.areas[i].x} y={tile.areas[i].y} width={tile.areas[i].width} height={tile.areas[i].height}/>);
					id++;
				}
				var atlasXML:XML=XML(xml.TextureAtlas);
				/*trace(atlasXML);*/
				return atlasXML;
			}
		}

	}
}
