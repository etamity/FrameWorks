package switcher.models
{
	import flash.display.MovieClip;

	public class Cell
	{
		private var _index:int;
		private var _stone:String;
		private var _mc:MovieClip;
		public function Cell()
		{
		}
		public function get index():int{
			return _index;
		}
		public function get stone():String{
			return _stone;
		}
		public function get mc():MovieClip{
			return _mc;
		}
		
		public function set index(val:int):void{
			_index=val;
		}
		public function set stone(val:String):void{
			_stone =val;
		}
		public function set mc(val:MovieClip):void{
			 _mc=val;
		}
	}
}