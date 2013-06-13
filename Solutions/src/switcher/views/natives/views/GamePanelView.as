package switcher.views.natives.views
{
	public class GamePanelView extends GamePanelAsset
	{
		public function GamePanelView()
		{
			super();
			bombMc.stop();
		}
		
		public function set time(val:String):void{
			this.timeTxt.text=val;
		}
		public function set score(val:String):void{
			this.scoreTxt.text=val;
		}
	}
}