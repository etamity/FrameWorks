package com.smart.scenes
{
	import com.smart.SmartSystem;
	import com.smart.physics.PhysicsEngine;
	import com.smart.physics.plugins.DebugDrawPlugin;
	import com.smart.physics.plugins.HandJointPlugin;
	import com.smart.physics.plugins.PhysicsObjectFactoryPlugin;

	public class PhysicsScene extends BaseScene
	{
		public function PhysicsScene()
		{
			super();
		}

		override public function addPlugins(system:SmartSystem):void{
			system.addEngine(new PhysicsEngine(0,600))
				  .addPlugin(new PhysicsObjectFactoryPlugin())
				  .addPlugin(new HandJointPlugin())
				  .addPlugin(new DebugDrawPlugin());
			
		}
	}
}