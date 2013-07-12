package com.smart.game.tower.scenes
{
	import com.data.BmpData;
	import com.data.EnemyFormat;
	import com.smart.core.SmartGame;
	import com.smart.core.SmartScene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class GameScene extends SmartScene
	{
		public function GameScene(game:SmartGame)
		{
			super(game);
		}
		
		override protected function initialize():void{
			var texture:Texture=  Texture.fromBitmapData(BmpData.bmpDatas[BmpData.BIKE][0][0]);
			
			var image:Image= new Image(BmpData.Textures[BmpData.BIKE][0][0]);
			//addChild(image);
			
			var vectorTextures:Vector.<Texture>=Vector.<Texture>(BmpData.bmpTextures[BmpData.HEAVYSOLDIER][EnemyFormat.MOVE_90]);
			var mc:MovieClip =new MovieClip(vectorTextures,25);
			addChild(mc);
			mc.play();
			Starling.juggler.add(mc);	
		}
		
		public function start():void{
			/*var map:Map = new Map();
			map.x = 18;
			map.y = 36;
			addChildAt(map, 0);
			var attack:AutoAttack = new AutoAttack();*/
		}

	}
}