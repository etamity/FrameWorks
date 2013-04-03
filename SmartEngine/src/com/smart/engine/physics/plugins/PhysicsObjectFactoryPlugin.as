package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.PhysicsObject;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	
	public class PhysicsObjectFactoryPlugin extends Plugin
	{
		private var engine:PhysicsEngine;
		private var _addBoder:Boolean;
		
		public function PhysicsObjectFactoryPlugin(addBoder:Boolean=true)
		{
			super();
			_addBoder=addBoder;
		}
		
		override public function onRegister(engine:IEngine):void{
			this.engine = engine as PhysicsEngine;
			if (_addBoder)
			addWall();
			
			
			test1();
		}
		
		
		public function test1():void{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			for (var i:int = 0; i < 16; i++) {
				createBox(24,24,(w / 2), ((h - 50) - 32 * (i + 0.5)));
			}
			createCircle(40);
		}
		
		public function createBox(w:Number,h:Number,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject();
			obj.shapes.add(new Polygon(Polygon.box(w, h)));
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createCircle(radius:Number,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject();
			obj.shapes.add(new Circle(radius));
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createGeomPoly(points:Array,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject();
			obj.points=points;
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createRegular(radius:Number,rotation:Number=0,edgeCount:int=5,x:Number=0,y:Number=0):PhysicsObject{
			var regularShape:Polygon=new Polygon(Polygon.regular(radius*2,radius*2,edgeCount));
			var obj:PhysicsObject = new PhysicsObject();
			regularShape.rotate(rotation);
			obj.addShape(regularShape);
			return obj;
			
		}
		
		
		public function addWall(top:Boolean= true, bottom:Boolean=true, left:Boolean=true,right:Boolean=true):Body{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			var border:Body = new Body(BodyType.STATIC);
			if (top)
			border.shapes.add(new Polygon(Polygon.rect(0, 0, w, -1)));    //TOP
			if (bottom)
			border.shapes.add(new Polygon(Polygon.rect(0, h, w, 1)));    //BOTTOM
			if (left)
			border.shapes.add(new Polygon(Polygon.rect(0, 0, -1, h)));   //LEFT
			if (right)
			border.shapes.add(new Polygon(Polygon.rect(w, 0, 1, h)));   // RIGHT
			
			border.space = engine.space;
			
			return border;
		}
	}
}