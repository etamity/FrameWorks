package com.smart.game.tower.enemy 
{
	import com.smart.game.tower.data.GraphicsData;

	public class Chopper extends PlaneBase 
	{
		
		public function Chopper(startId:int, healthModifier:Number) 
		{
			this.speed = 1.5;
			this.healthTotal = 650 * healthModifier;
			this.bmpData = GraphicsData.Textures[GraphicsData.CHOPPER];
			this.bmpPoint = GraphicsData.bmpPoints[GraphicsData.CHOPPER];
			this.score = 700;
			this.modifier = healthModifier;
			
			super(startId);
		}
		
	}

}