package com.smart.core
{
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;

	public class Plugin extends SmartObject implements IPlugin
	{

		protected var _enabled:Boolean=true;
		private var _stage:starling.display.Stage;
		
		private var _root:DisplayObjectContainer;
		
		public function Plugin()
		{
			name= this.getClassName(this);

		}
		public function get root():DisplayObjectContainer{
			return _root;
		}
		public function set root(val:DisplayObjectContainer):void{
			_root = val;
		}
		
		public function getClassName(val:*):String{
			var classPath:String = getQualifiedClassName(val);
			return classPath;
		}
		
	
		public function get stageWidth():int{
			return _stage.stageWidth;
		}
		public function get stageHeight():int{
			return _stage.stageHeight;
		}
		public function get nativeStage():flash.display.Stage{
			return Starling.current.nativeStage;
		}
		public function get stage():starling.display.Stage{
			return _stage;
		}
		public function set stage(val:starling.display.Stage):void{
			_stage = val;
		}

		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled(val:Boolean):void {
			_enabled = val;
		}
		
		
		public function onRegister(engine:IEngine):void {
			
		}

		
		protected function getClass(obj:Object):Class{
			var classPath:String = getQualifiedClassName(obj);
			var ClassDef:Class = getDefinitionByName(classPath) as Class;
			return ClassDef;
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
