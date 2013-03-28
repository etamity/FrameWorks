//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {
	import flash.utils.Dictionary;

	public class Engine extends Plugin implements IEngine{
		
		protected var plugins:Vector.<IPlugin>;
		protected var pluginsHash:Dictionary;

		
		public function Engine() {
			super();
			plugins=new <IPlugin>[];
			pluginsHash=new Dictionary();
		}

		
		override public function dispose():void{
			removeAllPlugins();
			plugins=null;
			pluginsHash=null;
		}
		public function getPluginByName(val:String):*
		{
			return pluginsHash[val];
		}
		public function getPlugin(val:*):*
		{
			var pluginName:String=getClassName(val);
			return getPluginByName(pluginName);
		}
		public function removeAllPlugins():void{
			for each (var plugin:IPlugin in plugins)
			{
				removePlugin(plugin);
			}
			plugins=new <IPlugin>[];
			pluginsHash=new Dictionary();
		}
		override public function onTrigger(time:Number):void {
			for each (var plugin:IPlugin in plugins) {
				if (plugin.enabled)
					plugin.onTrigger(time);
			}
		}

		public function removePlugin(plugin:IPlugin):void
		{
			var index:int=plugins.indexOf(plugin);
			if (index != -1)
			{
				plugins.splice(index, 1);
			}
			plugin.onRemove();
			plugin.dispose();
			delete pluginsHash[plugin.name];
		}

		public function addPlugin(plugin:IPlugin):IEngine
		{
			plugin.stage=stage;
			plugin.root=root;
			plugins.push(plugin);
			plugin.onRegister(this);
			pluginsHash[plugin.name]=plugin;
			return this;
		}	
	}
}

