/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Jeep extends ArmyObject 
	{
		
		public function Jeep(startId:int, healthModifier:Number) 
		{
			this.speed = 2;
			this.healthTotal = 650 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.JEEP];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.JEEP];
			this.score = 600;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}