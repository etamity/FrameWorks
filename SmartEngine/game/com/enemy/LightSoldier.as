package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class LightSoldier extends ArmyBase 
	{
		
		public function LightSoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 1.5;
			this.healthTotal = 100 * healthModifier;
			this.bmpData = BmpData.bmpDatas[BmpData.LIGHTSOLDIER];
			this.bmpPoint = BmpData.bmpPoints[BmpData.LIGHTSOLDIER];
			this.score = 100;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}