package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.Canvas;
	import com.smart.engine.physics.core.TouchEventHandler;
	
	import flash.geom.Point;
	
	import starling.utils.Color;
	
	public class DrawBodyPlugin extends Plugin
	{
		private var engine:PhysicsEngine;
		
		private var points:Array;
		private var isDrawing:Boolean=false;
		private var curPoint:Point;
		private var prePoint:Point;
		private var handJointPlugin:HandJointPlugin;
		private var physicsObjectFactoryPlugin:PhysicsObjectFactoryPlugin;
		private var touchEventHandler:TouchEventHandler;
		
		public const DRAW_GEOMPOLY:String="DRAW_GEOMPOLY";
		public const DRAW_CIRCLE:String="DRAW_CIRCLE";
		public const DRAW_BOX:String="DRAW_BOX";
		public const DRAW_REGULAR:String="DRAW_REGULAR";
		public const NONE:String="NONE";
		
		public const PIVOTJOINT:String="PIVOTJOINT";
		
		
		
		private var _state:String="";
		
		private var canvas:Canvas;
		
		public function DrawBodyPlugin()
		{
			super();

			points=new Array();
			canvas= new Canvas();
		}
		
		public function get state():String{
			return _state;
		}
		
		override public function dispose():void{
			touchEventHandler.clear();
			touchEventHandler.dispose();
			engine.root.removeChild(canvas);
			canvas.dispose();
			
		}
		
		public function set state(val:String):void{
			if (_state==val) return;
			
			_state=val;
			touchEventHandler.clear();
			isDrawing=false;
			switch (val){
				case DRAW_GEOMPOLY:
					touchEventHandler.mouseDown=mouseDownHandler;
					touchEventHandler.mouseUp=mouseUpHandler;
					touchEventHandler.mouseMove=mouseMoveHandler;
					break;
				case DRAW_CIRCLE:
					touchEventHandler.mouseDown=mouseDownHandler_DrawCircle;
					touchEventHandler.mouseUp=mouseUpHandler_DrawCircle;
					touchEventHandler.mouseMove=mouseMoveHandler_DrawCircle;
					
					break;
				case DRAW_BOX:
					touchEventHandler.mouseDown=mouseDownHandler_DrawBox;
					touchEventHandler.mouseUp=mouseUpHandler_DrawBox;
					touchEventHandler.mouseMove=mouseMoveHandler_DrawBox;
					break;
				case DRAW_REGULAR:
					touchEventHandler.mouseDown=mouseDownHandler_DrawRegular;
					touchEventHandler.mouseUp=mouseUpHandler_DrawRegular;
					touchEventHandler.mouseMove=mouseMoveHandler_DrawRegular;
					break;
				case PIVOTJOINT:
					touchEventHandler.mouseDown=mouseDownHandler_DrawRegular;
					touchEventHandler.mouseUp=mouseUpHandler_DrawRegular;
					touchEventHandler.mouseMove=mouseMoveHandler_DrawRegular;
					break;
				
				case NONE:
				default:
					touchEventHandler.stop();
					break;
			}

		}	
		
		
		private function mouseUpHandler_DrawRegular(point:Point):void {
			
			if(!isDrawing) return;
			isDrawing=false;
			canvas.graphics.clear();
			curPoint = new Point(point.x, point.y);
			var distance:Number = Point.distance(prePoint, curPoint);
			var ww:Number= curPoint.x-prePoint.x;
			var hh:Number= curPoint.y-prePoint.y;
			var r:Number = Math.sqrt(ww*ww + hh*hh);
			var mouseAngle:Number=Math.atan2(curPoint.y-prePoint.y, curPoint.x-prePoint.x);
			if (distance >= 5) {
			physicsObjectFactoryPlugin.createRegular(distance,mouseAngle,5,null,prePoint.x,prePoint.y);
			}
		}
		private function mouseDownHandler_DrawRegular(point:Point):void {
			if (handJointPlugin.active==false)
			{
				isDrawing=true;
				curPoint = new Point(point.x, point.y);
				prePoint = curPoint.clone();
				canvas.graphics.moveTo(point.x, point.y);
			}
		}
		private function mouseMoveHandler_DrawRegular(point:Point):void {
			if(!isDrawing) return;
			
			curPoint = new Point(point.x, point.y);
			
			canvas.graphics.clear();

			var angle:Number = Math.PI*2/5;
			var mouseAngle:Number=Math.atan2(curPoint.y-prePoint.y, curPoint.x-prePoint.x);
			var x:Number, y:Number;
			var ww:Number= curPoint.x-prePoint.x;
			var hh:Number= curPoint.y-prePoint.y;
			var r:Number = Math.sqrt(ww*ww + hh*hh);
			canvas.graphics.moveTo(prePoint.x+r * Math.cos(mouseAngle), prePoint.y+r * Math.sin(mouseAngle));
			if (r >= 5) {
				for (var i:int=1; i<=5; i++){
					x=prePoint.x + r * Math.cos( i*angle+mouseAngle);
					y=prePoint.y + r * Math.sin( i*angle+mouseAngle);
		
					canvas.graphics.lineTo(x,y);
				}
				
				
			}
			
		}
		
		
		private function mouseUpHandler_DrawBox(point:Point):void {
			
			if(!isDrawing) return;
			
			isDrawing=false;
			canvas.graphics.clear();
			curPoint = new Point(point.x, point.y);
			var distance:Number = Point.distance(prePoint, curPoint);
			var ww:Number= curPoint.x-prePoint.x;
			var hh:Number= curPoint.y-prePoint.y;
			if (distance >= 5) {
			physicsObjectFactoryPlugin.createBox(ww,hh,null,prePoint.x+ww/2,prePoint.y+hh/2);
			}
		}
		private function mouseDownHandler_DrawBox(point:Point):void {
			if (handJointPlugin.active==false)
			{
				isDrawing=true;
				curPoint = new Point(point.x, point.y);
				prePoint = curPoint.clone();
				canvas.graphics.moveTo(point.x, point.y);
			}
		}
		private function mouseMoveHandler_DrawBox(point:Point):void {
			if(!isDrawing) return;
			
			curPoint = new Point(point.x, point.y);
			var ww:Number= curPoint.x-prePoint.x;
			var hh:Number= curPoint.y-prePoint.y;
			canvas.graphics.clear();
			var distance:Number = Point.distance(prePoint, curPoint);
			if (distance >= 5) {
				canvas.graphics.drawRect(prePoint.x,prePoint.y,ww,hh);

			}
			
		}
		
		
		
		
		
		private function mouseUpHandler_DrawCircle(point:Point):void {
			
			if(!isDrawing) return;
			
			isDrawing=false;
			canvas.graphics.clear();
			curPoint = new Point(point.x, point.y);
			var distance:Number = Point.distance(prePoint, curPoint);
			if (distance >= 5) {
			physicsObjectFactoryPlugin.createCircle(distance,null,prePoint.x,prePoint.y);
			}
		}
		private function mouseDownHandler_DrawCircle(point:Point):void {
			if (handJointPlugin.active==false)
			{
				isDrawing=true;
				curPoint = new Point(point.x, point.y);
				prePoint = curPoint.clone();
				canvas.graphics.moveTo(point.x, point.y);
			}
		}
		private function mouseMoveHandler_DrawCircle(point:Point):void {
			if(!isDrawing) return;
			
			curPoint = new Point(point.x, point.y);
			
			canvas.graphics.clear();
			var distance:Number = Point.distance(prePoint, curPoint);
			if (distance >= 5) {
				canvas.graphics.drawCircle(prePoint.x,prePoint.y,distance);
			}
			
		}
		
		
		private function mouseUpHandler(point:Point):void {
			if(!isDrawing) return;
			isDrawing=false;
			canvas.graphics.clear();
			var distance:Number=101;
			if (points.length>2)
			{
				var firstPt:Point = points[0];
				var lastPt:Point = points[points.length-1];
				distance=Point.distance(firstPt, lastPt);
			}
			if (distance < 100)
			physicsObjectFactoryPlugin.createGeomPoly(points);

			points=new Array();
		}
		private function mouseDownHandler(point:Point):void {
			if (handJointPlugin.active==false)
			{
				isDrawing=true;
			
				canvas.graphics.moveTo(point.x, point.y);
				
				curPoint = new Point(point.x, point.y);
				prePoint = curPoint.clone();
	
				points.push(point);
			}
		}
		private function mouseMoveHandler(point:Point):void {
			if(!isDrawing) return;
			curPoint = new Point(point.x, point.y);
			var distance:Number = Point.distance(prePoint, curPoint);
			canvas.graphics.lineTo(point.x, point.y);
			if (distance >= 5) {

				points.push(point);
				prePoint = curPoint.clone();
			}
			
		}
		override public function onRegister(engine:IEngine):void{
			this.engine=engine as PhysicsEngine;
			engine.root.addChild(canvas);
			canvas.graphics.lineStyle(2,Color.BLUE);
			handJointPlugin= engine.getPlugin(HandJointPlugin);
			physicsObjectFactoryPlugin= engine.getPlugin(PhysicsObjectFactoryPlugin);
			
			touchEventHandler= new TouchEventHandler(engine.stage);

			state=DRAW_GEOMPOLY;
		}
	}
}