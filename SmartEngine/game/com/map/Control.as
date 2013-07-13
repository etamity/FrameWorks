package com.map 
{
	import com.tower.Flame;
	import com.tower.Gatling;
	import com.tower.Goo;
	import com.tower.Lightning;
	import com.tower.Missile;
	import com.tower.Mortar;
	import com.tower.Starter;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Control extends EventDispatcher
	{
		public static var control:Control;
		
		private var _cost:int = 15;//目前的金币
		private var _costTxt:TextField;//显示金币的文本
		private var _scoreTxt:TextField;//显示分数的文本
		private var _lifeTxt:TextField;//显示生命的文本
		private var _stateTxt:TextField;//显示关数的文本
		private var _btns:Array = [];//放置塔的6个按钮
		private var _score:int;//当前分数
		private var _life:int = 20;//当前生命
		private var _mc:MovieClip;//游戏界面的心形
		private var _attack:AutoAttack;//AutoAttack对象
		private var _playBtn:MovieClip;//播放和暂停按钮
		private var _speedBtn:MovieClip;//改变速度的按钮
		private var _settingBtn:SimpleButton;//选项按钮
		private var _settingPanel:MovieClip;//选项面板
		private var _round:int = 1;//当前关数
		
		private var _main:MovieClip;
		public function Control(mc:MovieClip, attack:AutoAttack)
		{
			control = this;
			_main=_mc;
			_attack = attack;
			_mc = mc.getChildByName("life") as MovieClip;
			_settingPanel = new SettingAsset();
			_settingPanel.visible = false;
			_playBtn = mc.getChildByName("play_btn") as MovieClip;
			_playBtn.buttonMode = true;
			_playBtn.gotoAndStop(2);
			_speedBtn = mc.getChildByName("speed_btn") as MovieClip;
			_speedBtn.buttonMode = true;
			_speedBtn.gotoAndStop(1);
			_settingBtn = mc.getChildByName("setting_btn") as SimpleButton;
			
			
			formatBtns(mc);
			
			sortTxt();
			
			changeBtnState();
			
			_settingBtn.addEventListener(MouseEvent.CLICK, settingClick);
			_speedBtn.addEventListener(MouseEvent.CLICK, speedClick);
			_playBtn.addEventListener(MouseEvent.CLICK, playClick);
			_settingPanel.addEventListener(MouseEvent.CLICK, panelClick);
		}
		
		private function removeLister():void//移除按钮的单击侦听
		{
			_settingBtn.removeEventListener(MouseEvent.CLICK, settingClick);
			_speedBtn.removeEventListener(MouseEvent.CLICK, speedClick);
			_playBtn.removeEventListener(MouseEvent.CLICK, playClick);
			_settingPanel.removeEventListener(MouseEvent.CLICK, panelClick);
		}
		
		private function panelClick(e:MouseEvent):void //选项面板的按钮动作
		{
			var btn:SimpleButton = e.target as SimpleButton;
			var str:String = btn?btn.name:null;
			if(str)_settingPanel.visible = false;
			switch(str)
			{
				case "btn1"://继续
					_attack.play();
					break;
				case "btn2"://重新开始
					_attack.reStart();
					_cost = 15;
					changeCost(0, false);
					_life = 21;
					changeLife();
					_score = 0;
					changeScore(0);
					changeRound(1);			
					_playBtn.gotoAndStop(2);
					_speedBtn.gotoAndStop(1);
					break;
				case "btn3"://保存并退出
					_attack.save();
					var share:SharedObject = SharedObject.getLocal("aaabbbccc");
					share.data.cost = _cost;
					share.data.life = _life;
					share.data.sorce = _score;
					share.data.round = _round;
					for each(var btn1:Starter in _btns)
					{
						btn1.removeLister();
					}
					this.removeLister();
					this.dispatchEvent(new Event("save"));
					break;
				case "btn4"://关闭面板
					_attack.play();
					break;
			}
		}
		
		public function gameOver(win:Boolean):void//游戏结束
		{
			setTimeout(overFun, 4000);
			//Map.map.parent.mouseEnabled = false;
			_attack.stop();
			var share:SharedObject = SharedObject.getLocal("aaabbbccc");
			if (!share.data.score) share.data.score = [];
			var arr:Array = share.data.score;
			for (var i:int = 0; i < arr.length + 1; i++)
			{
				if (arr[i] == undefined || arr[i] < _score)
				{
					arr.splice(i, 0, _score);
					break;
				}
			}
			for each(var btn1:Starter in _btns)
			{
				btn1.removeLister();
			}
			this.removeLister();
			formatTxt(new TextField(), 380, 200, win?"胜利":"失败");
		}
		
		private function overFun():void 
		{
			//Map.map.parent.mouseEnabled = true;
			Map.map.parent.removeChild(Map.map);
			this.dispatchEvent(new Event("save"));
		}
		
		public function recover():void//恢复保存的进度
		{
			var share:SharedObject = SharedObject.getLocal("aaabbbccc");
			_cost = 0;
			changeCost(share.data.cost, true);
			_life = share.data.life + 1;
			changeLife();
			_score = 0;
			changeScore(share.data.sorce);
			changeRound(share.data.round);
		}
		
		private function settingClick(e:MouseEvent):void //单击了选项按钮
		{
			_settingPanel.visible = true;
			_attack.stop();
		}
		
		private function speedClick(e:MouseEvent):void //单击了速度按钮
		{
			if (_speedBtn.currentFrame == 1)
			{
				_speedBtn.gotoAndStop(2);
				_attack.changeSpeed(true);
			}
			else
			{
				_speedBtn.gotoAndStop(1);
				_attack.changeSpeed(false);
			}
		}
		
		private function playClick(e:MouseEvent):void //单击了播放按钮
		{
			if (_playBtn.currentFrame == 1)
			{
				_playBtn.gotoAndStop(2);
				_attack.play();
			}
			else
			{
				_playBtn.gotoAndStop(1);
				_attack.stop();
			}
		}
		
		private function sortTxt():void//对所有的显示文本初始化
		{
			_costTxt = new TextField();
			formatTxt(_costTxt, 35, -20, String(_cost));
			_scoreTxt = new TextField();
			formatTxt(_scoreTxt, 380, -20, "0");
			_lifeTxt = new TextField();
			formatTxt(_lifeTxt, 700, -20, "20");
			_stateTxt = new TextField();
			formatTxt(_stateTxt, 360, 10,"ROUND 0");
		}
		
		public function changeCost(size:int, add:Boolean):void//改变金币
		{
			size = add?size:size * -1;
			_cost += size;
			_costTxt.text = String(_cost);
			changeBtnState();
		}
		
		public function changeScore(size:int):void //改变分数
		{
			_score += size;
			_scoreTxt.text = String(_score);
		}
		
		public function changeLife():void//改变命数
		{
			_life--;
			if (_life <= 0)gameOver(false);
			_lifeTxt.text = String(_life);
			_mc.gotoAndPlay(2);
		}
		
		private function changeBtnState():void//改变6个启动塔的按钮的状态
		{
			for each(var btn:Starter in _btns)
			{
				btn.changeState(_cost);
			}
		}
		
		public function changeRound(round:int):void//改变关数
		{
			_round = round;
			_stateTxt.text = "round " + String(round);
		}
		
		private function formatTxt(txt:TextField, x:int, y:int, str:String):void//初始化文本
		{
			var tf:TextFormat = new TextFormat("Stencil Std", 18);
			tf.color = 0xFFE600;
			txt.defaultTextFormat = tf;
			txt.x = x;
			txt.y = y;
			txt.text = str;
			txt.height = txt.textHeight + 4;
			txt.width = 200;
			txt.mouseEnabled = false;
			//_main.addChild(txt);
		}
		
		private function formatBtns(mc:MovieClip):void//初始化按钮
		{
			var btn:MovieClip = mc.getChildByName("gatling") as MovieClip;
			_btns.push(new Starter(btn, 5, null, Gatling));
			btn = mc.getChildByName("goo") as MovieClip;
			_btns.push(new Starter(btn, 10, null, Goo));
			btn = mc.getChildByName("missile") as MovieClip;
			_btns.push(new Starter(btn, 20, null, Missile));
			btn = mc.getChildByName("flame") as MovieClip;
			_btns.push(new Starter(btn, 50, null, Flame));
			btn = mc.getChildByName("lightning") as MovieClip;
			_btns.push(new Starter(btn, 70, null, Lightning));
			btn = mc.getChildByName("mortar") as MovieClip;
			_btns.push(new Starter(btn, 120, null, Mortar));
		}
		
		public function get cost():int 
		{
			return _cost;
		}
	}

}