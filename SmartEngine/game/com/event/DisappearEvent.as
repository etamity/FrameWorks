package com.event 
{
	import com.enemy.EnemyBase;
	
	import starling.events.Event;

	
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
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