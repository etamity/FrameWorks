package com.enemy 
{
	import com.data.BmpData;
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Plane extends PlaneBase 
	{
		
		public function Plane(startId:int, healthModifier:Number) 
		{
			this.speed = 2.5;
			this.healthTotal = 300 * healthModifier;
			this.bmpData = BmpData.bmpDatas[BmpData.PLANE];
			this.bmpPoint = BmpData.bmpPoints[BmpData.PLANE];
			this.score = 700;
			
			super(startId);
		}
		
	}

}