package  com.core.mvsc.model 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	public class SMButton extends Sprite
	{
		private var button:SimpleButton;
		public var url:String;
		private var _label:String;
		
		public var upStateText:TextField;
		private var _params:Object=new Object();
		public function SMButton(btn:SimpleButton)
		{
			super();
			button=btn;
			var sp:DisplayObjectContainer=button.upState as DisplayObjectContainer;
			if (sp!=null) {
				var n:uint=sp.numChildren;
				for (var i:int=0; i < n; i++) {
					var txt:*= sp.getChildAt(i);
					if (txt!=null)
					if (txt is TextField) {
						upStateText= TextField(txt);
					}
				}
			}
		}
		public function get params():Object{
			return _params;
		}
		public function set params(val:Object):void{
			_params=val;
		}
		public function set label(text:String):void{
			update(text);
		}
		
		public function get label():String{
			return _label;
		}
		public function set enabled(val:Boolean):void{
		
			button.enabled=val;
			button.mouseEnabled=val;
			if (val==false)
			{
			button.alpha= 0.8;
		
			}
			else
			{
			button.alpha= 1;
			}
		}
		public function get enabled():Boolean{
			return button.enabled;
		}
		public function get skin():SimpleButton{
			return button;
		}
		private function update(text:String):void {
			_label=text;
			updateText(button.upState, text);
			updateText(button.overState, text);
			updateText(button.downState, text);
			
			
		}
		public function updateText(o:DisplayObject,text:String):void {
			var sp:DisplayObjectContainer=o as DisplayObjectContainer;
			if (sp!=null) {
				var n:uint=sp.numChildren;
				for (var i:int=0; i < n; i++) {
					var txt:*= sp.getChildAt(i);
					if (txt is TextField) {
						TextField(txt).text=text;
						TextField(txt).mouseEnabled=false;
					}
				}
			}
		}
		
	}
}