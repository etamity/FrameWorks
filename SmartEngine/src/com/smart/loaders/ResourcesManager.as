package com.smart.loaders
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.assetloader.AssetLoader;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class ResourcesManager extends AssetLoader
	{

		private var _assetManager:AssetManager;
		public static var instance:ResourcesManager=new ResourcesManager();

		public function ResourcesManager()
		{
			_assetManager= new AssetManager();
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
