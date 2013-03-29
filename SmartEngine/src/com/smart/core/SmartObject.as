package com.smart.core
{

	public class SmartObject
	{
		protected var _name:String = "SmartObject";
		private var components:Vector.<IComponent>; 
		public function SmartObject()
		{
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(val:String):void {
			_name = val;
		}
		
		public function dispose():void{
			
		}
		
		public function remove(component:IComponent):void {
			component.onRemove();
			var index:int = components.indexOf(component);
			if (index != -1) {
				components.splice(index, 1);
			}
		}
		public function add(c:IComponent):IComponent {
			if (components == null) {
				components = new Vector.<IComponent>();
			}
			c.onRegister(this);
			components.push(c);
			return c;
		}
		public function onTrigger(time:Number):void {
			var component:IComponent;
			for each (component in components) {
				component.onTrigger(time); 
			}
		}
		
	}
}