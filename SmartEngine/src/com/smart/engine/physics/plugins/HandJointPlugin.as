package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.TouchEventHandler;
	
	import flash.geom.Point;
	
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;

	public class HandJointPlugin extends Plugin
		
	{	private var handJoint:PivotJoint;
		private var engine:PhysicsEngine;
		private var touchEventHandler:TouchEventHandler;
		public function HandJointPlugin()
		{
			super();
			
		}
		
		public function get active():Boolean{
			return handJoint.active;
		}
		
		override public function dispose():void{
			super.dispose();
			touchEventHandler.clear();
			touchEventHandler.dispose();
			touchEventHandler=null;
			handJoint.space=null;
			handJoint=null;
		}
		
		
		private function mouseUpHandler(point:Point):void {

			handJoint.active = false;
		}

		override public function onTrigger(time:Number):void{
			
			if (handJoint.active) {
				handJoint.anchor1.setxy(touchEventHandler.mouseX, touchEventHandler.mouseY);
			}
		}
		
		private function mouseMoveHandler(point:Point):void {
	
	
		}
		
		private function mouseDownHandler(point:Point):void {
			var mousePoint:Vec2 = Vec2.get(point.x, point.y);
			var bodies:BodyList = engine.space.bodiesUnderPoint(mousePoint);
			var body:Body
			for (var i:int = 0; i < bodies.length; i++) {
				body= bodies.at(i);
				
				if (!body.isDynamic()) {
					continue;
				}
				
				
				handJoint.body2 = body;
				handJoint.anchor2.set(body.worldPointToLocal(mousePoint, true));
				
				
				handJoint.active = true;
				
				break;
			}
			
			mousePoint.dispose();
		}
		
		override public function onRegister(engine:IEngine):void{
			this.engine=engine as PhysicsEngine;
		
			touchEventHandler= new TouchEventHandler(engine.stage);
			touchEventHandler.clear();
			
			touchEventHandler.mouseDown=mouseDownHandler;
			touchEventHandler.mouseUp=mouseUpHandler;
			touchEventHandler.mouseMove=mouseMoveHandler;
	
			handJoint = new PivotJoint(this.engine.space.world, null, Vec2.weak(), Vec2.weak());
			
			handJoint.space = this.engine.space;
			handJoint.active = false;
			handJoint.stiff = false;
			
			
		}
		
	}
}