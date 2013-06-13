
package com.core.mvsc.services
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import caurina.transitions.Tweener;
	
	import switcher.models.GameModel;
	import switcher.models.Stone;

	public class AnimationService 
	{
		public var fadeTime:int=1;
		public var delayTime:int=4000;
		public var moveime:Number=0.5;
		public var blinkime:Number=0.3;
		
		[Inject]
		public var gameModel:GameModel;
		public function AnimationService()
		{
			super();
		}

		public function spinGrids(grid:Array,row:int,col:int):void{
			var i:int;
			var j:int;
			var mc:MovieClip;
			var newY:int;
			var newGrid:Array=[];
			var newRow:Array=getRandomRow();
			
			function getRandomRow():Array{
				var x:int= Math.random() * row;
				var y:int= Math.random() * col;
				var stoneIndex:int;
				var tempArr:Array=[];
				for (var i:int=0;i<row;i++)
				{
					//mc=grid[y][x];
					stoneIndex= Math.random()* gameModel.stoneData.length;
					mc=new Stone();
					tempArr.push(mc);
					
				}
				return tempArr;
			}
			
		
			function onFinished():void{
				
			}
			
			
			newGrid.concat(grid);
			for(i=col-1;i>=0;i--){
				
				for(j=row-1;j>=0;j--){
					mc=grid[i][j];
					newY=gameModel.getCellY(i+1);
					moveTo(mc,{y:newY,time:0.3,onComplete:onFinished});
					grid[(col-1)-i][(row-1)-j]=newRow[j];
					
				}
			}
		}
		
		public function fadeInCenter(mc:MovieClip):void{
			fadeIn(mc,new Point(mc.stage.stageWidth/2,mc.stage.stageHeight/2));
		}
		
		public function fadeIn(mc:MovieClip,pt:Point):void{
			function onFinished(mc:MovieClip):void{
				setTimeout(function (mc:MovieClip):void{
					fadeMove(mc,{alpha:0,x:pt.x,y:pt.y},function(mc:MovieClip):void{
						mc.parent.removeChild(mc);
					});
				},delayTime,mc);
			}
			mc.alpha=0;
			mc.visible=true;
			mc.x=pt.x;
			mc.y=pt.y;
			setTimeout(function (mc:MovieClip):void{
				fadeMove(mc,{x:pt.x,y:pt.y,alpha:1},onFinished);
			},1000,mc);
		}
		private function fadeMove(mc:MovieClip, params:Object,complete:Function=null):void{
			Tweener.addTween(mc,{x:params.x, y:params.y,alpha:params.alpha, time: fadeTime ,onComplete:complete,onCompleteParams:[mc]});
		}
		
		public function blink(mc:MovieClip):void{
			function onFinishedFadeOut():void{
				Tweener.addTween(mc,{alpha:1,time:blinkime,onComplete:onFinishedFadeIn});
			}
			function onFinishedFadeIn():void{
				blink(mc);
			}
			mc.alpha=1;
			Tweener.addTween(mc,{alpha:0.5,time:blinkime,onComplete:onFinishedFadeOut});
		}
		
		public function moveTo(mc:MovieClip,params:Object):void{
			if (params.time==null)
			params.time=moveime;
			Tweener.addTween(mc,params);
		}
		public function switchPosition(mc1:MovieClip,mc2:MovieClip,complete:Function=null):void{
			var currentPt:Point=new Point(mc1.x,mc1.y);
			Tweener.addTween(mc1,{x:mc2.x,y:mc2.y,time:moveime});
			if (complete!=null)
			Tweener.addTween(mc2,{x:currentPt.x,y:currentPt.y,time:moveime,onComplete:complete});
			else
			Tweener.addTween(mc2,{x:currentPt.x,y:currentPt.y,time:moveime});
			
		}
	}
}