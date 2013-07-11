package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Chopper extends PlaneBase 
	{
		
		public function Chopper(startId:int, healthModifier:Number) 
		{
			this.speed = 1.5;
			this.healthTotal = 650 * healthModifier;
			this.bmpData = BmpData.bmpDatas[BmpData.CHOPPER];
			this.bmpPoint = BmpData.bmpPoints[BmpData.CHOPPER];
			this.score = 700;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}