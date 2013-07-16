/*******************************************************************************
 * Author: Joey Etamity
 * Email: etamity@gmail.com
 * For more information see http://www.langteach.com/etblog/
 ******************************************************************************/

package com.map 
{
	import com.enemy.EnemyBase;
	import com.tower.TowerBase;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	

	public class Map extends Sprite 
	{
		public static var place:Array;
		public static var map:Map;
		
		private var _childs:Array;
		private var _topChild:TowerBase;
		
		public function Map() 
		{
			map = this;
			
			drawMapGrid();
			
			layering();
		}
		
		private function layering():void
		{
			_childs = [];
			for (var i:int = 0; i < 13; i++)
			{
				_childs[i] = new Sprite();
				this.addChildAt(_childs[i], i);
			}
		}
		
		public function addTopChild(child:TowerBase):void
		{
			_topChild = child;
			addChild(child);
		}
		
		public function removeTopChild(child:TowerBase):void
		{
			_topChild = null;
			addChild(child);
		}
		
		/*override public function addChild(child:DisplayObject):DisplayObject
		{
			if (child == _topChild)
			{
				super.addChild(child);
			}
			else
			{
				if (child as EnemyBase)
				{
					_childs[11].addChild(child);
				}
				else
				{
					_childs[int(child.y / 36) - 1].addChild(child);
				}
			}
			return child;
		}*/
		
		public function addBulletChild(child:DisplayObject):void
		{
			_childs[12].addChild(child);
		}
		
		private function drawMapGrid():void
		{
			place = new Array();
			
			for (var i:int = 0; i < 22; i++)
			{
				place.push(new Array());
				
				for (var j:int = 0; j < 13; j++)
				{
					place[i][j] = [];
				}
			}
		}
	}

}