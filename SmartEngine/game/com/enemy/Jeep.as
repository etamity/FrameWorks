package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
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