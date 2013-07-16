/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.BmpData;

	public class Bike extends ArmyBase 
	{
		
		public function Bike(startId:int, healthModifier:Number) 
		{
			this.speed = 3;
			this.modifier = healthModifier;
			this.healthTotal = 200 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.BIKE];
			this.bmpPoint = BmpData.bmpPoints[BmpData.BIKE];
			this.score = 250;
			
			super(startId);
		}
		
	}

}