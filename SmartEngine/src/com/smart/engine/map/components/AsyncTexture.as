//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.components {

	import com.smart.core.AssetsManager;
	import com.smart.core.IComponent;
	import com.smart.core.SmartObject;
	import com.smart.engine.map.display.SmartDisplayObject;
	import com.smart.engine.map.loaders.ITextureLoader;
	
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
		public function onRegister(sprite:SmartObject):void {
			this.sprite = sprite as SmartDisplayObject;
			if (!this.sprite.display) {
				this.sprite.display=new Image(AssetsManager.instance.getTexture(this.sprite.textureName));
				trace("sprite.name::",this.sprite.textureName);
			}
			//loader = AssetsManager.instance.getLoader(assetManagerKey);
			//onTrigger(0);
			sprite.remove(this);
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

