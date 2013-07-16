/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.enemy 
{
	import com.data.BmpData;

	public class Robot extends ArmyBase 
	{
		
		public function Robot(startId:int, healthModifier:Number) 
		{
			this.speed = 1;
			this.healthTotal = 30000 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.ROBOT];
			this.bmpPoint = BmpData.bmpPoints[BmpData.ROBOT];
			this.score = 4000;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}