package com.smart.core
{
	import nape.phys.Body;

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