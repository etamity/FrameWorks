package com.smart.engine.core
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.display.Stage;

	public class PluginEngine implements IPlugin
	{
		protected var plugins:Vector.<IPlugin>;
		protected var pluginsHash:Dictionary;
		protected var _name:String = "Plugin";
		protected var _enabled:Boolean=true;
		private var _stage:Stage;
		public function PluginEngine()
		{
			name= this.getClassName(this);
			plugins=new <IPlugin>[];
			pluginsHash=new Dictionary();
		}

		public function getPluginByName(val:String):*
		{
			return pluginsHash[val];
		}
		public function getClassName(val:*):String{
			var classPath:String = getQualifiedClassName(val);
			return classPath;
		}
		public function getPlugin(val:*):*
		{
			var pluginName:String=getClassName(val);
			return getPluginByName(pluginName);
		}

		public function removePlugin(plugin:IPlugin):void
		{
			var index:int=plugins.indexOf(plugin);
			if (index != -1)
			{
				plugins.splice(index, 1);
			}
			plugin.onRemove();
			plugin.removeAllPlugins();
			delete pluginsHash[plugin.name];
		}
		
		
		public function removeAllPlugins():void{
			for each (var plugin:IPlugin in plugins)
			{
				removePlugin(plugin);
			}
			plugins=new <IPlugin>[];
			pluginsHash=new Dictionary();
		}
		
		public function get stage():Stage{
			return _stage;
		}
		public function set stage(val:Stage):void{
			_stage = val;
		}
		public function addPlugin(plugin:IPlugin):IPlugin
		{
			plugins.push(plugin);
			plugin.stage=_stage;
			plugin.onRegister(this);
			pluginsHash[plugin.name]=plugin;
			return plugin;
		}
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled(val:Boolean):void {
			_enabled = val;
		}
		
		
		public function get name():String {
			return _name;
		}
		
		public function set name(val:String):void {
			_name = val;
		}
		
		
		public function onRegister(engine:IPlugin):void {
			
		}
		public function onRemove():void {
		}
		
		protected function getClass(obj:Object):Class{
			var classPath:String = getQualifiedClassName(obj);
			var ClassDef:Class = getDefinitionByName(classPath) as Class;
			return ClassDef;
		}
		public function onTrigger(time:Number):void {
			for each (var plugin:IPlugin in plugins) {
				if (plugin.enabled)
					plugin.onTrigger(time);
			}
		}
		
		public function toString():String {
			return _name;
		}
		public function get EngineClass():Class
		{
			var classPath:String=getQualifiedClassName(this);
			var ClassDef:Class=getDefinitionByName(classPath) as Class;
			return ClassDef;
		}
	}
}
