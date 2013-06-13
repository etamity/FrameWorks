package switcher.views.natives.views
{
	public class GamePanelView extends GamePanelAsset
	{
		public function GamePanelView()
		{
			super();
			bombMc.stop();
		}
		
		public function time(val:String):void{
			this.timeTxt.text=val;
		}
		public function score(val:String):void{
			this.scoreTxt.text=val;
		}
	}
}