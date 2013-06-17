/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.mobile.views
{
	import com.core.mvsc.model.Utils;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	import switcher.views.interfaces.IGridsView;
	
	public class GridsView extends GridsViewAsset implements IGridsView
	{
		
		private var _cellsView:MovieClip=new MovieClip();
		
		private var _spinView:MovieClip=new MovieClip();
		
		private var _mask:Shape;
		public function GridsView()
		{
			super();
			
			_mask=Utils.generateMask("GRIDSVIEWMASK");
			mask=_mask;
			_cellsView.x=_spinView.x=_mask.x=layoutView.x;
			_cellsView.y=_spinView.y=_mask.y=layoutView.y;
			addChild(_cellsView);
			addChild(_spinView);


		}
		public function get mainView():MovieClip{
			return this;
		}
		public function get stoneView():MovieClip{
			return layoutView;
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