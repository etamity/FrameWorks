package com.smart.engine
{
	import com.smart.core.Engine;
	import com.smart.engine.physics.core.PhysicsObject;
	
	import flash.utils.Dictionary;
	
	import nape.geom.Vec2;
	import nape.space.Space;
	
	public class PhysicsEngine extends Engine
	{
		private var _gravity:Vec2;
		private var _space:Space;
		private var _debug:Boolean =true;
		private var _frameRate:Number=1/60;
		
		private var _objects:Vector.<PhysicsObject>;
		private var _objectHash:Dictionary;
		
		public function PhysicsEngine(gravx:Number=0,gravy:Number=0,debug:Boolean=true)
		{
			super();
			_debug=debug;
			_gravity=new Vec2(gravx,gravy);
			_space = new Space(_gravity);
			_objectHash=new Dictionary();
			_objects=new Vector.<PhysicsObject>();
	
		}
		
		public function addObject(object:PhysicsObject):PhysicsObject{
			_objects.push(object);
			_objectHash[object.name]=object;
			object.body.space=_space;
			return object;
		}
		override public function dispose():void{
			_space = new Space(_gravity);
			_objectHash=new Dictionary();
			_objects=new Vector.<PhysicsObject>();
			
		}
		public function removeObject(object:PhysicsObject):void{
			
			var index:int=_objects.indexOf(object);
			if (index != -1)
			{
				_objects.splice(index, 1);
			}
			object.dispose();
			delete _objectHash[object.name];
		}
		override public function onTrigger(time:Number):void{
			var length:int =_objects.length;
			for (var i:int=0 ; i< length; i++ )
			{
				_objects[i].onTrigger(time);
			}
			super.onTrigger(time);
			space.step(_frameRate);
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