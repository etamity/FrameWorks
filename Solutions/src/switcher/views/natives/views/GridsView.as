/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import switcher.views.natives.interfaces.IBaseView;
	
	public class GridsView extends Sprite implements IBaseView
	{
		public var stoneView:Sprite= new Sprite();
		
		public var cellsView:Sprite=new Sprite();
		
		public var spinView:Sprite=new Sprite();
		
		public function GridsView()
		{
			super();
			x=320;
			y=100;
			addChild(stoneView);
			addChild(cellsView);
			addChild(spinView);
		}
		public function addMask(shape:Shape):void{

			mask=shape;
			addChild(shape);
		}
		public function removeMask():void{
			if (mask!=null)
				removeChild(mask);
		}
		
	}

}