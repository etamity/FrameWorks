package com.smart.engine.physics.core
{
	import flash.geom.Point;
	
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.util.Debug;
	
	import starling.display.DisplayObject;
	import starling.display.Graphics;
	import starling.display.Shape;
	
	public class StarlingDebug extends Debug
	{
		private var _display:Shape;
		private var _lineWidth:Number=2;
		public function StarlingDebug(width:int,height:int,bgColor:int, transparent:Boolean=false)
		{
			super();
			_display= new Shape();
	
		}
		private function get g():Graphics{
			return _display.graphics;
		}
		public function get displayStarling():DisplayObject{
			return _display;
		}
		override public function draw(object:*):void{
			//__debug_draw(object);
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