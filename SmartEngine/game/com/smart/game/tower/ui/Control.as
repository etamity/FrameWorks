/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.smart.game.tower.ui 
{
	import com.smart.game.tower.tower.Flame;
	import com.smart.game.tower.tower.Gatling;
	import com.smart.game.tower.tower.Goo;
	import com.smart.game.tower.tower.Lightning;
	import com.smart.game.tower.tower.Missile;
	import com.smart.game.tower.tower.Mortar;
	import com.smart.game.tower.tower.Starter;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import com.smart.game.tower.model.AutoAttack;
	import com.smart.game.tower.model.Map;


	public class Control extends EventDispatcher
	{
		public static var control:Control;
		
		private var _cost:int = 15;
		private var _costTxt:TextField;
		private var _scoreTxt:TextField;
		private var _lifeTxt:TextField;
		private var _stateTxt:TextField;
		private var _btns:Array = [];
		private var _score:int;
		private var _life:int = 20;
		private var _lifes:MovieClip;
		private var _attack:AutoAttack;
		private var _playBtn:MovieClip;
		private var _speedBtn:MovieClip;
		private var _settingBtn:SimpleButton;
		private var _settingPanel:MovieClip;
		private var _round:int = 1;
		
		private var _startUI:MovieClip;
		private var _gameUI:MovieClip;
		public function Control(mc:GameUIAsset, attack:AutoAttack)
		{
			control = this;
			_gameUI=mc.gameUI;
			_attack = attack;
			_lifes = _gameUI.life;
			_settingPanel = mc.setting_panel;
			_settingPanel.visible = false;
			_startUI=mc.startUI;
			_startUI.visible=false;
			_playBtn = _gameUI.play_btn;
			_playBtn.buttonMode = true;
			_playBtn.gotoAndStop(2);
			_speedBtn = _gameUI.speed_btn
			_speedBtn.buttonMode = true;
			_speedBtn.gotoAndStop(1);
			_settingBtn = _gameUI.setting_btn;
			
			
			
			createGameUIButtons();
			
			
	
			
			changeBtnState();
			sortTxt();
			_settingBtn.addEventListener(MouseEvent.CLICK, settingClick);
			_speedBtn.addEventListener(MouseEvent.CLICK, speedClick);
			_playBtn.addEventListener(MouseEvent.CLICK, playClick);
			_settingPanel.addEventListener(MouseEvent.CLICK, panelClick);
		}
		
		private function createGameUIButtons():void{
			var btn:MovieClip =_gameUI.gatling;
			btn.stop();
			_btns.push(new Starter(btn, 5, null, Gatling));
			btn = _gameUI.goo;
			btn.stop();
			_btns.push(new Starter(btn, 10, null, Goo));
			btn = _gameUI.missile;
			btn.stop();
			_btns.push(new Starter(btn, 20, null, Missile));
			btn =_gameUI.flame;
			btn.stop();
			_btns.push(new Starter(btn, 50, null, Flame));
			btn = _gameUI.lightning;
			btn.stop();
			_btns.push(new Starter(btn, 70, null, Lightning));
			btn =_gameUI.mortar;
			btn.stop();
			_btns.push(new Starter(btn, 120, null, Mortar));
		}
		
		private function removeLister():void
		{
			_settingBtn.removeEventListener(MouseEvent.CLICK, settingClick);
			_speedBtn.removeEventListener(MouseEvent.CLICK, speedClick);
			_playBtn.removeEventListener(MouseEvent.CLICK, playClick);
			_settingPanel.removeEventListener(MouseEvent.CLICK, panelClick);
		}
		
		private function panelClick(e:MouseEvent):void 
		{
			var btn:SimpleButton = e.target as SimpleButton;
			var str:String = btn?btn.name:null;
			if(str)_settingPanel.visible = false;
			switch(str)
			{
				case "btn1":
					_attack.play();
					break;
				case "btn2":
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
				case "btn3":
					_attack.save();
					var share:SharedObject = SharedObject.getLocal("TowerGame20130715");
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
				case "btn4":
					_attack.play();
					break;
			}
		}
		
		public function gameOver(win:Boolean):void
		{
			setTimeout(overFun, 4000);
			//Map.map.parent.mouseEnabled = false;
			_attack.stop();
			var share:SharedObject = SharedObject.getLocal("TowerGame20130715");
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
			formatTxt(new TextField(), 380, 200, win?"WIN":"FAILURE");
		}
		
		private function overFun():void 
		{
			//Map.map.parent.mouseEnabled = true;
			Map.map.parent.removeChild(Map.map);
			this.dispatchEvent(new Event("save"));
		}
		
		public function recover():void
		{
			var share:SharedObject = SharedObject.getLocal("TowerGame20130715");
			_cost = 0;
			changeCost(share.data.cost, true);
			_life = share.data.life + 1;
			changeLife();
			_score = 0;
			changeScore(share.data.sorce);
			changeRound(share.data.round);
		}
		
		private function settingClick(e:MouseEvent):void
		{
			_settingPanel.visible = true;
			_attack.stop();
		}
		
		private function speedClick(e:MouseEvent):void
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
		
		private function playClick(e:MouseEvent):void 
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
		
		private function sortTxt():void
		{
			_costTxt = new TextField();
			formatTxt(_costTxt, 65, 20, String(_cost));
			_scoreTxt = new TextField();
			formatTxt(_scoreTxt, 380, 20, "0");
			_lifeTxt = new TextField();
			formatTxt(_lifeTxt, 700, 20, "20");
			_stateTxt = new TextField();
			formatTxt(_stateTxt, 360, 40,"ROUND 0");
		}
		
		public function changeCost(size:int, add:Boolean):void
		{
			size = add?size:size * -1;
			_cost += size;
			_costTxt.text = String(_cost);
			changeBtnState();
		}
		
		public function changeScore(size:int):void
		{
			_score += size;
			_scoreTxt.text = String(_score);
		}
		
		public function changeLife():void
		{
			_life--;
			if (_life <= 0)gameOver(false);
			_lifeTxt.text = String(_life);
			_lifes.gotoAndPlay(2);
		}
		
		private function changeBtnState():void
		{
			for each(var btn:Starter in _btns)
			{
				btn.changeState(_cost);
			}
		}
		
		public function changeRound(round:int):void
		{
			_round = round;
			_stateTxt.text = "ROUND " + String(round);
		}
		
		private function formatTxt(txt:TextField, x:int, y:int, str:String):void
		{
			var tf:TextFormat = new TextFormat("Stencil Std", 18);
			tf.color = 0xFFE600;
			txt.defaultTextFormat = tf;
			txt.defaultTextFormat.bold=true;
			txt.x = x;
			txt.y = y;
			txt.text = str;
			txt.height = txt.textHeight + 4;
			txt.width = 200;
			txt.mouseEnabled = false;
			_gameUI.addChild(txt);
		}
		

		public function get cost():int 
		{
			return _cost;
		}
	}

}