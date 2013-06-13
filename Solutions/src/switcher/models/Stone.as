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
				stone=GameModel.stoneDict[rn];
			}
				
			addChild(createStoneMc(stone));
			_type=stone;
		}
		
		public function createStoneMc(stone:String):MovieClip{
			var mc:MovieClip;
			switch (stone){
				case StoneType.BLUE:
					mc= new BlueAsset();
					break;
				case StoneType.GREEN:
					mc= new GreenAsset();
					break;
				case StoneType.PURPLE:
					mc= new PurpleAsset();
					break;
				case StoneType.RED:
					mc= new RedAsset();
					break;
				case StoneType.YELLOW:
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