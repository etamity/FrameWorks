/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/
package switcher.models
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ScrollingText extends Sprite {
		
		private var SPEED:int = 80; 
		private var DIGITS_COUNT:int = 7; 
		private var PADDING:int =25;
		private var _totalScore:int = 0;
		private var _displayScore:int= 0;
		
		private var initLoad:Boolean=true;
		

		public function ScrollingText(sp:int=1) {
			SPEED=sp;
			build(0);
		}
		

		public function get totalScore():int {
			return _totalScore;
		}
		
		public function build(num:int):void{
			clean();
			var scoreStr:String = String(num);
			DIGITS_COUNT=num.toString().length;
			for (var i:int = 0; i < DIGITS_COUNT; i++) {
				var mc:ScoreDigitAsset=new ScoreDigitAsset();
				mc.name="digit"+(i+1);
				var number:int = int(scoreStr.charAt(i));
				mc.display.gotoAndStop(number+1);
				mc.x = i * PADDING;
				addChild(mc);
			}
			//_totalScore=num;
			_displayScore=num;
		}
		public function set intiScore(num:int):void{
			build(num);
			_totalScore=num;
		}
		
		public function clean():void{
			//removeChildren();
			while (numChildren>0)
				removeChildAt(0);
		}
		public function set score(val:int):void{
			if (_totalScore == val) return;
			var scoreStr:String = String(_totalScore);
			if (initLoad==true){
				initLoad=false;
				intiScore=val;
			}else{
				if (_totalScore>val){
					_totalScore=val;
					_displayScore=val;
					while(scoreStr.length < DIGITS_COUNT){
						scoreStr = "0" + scoreStr;
					}
					for (var i:int = 0; i < DIGITS_COUNT; i++) {
						var num:int = int(scoreStr.charAt(i));
		
						var ni : ScoreDigitAsset = getChildAt(i) as ScoreDigitAsset;
						ni.display.gotoAndStop(num+1);
					}
				}else
				{
					var amount:int = val-_totalScore;
					add(amount);
				}
				addEventListener(Event.ENTER_FRAME, updateScoreDisplay); 
			}
		}
		
		

		public function add(amount:int):void {
			_totalScore += amount;
			if (_totalScore<0)
				_totalScore=0;
			addEventListener(Event.ENTER_FRAME, updateScoreDisplay); 
		}

		private function updateScoreDisplay(e:Event):void {
			
			_displayScore += SPEED;
		
			if(_displayScore > _totalScore){
				_displayScore = _totalScore;
			}
			
			var scoreStr:String = String(_displayScore); 

			if (scoreStr.length!=DIGITS_COUNT)
			{
				DIGITS_COUNT=scoreStr.length;
				build(_displayScore);
			}

			for (var i:int = 0; i < DIGITS_COUNT; i++) {
				var num:int = int(scoreStr.charAt(i));

				var ni : ScoreDigitAsset = getChildAt(i) as ScoreDigitAsset;
				ni.display.gotoAndStop(num+1);
			}

			if(_totalScore == _displayScore){
				removeEventListener(Event.ENTER_FRAME, updateScoreDisplay);
			}
		}
		
	}
}