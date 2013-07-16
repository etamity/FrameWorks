/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.BmpData;

	public class Jeep extends ArmyBase 
	{
		
		public function Jeep(startId:int, healthModifier:Number) 
		{
			this.speed = 2;
			this.healthTotal = 650 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.JEEP];
			this.bmpPoint = BmpData.bmpPoints[BmpData.JEEP];
			this.score = 600;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}