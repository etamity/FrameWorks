package com.smart.engine.core
{	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	public class PluginEngine implements IPluginEngine
	{
		private var plugins:Vector.<IPlugin>;
		private var pluginsHash:Dictionary;
		public function PluginEngine()
		{
			plugins = new <IPlugin>[];
			pluginsHash = new Dictionary();
		}
		public function getPluginByName(val:String):IPlugin {
			return pluginsHash[val];
		}
		public function removePlugin(plugin:IPlugin):void {
			var index:int = plugins.indexOf(plugin);
			if (index != -1) {
				plugins.splice(index, 1);
			}
			plugin.onRemove();
			delete pluginsHash[plugin.name];
		}
		
		public function addPlugin(plugin:IPlugin):void {
			plugins.push(plugin);
			plugin.onRegister(this);
			pluginsHash[plugin.name] = plugin;
		}
		public function get EngineClass():Class{
			var classPath:String = getQualifiedClassName(this);
			var ClassDef:Class = getDefinitionByName(classPath) as Class;
			return ClassDef;
		}
	}
}