//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.components {

	import com.smart.engine.core.MapAssetsManager;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.loaders.ITextureLoader;
	
	import starling.display.Image;

	public class AsyncTexture implements IComponent {
		private static var I:int = 0; 

		public function AsyncTexture(textureName:String) {
			i = ++I;
			this.assetManagerKey = textureName;
		}

		private var assetManagerKey:String;
		private var i:int        = 0; 
		private var sprite:SmartDisplayObject;
		private var loader:ITextureLoader;
		public function onRegister(sprite:SmartDisplayObject):void {
			this.sprite = sprite;
			if (!sprite.display) {
				sprite.display=new Image(MapAssetsManager.instance.getTexture(sprite.textureName));
				trace("sprite.name::",sprite.textureName);
			}
			//loader = AssetsManager.instance.getLoader(assetManagerKey);
			//onTrigger(0);
			sprite.removeComponent(this);
		}

		public function onRemove():void {
		}

		public function onTrigger(time:Number):void {
			/*if (loader.isLoaded == false) {
				return;
			}

			loader.setTexture(sprite);

			sprite.removeComponent(this);*/
		}
	}

}

