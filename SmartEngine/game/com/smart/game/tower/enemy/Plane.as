/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Plane extends PlaneBase 
	{
		
		public function Plane(startId:int, healthModifier:Number) 
		{
			this.speed = 2.5;
			this.healthTotal = 300 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.PLANE];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.PLANE];
			this.score = 700;
			
			super(startId);
		}
		
	}

}