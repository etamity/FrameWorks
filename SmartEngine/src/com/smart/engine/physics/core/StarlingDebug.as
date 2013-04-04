package com.smart.engine.physics.core
{
	import flash.geom.Point;
	
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.space.Space;
	import nape.util.Debug;
	
	import starling.display.DisplayObject;
	import starling.display.Graphics;
	
	public class StarlingDebug extends Debug
	{
		private var _display:Canvas;
		private var _lineWidth:Number=2;
		private var _color:int=0;
		public function StarlingDebug(width:int,height:int,bgColor:int, transparent:Boolean=false)
		{
			super();
			_display= new Canvas();
	
		}
		private function get g():Graphics{
			return _display.graphics;
		}
		public function get displayStarling():DisplayObject{
			return _display;
		}
		override public function draw(object:*):void{
			debug_draw(object);
		}
		
		private function debug_draw(object:*):void{
		
			var bodies:BodyList=Space(object).bodies;
			var body:Body;
			var shape:Shape;
			for (var i:int=0; i<bodies.length;i++)
					{
				         body=bodies.at(i);
						 
						for (var a:int=0;a<body.shapes.length ;a++)
						{
							shape = body.shapes.at(a);
							draw_shape(shape);
						}
					
				}
					
			
		}
		private function draw_shape(shape:Shape):void{
			if (shape.isCircle()){
				var circle:Circle=shape.castCircle;
				drawCircle(circle.worldCOM,circle.radius,_color);
				trace("drawCircle(circle.worldCOM,circle.radius,_color)");
			}else{
				var poly:Polygon= shape.castPolygon;
				drawPolygon(poly,_color);
			}
			
			
		}
		override public function drawAABB(aabb:AABB, colour:int):void{
			g.lineStyle(_lineWidth,colour&0xffffff,1);
			g.drawRect(aabb.x,aabb.y,aabb.width,aabb.height);
		}
		override public function drawCircle(position:Vec2, radius:Number, colour:int):void{
			g.lineStyle(_lineWidth,colour&0xffffff,1);
			g.drawCircle(position.x,position.y,radius);
		}
		override public function drawCurve(start:Vec2, control:Vec2, end:Vec2, colour:int):void{
			g.lineStyle(_lineWidth,colour&0xffffff,1);
			g.moveTo(start.x,start.y);
			g.curveTo(control.x,control.y,end.x,end.y);
		}
		override public function drawFilledCircle(position:nape.geom.Vec2, radius:Number, colour:int):void{
			g.lineStyle(0,0,0);
			g.beginFill(colour&0xffffff,1);
			g.drawCircle(position.x,position.y,radius);
			g.endFill();
		}
		
		override public function drawFilledPolygon(polygon:*, colour:int):void{
			g.beginFill(colour&0xffffff,1.0);
			g.lineStyle(0,0,0);
			var fst:Point = null;
			var fsttime:Boolean = true;
			for each(var p:* in polygon ){
				if(fsttime) { 
					fst = p.copy(); g.moveTo(p.x,p.y); 
				} else 
					g.lineTo(p.x,p.y); fsttime = false;
			}
			g.lineTo(fst.x,fst.y);
		}
		override public function drawFilledTriangle(p0:Vec2, p1:Vec2, p2:Vec2, colour:int):void{
			g.lineStyle(0,0,0);
			g.beginFill(colour&0xffffff,1);
			g.moveTo(p0.x,p0.y);
			g.lineTo(p1.x,p1.y);
			g.lineTo(p2.x,p2.y);
			g.endFill();
		}
		override public function drawLine(start:Vec2, end:Vec2, colour:int):void{
			g.lineStyle(_lineWidth,colour&0xffffff,1);
			g.moveTo(start.x,start.y);
			g.lineTo(end.x,end.y);
		}
		override public function drawPolygon(polygon:*, colour:int):void{
			g.lineStyle(0.1,colour&0xffffff,1.0);
			/*var fst:Point = null;
			var fsttime:Boolean = true;
			for each(var p:* in polygon ){
				if(fsttime) { 
					fst = p.copy(); 
					g.moveTo(p.x,p.y); 
				} else 
					g.lineTo(p.x,p.y); fsttime = false;
			}
			g.lineTo(fst.x,fst.y);*/
			var p:Polygon= polygon as Polygon;
			var fst:Vec2 = p.localVerts.at(0);
			var pt:Vec2;
			g.moveTo(fst.x,fst.y); 
			for (var i:int=1;i<p.localVerts.length;i++)
			{
				pt= p.localVerts.at(i);
				g.lineTo(pt.x,pt.y);
			}
			
			
		}
		override public function drawSpring(start:Vec2, end:Vec2, colour:int, coils:int = 3, radius:Number = 3.0):void{
			//__debug_spring(start,end,colour,coils,radius)
		}
		override public function flush():void{

		}
		override public function clear():void{
			g.clear();
		}
	}
}