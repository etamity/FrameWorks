package com.smart.logs.console
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;

	import feathers.text.BitmapFontTextFormat;
    import feathers.core.FeathersControl;
	import feathers.controls.Label;
	import starling.events.Event;

	internal class ConsoleItemRenderer extends FeathersControl implements IListItemRenderer
	{
		private static var _format:BitmapFontTextFormat = null;
		private static var _formatHighlight:BitmapFontTextFormat = null;
		
		private var _data:Object;
		private var _index:int;
		private var _owner:List;
		private var _isSelected:Boolean;
		
		private var _label:Label;
		private var _setting:ConsoleConfig;
		[Event(name="change",type="starling.events.Event")]
		
		public function ConsoleItemRenderer(setting:ConsoleConfig) 
		{	
			_setting = setting;
			
			this.height= _setting.logItemHeight;
			
		}
		override protected function initialize():void
		{	
			if(!this._label)
			{
			
				this._label = new Label();
				this.addChild(this._label);
			}
		}
		protected function commitData():void
		{
			if(this._data)
			{
				this._label.text = this._data.label.toString();
			}
			else
			{
				this._label.text = "";
			}
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
 
			if(dataInvalid)
			{
				this.commitData();
			}
 
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
 
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
		protected function layout():void
		{
			this._label.width = this.actualWidth;
			this._label.height = this.actualHeight;
		}
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this._label.width = NaN;
			this._label.height = NaN;
			this._label.validate();
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this._label.width;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = this._label.height;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		public function get data():Object 
		{
			return _data;
		}
		public function get owner():List
		{
			return List(this._owner);
		}
 
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		public function set data(value:Object):void 
		{
			if (value == null) 
			{
				return;
			}
			
			_label.text = value.label;
			_data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);

		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			if (_isSelected == value) 
			{
				return;
			}
			
			if (value) 
			{
				_label.textRendererProperties.textFormat = _setting.highLightTextFormat;
			}
			else 
			{
				_label.textRendererProperties.textFormat = _setting.defaultTextFormat;
			}
			
			_isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED)
			dispatchEventWith(Event.CHANGE);
		}
		 
	}
}