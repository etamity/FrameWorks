//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.components {
	
	import com.smart.engine.core.AssetsManager;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.loaders.ITextureLoader;
	
	public class ImageTexture implements IComponent {
		private static var I:int = 0; 
		
		public function ImageTexture(assetManagerKey:String) {
			i = ++I;
			this.assetManagerKey = assetManagerKey;
		}
		
		private var assetManagerKey:String;
		private var i:int        = 0; 
		private var sprite:SmartDisplayObject;
		
		public function onRegister(sprite:SmartDisplayObject):void {
			this.sprite = sprite;
			if (!sprite.display) {
				sprite.display = AssetsManager.instance.getImage(assetManagerKey);
			}
			onTrigger(0);
		}
		
		public function onRemove():void {
		}
		
		public function onTrigger(time:Number):void {
			var loader:ITextureLoader = AssetsManager.instance.getLoader(assetManagerKey);
			if (loader.isLoaded == false) {
				return;
			}
			loader.setTexture(sprite);
			
			sprite.removeComponent(this);
		}
	}
	
}

