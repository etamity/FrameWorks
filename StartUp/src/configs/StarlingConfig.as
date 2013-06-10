package configs
{
	import com.smart.loaders.ResourcesManager;
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.mvsc.GameContent;
	import com.smart.mvsc.GameContentMediator;
	import com.smart.mvsc.controllers.commands.DataInitCommand;
	import com.smart.mvsc.controllers.commands.DataLoadedCommand;
	import com.smart.mvsc.controllers.commands.StartupCommand;
	import com.smart.mvsc.controllers.signals.SystemEvent;
	import com.smart.mvsc.model.SignalBus;
	import com.smart.mvsc.services.ThemeService;
	import solutions.views.starling.mediators.MainMediator;
	import solutions.views.starling.mediators.MenuMediator;
	import com.smart.mvsc.views.starlingviews.StageMediator;
	import solutions.views.starling.screens.MainScreen;
	import solutions.views.starling.screens.MenuScreen;
	
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;
	
	import starling.display.Stage;

	public class StarlingConfig implements IConfig
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
		public function configure() : void
		{
			mapSingletons();
			mapViews();
			mapSignals();

		}

		private function mapViews():void{
			mediatorMap.map(MainScreen).toMediator(MainMediator);
			mediatorMap.map(MenuScreen).toMediator(MenuMediator);
			mediatorMap.map(GameContent).toMediator(GameContentMediator);
			mediatorMap.map(Stage).toMediator(StageMediator);
		}
		
		private function mapSingletons():void {
			signalBus=injector.getOrCreateNewInstance(SignalBus);
			injector.map(SignalBus).toValue(signalBus);
			injector.map(ConsoleCommand).toValue(ConsoleCommand.getInstance());
			injector.map(ResourcesManager).toValue(ResourcesManager.instance);
			injector.map(ThemeService).asSingleton();
			
		}
		private function mapSignals():void{
			commandMap.mapSignal(signalBus.signal(SystemEvent.STARTUP),StartupCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.DATA_INIT),DataInitCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.DATA_LOADED),DataLoadedCommand);
		}
	}
}