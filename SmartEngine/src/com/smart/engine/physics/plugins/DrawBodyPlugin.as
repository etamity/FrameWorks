package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	
	import flash.geom.Point;
	
	import nape.geom.Vec2;
	
	public class DrawBodyPlugin extends Plugin
	{
		private var engine:PhysicsEngine;
		private var vertice:Vector.<Vec2>;
		
		private var points:Array;
		private var isDrawing:Boolean=false;
		private var curPoint:Point;
		private var prePoint:Point;
		private var handJointPlugin:HandJointPlugin;
		private var physicsObjectFactoryPlugin:PhysicsObjectFactoryPlugin;
		private var touchEventPlugin:TouchEventPlugin;
		public function DrawBodyPlugin()
		{
			super();
			vertice=new Vector.<Vec2>();
			points=new Array();
		}
		private function mouseUpHandler(point:Point):void {
			isDrawing=false;
			physicsObjectFactoryPlugin.createGeomPoly(points,point.x,point.y);
			vertice = new Vector.<Vec2>();
			points=new Array();
		}
		private function mouseDownHandler(point:Point):void {
			if (handJointPlugin.active==false)
			{
				isDrawing=true;
				curPoint = new Point(point.x, point.y);
				prePoint = curPoint.clone();
				vertice.push(new Vec2(point.x, point.y));
				points.push(point);
			}
		}
		private function mouseMoveHandler(point:Point):void {
			if(!isDrawing) return;
			curPoint = new Point(point.x, point.y);
			var distance:Number = Point.distance(prePoint, curPoint);
			if (distance >= 30) {
		
				vertice.push(new Vec2(point.x, point.y ));
				points.push(point);
				prePoint = curPoint.clone();
			}
			
		}
		override public function onRegister(engine:IEngine):void{
			this.engine=engine as PhysicsEngine;
			handJointPlugin= engine.getPlugin(HandJointPlugin);
			physicsObjectFactoryPlugin= engine.getPlugin(PhysicsObjectFactoryPlugin);
			touchEventPlugin= engine.getPlugin(TouchEventPlugin);
			
			touchEventPlugin.addTouchDown(mouseDownHandler);
			touchEventPlugin.addTouchUp(mouseUpHandler);
			touchEventPlugin.addTouchMove(mouseMoveHandler);
		}
	}
}