/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.enemy 
{
	import com.data.BmpData;

	public class Plane extends PlaneBase 
	{
		
		public function Plane(startId:int, healthModifier:Number) 
		{
			this.speed = 2.5;
			this.healthTotal = 300 * healthModifier;
			this.bmpData = BmpData.Textures[BmpData.PLANE];
			this.bmpPoint = BmpData.bmpPoints[BmpData.PLANE];
			this.score = 700;
			
			super(startId);
		}
		
	}

}