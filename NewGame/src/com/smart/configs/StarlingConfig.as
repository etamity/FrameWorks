package com.smart.configs
{
	import com.smart.GameContent;
	import com.smart.controllers.commands.InitDataCommand;
	import com.smart.controllers.commands.InitFinishedCommand;
	import com.smart.controllers.commands.StartupCommand;
	import com.smart.controllers.signals.SystemEvent;
	import com.smart.loaders.ResourcesManager;
	import com.smart.logs.console.ConsoleCommand;
	import com.smart.model.GameConfig;
	import com.smart.model.SignalBus;
	import com.smart.services.ThemeService;
	import com.smart.views.MainView;
	import com.smart.views.mediators.GameContentMediator;
	import com.smart.views.mediators.MainMediator;
	import com.smart.views.mediators.StageMediator;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.display.Stage;

	public class StarlingConfig implements IConfig
	{
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		[Inject]
		public var injector:IInjector;
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
			//context.afterInitializing(start);
		}
		private function start():void{
			signalBus.dispatch(SystemEvent.STARTUP_SIGNAL);
		}

		private function mapViews():void{
			mediatorMap.map(MainView).toMediator(MainMediator);
			mediatorMap.map(GameContent).toMediator(GameContentMediator);
			mediatorMap.map(Stage).toMediator(StageMediator);
		}
		
		private function mapSingletons():void {
			signalBus=injector.getOrCreateNewInstance(SignalBus);
			injector.map(GameConfig).asSingleton();
			injector.map(SignalBus).toValue(signalBus);
			injector.map(ConsoleCommand).toValue(ConsoleCommand.getInstance());
			injector.map(ResourcesManager).toValue(ResourcesManager.instance);
			injector.map(ThemeService).asSingleton();
			
		}
		private function mapSignals():void{
			commandMap.mapSignal(signalBus.signal(SystemEvent.STARTUP_SIGNAL),StartupCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.INIT_DATA),InitDataCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.INIT_DATA_FINISHED),InitFinishedCommand);
		}
	}
}