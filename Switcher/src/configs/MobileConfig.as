/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package configs
{
	import com.core.mvsc.controllers.commands.DataLoadCommand;
	import com.core.mvsc.controllers.commands.StartupCommand;
	import com.core.mvsc.controllers.signals.SystemEvent;
	import com.core.mvsc.model.SignalBus;
	import com.core.mvsc.services.AnimationService;
	import com.smart.logs.console.ConsoleCommand;
	
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	
	import switcher.models.GameModel;
	import switcher.views.interfaces.IGridsView;
	import switcher.views.mobile.views.GridsView;
	import switcher.views.natives.views.CellView;
	import switcher.views.natives.views.GamePanelView;
	import switcher.views.natives.views.MessageBoxView;
	import switcher.views.natives.views.mediators.CellViewMediator;
	import switcher.views.natives.views.mediators.GamePanelMediator;
	import switcher.views.natives.views.mediators.GridsViewMediator;
	import switcher.views.natives.views.mediators.MessageBoxMediator;
	
	public class MobileConfig implements IConfig
	{
		[Inject]
		public var mediatorMap:IMediatorMap;
		[Inject]
		public var injector:Injector;
		[Inject]
		public var commandMap:ISignalCommandMap;
		[Inject]
		public var context:IContext;
		[Inject]
		public var contextView:ContextView;
		protected var signalBus:SignalBus;
		public function configure():void
		{
			mapSingletons();
			mapViews();
			mapSignals();
			setupViews();
			context.afterInitializing(init);
		}
		public function init():void{
			mediatorMap.mediate(contextView.view);
			signalBus.dispatch(SystemEvent.STARTUP);
		}
		private function setupViews():void{

			//contextView.view.addChild(new GameBGAsset());
			contextView.view.addChild(new GridsView());
			contextView.view.addChild(new GamePanelView());
			contextView.view.addChild(new MessageBoxView());
		}
		private function mapViews():void{
			mediatorMap.map(IGridsView).toMediator(GridsViewMediator);
			mediatorMap.map(CellView).toMediator(CellViewMediator);
			mediatorMap.map(GamePanelView).toMediator(GamePanelMediator);
			mediatorMap.map(MessageBoxView).toMediator(MessageBoxMediator);
		}
		private function mapSingletons():void {
			signalBus=injector.getOrCreateNewInstance(SignalBus);
			injector.map(SignalBus).toValue(signalBus);
			injector.map(GameModel).toSingleton(GameModel);
			injector.map(AnimationService).toSingleton(AnimationService);
			injector.map(ConsoleCommand).toValue(ConsoleCommand.getInstance());
			
		}
		
		private function mapSignals():void{
			commandMap.mapSignal(signalBus.signal(SystemEvent.STARTUP),StartupCommand);
			commandMap.mapSignal(signalBus.signal(SystemEvent.DATA_INIT),DataLoadCommand);

		}
	}
}