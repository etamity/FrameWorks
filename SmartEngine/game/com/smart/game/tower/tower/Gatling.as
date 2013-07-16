/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/


package com.smart.game.tower.tower 
{
	import com.smart.game.tower.data.GraphicsData;
	import com.smart.game.tower.enemy.EnemyObject;
	import flash.utils.setTimeout;

	public class Gatling extends TowerObject 
	{
		public function Gatling() 
		{
			this.defense = 72;
			this.damage = [43, 86, 129];
			this.cost = [5, 4, 4];
			this.bmpData = GraphicsData.Textures[GraphicsData.GATLING];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.GATLING];
			this.reloadTime = 1;
			
			super();
		}
		
		override protected function fire(mc:EnemyObject, angle:Number):void
		{
			this.changeState(true);
			mc.destroy(this.damage[this.level - 1], EnemyObject.DEATH_COMMON);
			setTimeout(timeOut, 10);
		}
		
		protected function timeOut():void 
		{
			this.changeState(false);
		}
	}

}