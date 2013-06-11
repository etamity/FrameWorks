package switcher.views.natives.views
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import switcher.models.StoneType;
	
	public class CellsView extends Sprite
	{
		public function CellsView()
		{
			super();
		}

		public function createStones(stone:String):MovieClip{
			var mc:MovieClip;
			switch (stone){
				case StoneType.BLUE:
					mc= new BlueAsset();
				case StoneType.GREEN:
					mc= new GreenAsset();
				case StoneType.PURPLE:
					mc= new PurpleAsset();
				case StoneType.RED:
					mc= new RedAsset();
				case StoneType.YELLOW:
					mc=new YellowAsset();
			}
			return mc;
		}
		
	}

}