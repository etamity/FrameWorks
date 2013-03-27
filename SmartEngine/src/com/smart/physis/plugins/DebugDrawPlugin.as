package com.smart.physis.plugins
{
	import com.smart.Engine;
	import com.smart.core.IPlugin;
	import com.smart.core.Plugin;
	import com.smart.physis.PhysisEngine;
	
	import nape.space.Space;
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;


	public class DebugDrawPlugin extends Plugin
	{
		private var _debug:BitmapDebug;
		private var engine:PhysisEngine;
		private var _space:Space;
		public function DebugDrawPlugin()
		{
		}
		
		override public function onTrigger(time:Number):void{
			_debug.clear();
			_debug.draw(_space);
			_debug.flush();
		}
		override public function onRegister(engine:IPlugin):void{
			this.engine=engine as PhysisEngine;
			_debug= new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
			Starling.current.nativeStage.addChild(_debug.display);
			_space= this.engine.space;
		}
	}
}