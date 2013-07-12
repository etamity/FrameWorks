package com.map 
{
	import com.enemy.EnemyBase;
	import com.tower.TowerBase;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	

	/**
	 * ...
	 * @author tomome52@gmail.com
	 */
	public class Map extends Sprite 
	{
		public static var place:Array;//地图二维数组
		public static var map:Map;//对当前类对象的引用
		
		private var _childs:Array;//用于分层的显示对象
		private var _topChild:TowerBase;//置顶的子元素
		
		public function Map() 
		{
			map = this;
			
			drawMapGrid();
			
			layering();
		}
		
		private function layering():void//分层，让地图的东西按一定的层级排序
		{
			_childs = [];
			for (var i:int = 0; i < 13; i++)
			{
				_childs[i] = new Sprite();
				this.addChildAt(_childs[i], i);
			}
		}
		
		public function addTopChild(child:TowerBase):void//添加置顶显示的子元件
		{
			_topChild = child;
			addChild(child);
		}
		
		public function removeTopChild(child:TowerBase):void//移除置顶显示的子元件
		{
			_topChild = null;
			addChild(child);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject//让子元件按规律排序
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
		}
		
		public function addBulletChild(child:DisplayObject):void//主要用于子弹
		{
			_childs[12].addChild(child);
		}
		
		private function drawMapGrid():void//生成地图的二维数组
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