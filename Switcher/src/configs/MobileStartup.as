/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package configs
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	public class MobileStartup extends Sprite
	{
		public function MobileStartup()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
		}
		private function onAddtoStage(evt:Event):void{
			init();
			
		}
		private function init():void
		{
			const context:IContext = new Context()
				.install(MVCSBundle,
					SignalCommandMapExtension)
				.configure( MobileConfig, 
					new ContextView(this));
		}
		
		
	}
}
