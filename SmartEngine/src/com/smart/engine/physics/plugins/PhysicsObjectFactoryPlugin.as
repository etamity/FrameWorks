package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.PhysicsObject;
	
	import nape.constraint.AngleJoint;
	import nape.constraint.Constraint;
	import nape.constraint.DistanceJoint;
	import nape.constraint.LineJoint;
	import nape.constraint.MotorJoint;
	import nape.constraint.PivotJoint;
	import nape.constraint.PulleyJoint;
	import nape.constraint.WeldJoint;
	import nape.geom.Vec2;
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
		public var _frequency:Number=20.0;
		public var _damping:Number=1.0;
		public function PhysicsObjectFactoryPlugin(addBoder:Boolean=true)
		{
			super();
			_addBoder=addBoder;
		}
		
		override public function onRegister(engine:IEngine):void{
			this.engine = engine as PhysicsEngine;
			if (_addBoder)
			addWall();

			//test3();
		}
		
		public function test2():void{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			var objects:Array=[];
			for (var i:int = 0; i < 6; i++) {
				objects.push(createBox(24,24,null,(w / 2), ((h - 50) - 32 * (i + 0.5))));
			}
			var b1:Body=objects[0].body;
			var b2:Body=objects[1].body;
			var b3:Body=objects[2].body;
			var b4:Body=objects[3].body;
			var b5:Body=objects[4].body;
			var b6:Body=objects[5].body;
			
			makeWeldJoint(b1,b2,b1.position.x,b1.position.y);
			makePivotJoint(b3,b4,b3.position.x,b3.position.y-100);
			makeMotorJoint(b5,b6,b5.position.x,b5.position.y);
			b5.position.setxy(200,100);
			objects[4].pinned=true;
			var box:PhysicsObject=createBox(40,50,null,300,300);
			box.pinned=true;
			
		}
		
		public function test3():void{
			const cellWcnt:int = 3;
			const cellHcnt:int = 3;
			const cellWidth:Number = 800 / cellWcnt;
			const cellHeight:Number = 600 / cellHcnt;
			const size:Number = 22;
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			function withCell(i:int, j:int, title:String, f:Function):void {
				f(function (x:Number):Number { return x + (i * cellWidth); },
					function (y:Number):Number { return y + (j * cellHeight); });
			}
			
			// Box utility.
			function box(x:Number, y:Number, radius:Number, pinned:Boolean=false):Body {
				var body:Body = new Body();
				body.position.setxy(x, y);
				body.shapes.add(new Polygon(Polygon.box(radius*2, radius*2)));
				body.space = engine.space;
				if (pinned) {
					var pin:PivotJoint = new PivotJoint(
						engine.space.world, body,
						body.position,
						Vec2.weak(0,0)
					);
					pin.space = engine.space;
				}
				return body;
			}
			
			withCell(1, 0, "PivotJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(1*cellWidth/3),y(cellHeight/2),size);
				var b2:Body = box(x(2*cellWidth/3),y(cellHeight/2),size);
				
				var pivotPoint:Vec2 = Vec2.get(x(cellWidth/2),y(cellHeight/2));
				format(new PivotJoint(
					b1, b2,
					b1.worldPointToLocal(pivotPoint, true),
					b2.worldPointToLocal(pivotPoint, true)
				));
				pivotPoint.dispose();
			});
			withCell(2, 0, "WeldJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(1*cellWidth/3),y(cellHeight/2),size);
				var b2:Body = box(x(2*cellWidth/3),y(cellHeight/2),size);
				
				var weldPoint:Vec2 = Vec2.get(0,0);
				format(new WeldJoint(
					b1, b2,
					b1.worldPointToLocal(weldPoint, true),
					b2.worldPointToLocal(weldPoint, true),
					/*phase*/ Math.PI/4 /*45 degrees*/
				));
				weldPoint.dispose();
			});
			
			withCell(0, 1, "DistanceJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(1.25*cellWidth/3),y(cellHeight/2),size);
				var b2:Body = box(x(1.75*cellWidth/3),y(cellHeight/2),size);
				
				format(new DistanceJoint(
					b1, b2,
					Vec2.weak(0, -size),
					Vec2.weak(0, -size),
					/*jointMin*/ cellWidth/3*0.75,
					/*jointMax*/ cellWidth/3*1.25
				));
			});
			
			withCell(1, 1, "LineJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(1*cellWidth/3),y(cellHeight/2),size);
				var b2:Body = box(x(2*cellWidth/3),y(cellHeight/2),size);
				
				var anchorPoint:Vec2 = Vec2.get(x(cellWidth/2),y(cellHeight/2));
				format(new LineJoint(
					b1, b2,
					b1.worldPointToLocal(anchorPoint, true),
					b2.worldPointToLocal(anchorPoint, true),
					/*direction*/ Vec2.weak(0, 1),
					/*jointMin*/ -size,
					/*jointMax*/ size
				));
				anchorPoint.dispose();
			});
			
			withCell(2, 1, "PulleyJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(cellWidth/2),y(size),size/2, true);
				b1.scaleShapes(4, 1);
				
				var b2:Body = box(x(1*cellWidth/3),y(cellHeight/2),size/2);
				var b3:Body = box(x(2*cellWidth/3),y(cellHeight/2),size);
				
				format(new PulleyJoint(
					b1, b2,
					b1, b3,
					Vec2.weak(-size*2, 0), Vec2.weak(0, -size/2),
					Vec2.weak( size*2, 0), Vec2.weak(0, -size),
					/*jointMin*/ cellHeight*0.75,
					/*jointMax*/ cellHeight*0.75,
					/*ratio*/ 2.5
				));
			});
			
			withCell(0, 2, "AngleJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(1*cellWidth/3),y(cellHeight/2),size, true);
				var b2:Body = box(x(2*cellWidth/3),y(cellHeight/2),size, true);
				
				format(new AngleJoint(
					b1, b2,
					/*jointMin*/ -Math.PI*1.5,
					/*jointMax*/ Math.PI*1.5,
					/*ratio*/ 2
				));
			});
			
			withCell(1, 2, "MotorJoint", function (x:Function, y:Function):void {
				var b1:Body = box(x(1*cellWidth/3),y(cellHeight/2),size, true);
				var b2:Body = box(x(2*cellWidth/3),y(cellHeight/2),size, true);
				
				format(new MotorJoint(
					b1, b2,
					/*rate*/ 10,
					/*ratio*/ 3
				));
			});
			
		}

		
		private function test1():void{
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
		
		private function format(c:Constraint):void{
			c.stiff = false;
			c.frequency = _frequency;
			c.damping = _damping;
			c.space= engine.space;
		}
		public function getBodiesCenter(b1:Body,b2:Body):Vec2{
			var px:Number=(b1.position.x-b2.position.x);
			var py:Number=(b1.position.y-b2.position.y);
			var vec:Vec2= Vec2.get(px,py);
			return vec;
		}
		
		public function makePivotJoint(b1:Body,b2:Body,x:Number=0,y:Number=0):PivotJoint{

			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var pivotJoint:PivotJoint=new PivotJoint(
					b1, b2,
					anchor1,
					anchor2
				);
			format(pivotJoint);
			anchor.dispose();
				
			return pivotJoint;
		}
		
	
		
		public function makeWeldJoint(b1:Body,b2:Body,x:Number=0,y:Number=0,phase:Number=0):WeldJoint{
			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var weldJoint:WeldJoint=new WeldJoint(
				b1, b2,
				anchor1,
				anchor2,
				phase
			);
			format(weldJoint);
			anchor.dispose();
			return weldJoint;
		}
		
		public function makeDistanceJoint(b1:Body,b2:Body,x:Number=0,y:Number=0,jointMin:Number=10,jointMax:Number=100):DistanceJoint{
			/*var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);*/
			var size:Number =-b1.bounds.height/2;
			var distanceJoint:DistanceJoint=new DistanceJoint(
				b1, b2,
				Vec2.weak(0, -size),
				Vec2.weak(0, -size),
				jointMin,
				jointMax
			);

			
			format(distanceJoint);
			//anchor.dispose();
			return distanceJoint;
		}
		public function makeLineJoint(b1:Body,b2:Body,x:Number=0,y:Number=0,jointMin:Number=10,jointMax:Number=100):LineJoint{
			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var size:Number =-b1.bounds.height/2;
			var lineJoint:LineJoint=new LineJoint(
				b1, b2,
				anchor1,
				anchor2,
				/*direction*/ Vec2.weak(0, 1),
				jointMin,
				jointMax
			);
			
			
			format(lineJoint);
			anchor.dispose();
			return lineJoint;
		}
		public function makePulleyJoint(b1:Body,b2:Body,b3:Body,x:Number=0,y:Number=0,jointMin:Number=10,jointMax:Number=100,ratio:Number=2.5):PulleyJoint{
			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var size:Number =-b1.bounds.height/2;
			var pulleyJoint:PulleyJoint=new PulleyJoint(
				b1, b2,
				b1, b3,
				Vec2.weak(-size*2, 0), Vec2.weak(0, -size/2),
				Vec2.weak( size*2, 0), Vec2.weak(0, -size),
				jointMin,
				jointMax,
				ratio
			);
			
			
			format(pulleyJoint);
			anchor.dispose();
			return pulleyJoint;
		}

		public function makeAngleJoint(b1:Body,b2:Body,x:Number=0,y:Number=0,ratio:Number=2):AngleJoint{
			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var size:Number =-b1.bounds.height/2;
			var angleJoint:AngleJoint=new AngleJoint(
				b1, b2,
				/*jointMin*/ -Math.PI*1.5,
				/*jointMax*/ Math.PI*1.5,
				ratio
			);
			
			
			format(angleJoint);
			anchor.dispose();
			return angleJoint;
		}
		
		
		public function makeMotorJoint(b1:Body,b2:Body,x:Number=0,y:Number=0,rate:Number=10,ratio:Number=3):MotorJoint{
			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var size:Number =-b1.bounds.height/2;
			var motorJoint:MotorJoint=new MotorJoint(
				b1, b2,
				rate,
				ratio
			);
			
			
			format(motorJoint);
			anchor.dispose();
			return motorJoint;
		}
		

		
		/*public function makeConstraint(b1:Body,b2:Body,x:Number=0,y:Number=0):Constraint{
			var anchor : Vec2 = Vec2.get(x,y);
			var anchor1 : Vec2 = b1.worldPointToLocal(anchor,true);
			var anchor2 : Vec2 = b2.worldPointToLocal(anchor,true);
			var constraint:Constraint=new WeldJoint(
				b1, b2,
				anchor1,
				anchor2,
				0
			);
			format(constraint);
			anchor.dispose();
			return constraint;
		}*/
		
		
		public function createWater(w:Number,h:Number,params:Object=null,x:Number=0,y:Number=0):PhysicsObject{
			params.type =BodyType.STATIC;
			var obj:PhysicsObject = new PhysicsObject(params);
			var shape:Polygon = new Polygon(Polygon.box(w, h),obj.material);
			shape.fluidEnabled=true;
			shape.fluidProperties= new FluidProperties(4, 10);
			obj.shapes.add(shape);
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		
		}
		
		
		public function createBox(w:Number,h:Number,params:Object=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject(params);
			var shape:Polygon =new Polygon(Polygon.box(w, h),obj.material);
			obj.shapes.add(shape);
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createCircle(radius:Number,params:Object=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject(params);
			var shape:Circle =new Circle(radius,null,obj.material);
			obj.position.setxy(x, y);
			obj.shapes.add(shape);
			engine.addObject(obj);
			return obj;
		}
		
		public function createGeomPoly(points:Array,params:Object=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject(params);
			obj.points=points;
			obj.position.setxy(x, y);
			engine.addObject(obj);
			return obj;
		}
		
		public function createRegular(radius:Number,rotation:Number=0,edgeCount:int=5,params:Object=null,x:Number=0,y:Number=0):PhysicsObject{
			var obj:PhysicsObject = new PhysicsObject(params);
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