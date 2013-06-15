/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views
{
	import switcher.models.ScrollingText;

	public class GamePanelView extends GamePanelAsset
	{
		private var scoreLabel:ScrollingText;
		public function GamePanelView()
		{
			super();
			bombMc.stop();
			
			/*scoreTxt.visible=false;
			
			
			scoreLabel=new ScrollingText();
			scoreLabel.x=scoreTxt.x;
			scoreLabel.y=scoreTxt.y-7;
			addChild(scoreLabel);*/
		}
		
		public function set time(val:String):void{
			this.timeTxt.text=val;
		}
		public function set score(val:String):void{
			scoreTxt.text=val;
		}
	}
}