/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import caurina.transitions.Tweener;
	
	import org.osflash.signals.Signal;
	
	import switcher.models.Node;
	import switcher.models.Stone;

	public class CellView extends CellAsset
	{
		public var clickSignal:Signal=new Signal();
		
		public var node:Node=new Node();
		
		public var index:int;

		public var cellx:int;
		public var celly:int;
		
		private var _stone:Stone;
		
		private var eventEnabled:Boolean=false;
		
		public function CellView()
		{
			node.data=this;
			this.alpha=0;
		}

		public function get stone():Stone{
			return _stone;
		}
		public function set stone(val:Stone):void{
			_stone=val;
		}
		public function switchStone(target:Node):void{
			var temp:Stone=_stone;
			_stone= target.data.stone;
			target.data.stone=temp;
			
		}
	
		
		public function blinking(val:Boolean):void{
			if (val)
				blink();
			else
			{
				if (_stone!=null)
				{
				Tweener.removeTweens(_stone);
				_stone.alpha=1;
				}
			}
		}
		
		private function blink():void{
		
			function onFinishedFadeOut():void{
				Tweener.addTween(_stone,{alpha:1,time:0.3,onComplete:onFinishedFadeIn});
			}
			function onFinishedFadeIn():void{
				blink();
			}
			if (_stone!=null)
			{
			_stone.alpha=1;
			Tweener.addTween(_stone,{alpha:0.5,time:0.3,onComplete:onFinishedFadeOut});
			}
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
			if (eventEnabled==false)
			{
			eventEnabled=true;
			mc.buttonMode=true;
			mc.addEventListener(MouseEvent.CLICK,doClickEvent);
			}
		}
		private function removeEvents(mc:MovieClip):void{
			eventEnabled=false;
			mc.buttonMode=false;
			mc.removeEventListener(MouseEvent.CLICK,doClickEvent);
		}
		private function doClickEvent(evt:MouseEvent):void{
			clickSignal.dispatch();
		}
	}
}