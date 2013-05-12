package com.smart.services
{
	import com.smart.loaders.ResourcesManager;
	import com.smart.model.Actor;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.utils.Color;

	public class ThemeService extends Actor
	{
		private var _theme:MetalWorksMobileTheme;
		[Inject]
		public var assets:ResourcesManager;
		
		public static const HEADER_MONEY_LABEL:String= "HEADER_MONEY_LABEL";
		public static const HEADER_PLAYERBAR:String= "HEADER_PLAYERBAR";
		public function ThemeService()
		{
			super();
			this._theme = new MetalWorksMobileTheme(Starling.current.stage);

		}
		
		public function update():void{
			_theme.setInitializerForClass(Header, headerInitializer,HEADER_PLAYERBAR);
			_theme.setInitializerForClass(Label, headerMoneyLabel,HEADER_MONEY_LABEL);
			//_theme.setInitializerForClass(Button, headerButtonLabel);
		}
		private function headerButtonLabel(button:Button):void{
			//button.disabledLabelProperties.textFormat = new TextFormat( "Arial", 14, Color.MAROON, true);
		}
		private function headerMoneyLabel(label:Label):void{
			label.textRendererProperties.textFormat = new TextFormat( "Arial", 14, Color.MAROON, true);
		}
		
		private function headerInitializer(header:Header):void
		{
			var texture:Scale9Textures=new Scale9Textures(assets.getTexture("loading-panel"),new Rectangle(10,10,10,10));
			var backgroundSkin:Scale9Image=new Scale9Image(texture);
			header.backgroundSkin = backgroundSkin;
			/*header.titleFactory= function():ITextRenderer
			{
				var textRender:TextFieldTextRenderer =new TextFieldTextRenderer();
				textRender.textFormat = new TextFormat( "Arial", 20,   );
				return 
			};*/
			header.gap=0;
			header.paddingLeft=20;
			header.paddingRight=20;
			header.backgroundDisabledSkin=backgroundSkin;
			
		}
	}
}