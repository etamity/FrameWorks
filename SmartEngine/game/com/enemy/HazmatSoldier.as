package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
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