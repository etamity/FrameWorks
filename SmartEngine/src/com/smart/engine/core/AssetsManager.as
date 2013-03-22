//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.core {

	import com.smart.engine.loaders.ITextureLoader;
	
	import flash.utils.Dictionary;

	public class AssetsManager {

		public static var instance:AssetsManager = new AssetsManager();


		public function AssetsManager() {

		}

		private var assetLoaders:Dictionary     = new Dictionary();


	
		public function addLoader(loader:ITextureLoader):void {
			if (hasLoader(loader.id)) {
				return;
			} 
			assetLoaders[loader.id] = loader;
			loader.load();
		}

		public function getDisplay(id:String):* {
			var loader:ITextureLoader = assetLoaders[id];
			if (loader == null) {
				throw new Error("loader not added for asset ID: " + id);
			}
			return loader.getDisplay();
		}
		public function getLoader(id:String):ITextureLoader {
			return assetLoaders[id];
		}


		public function hasLoader(id:String):Boolean {
			return getLoader(id) != null;
		}

		public function isLoaded(id:String):Boolean {
			var loader:ITextureLoader = getLoader(id);
			if (loader === null) {
				return false;
			}
			return loader.isLoaded;
		}
	}

}

