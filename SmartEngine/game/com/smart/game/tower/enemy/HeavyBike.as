/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class HeavyBike extends ArmyObject 
	{
		
		public function HeavyBike(startId:int, healthModifier:Number) 
		{
			this.speed = 2.5;
			this.healthTotal = 300 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.HEAVYBIKE];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.HEAVYBIKE];
			this.score = 350;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}