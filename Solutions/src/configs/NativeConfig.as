package configs
{
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.mvsc.controllers.commands.DataInitCommand;
	import com.smart.mvsc.controllers.commands.DataLoadedCommand;
	import com.smart.mvsc.controllers.commands.StartupCommand;
	import com.smart.mvsc.controllers.signals.SystemEvent;
	import com.smart.mvsc.model.SignalBus;
	
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	
	public class NativeConfig implements IConfig
	{
		[Inject]
		public var mediatorMap:IMediatorMap;
		[Inject]
		public var injector:Injector;
		[Inject]
		public var commandMap:ISignalCommandMap;
		[Inject]
		public var context:IContext;
		
		protected var signalBus:SignalBus;
		public function NativeConfig()
		{
		}
		
		public function configure():void
		{
			context.install(
				MVCSBundle,
				SignalCommandMapExtension);
			
		}
		private function mapViews():void{

		}
		private function mapSingletons():void {
			signalBus=injector.getOrCreateNewInstance(SignalBus);
			injector.map(SignalBus).toValue(signalBus);
			injector.map(ConsoleCommand).toValue(ConsoleCommand.getInstance());
			
		}
		
		private function mapSignals():void{
			commandMap.mapSignal(signalBus.signal(SystemEvent.STARTUP),StartupCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.DATA_INIT),DataInitCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.DATA_LOADED),DataLoadedCommand);
		}
	}
}