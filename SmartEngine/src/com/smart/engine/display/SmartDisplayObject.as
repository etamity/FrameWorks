//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.display {

	import com.smart.engine.components.AsyncTexture;
	import com.smart.engine.components.IComponent;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.utils.State;
	
	import starling.display.DisplayObject;

	public class SmartDisplayObject {
		public var name:String;
		public var position:Point3D;
		public var state:State;
		public var type:String;
		internal var layer:ILayerDisplay;
		internal var layerIndex:int = -1;
		private var async:AsyncTexture;
		private var components:Vector.<IComponent>; 
		public var _assetID:String;
		public function SmartDisplayObject(assetID:String, name:String, pt:Point3D = null, state:State = null) {
			this.name = name;
			this.state = state != null ? state : new State();
			this.position = pt != null ? pt : new Point3D();
			_assetID=assetID;
			//trace("_assetID:"+_assetID);
			changeTo(assetID);
		}
		
		public function addComponent(c:IComponent):IComponent {
			if (components == null) {
				components = new Vector.<IComponent>();
			}
			c.onRegister(this);
			components.push(c);
			return c;
		}

		public function changeTo(assetID:String):void {
			if (async) {
				removeComponent(async);
			}
			addComponent(async = new AsyncTexture(assetID));
		}

		public function get display():DisplayObject {
			throw new Error("method get display() must be overridden");
		}

		public function set display(val:DisplayObject):void {
			throw new Error("method set display() must be overridden");
		}

		public function onTrigger(time:Number):void {
			var component:IComponent;
			for each (component in components) {
				component.onTrigger(time); 
			}
		}

		public function remove():void {
			if (layer != null) {
				layer.remove(this);
			}
		}

		public function removeComponent(component:IComponent):void {
			component.onRemove();
			var index:int = components.indexOf(component);
			if (index != -1) {
				components.splice(index, 1);
			}
			if (component == async) {
				async = null;
			}
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
