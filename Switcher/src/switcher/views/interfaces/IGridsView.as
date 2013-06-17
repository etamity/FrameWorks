package switcher.views.interfaces
{
	import flash.display.MovieClip;

	public interface IGridsView extends IBaseView
	{
		function get stoneView():MovieClip;
		function get cellsView():MovieClip;
		function get spinView():MovieClip;
		function get mainView():MovieClip;
	}
}