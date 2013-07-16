/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.BmpData;

	public class LightSoldier extends ArmyBase 
	{
		
		public function LightSoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 1.5;
			this.healthTotal = 100 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.LIGHTSOLDIER];
			this.bmpPoint = BmpData.bmpPoints[BmpData.LIGHTSOLDIER];
			this.score = 100;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}