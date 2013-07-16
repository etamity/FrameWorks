/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class HeavySoldier extends ArmyObject 
	{
		
		public function HeavySoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 1.9;
			this.healthTotal = 150 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.HEAVYSOLDIER];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.HEAVYSOLDIER];
			this.score = 150;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}