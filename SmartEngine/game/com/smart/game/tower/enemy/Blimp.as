/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Blimp extends PlaneBase 
	{
		
		public function Blimp(startId:int, healthModifier:Number) 
		{
			this.speed = 0.25;
			this.healthTotal = 60000 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.BLIMP];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.BLIMP];
			this.score = 10000;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}