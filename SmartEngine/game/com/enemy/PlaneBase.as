package com.enemy 
{
	import flash.events.TimerEvent;
	import com.data.EnemyFormat;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class PlaneBase extends EnemyBase 
	{
		public function PlaneBase(startId:int) 
		{
			this.startPoint = startId;
			super();
		}
		
		override protected function move(e:TimerEvent):void
		{
			this.setPoint(this.x + this.speed * 1.5, this.y);
			super.move(e);
		}
	}

}