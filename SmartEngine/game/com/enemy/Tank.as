package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Tank extends ArmyBase 
	{
		
		public function Tank(startId:int, healthModifier:Number) 
		{
			this.speed = 1;
			this.healthTotal = 8000 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.TANK];
			this.bmpPoint = BmpData.bmpPoints[BmpData.TANK];
			this.score = 1000;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}