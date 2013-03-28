package com.smart.engine
{
	import com.smart.core.Engine;
	
	import nape.geom.Vec2;
	import nape.space.Space;
	
	public class PhysicsEngine extends Engine
	{
		private var _gravity:Vec2;
		private var _space:Space;
		private var _debug:Boolean =true;
		private var _frameRate:Number=60;
		public function PhysicsEngine(gravx:Number=0,gravy:Number=0,debug:Boolean=true)
		{
			super();
			_debug=debug;
			_gravity=new Vec2(gravx,gravy);
			_space = new Space(_gravity);
	
		}
		override public function onTrigger(time:Number):void{

			super.onTrigger(time);
			space.step(1 / _frameRate);
		}

		public function get frameRate():Number{
			return _frameRate;
		}
		public function set frameRate(val:Number):void{
			 _frameRate=val;
		}
		
		public function get space():Space{
			return _space;
		}
	}
}