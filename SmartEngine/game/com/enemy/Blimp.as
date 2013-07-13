package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
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