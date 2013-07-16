/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.event 
{
	import com.enemy.EnemyBase;
	
	import starling.events.Event;


	public class DisappearEvent extends Event 
	{
		public static const DISAPPEAR:String = "disappear";
		
		private var _info:EnemyBase;
		
		public function DisappearEvent(type:String, enemy:EnemyBase) 
		{ 
			_info = enemy;
			super(type, false, false);
		} 
		
		public function get info():EnemyBase 
		{
			return _info;
		}
	}
	
}