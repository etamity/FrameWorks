package 
{
	import com.data.BmpData;
	import com.event.LoadEvent;
	import com.map.AutoAttack;
	import com.map.Control;
	import com.map.Map;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class TowerDefence extends Sprite  
	{
		private var _startUI:MovieClip;//这些MovieClip为fla中的
		private var _progressBar:MovieClip;
		private var _scorePlan:MovieClip;
		private var _progressMask:MovieClip;
		private var _recover:Boolean;//是否是恢复
		private var _main:GameMainAsset;
		public function TowerDefence() 
		{
			_main=new GameMainAsset();
			_startUI = _main.startUI;
			_progressBar = _startUI.progressBar;
			_progressMask = _progressBar.maskMC;
			_progressBar.visible = false;
			_scorePlan = _startUI.scorePlan;
			_scorePlan.getChildAt(1).addEventListener(MouseEvent.CLICK, closeClick);
			_scorePlan.visible = false;
			
			addBtnListener("startBtn");
			addBtnListener("resumeBtn");
			addBtnListener("scoreBtn");
			addChild(_main);
		}
		
		private function closeClick(e:MouseEvent):void 
		{
			_scorePlan.visible = false;
		}
		
		private function addBtnListener(name:String):void//给按钮添加侦听
		{
			var btn:SimpleButton = _startUI.getChildByName(name) as SimpleButton;
			btn.addEventListener(MouseEvent.CLICK, btnClick);
		}
		
		private function btnClick(e:MouseEvent):void //按钮被单击
		{
			switch((e.currentTarget as SimpleButton).name)
			{
				case "startBtn":
					loadData();
					break;
				case "resumeBtn":
					_recover = true;
					loadData();
					break;
				case "scoreBtn":
					_scorePlan.visible = true;
					showScore();
					break;
			}
		}
		
		private function showScore():void//显示分数排行
		{
			while (_scorePlan.numChildren > 2)
			{
				_scorePlan.removeChildAt(2);
			}
			var share:SharedObject = SharedObject.getLocal("aaabbbccc");
			var arr:Array = share.data.score;
			if (!arr) return;
			var num:int = arr.length > 5?5:arr.length;
			for (var i:int = 0; i < num; i++)
			{
				var txt:TextField = new TextField();
				txt.textColor = 0xffffff;
				txt.text = (i + 1).toString() + "                               Score:  " + arr[i].toString();
				txt.y = i * 40 + 60;
				txt.x = 20;
				txt.width = txt.textWidth + 4;
				_scorePlan.addChild(txt);
			}
		}
		
		private function loadData():void//加载素材
		{
			if (BmpData.bmpDatas) 
			{
				loaded(null);
				return;
			}
			_progressBar.visible = true;
			_progressMask.scaleX = 0;
			var bmpData:BmpData = new BmpData();
			bmpData.addEventListener(LoadEvent.LOADING, loading);
			bmpData.addEventListener(LoadEvent.LOADED, loaded);
		}
		
		private function loaded(e:LoadEvent):void//素材加载完成
		{
			var map:Map = new Map();
			map.x = 18;
			map.y = 36;
			_main.addChildAt(map, 2);
			_startUI.visible = false;
			var attack:AutoAttack = new AutoAttack();
			var con:Control = new Control(_main.gameUI, attack);
			if (_recover)
			{
				_recover = false;
				attack.recover();
			}
			con.addEventListener("save", saveFun);
		}
		
		private function saveFun(e:Event):void 
		{
			_startUI.visible = true;
			_progressBar.visible = false;
		}
		
		private function loading(e:LoadEvent):void 
		{
			_progressMask.scaleX = Number(e.info);
		}
	}
	
}