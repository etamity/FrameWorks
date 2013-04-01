package com.smart.engine.physics.core
{
	import com.smart.core.SmartObject;
	
	import flash.geom.Point;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Shape;
	
	import starling.display.DisplayObject;

	public class PhysicsObject extends SmartObject
	{
		private var _body:Body;
		private var _shape:Shape;
		private var _position:Point;
		protected var _rotation:Number = 0;
		protected var _width:Number = 1;
		protected var _height:Number = 1;
		protected var _radius:Number = 0;
		public function PhysicsObject()
		{
			super();
			_body=new Body(BodyType.DYNAMIC);
			_shape= new Shape();
			_position = new Point(0,0);
		}

		override public function dispose():void{
			_body = null;
		}
		public function get width():Number{
			return _width;
		}
		public function set width(val:Number):void{
			 _width = val;
		}
		public function get radius():Number{
			return _radius;
		}
		public function set radius(val:Number):void{
			_radius = val;
		}
		public function get height():Number{
			return _height;
		}
		public function set height(val:Number):void{
			_height = val;
		}
		
		public function get x():Number{
			return _position.x;
		}
		
		public function set x(val:Number):void{
			_position.x=val;
		}
		
		public function get y():Number{
			return _position.y;
		}
		
		public function set y(val:Number):void{
			_position.y=val;
		}
		
		public function set view(val:DisplayObject):void
		{

			_body.userData.graphic=val;
		}

		public function get body():Body
		{
			return _body;
		}
	}


}
