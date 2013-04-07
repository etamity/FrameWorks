package com.smart.engine.physics.plugins
{
	import com.smart.core.IEngine;
	import com.smart.core.Plugin;
	import com.smart.engine.PhysicsEngine;
	import com.smart.engine.physics.core.PhysicsObject;
	
	import flash.utils.Dictionary;
	
	import nape.phys.Body;
	
	import starling.display.DisplayObject;

	public class PhysicsRenderPlugin extends Plugin
	{
		private var engine:PhysicsEngine;
		private var bodies:Vector.<Body>;
		private var bodyGraphics:Dictionary;
		public function PhysicsRenderPlugin(val:Dictionary=null)
		{
			super();
			bodies= new Vector.<Body>();
			bodyGraphics = val;
		}
		
		public function addGraphics(body:Body):void{
			var graphic:DisplayObject;
			graphic=bodyGraphics[body.userData.name] ;
			if (graphic!=null){
			graphic.pivotX= graphic.width/2;
			graphic.pivotY= graphic.height/2;
			//graphic.scaleX=graphic.scaleY=4;
			body.userData.graphic=graphic;
			this.engine.root.addChild(graphic);
			}
		}
		
		public function render(body:Body):void{
			var graphic:DisplayObject;
			graphic=body.userData.graphic;
			if (graphic!=null)
			{
				graphic.x= body.position.x ;
				graphic.y= body.position.y;
				graphic.rotation= body.rotation;
			}
		}
		public function setImage():void{
			this.engine.space.bodies.foreach(addGraphics);
			
		}
		
		override public function onRegister(engine:IEngine):void{
			this.engine=engine as PhysicsEngine;
		}
		
		override public function onTrigger(time:Number):void{
			this.engine.space.bodies.foreach(render);
		}
	}
}