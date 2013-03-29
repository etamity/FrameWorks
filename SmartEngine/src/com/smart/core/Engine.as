//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.core {
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Engine extends Plugin implements IEngine{
		
		protected var plugins:Vector.<IPlugin>;
		protected var pluginsHash:Dictionary;
		
		private var position:Point;
		
		public function Engine() {
			super();
			plugins=new <IPlugin>[];
			pluginsHash=new Dictionary();
			position = new Point(1, 1);
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
		
		
		public function get currentZoom():Number {
			return root.scaleX;
		}
		
		public function set currentZoom(val:Number):void {
			root.scaleX = root.scaleY = val;
		}
		public function moveTo(x:Number, y:Number):void {
			position.setTo(x, y);
		}
		
		public function get positionY():Number {
			return position.y;
		}
		
		public function set positionY(val:Number):void {
			position.y = val;
		}
		public function get positionX():Number {
			return position.x;
		}
		
		public function set positionX(val:Number):void {
			position.x = val;
		}
		
		public function offset(x:Number, y:Number):void {
			position.offset(x, y);
		}
		public function removePlugin(plugin:IPlugin):void
		{
			var index:int=plugins.indexOf(plugin);
			if (index != -1)
			{
				plugins.splice(index, 1);
			}
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

