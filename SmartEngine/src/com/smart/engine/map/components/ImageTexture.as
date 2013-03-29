//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.components {
	
	import com.smart.loaders.ResourcesManager;
	import com.smart.engine.map.display.SmartDisplayObject;
	import com.smart.engine.map.loaders.ITextureLoader;
	import com.smart.core.IComponent;
	
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
				sprite.display = ResourcesManager.instance.getDisplay(assetManagerKey);
			}
			onTrigger(0);
		}
		
		public function onRemove():void {
		}
		
		public function onTrigger(time:Number):void {
			var loader:ITextureLoader = ResourcesManager.instance.getLoader(assetManagerKey);
			if (loader.isLoaded == false) {
				return;
			}
			loader.setTexture(sprite);
			
			sprite.remove(this);
		}
	}
	
}

