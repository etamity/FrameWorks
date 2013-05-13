package configs
{
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.api.IBundle;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;
	
	public class StarlingBundle implements IBundle
	{
		public function StarlingBundle()
		{
		}
		
		public function extend(context:IContext):void
		{
			context.install(
				MVCSBundle,
				StarlingViewMapExtension,
				SignalCommandMapExtension);
		}
	}
}