/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.models
{
	public class Player
	{
		
		private var _score:int=0;
		public function Player()
		{
		}
		
		public function get score():int{
			return _score;
			
		}
		public function set score(val:int):void{
			 _score=val;
			
		}
	}
}