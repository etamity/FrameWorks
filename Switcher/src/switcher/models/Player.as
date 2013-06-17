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
		private var _spins:int=0;
		private var _lives:int=0;
		public function Player()
		{
		}
		public function get spins():int{
			return _spins;
			
		}
		public function set spins(val:int):void{
			_spins=val;
			
		}
		public function get lives():int{
			return _lives;
			
		}
		public function set lives(val:int):void{
			_lives=val;
			
		}
		public function get score():int{
			return _score;
			
		}
		public function set score(val:int):void{
			 _score=val;
			
		}
	}
}