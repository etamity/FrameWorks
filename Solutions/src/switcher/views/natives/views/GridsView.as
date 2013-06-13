package switcher.views.natives.views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import switcher.views.natives.interfaces.IBaseView;
	
	public class GridsView extends Sprite implements IBaseView
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
		public function addMask(shape:Shape):void{

			this.mask=shape;
			addChild(shape);
		}
		
	}

}