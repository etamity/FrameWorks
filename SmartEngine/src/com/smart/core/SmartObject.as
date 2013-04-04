package com.smart.core
{

	public class SmartObject
	{
		protected var _name:String = "SmartObject";
		private var components:Vector.<IComponent>;
		
		protected var _params:Object;
		public function SmartObject(params:Object = null)
		{
			_params = params;
		}
		public function initialize():void {
			
			if (_params)
				setParameters(this, _params);				
		}
		
		public function get params():Object{
			return _params;
		}
		
		public function setParameters(object:Object, params:Object):void
		{
			for (var param:String in params)
			{
				try
				{
					if (params[param] == "true")
						object[param] = true;
					else if (params[param] == "false")
						object[param] = false;
					else
						object[param] = params[param];
				}
				catch (e:Error)
				{
						trace("Warning: The parameter " + param + " does not exist on " + this);
				}
			}
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