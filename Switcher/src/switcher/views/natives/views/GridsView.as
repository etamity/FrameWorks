/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views
{
	import com.core.mvsc.model.Utils;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	import switcher.views.interfaces.IGridsView;
	
	public class GridsView extends MovieClip implements IGridsView
	{
		public var _stoneView:MovieClip= new MovieClip();
		
		public var _cellsView:MovieClip=new MovieClip();
		
		public var _spinView:MovieClip=new MovieClip();
		
		private var _mask:Shape;
		
		public function GridsView()
		{
			super();
			_mask=Utils.generateMask("GRIDSVIEWMASK");
			mask=_mask;
			x=320;
			y=100;
			addChild(_stoneView);
			addChild(_cellsView);
			addChild(_spinView);

		}
		public function get mainView():MovieClip{
			return this;
		}
		public function get stoneView():MovieClip{
			return _stoneView;
		}
		public function get cellsView():MovieClip{
			return _cellsView;
		}
		public function get spinView():MovieClip{
			return _spinView;
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