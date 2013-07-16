/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/


package com.tower 
{

	public class Indicator extends IndicatorAsset 
	{
		
		private var _upgrade:Starter;
		private var _reclaim:Starter;
		private var _defense:int;
		
		public function Indicator(defense:int, money:int) 
		{
			_defense = defense;
			//upgrade = this.getChildByName("upgrade") as MovieClip;
			//reclaim = this.getChildByName("reclaim") as MovieClip;
			upgrade.label.text="upgrade";
			reclaim.label.text="reclaim";
			
			reclaim.x = -100;
			reclaim.y = -35;
			upgrade.x = 28;
			upgrade.y = -35;
			_upgrade = new Starter(upgrade, money, upgradeFun, null);
			_reclaim = new Starter(reclaim, money, reclaimFUn, null);
		}
		
		private function reclaimFUn():void 
		{
			(this.parent as TowerBase).sellTower();
		}
		
		private function upgradeFun():void 
		{
			(this.parent as TowerBase).upgrade();
		}
		
		public function setMoney(money1:int, money2:int):void
		{
			_upgrade.setMoney(money1);
			_reclaim.setMoney(money2);
		}
		
		public function changeUpgradeState(money:int):void
		{
			_upgrade.changeState(money);
		}
		
		public function changeState(id:int):void
		{
			var color:uint = id == 0?0xff0000:0x00ff00;
			drawBack(color);
			var bool:Boolean = id == 2;
			reclaim.visible = bool;
			upgrade.visible = bool;
			var index:int = id == 0?1:0;
			this.parent.setChildIndex(this, index);
		}
		
		private function drawBack(color:uint):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, color);
			this.graphics.beginFill(color, 0.5);
			this.graphics.drawCircle(0, 0, _defense);
			this.graphics.endFill();
		}
	}

}