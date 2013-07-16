/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class HazmatSoldier extends ArmyObject 
	{
		
		public function HazmatSoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 2;
			this.healthTotal = 100 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.HAZMATSOLDIER];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.HAZMATSOLDIER];
			this.score = 100;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}