package com.smart.core
{
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;

	public class Plugin implements IPlugin
	{

		protected var _name:String = "Plugin";
		protected var _enabled:Boolean=true;
		private var _stage:starling.display.Stage;
		
		private var _root:DisplayObject;
		
		public function Plugin()
		{
			name= this.getClassName(this);

		}
		public function get root():DisplayObject{
			return _root;
		}
		public function set root(val:DisplayObject):void{
			_root = val;
		}
		
		public function getClassName(val:*):String{
			var classPath:String = getQualifiedClassName(val);
			return classPath;
		}
		
		public function dispose():void{

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
		
		
		public function get name():String {
			return _name;
		}
		
		public function set name(val:String):void {
			_name = val;
		}
		
		
		public function onRegister(engine:IEngine):void {
			
		}
		public function onRemove():void {
		}
		
		protected function getClass(obj:Object):Class{
			var classPath:String = getQualifiedClassName(obj);
			var ClassDef:Class = getDefinitionByName(classPath) as Class;
			return ClassDef;
		}
		public function onTrigger(time:Number):void {

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
