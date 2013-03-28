package com.smart.physis.plugins
{
	import com.smart.core.IPlugin;
	import com.smart.core.Plugin;
	import com.smart.physis.PhysisEngine;
	
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;


	public class DebugDrawPlugin extends Plugin
	{
		private var _debug:BitmapDebug;
		private var engine:PhysisEngine;
		private var handJoint:PivotJoint;

		
		private var prevTimeMS:int;
		private var simulationTime:Number;
		public function DebugDrawPlugin()
		{
		}
		
		override public function onTrigger(time:Number):void{
			var curTimeMS:uint = getTimer();
			if (curTimeMS == prevTimeMS) {
				// No time has passed!
				return;
			}
			var deltaTime:Number = (curTimeMS - prevTimeMS) / 1000;
			// We cap this value so that if execution is paused we do
			// not end up trying to simulate 10 minutes at once.
			if (deltaTime > 0.05) {
				deltaTime = 0.05;
			}
			prevTimeMS = curTimeMS;
			simulationTime += deltaTime;
			
			if (handJoint.active) {
				handJoint.anchor1.setxy(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
			}
			
			while ( engine.space.elapsedTime < simulationTime) {
				engine.space.step(1 / Starling.current.nativeStage.frameRate);
			}
			_debug.clear();
			_debug.draw(engine.space);
			_debug.flush();
		}
		
		private function test():void{
			
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;

			for (var i:int = 0; i < 16; i++) {
				var box:Body = new Body(BodyType.DYNAMIC);
				box.shapes.add(new Polygon(Polygon.box(16, 32)));
				box.position.setxy((w / 2), ((h - 50) - 32 * (i + 0.5)));
				box.space = engine.space;
			}
			
			// Create the rolling ball.
			//   We use a DYNAMIC type object, and give it a single
			//   Circle with radius 50px. Unless specified otherwise
			//   in the second optional argument, the circle is always
			//   centered at the origin.
			//
			//   we give it an angular velocity so when it touched
			//   the floor it will begin rolling towards the tower.
			var ball:Body = new Body(BodyType.DYNAMIC);
			ball.shapes.add(new Circle(50));
			ball.position.setxy(50, h / 2);
			ball.angularVel = 10;
			ball.space = engine.space;
			
			
			handJoint = new PivotJoint(engine.space.world, null, Vec2.weak(), Vec2.weak());
			handJoint.space = engine.space;
			handJoint.active = false;
			
			// We also define this joint to be 'elastic' by setting
			// its 'stiff' property to false.
			//
			//   We could further configure elastic behaviour of this
			//   constraint through the 'frequency' and 'damping'
			//   properties.
			handJoint.stiff = false;

			// Set up fixed time step logic.
			prevTimeMS = getTimer();
			simulationTime = 0.0;
		}
		private function mouseUpHandler(ev:MouseEvent):void {
			// Disable hand joint (if not already disabled).
			handJoint.active = false;
		}
		
		private function mouseDownHandler(ev:MouseEvent):void {
			// Allocate a Vec2 from object pool.
			var mousePoint:Vec2 = Vec2.get(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
			
			// Determine the set of Body's which are intersecting mouse point.
			// And search for any 'dynamic' type Body to begin dragging.
			var bodies:BodyList = engine.space.bodiesUnderPoint(mousePoint);
			for (var i:int = 0; i < bodies.length; i++) {
				var body:Body = bodies.at(i);
				
				if (!body.isDynamic()) {
					continue;
				}
				
				// Configure hand joint to drag this body.
				//   We initialise the anchor point on this body so that
				//   constraint is satisfied.
				//
				//   The second argument of worldPointToLocal means we get back
				//   a 'weak' Vec2 which will be automatically sent back to object
				//   pool when setting the handJoint's anchor2 property.
				handJoint.body2 = body;
				handJoint.anchor2.set(body.worldPointToLocal(mousePoint, true));
				
				// Enable hand joint!
				handJoint.active = true;
				
				break;
			}
			
			// Release Vec2 back to object pool.
			mousePoint.dispose();
		}
		override public function onRegister(engine:IPlugin):void{
			this.engine=engine as PhysisEngine;
			_debug= new BitmapDebug(stage.stageWidth, stage.stageHeight);
			_debug.drawConstraints = true;
			Starling.current.nativeStage.addChild(_debug.display);
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			test();
		}
	}
}