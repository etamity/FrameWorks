/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.BmpData;

	public class Blimp extends PlaneBase 
	{
		
		public function Blimp(startId:int, healthModifier:Number) 
		{
			this.speed = 0.25;
			this.healthTotal = 60000 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.BLIMP];
			this.bmpPoint = BmpData.bmpPoints[BmpData.BLIMP];
			this.score = 10000;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}