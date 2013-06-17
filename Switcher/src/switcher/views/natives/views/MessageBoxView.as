/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.views.natives.views
{
	public class MessageBoxView extends MessageBoxAsset
	{
		public function MessageBoxView()
		{
			super();
			visible=false;

		}
		
		public function set score(val:String):void{
			scoreTxt.text=val;
		}
		
		public function show():void{
			visible=true;

		}
	}
}