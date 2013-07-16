/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Tank extends ArmyObject 
	{
		
		public function Tank(startId:int, healthModifier:Number) 
		{
			this.speed = 1;
			this.healthTotal = 8000 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.TANK];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.TANK];
			this.score = 1000;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}