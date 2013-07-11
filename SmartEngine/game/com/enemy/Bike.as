package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Bike extends ArmyBase 
	{
		
		public function Bike(startId:int, healthModifier:Number) 
		{
			this.speed = 3;
			this.modifier = healthModifier;
			this.healthTotal = 200 * healthModifier;
			this.bmpData = BmpData.bmpDatas[BmpData.BIKE];
			this.bmpPoint = BmpData.bmpPoints[BmpData.BIKE];
			this.score = 250;
			
			super(startId);
		}
		
	}

}