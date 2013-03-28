package com.smart.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.physics.PhysicsEngine;
	
	import flash.events.MouseEvent;
	
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	
	import starling.core.Starling;
	
	public class HandJointPlugin extends Plugin
		
	{	private var handJoint:PivotJoint;
		private var engine:PhysicsEngine;
		public function HandJointPlugin()
		{
			super();
		}
		
		private function mouseUpHandler(ev:MouseEvent):void {
			handJoint.active = false;
		}
		override public function onTrigger(time:Number):void{
			
			if (handJoint.active) {
				handJoint.anchor1.setxy(nativeStage.mouseX, nativeStage.mouseY);
			}
	
		}
		private function mouseDownHandler(ev:MouseEvent):void {
			
			var mousePoint:Vec2 = Vec2.get(nativeStage.mouseX, nativeStage.mouseY);
			
			
			var bodies:BodyList = engine.space.bodiesUnderPoint(mousePoint);
			for (var i:int = 0; i < bodies.length; i++) {
				var body:Body = bodies.at(i);
				
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

			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			handJoint = new PivotJoint(this.engine.space.world, null, Vec2.weak(), Vec2.weak());
			handJoint.space = this.engine.space;
			handJoint.active = false;
			handJoint.stiff = false;
		}
		
	}
}