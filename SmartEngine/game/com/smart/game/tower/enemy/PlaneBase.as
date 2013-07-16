/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import flash.events.TimerEvent;
	import com.smart.game.tower.data.EnemyParser;

	public class PlaneBase extends EnemyObject 
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