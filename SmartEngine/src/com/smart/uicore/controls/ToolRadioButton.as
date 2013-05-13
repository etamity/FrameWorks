package com.smart.uicore.controls 
{
	import com.smart.uicore.controls.managers.SkinLoader;
	import com.smart.uicore.controls.managers.SkinManager;
	import com.smart.uicore.controls.managers.SourceSkinLinkDefine;
	import com.smart.uicore.controls.skin.ActionDrawSkin;
	import com.smart.uicore.controls.skin.ToolRadioButtonSkin;
	import com.smart.uicore.controls.skin.sourceSkin.ToolRadioButtonSourceSkin;
	
	/**
	 * ToolRadioButton 与 ToggleButton 类似，但这一组按钮在同一时刻只有一个是选中的，可以使用此组件方便的创建工具条（类似于Phtoshop左侧的工具栏）。 
	 *  
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see cn.flashk.controls.ToggleButton
	 * 
	 * @author flashk
	 */
	public class ToolRadioButton extends RadioButton
	{
		
		public function ToolRadioButton() 
		{
			super();
			groupName = "defaultToolRadioButtonGroup";
			label = "工具";
		}
		
		override public function setDefaultSkin():void {
			setSkin(ToolRadioButtonSkin);
		}
		
		override public function setSourceSkin():void {
			setSkin(SkinLoader.getClassFromSkinFile(SourceSkinLinkDefine.TOOL_BUTTON));
		}
		
		override public function setSkin(Skin:Class):void {
			if(SkinManager.isUseDefaultSkin == true){
				skin = new Skin();
				ActionDrawSkin(skin).init(this,styleSet);
			}else{
				var sous:ToolRadioButtonSourceSkin = new ToolRadioButtonSourceSkin();
				sous.useCatch = false;
				sous.init(this,styleSet,Skin);
				skin = sous;
			}
		}
		
	}
}