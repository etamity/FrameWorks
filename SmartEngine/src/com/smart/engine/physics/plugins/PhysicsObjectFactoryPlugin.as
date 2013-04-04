package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.PhysicsObject;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.FluidProperties;
	import nape.phys.Material;
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
				createBox(24,24,null,(w / 2), ((h - 50) - 32 * (i + 0.5)));
			}
			
			for (var a:int = 0; a < 16; a++) {
				createCircle(20,null ,(w / 2)+50, ((h - 50) - 32 * (i + 0.5)));
			}
			
			createWater(w-2,200,null,(w / 2)+1,h-220);
			
		}
		
		public function createWater(w:Number,h:Number,material:Material=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject({"material":material,"type":BodyType.STATIC});
			var shape:Polygon = new Polygon(Polygon.box(w, h),obj.material);
			shape.fluidEnabled=true;
			shape.fluidProperties= new FluidProperties(4, 10);
			obj.shapes.add(shape);
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		
		}
		
		
		public function createBox(w:Number,h:Number,material:Material=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject({"material":material});
			var shape:Polygon =new Polygon(Polygon.box(w, h),obj.material);
			obj.shapes.add(shape);
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createCircle(radius:Number,material:Material=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject({"material":material});
			var shape:Circle =new Circle(radius,null,obj.material);
			obj.position.setxy(x, y);
			obj.shapes.add(shape);
			engine.addObject(obj);
			return obj;
		}
		
		public function createGeomPoly(points:Array,material:Material=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject({"material":material});
			obj.points=points;
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createRegular(radius:Number,rotation:Number=0,edgeCount:int=5,material:Material=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject({"material":material});
			var shape:Polygon=new Polygon(Polygon.regular(radius,radius,edgeCount),obj.material);
			shape.rotate(rotation);
			obj.position.setxy(x, y);
			obj.shapes.add(shape);
			engine.addObject(obj);
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