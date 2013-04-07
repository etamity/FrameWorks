package com.smart.engine.physics.core
{
	import com.smart.core.SmartObject;
	import com.smart.engine.PhysicsEngine;
	
	import flash.geom.Point;
	
	import nape.constraint.Constraint;
	import nape.constraint.PivotJoint;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.shape.ShapeList;
	import nape.shape.ValidationResult;
	import nape.space.Space;
	
	import starling.display.DisplayObject;

	dynamic	public class PhysicsObject extends SmartObject
	{
		private var _body:Body;
		private var _engine:PhysicsEngine;
		protected var _material:Material;
		protected var _rotation:Number=0;
		protected var _width:Number=1;
		protected var _height:Number=1;
		protected var _radius:Number=0;
		protected var _bodyType:BodyType;
		
		public var _points:Array;
		private var _pin:Boolean=false;
		public function PhysicsObject(params:Object=null)
		{
			super(params);


			_bodyType=BodyType.DYNAMIC;
			_body=new Body(_bodyType, new Vec2(0, 0));
			_body.userData.myData=this;
			_body.rotate(new Vec2(0, 0), _rotation);
			
			_material=new Material();
		}
		
		public function set space(val:Space):void{
			body.space=val;
		}
		public function get space():Space{
			return body.space;
		}
		public function set pinned(val:Boolean):void{
			_pin=val;
			if (val) {
				var pin:PivotJoint = new PivotJoint(
					body.space.world, body,
					body.position,
					Vec2.weak(0,0)
				);
				pin.space = body.space;
			}
		}
		public function get pinned():Boolean{
			return _pin;
		}
		public function get material():Material{
			return _material;
		}
		public function set material(val:Material):void{
			 _material=val;
			 setMaterial(_material.elasticity,_material.dynamicFriction,_material.staticFriction,_material.density,_material.rollingFriction);
		}
		
		private function setMaterial(elastic:Number = 0, dynamicFriction:Number = 1, staticFriction:Number=1.2, density:Number = 1, rollingFriction:Number=0.001):void {
			if (!_body) return;
			var length:int =shapes.length;
			for (var i:int = 0; i <length ; i++) {
				var shape:Shape = shapes.at(i);
				shape.material.elasticity = elastic;
				shape.material.dynamicFriction = dynamicFriction;
				shape.material.staticFriction = staticFriction;
				shape.material.density = density;
				shape.material.rollingFriction = rollingFriction;
			}
		}
		
		public function get shapes():ShapeList{
			return _body.shapes;
		}
		
		public function addShape(obj:Shape):Body{
			shapes.add(obj);
			return _body;
		}

		override public function dispose():void
		{
			_body=null;
		}

		public function get points():Array
		{
			return _points;
		}

		public function set points(pointsArr:Array):void
		{
			_points=pointsArr;
			shapes.clear();
			var shape:Shape;
			if (_points && _points.length > 1) {

			var verts: Vector.<Vec2> = new Vector.<Vec2>();;

			for each (var point:Point in _points)
			{
				verts.push(new Vec2(point.x, point.y));
			}
			var polygon:Polygon = new Polygon(verts, _material);
			var validation:ValidationResult = polygon.validity();

			if (validation == ValidationResult.VALID)
				shape = polygon;

			else if (validation == ValidationResult.CONCAVE) {

				var concave:GeomPoly = new GeomPoly(verts);
				var convex:GeomPolyList = concave.convexDecomposition();
				convex.foreach(function(gp:GeomPoly):void {
					shapes.add(new Polygon(gp));
				});
				return;

			} else
				throw new Error("Invalid polygon/polyline");

		} else {

			if (_radius != 0)
				shape = new Circle(_radius, null, _material);
			else
				shape = new Polygon(Polygon.box(_width, _height), _material);
		}

			shapes.add(shape);
			body.align();
		}
		
		public function get position():Vec2{
			return _body.position;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(val:Number):void
		{
			_width=val;
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(val:Number):void
		{
			_radius=val;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(val:Number):void
		{
			_height=val;
		}

		public function get x():Number
		{
			return _body.position.x;
		}

		
		public function get rotation():Number
		{
			if (_body)
				return _body.rotation * 180 / Math.PI;
			else
				return _rotation * 180 / Math.PI;
		}

		public function set rotation(value:Number):void
		{
			_rotation=value * Math.PI / 180;

			if (_body)
				_body.rotate(new Vec2(x, y), _rotation);
		}

		public function set x(val:Number):void
		{
			_body.position.x=val;
		}

		public function get y():Number
		{
			return _body.position.y;
		}

		public function set y(val:Number):void
		{
			_body.position.y=val;
		}

		public function set view(val:DisplayObject):void
		{

			_body.userData.graphic=val;
		}

		public function get body():Body
		{
			return _body;
		}
		public function set type(val:BodyType):void{
			_body.type=val;
		}
		public function get type():BodyType{
			return _body.type;
		}
	}


}
