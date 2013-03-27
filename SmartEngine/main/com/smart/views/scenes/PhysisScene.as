package com.smart.views.scenes
{
	import com.smart.Engine;
	import com.smart.physis.PhysisEngine;
	import com.smart.physis.plugins.DebugDrawPlugin;

	public class PhysisScene extends BaseScene
	{
		public function PhysisScene()
		{
			super();
		}
		override protected function initialize():void{
			start();
		}
		override public function addPlugins(engine:Engine):void{
			var physis:PhysisEngine=new PhysisEngine();
			physis.addWall();
			engine.addPlugin(new DebugDrawPlugin());
			
		}
	}
}