/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package switcher.models
{
	public class User
	{
		
		private var _score:int=0;
		public function User()
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