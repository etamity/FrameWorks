package com.smart.game.tower.scenes
{
	import com.map.AutoAttack;
	import com.map.Control;
	import com.map.Map;
	import com.smart.core.SmartGame;
	import com.smart.core.SmartScene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class GameScene extends SmartScene
	{
		public function GameScene(game:SmartGame)
		{
			super(game);
		}
		
		override protected function initialize():void{
		/*	var texture:Texture=  Texture.fromBitmapData(BmpData.bmpDatas[BmpData.BIKE][0][0]);
			
			
			var sp:Sprite=new Sprite();
			var image:Image= new Image(BmpData.Textures[BmpData.BIKE][0][0]);
			//addChild(image);
			
			var vectorTextures:Vector.<Texture>=Vector.<Texture>(BmpData.Textures[BmpData.LIGHTSOLDIER][EnemyFormat.MOVE_90]);
			var mc:MovieClip =new MovieClip(vectorTextures,25);
			sp.addChild(mc);
			addChild(sp);
			mc.play();
			Starling.juggler.add(mc);	*/
			
			start();
		}
		
		public function start():void{
			
			var bg:Image=new Image(Texture.fromBitmap(new AssetEmbeds_3x.frostbite()))
			addChild(bg);
			var map:Map = new Map();
			map.x = 18;
			map.y = 36;
			addChild(map);
			var attack:AutoAttack = new AutoAttack();
			var mc:GameUIAsset=new GameUIAsset();
			var con:Control = new Control(mc, attack);
			Starling.current.nativeStage.addChild(mc);
		}

	}
}