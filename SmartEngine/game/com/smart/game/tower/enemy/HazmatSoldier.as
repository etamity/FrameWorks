/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.BmpData;

	public class HazmatSoldier extends ArmyBase 
	{
		
		public function HazmatSoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 2;
			this.healthTotal = 100 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.HAZMATSOLDIER];
			this.bmpPoint = BmpData.bmpPoints[BmpData.HAZMATSOLDIER];
			this.score = 100;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}