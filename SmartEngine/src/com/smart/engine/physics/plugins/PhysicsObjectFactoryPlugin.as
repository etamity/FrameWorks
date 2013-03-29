package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	
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
			addStageBorder();
			
			test1();
		}
		
		
		public function test1():void{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;

			for (var i:int = 0; i < 16; i++) {
				var box:Body = new Body(BodyType.DYNAMIC);
				//box.shapes.add(new Polygon(Polygon.box(16, 32)));
				box.shapes.add(new Circle(20));
				
				box.position.setxy((w / 2), ((h - 50) - 32 * (i + 0.5)));
				box.space = engine.space;
			}
			

			var ball:Body = new Body(BodyType.DYNAMIC);
			ball.shapes.add(new Circle(50));
			ball.position.setxy(50, h / 2);
			ball.angularVel = 10;
			ball.space = engine.space;
		}
		
		public function addStageBorder(top:Boolean= true, bottom:Boolean=true, left:Boolean=true,right:Boolean=true):Body{
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