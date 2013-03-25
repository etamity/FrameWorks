package com.smart.tiled
{
	import com.smart.engine.utils.StringUtils;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	/**
	 * @author shaun.mitchell
	 */
	public class TMXTileMap extends Sprite implements IAnimatable
	{
		// The TMX file to load

		private var _path:String;
		private var _fileName:String;
		private var _mapLoaded:Boolean;
		// XML of TMX file
		private var _TMX:XML;
		// Layers and tilesheet holders
		private var _layers:Vector.<TMXLayer>;
		private var _tilesheets:Vector.<TMXTileSheet>;
		// variables pertaining to map description
		private var _numLayers:uint;
		private var _numTilesets:uint;
		private var _tilelistCount:uint;
		private var _mapWidth:uint;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		// used to get the correct tile from various tilesheets
		private var _gidLookup:Vector.<uint>;
		private var _embedTilesets:Vector.<Bitmap>;

		private var _displayArea:Sprite=new Sprite();

		private var ratio:Point=new Point(1, 1);
		private var projection:Matrix;
		private var projectionInverse:Matrix;
		private var sqEdgeSize:Number;
		private var velocity:Point;
		public var speed:Number=4;
		private var hitArea:Number=10;
		private var _juggler:Juggler;

		private var position:Point=new Point();

		public function TMXTileMap(stage:Stage):void
		{
			_mapLoaded=false;
			_fileName="";

			_numLayers=0;
			_numTilesets=0;
			_tilelistCount=0;
			_mapWidth=0;
			_tileHeight=0;
			_tileWidth=0;

			_layers=new Vector.<TMXLayer>();
			_tilesheets=new Vector.<TMXTileSheet>();
			_gidLookup=new Vector.<uint>();


			projection=new Matrix();
			this.hitArea=hitArea;
			this.speed=speed;
			velocity=new Point(0, 0);
			addChild(_displayArea);
			stage.addEventListener("mouseLeave", onMouseOut);
			stage.addEventListener("mouseOut", onMouseOut);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			_juggler=new Juggler();
			Starling.juggler.add(this);
			advanceTime(0);
		}

		public function advanceTime(time:Number):void
		{
			onTrigger(time);
		}

		public function moveTo(x:Number, y:Number):void
		{
			position.x += -x * ratio.x;
			position.y += -y * ratio.y;
		}

		public function onTrigger(time:Number):void
		{
			_juggler.advanceTime(time);
			/*position.x += velocity.x;
			position.y += velocity.y;*/


			for each (var layer:TMXLayer in _layers)
			{
				layer.x = position.x;
				layer.y = position.y;

			/*	layer.x = Math.min(Math.max(layer.worldBounds.left + this.stage.stageWidth, layer.x), layer.worldBounds.right);
				layer.y = Math.min(Math.max(layer.worldBounds.top + this.stage.stageHeight, layer.y), layer.worldBounds.bottom);
			*/

				/*var newViewPort:Rectangle = layer.visibleViewport.clone();
				newViewPort.x = -layer.x;
				newViewPort.y = -layer.y;
				newViewPort.offset(-layer.x,-layer.y);
				trace("newViewPort::",newViewPort);
				layer.visibleViewport = newViewPort;
				}*/
			/*	var newViewPort:Rectangle=layer.visibleViewport.clone();
				if (layer.worldBounds.containsRect(newViewPort))
				{

					newViewPort.x = -layer.x;
					newViewPort.y = -layer.y;

					//newViewPort.offset(layer.x, layer.y);
			


				}
				layer.visibleViewport=newViewPort;*/
			}

			moveTo(velocity.x, velocity.y);
		}

		private function onMouseOut(e:*):void
		{
			velocity.x=0;
			velocity.y=0;
		}

		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(stage);
			if (touch == null)
			{
				return;
			}

			var _x:Number=touch.globalX;
			var _y:Number=touch.globalY;
			if (_x > stage.stageWidth - hitArea)
			{
				velocity.x=speed;
			}
			else if (_x < hitArea)
			{
				velocity.x=-speed;
			}
			else
			{
				velocity.x=0;
			}

			if (_y > stage.stageHeight - hitArea)
			{
				velocity.y=speed;
			}
			else if (_y < hitArea)
			{
				velocity.y=-speed;
			}
			else
			{
				velocity.y=0;
			}



		}

		public function load(file:String):void
		{
			_fileName=file;
			_path=StringUtils.getPath(file);
			trace(_fileName);
			trace(_path);
			var _loader:URLLoader=new URLLoader();
			_loader.addEventListener(flash.events.Event.COMPLETE, loadTilesets);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				trace("URL:" + _fileName, e.text)
			});
			_loader.load(new URLRequest(_fileName));
		}

		public function loadFromEmbed(tmx:XML, tilesets:Vector.<Bitmap>):void
		{
			_TMX=tmx;
			_embedTilesets=tilesets;

			loadEmbedTilesets();
		}

		// Getters ------------------------------------------
		public function layers():Vector.<TMXLayer>
		{
			return _layers;
		}

		public function tilesheets():Vector.<TMXTileSheet>
		{
			return _tilesheets;
		}

		public function numLayers():uint
		{
			return _numLayers;
		}

		public function numTilesets():uint
		{
			return _numTilesets;
		}

		public function mapWidth():uint
		{
			return _mapWidth;
		}

		public function tileHeight():uint
		{
			return _tileHeight;
		}

		public function tileWidth():uint
		{
			return _tileWidth;
		}

		// End getters --------------------------------------
		// get the number of tilsets from the TMX XML
		private function getNumTilesets():uint
		{
			if (_mapLoaded)
			{
				var count:uint=0;
				for (var i:int=0; i < _TMX.children().length(); i++)
				{
					if (_TMX.tileset[i] != null)
					{
						count++;
					}
				}

				trace(count);
				return count;
			}

			return 0;
		}

		// get the number of layers from the TMX XML
		private function getNumLayers():uint
		{
			if (_mapLoaded)
			{
				var count:uint=0;
				for (var i:int=0; i < _TMX.children().length(); i++)
				{
					if (_TMX.layer[i] != null)
					{
						count++;
					}
				}

				trace(count);
				return count;
			}
			return 0;
		}

		private function loadTilesets(event:flash.events.Event):void
		{
			_mapLoaded=true;

			_TMX=new XML(event.target.data);

			if (_TMX)
			{
				_mapWidth=_TMX.@width;
				_tileHeight=_TMX.@tileheight;
				_tileWidth=_TMX.@tilewidth;

				_numLayers=getNumLayers();
				_numTilesets=getNumTilesets();
				// _TMX.properties.property[1].@value;

				var tileSheet:TMXTileSheet=new TMXTileSheet();
				tileSheet.loadTileSheet(_TMX.tileset[_tilelistCount].@name, _path + _TMX.tileset[_tilelistCount].image.@source, _TMX.tileset[_tilelistCount].@tilewidth, _TMX.tileset[_tilelistCount].@tileheight, _TMX.tileset[_tilelistCount].@firstgid - 1);
				tileSheet.addEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);
				_tilesheets.push(tileSheet);
				_gidLookup.push(_TMX.tileset[_tilelistCount].@firstgid);




			}
		}

		private function loadEmbedTilesets():void
		{
			trace("loading embedded tilesets");
			_mapLoaded=true;

			if (_TMX)
			{
				_mapWidth=_TMX.@width;
				_tileHeight=_TMX.@tileheight;
				_tileWidth=_TMX.@tilewidth;


				_numLayers=getNumLayers();
				_numTilesets=getNumTilesets();

				// _TMX.properties.property[1].@value;

				for (var i:int=0; i < _numTilesets; i++)
				{
					var tileSheet:TMXTileSheet=new TMXTileSheet();
					trace(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1);
					tileSheet.loadEmbedTileSheet(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1);
					_tilesheets.push(tileSheet);
					_gidLookup.push(_TMX.tileset[i].@firstgid);
				}

				loadMapData();
			}
		}

		private function loadRemainingTilesets(event:starling.events.Event):void
		{
			event.target.removeEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);

			_tilelistCount++;
			if (_tilelistCount >= _numTilesets)
			{
				trace("done loading tilelists");
				loadMapData();
			}
			else
			{
				trace(_TMX.tileset[_tilelistCount].@name);
				var tileSheet:TMXTileSheet=new TMXTileSheet();
				tileSheet.loadTileSheet(_TMX.tileset[_tilelistCount].@name, _path + _TMX.tileset[_tilelistCount].image.@source, _TMX.tileset[_tilelistCount].@tilewidth, _TMX.tileset[_tilelistCount].@tileheight, _TMX.tileset[_tilelistCount].@firstgid - 1);
				tileSheet.addEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);
				_gidLookup.push(_TMX.tileset[_tilelistCount].@firstgid);
				_tilesheets.push(tileSheet);
			}
		}

		private function loadMapData():void
		{
			if (_mapLoaded)
			{
				for (var i:int=0; i < _numLayers; i++)
				{
					trace("loading map data");
					var ba:ByteArray=Base64.decode(_TMX.layer[i].data);
					ba.uncompress();

					var data:Array=new Array();

					for (var j:int=0; j < ba.length; j+=4)
					{
						// Get the grid ID

						var a:int=ba[j];
						var b:int=ba[j + 1];
						var c:int=ba[j + 2];
						var d:int=ba[j + 3];

						var gid:int=a | b << 8 | c << 16 | d << 24;
						data.push(gid);


					}
					var tmxLayer:TMXLayer=new TMXLayer();
					tmxLayer.setData(data);
					_layers.push(tmxLayer);
					_displayArea.addChild(tmxLayer);

				}

				drawLayers();
			}
		}

		// draw the layers into a holder contained in a TMXLayer object
		private function drawLayers():void
		{
			trace("drawing layers");
			var row:int=0;
			var col:int=0;
			var img:Image;
			var isoPt:Point;
			var pt:Point;



			var ww:int=60;
			var hh:int=40;

			var scale:Number=1;
			var length:Number=Math.sqrt(ww * ww + hh * hh);

			sqEdgeSize=30;
			projection.rotate(45 * (Math.PI / 180));
			scale=1.4142137000082988;
			//scale = 1.5;
			projection.scale(scale * 1, scale * .5);

			projectionInverse=(projection.clone());
			projectionInverse.invert();
			projection.translate(-ww, hh);


			for (var i:int=0; i < _numLayers; i++)
			{

				col=0;
				row=0;

				for (var j:int=0; j < _layers[i].getData().length; j++)
				{

					if (col > (_mapWidth - 1))
					{
						col=0;
						row++;
					}

					if (_layers[i].getData()[j] != 0)
					{


						img=new Image(_tilesheets[findTileSheet(_layers[i].getData()[j])].textureAtlas.getTexture(String(_layers[i].getData()[j])));
						//img.x = col;
						//img.y = row;

						isoPt=getPoint(col, row);
						//isoPt  = new Point(col ,row);
						pt=projection.transformPoint(isoPt);
						img.x=pt.x;
						img.y=pt.y;
						_layers[i].add(img);
					}

					col++;
				}
			}


			/*displayArea.x = width * .5;
			_displayArea.y = height * .5;
			moveTo(width,height);*/
			// notify that the load is complete
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}


		private function getPoint(gridX:int, gridY:int):Point
		{
			return new Point(gridX * sqEdgeSize, gridY * sqEdgeSize);
		}

		private function findTileSheet(id:uint):int
		{
			var value:int=0;
			var theOne:int;
			for (var i:int=0; i < _tilesheets.length; i++)
			{
				if (_tilesheets[i].textureAtlas.getTexture(String(id)) != null)
				{
					theOne=i;
				}
				else
				{
					value=i;
				}
			}
			return theOne;
		}
	}
}
