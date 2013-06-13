package switcher.views.natives.views
{
	import flash.display.Sprite;
	
	public class GridsView extends Sprite
	{
		public var stoneView:Sprite= new Sprite();
		
		public var cellsView:Sprite=new Sprite();
		
		public function GridsView()
		{
			super();
			x=320;
			y=100;
			addChild(stoneView);
			addChild(cellsView);
		}
		
	}

}