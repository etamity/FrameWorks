package com.smart.engine.physics.core
{
	import com.smart.core.SmartObject;
	import com.smart.engine.PhysicsEngine;
	
	import flash.geom.Point;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	
	import starling.display.DisplayObject;

	public class PhysicsObject extends SmartObject
	{
		private var _body:Body;
		private var _position:Point;
		protected var _rotation:Number = 0;
		protected var _width:Number = 1;
		protected var _height:Number = 1;
		protected var _radius:Number = 0;
		protected var _material:Material;
		public var _points:Array;
		protected var _bodyType:BodyType;
		private var _engine:PhysicsEngine;
		public function PhysicsObject(params:Object = null)
		{
			super(params);
			_position = new Point(0,0);
			
			_bodyType = BodyType.DYNAMIC;
			_body = new Body(_bodyType, new Vec2(x, y));
			_body.userData.myData = this;
			_body.rotate(new Vec2(x, y), _rotation);
			
			_material = new Material(0.65, 0.57, 1.2, 1, 0);
		}

	
		override public function initialize(params:Object=null):void{
			if (params)
				super.initialize(params);

			
		}
		

		override public function dispose():void{
			_body = null;
		}
		public function get points():Array {
			return _points;
		}
		
		public function set points(pointsArr:Array):void {
			_points = pointsArr;
			/*if (_points && pointsArr.length > 1) {
				
				var verts:Vec2List = new Vec2List();
				
				for each (var point:Object in pointsArr)
				verts.push(new Vec2(point.x as Number, point.y as Number));
				
				var polygon:Polygon = new Polygon(verts, _material);
				var validation:ValidationResult = polygon.validity();
				
				if (validation == ValidationResult.VALID)
					_shape = polygon;
					
				else if (validation == ValidationResult.CONCAVE) {
					
					var concave:GeomPoly = new GeomPoly(verts);
					var convex:GeomPolyList = concave.convexDecomposition();
					convex.foreach(function(p:GeomPoly):void {
						_body.shapes.add(new Polygon(p));
					});
					return;
					
				} else
					throw new Error("Invalid polygon/polyline");
				
			} else {
				
				if (_radius != 0)
					_shape = new Circle(_radius, null, _material);
				else
					_shape = new Polygon(Polygon.box(_width, _height), _material);
			}
			
			_body.shapes.add(_shape);*/
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
		public function get rotation():Number
		{
			if (_body)
				return _body.rotation * 180 / Math.PI;
			else
				return _rotation * 180 / Math.PI;
		}
		
		public function set rotation(value:Number):void
		{
			_rotation = value * Math.PI / 180;
			
			if (_body)
				_body.rotate(new Vec2(x, y), _rotation);
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
