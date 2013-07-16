/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Bike extends ArmyObject 
	{
		
		public function Bike(startId:int, healthModifier:Number) 
		{
			this.speed = 3;
			this.modifier = healthModifier;
			this.healthTotal = 200 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.BIKE];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.BIKE];
			this.score = 250;
			
			super(startId);
		}
		
	}

}