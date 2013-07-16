/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.smart.game.tower.event 
{
	import com.smart.game.tower.enemy.EnemyObject;
	
	import starling.events.Event;


	public class DisappearEvent extends Event 
	{
		public static const DISAPPEAR:String = "disappear";
		
		private var _info:EnemyObject;
		
		public function DisappearEvent(type:String, enemy:EnemyObject) 
		{ 
			_info = enemy;
			super(type, false, false);
		} 
		
		public function get info():EnemyObject 
		{
			return _info;
		}
	}
	
}