package com.smart.mvsc.model
{
	import nape.phys.Material;
	
	public class MaterialsFactory extends Actor
	{
		public static const GLASS_MATERIAL:String="GLASS_MATERIAL";
		public static const ICE_MATERIAL:String="ICE_MATERIAL";
		public static const RUBBER_MATERIAL:String="RUBBER_MATERIAL";
		public static const SAND_MATERIAL:String="SAND_MATERIAL";
		public static const STEEL_MATERIAL:String="STEEL_MATERIAL";
		public static const WOOD_MATERIAL:String="WOOD_MATERIAL";
		
		
		public static function getMaterial(type:String):Material{
			var result:Material;
			switch (type){
				case GLASS_MATERIAL:
					result= new Material(0.4,0.4,0.94,2.6,0.002);
					break;
				case ICE_MATERIAL:
					result= new Material(0.3,0.03,0.1,0.9,0.0001);
					break;
				case RUBBER_MATERIAL:
					result= new Material(0.8,1.0,1.4,1.5,0.01);
					break;
				case SAND_MATERIAL:
					result= new Material(-1.0,0.45,0.6,1.6,16.0);
					break;
				case STEEL_MATERIAL:
					result= new Material(0.2,0.57,0.74,7.8,0.001);
					break;
				case WOOD_MATERIAL:
					result= new Material(0.4,0.2,0.38,0.7,0.005);
					break;
				default:
					result= new Material();
					break;
			}
			return result;
		}
	}
}