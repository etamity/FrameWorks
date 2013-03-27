//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins
{

	import com.smart.core.IPlugin;
	import com.smart.core.Plugin;
	import com.smart.engine.display.ILayerDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.tmxdata.TMXMapModel;
	import com.smart.engine.utils.Point3D;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import com.smart.engine.MapEngine;


	public class ViewportPlugin extends Plugin implements IViewPort
	{
		public static var TYPE_ISOMETRIC:String="isometric";
		public static var TYPE_ORTHOGONAL:String="orthogonal";
		private var projection:Matrix;
		private var projectionInverse:Matrix;
		private var pt:Point;
		//private var _tmx:TMXMap;
		private var engine:MapEngine;

		private var _cellH:Number;
		
		//private var sortSprite:SmartDisplayObject;
		
		public function ViewportPlugin(projectionType :String ,cellwidth:Number, cellheight:Number)
		{
			var type:String=projectionType;
			var cellWidth:Number=cellwidth;
			var cellHeight:Number=cellheight;
			_cellH=cellHeight;
			pt=new Point();
			projection=new Matrix();
			
			var scale:Number=1;
			var length:Number=Math.sqrt(cellWidth * cellWidth + cellHeight * cellHeight);
			
			if (type == TYPE_ISOMETRIC)
			{
				projection.rotate(45 * (Math.PI / 180));
				scale=1.4142137000082988;
				//scale = 1.5;
				projection.scale(scale * 1, scale * .5);
			}
			else if (type == TYPE_ORTHOGONAL)
			{
				projection.rotate(0);
				//scale = 1.24;
				scale=1;
				projection.scale(scale * 1, scale * 1);
			}
			else
			{
				throw new Error("Invalid projection type: " + type);
			}
			
			
			projectionInverse=(projection.clone());
			projectionInverse.invert();
			projection.translate(-cellHeight, cellHeight);
		}
		
		public function get renderType():String{
			return null;
		}
		
		public function get width():int{
			return stage.stageWidth;
		}
		public function get height():int{
			return stage.stageHeight;
		}
		override public function onTrigger(time:Number):void {

		}
		
		override public function onRegister(engine:IPlugin):void {
			//super.onRegister(engine);
			this.engine = engine as MapEngine;

			
		}
		override public function onRemove():void
		{
			super.onRemove();
		}

		public function layerToScreen(Pt3D:Point3D):Point
		{
			return projection.transformPoint(Pt3D);
		}

		public function onSetup(grid:ILayerDisplay):void
		{

		}

		public function update(sprite:SmartDisplayObject):void
		{
				
			var isoPt:Point=sprite.position;
			var image:DisplayObject=sprite.display;
			pt=projection.transformPoint(isoPt);
			//pt = isoPt;s
			image.x=pt.x - sprite.display.width /2;
			//image.y=pt.y;
			/*image.x = pt.x-sprite.position.z;*/
			image.y=pt.y - (sprite.display.height) +_cellH ;
			
			/*if ((sortSprite!= null) && (sprite.index> sortSprite.index))
			{
				sprite.display.parent.swapChildren(sortSprite.display, sortSprite.display);
				
			}
			sortSprite = sprite;*/
		}

		public function screenToLayer(pt:Point):Point3D
		{
			var newPt:Point=projectionInverse.transformPoint(pt);
			return new Point3D(newPt.x, newPt.y);
		}
	}

}

