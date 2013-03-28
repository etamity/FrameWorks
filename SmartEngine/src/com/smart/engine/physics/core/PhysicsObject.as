package com.smart.engine.physics.core
{
	import nape.phys.Body;
	import com.smart.core.SmartObject;

	public class PhysicsObject extends SmartObject
	{
		private var _body:Body;
		public function PhysicsObject()
		{
			super();
		}
		
		public function get body():Body{
			return _body;
		}
	}
}