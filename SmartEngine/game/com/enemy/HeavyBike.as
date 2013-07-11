package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class HeavyBike extends ArmyBase 
	{
		
		public function HeavyBike(startId:int, healthModifier:Number) 
		{
			this.speed = 2.5;
			this.healthTotal = 300 * healthModifier;
			this.bmpData = BmpData.bmpDatas[BmpData.HEAVYBIKE];
			this.bmpPoint = BmpData.bmpPoints[BmpData.HEAVYBIKE];
			this.score = 350;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}