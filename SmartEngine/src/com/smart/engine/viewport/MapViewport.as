//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.viewport {

	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.smart.engine.display.ILayerDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartSprite;
	import com.smart.engine.utils.Point3D;
	import starling.display.DisplayObject;
	import starling.display.Image;

	public class MapViewport implements IProjection {
		public static var TYPE_ISOMETRIC:String  = "isometric";
		public static var TYPE_ORTHOGONAL:String = "orthogonal";

		public function MapViewport(type:String, cellWidth:Number, cellHeight:Number) {

			pt = new Point();
			projection = new Matrix();

			var scale:Number  = 1;
			var length:Number = Math.sqrt(cellWidth * cellWidth + cellHeight * cellHeight);

			if (type == TYPE_ISOMETRIC) {
				projection.rotate(45 * (Math.PI / 180));
				scale = 1.4142137000082988; 
				//scale = 1.5;
				projection.scale(scale * 1, scale * .5);
			}
			else if (type == TYPE_ORTHOGONAL) {
				projection.rotate(0);
				//scale = 1.24;
				scale = 1;
				projection.scale(scale * 1, scale * 1);
			}
			else {
				throw new Error("Invalid projection type: " + type);
			}


			projectionInverse = (projection.clone());
			projectionInverse.invert();
			projection.translate(-cellHeight, cellHeight);
		}

		private var projection:Matrix;
		private var projectionInverse:Matrix;
		private var pt:Point;

		public function layerToScreen(Pt3D:Point3D):Point {
			return projection.transformPoint(Pt3D);
		}

		public function onRemove():void {

		}

		public function onSetup(grid:ILayerDisplay):void {

		}

		public function perSprite(sprite:SmartDisplayObject):void {
			var isoPt:Point         = sprite.position;
			var image:DisplayObject = sprite.display;
			pt = projection.transformPoint(isoPt);
			image.x = pt.x;
			image.y = pt.y;
		}

		public function screenToLayer(pt:Point):Point3D {
			var newPt:Point = projectionInverse.transformPoint(pt);
			return new Point3D(newPt.x, newPt.y);
		}
	}

}

