package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	
	import nape.util.BitmapDebug;


	public class DebugDrawPlugin extends Plugin
	{
		private var _debug:BitmapDebug;
		private var engine:PhysicsEngine;
	

		public function DebugDrawPlugin()
		{
		}
		
		override public function onTrigger(time:Number):void{
	
			_debug.clear();
			_debug.draw(engine.space);
			_debug.flush();
		}


		override public function onRegister(engine:IEngine):void{
			this.engine=engine as PhysicsEngine;
			_debug= new BitmapDebug(stage.stageWidth, stage.stageHeight-root.y,0 ,true);
			_debug.display.x =root.x;
			_debug.display.y =root.y;
			_debug.drawConstraints = true;
			nativeStage.addChild(_debug.display);

		}
	}
}