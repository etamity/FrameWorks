//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.map.display {

	import com.smart.core.AssetsManager;
	import com.smart.core.IComponent;
	import com.smart.core.SmartObject;
	import com.smart.engine.map.components.AsyncTexture;
	import com.smart.engine.map.utils.Point3D;
	import com.smart.engine.map.utils.State;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import com.smart.engine.map.layer.ILayerDisplay;

	public class SmartDisplayObject extends SmartObject{
		public var textureName:String;
		
		public var position:Point3D;
		public var state:State;
		public var type:String;
		internal var layer:ILayerDisplay;
		internal var layerIndex:int = -1;
		private var async:AsyncTexture;
		private var components:Vector.<IComponent>; 
		public var _assetID:String;
		public function SmartDisplayObject(textureName:String, pt:Point3D = null, state:State = null) {
			this.textureName = textureName;
			this.state = state != null ? state : new State();
			this.position = pt != null ? pt : new Point3D();
			changeTo(textureName);
		}
		override public function remove(component:IComponent):void {
			super.remove(component);
			if (component == async) {
				async = null;
			}
		}


		public function changeTo(textureName:String):void {
			if (async) {
				remove(async);
			}
			//addComponent(async = new AsyncTexture(textureName));
			display=new Image(AssetsManager.instance.getTexture(textureName));
			/*display.x=position.x;
			display.y=position.y;*/
		}

		public function get display():DisplayObject {
			throw new Error("method get display() must be overridden");
		}

		public function set display(val:DisplayObject):void {
			throw new Error("method set display() must be overridden");
		}

		public function get index():int{
			return this.layerIndex;
		}
		public function set index(val:int):void{
			layerIndex =val;
		}
		public function get x():Number {
			return position.x;
		}

		public function set x(val:Number):void {
			position.x = x;
		}

		public function get y():Number {
			return position.y;
		}

		public function set y(val:Number):void {
			position.y = y;
		}
	}
}
