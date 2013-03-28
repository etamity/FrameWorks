package com.smart.loaders
{
	import com.smart.engine.map.models.TMXMapModel;
	import com.smart.engine.map.models.TMXTileset;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import org.assetloader.AssetLoader;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class AssetsManager extends AssetLoader
	{
		private var _tmx:TMXMapModel;
		private var _tilesetXML:Dictionary;
		private var _assetManager:AssetManager;
		public static var instance:AssetsManager=new AssetsManager();

		public function AssetsManager(tmx:TMXMapModel=null)
		{
			if (tmx)
				loadTmx(tmx);
			
			_assetManager= new AssetManager();
		}

		public function loadTmx(tmx:TMXMapModel, onProgress:Function=null):void
		{   _assetManager.purge();
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
				//trace(atlasXML);
				return atlasXML;
			}
		}
		public function getTexture(name:String):Texture
		{
			return _assetManager.getTexture(name);
		}
		public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture>
		{
			return _assetManager.getTextures(prefix,result);
		}
		public function getTextureNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
		{
			return _assetManager.getTextureNames(prefix,result);
		}
		public function getTextureAtlas(name:String):TextureAtlas{
			return _assetManager.getTextureAtlas(name);
		}
		public function getSound(name:String):Sound{
			return _assetManager.getSound(name);
		}
		public function getSoundNames(prefix:String=""):Vector.<String>
		{
			return _assetManager.getSoundNames(prefix);
		}
		public function playSound(name:String, startTime:Number=0, loops:int=0, 
								  transform:SoundTransform=null):SoundChannel{
			return _assetManager.playSound(name,startTime,loops,transform);
		}
		public function addTexture(name:String, texture:Texture):void
		{
			_assetManager.addTexture(name,texture);
		}
		public function addTextureAtlas(name:String, atlas:TextureAtlas):void
		{
			_assetManager.addTextureAtlas(name,atlas);
		}
		public function addSound(name:String, sound:Sound):void
		{
			_assetManager.addSound(name,sound);
		}
		public function removeTexture(name:String, dispose:Boolean=true):void
		{
			_assetManager.removeTexture(name,dispose);
		}
		public function removeTextureAtlas(name:String, dispose:Boolean=true):void
		{
			_assetManager.removeTextureAtlas(name,dispose);
		}
		public function removeSound(name:String):void
		{
			_assetManager.removeSound(name);
		}
		public function dispose():void{
			_assetManager.purge();
			dispose();
		}   
		
		public function enqueue(...rawAssets):void{
			_assetManager.enqueue(rawAssets);
		}
		
		public function loadQueue(onProgress:Function):void
		{
			_assetManager.loadQueue(onProgress);
		}
		
		
		
		public function get verbose():Boolean{ return _assetManager.verbose;  }
		public function set verbose(val:Boolean):void{_assetManager.verbose = val;  }
		
		public function get useMipMaps():Boolean { return 	_assetManager.useMipMaps; }
		public function set useMipMaps(value:Boolean):void { _assetManager.useMipMaps = value; }
		
		public function get scaleFactor():Number { return _assetManager.scaleFactor; }
		public function set scaleFactor(value:Number):void { _assetManager.scaleFactor = value; }
		
	}
}
