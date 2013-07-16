/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class LightSoldier extends ArmyObject 
	{
		
		public function LightSoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 1.5;
			this.healthTotal = 100 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.LIGHTSOLDIER];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.LIGHTSOLDIER];
			this.score = 100;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}