//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine
{

	import com.smart.SmartSystem;
	import com.smart.core.Engine;
	import com.smart.core.IEngine;
	import com.smart.engine.map.display.SmartDisplayObject;
	import com.smart.engine.map.display.SmartImage;
	import com.smart.engine.map.layer.ILayerDisplay;
	import com.smart.engine.map.layer.LayerBatchDisplay;
	import com.smart.engine.map.models.TMXLayer;
	import com.smart.engine.map.models.TMXMapModel;
	import com.smart.engine.map.models.TMXObject;
	import com.smart.engine.map.models.TMXObjectgroup;
	import com.smart.engine.map.models.TMXTileset;
	import com.smart.engine.map.plugins.ViewportPlugin;
	import com.smart.engine.map.utils.Point3D;
	import com.smart.engine.map.utils.State;
	import com.smart.loaders.AssetsManager;
	
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;

	public class MapEngine extends Engine
	{
		private static const TILE_PROPERTY_HIT_MAP:String="hitmap";
		private static const TILE_PROPERTY_HIT_MAP_VALUE:String="true";

		private var layers:Vector.<ILayerDisplay>;
		private var layersHash:Dictionary;
		private var container:Sprite;

		private var iSprite:int=1;
		private var linkedLayer:Vector.<ILayerDisplay> = new <ILayerDisplay>[];
		private var steps:int=0;
		private var tmx:TMXMapModel;


		private var engine:SmartSystem;
		public var onCompelete:Function;
		
		private var viewport:ViewportPlugin;
		
		
		public function MapEngine(tmx:TMXMapModel=null)
		{
			super();
			layers=new <ILayerDisplay>[];
			layersHash=new Dictionary();
			container=new Sprite();

			this.tmx=tmx;
			//linkedLayer=new <LayerQuadDisplay>[];
			if (this.tmx != null)
			{
				AssetsManager.instance.loadTmx(tmx, onProgress);
			}
		}
		
		
		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):ILayerDisplay
		{
			
			var layer:ILayerDisplay=new LayerBatchDisplay(name,tmx,viewport);
			for (var i:int=0; i <= tmxLayerIndex; i++)
			{
				if (i == linkedLayer.length)
				{
					linkedLayer.push(null);
				}
			}
			return linkedLayer[tmxLayerIndex]=layer;
		}
		
		public function addObjects():void
		{
			var layer:ILayerDisplay;
			for each (var objectGroup:TMXObjectgroup in tmx.objectsArray)
			{
				if (objectGroup == null)
				{
					continue;
				}
				layer=linkedLayer[0];

				addObjectsToLayer(layer, objectGroup);
			}
		}



		public function getLayerByIndex(index:int):ILayerDisplay
		{
			return layers[index];
		}

		public function getObjectByName(name:String):SmartDisplayObject{
			return linkedLayer[0].getByName(name);
		}

		public function getLayerByName(name:String):ILayerDisplay
		{
			return layersHash[name];
		}

		public function getSpriteByLayerIndex(layerIndex:int, spriteName:String):SmartDisplayObject
		{
			var layer:ILayerDisplay=layers[layerIndex];
			return layer.getByName(spriteName);
		}

		public function getSpriteByLayerName(layerName:String, spriteName:String):SmartDisplayObject
		{
			var layer:ILayerDisplay=getLayerByName(layerName);
			if (layer == null)
			{
				return null;
			}
			var result:SmartDisplayObject=layer.getByName(spriteName);
			return result;
		}

		public function get numChildrenSprites():int
		{
			var num:int=0;
			for each (var layer:ILayerDisplay in layers)
			{
				num+=layer.numChildrenSprites;
			}

			return num;
		}
		
		override public function onTrigger(time:Number):void
		{
			for each (var layer:ILayerDisplay in layers)
			{
				if (layer != null)
				{
					if (layer.autoPosition)
					{
						layer.moveTo(x, y);
					}
					
					layer.onTrigger(time, engine);
					
					
				}
				
			}
			
			super.onTrigger(time);
		}

		public function get numberOfLayers():int
		{
			return layers.length;
		}

		/*public function gridInLayerPt(pt:Point):Point3D {
			var currentGrid:Point3D = this.layers[0].gridToLayerPt(pt.x, pt.y);
			return currentGrid;
		}
		public function objectInGridPt(val:Point3D):Point {
			var pt:Point3D        = val;
			var currentGrid:Point = this.layers[0].layerToGridPt(pt.x, pt.y);
			return currentGrid;
		}*/
		public function addLayer(index:int, layer:ILayerDisplay):void
		{
			if (layer.name == "" || layer.name == null)
			{
				throw new Error("invalid layer name");
			}
			if (layersHash[layer.name] != null)
			{
				throw new Error("layer " + layer.name + " already added");
			}
			for (var i:int=0; i <= index; i++)
			{
				if (i == index)
				{
					layers[i]=layer;
					break;
				}
				else if (i == layers.length)
				{
					layers.push(null);
				}
			}
			layersHash[layer.name]=layer;
			if (layer != null)
			{
				container.addChild(layer.display);
			}
		}

		public function addObjectsToLayer(grid:ILayerDisplay, group:TMXObjectgroup):void
		{
			var tile:TMXTileset;
			var name:String;
			var assetID:String;
			var sprite:SmartImage;
			var pt3:Point3D;
			
			for each (var obj:TMXObject in group.objects)
			{
				tile=tmx.tilesets[obj.gid];
				//name           = tmx.getImgSrc(obj.gid) + "_" + "1";

				//assetID=String(obj.gid);
				

				
				assetID=tmx.getImgSrc(obj.gid)+"_"+String(obj.gid); 
				
				name = obj.name;
				//assetID        = tmx.getImgSrc(obj.gid);
				pt3=new Point3D(obj.x, obj.y);
				// trace("Objs: "+assetID, name, new Point3D(obj.x, obj.y));
				sprite=new SmartImage(assetID, pt3);
				if (obj.name == "")
				{
					obj.name=assetID;
				}
				trace("Object:" , name , grid.name);
				sprite.name=name;
				sprite.type=obj.type;
				//sprite.currentFrame = tmx.getImgFrame(obj.gid);
				grid.add(sprite);
			}
		}


		private function loadTiles():void
		{

			viewport = this.getPlugin(ViewportPlugin);
			makeEmptyGrid();
			makeLayer();
			addObjects();
			//renderMap();
			onCompelete();
		}

		public function makeLayer():void
		{
			for (var y:int=0; y < tmx.height; y++)
			{
			for (var x:int=0; x < tmx.width; x++)
			{
			makeTiles(x, y);
			}
			}
			
		}
		

		override public function onRegister(engine:IEngine):void
		{
			this.engine=engine as SmartSystem; //this.EngineClass(engine); 
			this.engine.addDisplay(this.container);
	

		}


		public function removeLayer(layer:ILayerDisplay):void
		{
			var index:int=layers.indexOf(layer);
			layers.splice(index, 1);
			delete layersHash[layer.name];
			container.removeChild(layer.display);
			layer.dispose();
			layer=null;
		}
		override public function dispose():void{
			super.dispose();
			removeAllLayers();
			tmx.dispose();
			AssetsManager.instance.purge();
		}

		public function removeAllLayers():void
		{
			for each (var layer:ILayerDisplay in layers)
			{
				removeLayer(layer);
			}
			layers=null;
			layersHash=null;
			if (container!=null)
			{
			container.removeChildren();
			container.dispose();
			
			container=null;
			}

		}

		public function get tmxData():TMXMapModel
		{
			return tmx;
		}

		public function set tmxData(data:TMXMapModel):void
		{
			
			tmx=data;
			if (this.tmx != null)
			{
				AssetsManager.instance.loadTmx(tmx, onProgress);
			}
		}





		private function onProgress(ratio:Number):void
		{
			if (ratio == 1.0)
			{
				loadTiles();
			}

		}

		private function makeEmptyGrid():void
		{
			var layer:TMXLayer;
			var layerName:String;
			var grid:ILayerDisplay;
			for (var i:int=0; i < tmx.layersArray.length; i++)
			{
				layer=tmx.layersArray[i];
				layerName=layer.name;
				grid=makeEmptyGridOfSize(i, layerName);
				//grid.flatten(); 
				addLayer(i, grid);
			}

		}
		
		


		private function makeTiles(cellX:int, cellY:int):void
		{
			var layer:TMXLayer;
			var _cell:int;
			var grid:ILayerDisplay;
			var pt3:Point3D;
    
			var assetID:String;
			var sprite:SmartImage;

			for (var i:int=0; i < tmx.layersArray.length; i++)
			{
				layer=tmx.layersArray[i];
				if (layer == null)
				{
					continue;
				}
				_cell=layer.getCell(cellX, cellY);

				if (_cell == 0 || isNaN(_cell))
				{
					continue;
				}
				grid=linkedLayer[i];

				pt3=grid.gridToLayerPt(cellX, cellY);
				//name = tmx.getImgSrc(_cell) + "_" + String(_cell);
				
				assetID=tmx.getImgSrc(_cell)+"_"+String(_cell); 
				//assetID = tmx.getImgSrc(_cell);

				//trace("object: ", name, pt3, new State("", 0, 0, true));

				sprite=new SmartImage(assetID, pt3, new State("", 0, 0, true));
				//sprite.currentFrame = tmx.getImgFrame(_cell);
				
				sprite.index= layer.getCellIndex(cellX, cellY);
				grid.add(sprite);
				//grid.addStarlingChild(sprite)
				/*setTimeout(add,delay*100,_cell,cellX,cellY,sprite,grid);
				delay++;;*/
			}
			function add(cell:int, x:int,y:int,sp:SmartDisplayObject,lay:ILayerDisplay):void{
				grid.add(sp);
				//grid.addStarlingChild(sp);
				trace("cell:",cell ,"index:", sp.index," x,y :" ,x, y,"layer.name",lay.name );
			}	
		
		}	
		private var delay:int=0;
	}

}

