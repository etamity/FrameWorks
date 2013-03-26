//##########################################################
//	Smart Engine
//	Version 1.0
//	Author: Joey Etamity  Email:etamity@gmail.com
//	Copyright 2012
//	All rights reserved.
//##########################################################

package com.smart.engine.plugins
{

	import com.smart.engine.SmartEngine;
	import com.smart.engine.core.IPlugin;
	import com.smart.engine.core.MapAssetsManager;
	import com.smart.engine.core.Plugin;
	import com.smart.engine.display.ILayerDisplay;
	import com.smart.engine.display.LayerQuadDisplay;
	import com.smart.engine.display.SmartDisplayObject;
	import com.smart.engine.display.SmartImage;
	import com.smart.engine.tmxdata.TMXLayer;
	import com.smart.engine.tmxdata.TMXMap;
	import com.smart.engine.tmxdata.TMXObject;
	import com.smart.engine.tmxdata.TMXObjectgroup;
	import com.smart.engine.tmxdata.TMXTileset;
	import com.smart.engine.utils.Point3D;
	import com.smart.engine.utils.State;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;

	public class TMXQuadPlugin extends Plugin
	{
		private static const TILE_PROPERTY_HIT_MAP:String="hitmap";
		private static const TILE_PROPERTY_HIT_MAP_VALUE:String="true";

		private var layers:Vector.<ILayerDisplay>;
		private var layersHash:Dictionary;
		private var container:Sprite;

		private var iSprite:int=1;
		private var linkedLayer:Vector.<LayerQuadDisplay>;
		private var steps:int=0;
		private var tmx:TMXMap;

		private var position:Point=new Point();
		private var ratio:Point=new Point(1, 1);

		private var engine:SmartEngine;
		public var onCompelete:Function;
		
		private var viewport:ViewportPlugin;
		
		
		public function TMXQuadPlugin(tmx:TMXMap=null)
		{
			super();
			layers=new <ILayerDisplay>[];
			layersHash=new Dictionary();
			container=new Sprite();

			this.tmx=tmx;
			linkedLayer=new <LayerQuadDisplay>[];
			if (this.tmx != null)
			{
				MapAssetsManager.instance.loadTmx(tmx, onProgress);
			}
		}
		
		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):LayerQuadDisplay
		{
			
			var layer:LayerQuadDisplay=new LayerQuadDisplay(name,tmx,viewport);
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
			var layer:LayerQuadDisplay;
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

		public function addObjectsToLayer(grid:LayerQuadDisplay, group:TMXObjectgroup):void
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
			/*var loader:TextureAtlasLoader;
			var i:int;
			for each (var tile:TMXTileset in tmx.uniqueTilesets) {
			trace("Image Path:",tmx.getImgPath(tile.firstgid));
			loader = new TextureAtlasLoader(tmx.getImgPath(tile.firstgid), tile, null, tile.getPropsByID(TILE_PROPERTY_HIT_MAP) == TILE_PROPERTY_HIT_MAP_VALUE);
			AssetsManager.instance.addLoader(loader);
			}*/
			viewport = this.getPlugin(ViewportPlugin);
			makeEmptyGrid();
			makeLayer();
			addObjects();
			//renderMap();
			onCompelete();
		}
		
		private function renderMap():void{
			var layer:TMXLayer;
			var grid:LayerQuadDisplay;
			for (var i:int=0; i < tmx.layersArray.length; i++)
			{
				layer=tmx.layersArray[i];
				if (layer == null)
				{
					continue;
				}
				grid=linkedLayer[i];
				grid.render();
			}
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
		
		
		
		public function makeLayers():void
		{
			/*for (var y:int=0; y < tmx.height; y++)
			{
				for (var x:int=0; x < tmx.width; x++)
				{
					makeTiles(x, y);
				}
			}*/
			
			
			var layer:TMXLayer;
			var _cell:int;
			var grid:LayerQuadDisplay;
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
			
				for (var y:int=0; y < tmx.height; y++)
				{
					for (var x:int=0; x < tmx.width; x++)
					{
						//makeTiles(x, y);
						_cell=layer.getCell(x, y);
						
						if (_cell == 0 || isNaN(_cell))
						{
							continue;
						}
						grid=linkedLayer[i];
						
						pt3=grid.gridToLayerPt(x, y);
						//name = tmx.getImgSrc(_cell) + "_" + String(_cell);
						assetID=String(_cell); //String(iSprite++);
						//assetID = tmx.getImgSrc(_cell);
						
						//trace("object: ", name, pt3, new State("", 0, 0, true));
						
						sprite=new SmartImage(assetID, pt3, new State("", 0, 0, true));
						//sprite.currentFrame = tmx.getImgFrame(_cell);
						
						//setTimeout(add,delay*100,x,y,sprite,grid);
						sprite.index= layer.getCellIndex(x, y);
						
						
						grid.add(sprite);
						trace("cell:",_cell ,"index:", sprite.index," x,y :" ,x, y,"layer.name",grid.name );
					}
				}
				
				
			}
			
			function add(xx:int,xy:int,sp:SmartDisplayObject,lay:LayerQuadDisplay):void{
				grid.add(sp);
				trace("cell:",_cell ,"index:", sprite.index," x,y :" ,xx, xy,"layer.name",grid.name );
			}	
		}

		override public function onRegister(engine:IPlugin):void
		{
			this.engine=engine as SmartEngine; //this.EngineClass(engine); 
			this.engine.addDisplay(this.container);
	

		}


		override public function onRemove():void
		{
			super.onRemove();
		}

		public function moveTo(x:Number, y:Number):void
		{
			position.x=x * ratio.x;
			position.y=y * ratio.y;

		}

		override public function onTrigger(time:Number):void
		{
			//container.x=engine.positionX;
			//container.y=engine.positionY;
			for each (var layer:ILayerDisplay in layers)
			{
				if (layer != null)
				{
					if (layer.autoPosition)
					{
						layer.moveTo(engine.positionX, engine.positionY);
					}

					layer.onTrigger(time, engine);


				}

			}
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

		public function get tmxData():TMXMap
		{
			return tmx;
		}

		public function set tmxData(data:TMXMap):void
		{
			
			tmx=data;
			if (this.tmx != null)
			{
				MapAssetsManager.instance.loadTmx(tmx, onProgress);
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
			var grid:LayerQuadDisplay;
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
			var grid:LayerQuadDisplay;
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
				grid.addStarlingChild(sprite)
				/*setTimeout(add,delay*100,_cell,cellX,cellY,sprite,grid);
				delay++;;*/
			}
			function add(cell:int, x:int,y:int,sp:SmartDisplayObject,lay:LayerQuadDisplay):void{
				grid.add(sp);
				grid.addStarlingChild(sp);
				trace("cell:",cell ,"index:", sp.index," x,y :" ,x, y,"layer.name",lay.name );
			}	
		
		}	
		private var delay:int=0;
	}

}

