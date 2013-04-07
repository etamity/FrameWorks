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
			super();
		}
		
		override public function onTrigger(time:Number):void{
			_debug.clear();
			_debug.draw(engine.space);
			_debug.flush();
		}

		override public function dispose():void{
			nativeStage.removeChild(_debug.display);
			_debug.clear();
			_debug=null;
		}

		override public function onRegister(engine:IEngine):void{
			this.engine=engine as PhysicsEngine;
			_debug= new BitmapDebug(stage.stageWidth, stage.stageHeight,0 ,true);
			_debug.drawConstraints = true;

			/*_debug.cullingEnabled=true;
			_debug.drawFluidArbiters=true;
			_debug.drawBodyDetail=true;
			_debug.drawCollisionArbiters=true;
			_debug.drawBodies=true;*/
			nativeStage.addChild(_debug.display);

		}
	}
}