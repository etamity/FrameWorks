package com.smart.physis
{
	import com.smart.core.IPlugin;
	import com.smart.core.Plugin;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	public class PhysisEngine extends Plugin
	{
		private var _gravity:Vec2;
		private var _space:Space;
		private var _debug:Boolean =true;
		public function PhysisEngine(gravx:Number=0,gravy:Number=0,debug:Boolean=true)
		{
			super();
			_debug=debug;
			_gravity=new Vec2(gravx,gravy);
			_space = new Space(_gravity);
	
		}
		override public function onTrigger(time:Number):void{
			space.step(time);
		}
		
		
		public function addWall():void{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			var floor:Body = new Body(BodyType.STATIC);
			floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
			floor.space = space;
		}
		
		override public function onRegister(engine:IPlugin):void{
			
			
			addWall();
			
		}
		
		public function get space():Space{
			return _space;
		}
	}
}