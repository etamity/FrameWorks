/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Robot extends ArmyObject 
	{
		
		public function Robot(startId:int, healthModifier:Number) 
		{
			this.speed = 1;
			this.healthTotal = 30000 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.ROBOT];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.ROBOT];
			this.score = 4000;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}