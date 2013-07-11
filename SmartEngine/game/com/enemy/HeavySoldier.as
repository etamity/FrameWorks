package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class HeavySoldier extends ArmyBase 
	{
		
		public function HeavySoldier(startId:int, healthModifier:Number) 
		{
			this.speed = 1.9;
			this.healthTotal = 150 * healthModifier;
			this.bmpData = BmpData.bmpDatas[BmpData.HEAVYSOLDIER];
			this.bmpPoint = BmpData.bmpPoints[BmpData.HEAVYSOLDIER];
			this.score = 150;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}