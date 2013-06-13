package switcher.models
{
	import flash.display.MovieClip;
	
	public class Stone extends MovieClip
	{
		private var _type:String;
		public function Stone(stone:String="")
		{
			super();
			
			if (stone=="")
			{
				var rn:int = Math.random()* 5 ;
				stone=String(rn);
			}
				
			addChild(createStoneMc(stone));
			_type=stone;
		}
		
		public function createStoneMc(stone:String):MovieClip{
			var mc:MovieClip;
			switch (stone){
				case StoneType.BLUE:
				case "0":
					mc= new BlueAsset();
					break;
				case StoneType.GREEN:
				case "1":
					mc= new GreenAsset();
					break;
				case StoneType.PURPLE:
				case "2":
					mc= new PurpleAsset();
					break;
				case StoneType.RED:
				case "3":
					mc= new RedAsset();
					break;
				case StoneType.YELLOW:
				case "4":
					mc=new YellowAsset();
					break;
			}
			return mc;
		}
		public function get type():String{
			return _type;
		}
		
		public function set type(val:String):void{
			_type =val;
		}
	}
}