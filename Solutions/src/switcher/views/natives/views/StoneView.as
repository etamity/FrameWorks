package switcher.views.natives.views
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import caurina.transitions.Tweener;
	
	import org.osflash.signals.Signal;

	public class StoneView extends MovieClip
	{
		private var _index:int;
		private var _type:String;
		private var _mc:MovieClip;
		
		public var clickSignal:Signal=new Signal();
		public function StoneView()
		{
	
		}
		public function get index():int{
			return _index;
		}
		public function get type():String{
			return _type;
		}

		public function set index(val:int):void{
			_index=val;
		}
		public function set type(val:String):void{
			_type =val;
		}
		public function blinking(val:Boolean):void{
			if (val)
				blink();
			else
				Tweener.removeTweens(this);
		}
		
		private function blink():void{
			function onFinishedFadeOut():void{
				Tweener.addTween(this,{alpha:1,time:0.3,onComplete:onFinishedFadeIn});
			}
			function onFinishedFadeIn():void{
				blink();
			}
			this.alpha=1;
			Tweener.addTween(this,{alpha:0.5,time:0.3,onComplete:onFinishedFadeOut});
		}
		
		public function enableEvents(val:Boolean):void{
			if (val)
			{
				addEvents(this);
			}else
			{
				removeEvents(this);
			}
			blinking(val);
		}
		public function addEvents(mc:MovieClip):void{
			mc.buttonMode=true;
			mc.addEventListener(MouseEvent.CLICK,doClickEvent);
		}
		private function removeEvents(mc:MovieClip):void{
			mc.buttonMode=false;
			mc.removeEventListener(MouseEvent.CLICK,doClickEvent);
		}
		private function doClickEvent(evt:MouseEvent):void{
			clickSignal.dispatch(this);
		}
	}
}