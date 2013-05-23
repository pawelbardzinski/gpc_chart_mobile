package com.goldpricecafe.mobile
{

	import flash.events.FocusEvent;
	import spark.components.TextInput;
	import spark.formatters.NumberFormatter;
	
	public class NumberInput extends TextInput		
	{
		
		public function NumberInput() {
			
			super.restrict = "0-9 .,";
			
			addEventListener("creationComplated", function() : void  {
				text = format(_value);
			});
	
		}
		
		//////////////////////////////////////////////
		//                                     		//
		//				Properties					//
		//											//
		//////////////////////////////////////////////
		
		[Bindable]
		public function set numericValue( val:Number ) : void
		{		
			_value = val;
			text = format(_value);
		}			
		public function get numericValue() : Number 
		{ 
			return _value;		
		}
			
		
		[Bindable]
		public function set maximum( val:Number ) : void {
			
			_maximum = val;
			
		}			
		public function get maximum() : Number { 
			return _maximum;		
		}
		
		[Bindable]
		public function set minimum( val:Number ) : void {
			
			_minimum = val;
			
		}			
		public function get minimum() : Number { 
			return _minimum;		
		}
		
		public function set numberFormater( formater:NumberFormatter ) : void {
			_formater = formater;
			text = format(_value);
		}		
		public function get numberFormater() : NumberFormatter {
			return _formater;		
		}
		
		
		public override function set maxChars(value:int) : void {
			
			_maxChars = value;
			if(!_editing) {
				super.maxChars = _maxChars;
			}
			
		}
		
		//////////////////////////////////////////////
		//                                     		//
		//					Protected				//
		//											//
		//////////////////////////////////////////////	
		
		protected static var _defaultFormater:NumberFormatter = new NumberFormatter();
		
		protected var _value:Number;
		protected var _formater:NumberFormatter = _defaultFormater;
		protected var _editing:Boolean = false;
		protected var _maxChars:Number;
		protected var _maximum:Number = NaN;
		protected var _minimum:Number = NaN;
		
		
		protected override function focusInHandler(event:FocusEvent) : void {
				
			_editing = true;
			super.textDisplay.text = _value.toString();
			super.maxChars = NaN;	
			
			super.focusInHandler(event);

		}
		
		protected override function focusOutHandler(event:FocusEvent) : void {
	
			_editing = false;
			var val:Number = Number( text );
			
			if( val < _minimum ) {
				val = _minimum;
			}
			
			if( val > _maximum ) {
				val = _maximum ;
			}
			
			numericValue = val;
			super.textDisplay.text = format(_value);
			super.focusOutHandler(event);

		}	
		
					
		protected function format( val:Number ) : String {
			
			if( _editing ) {
				return val.toString();
			}
			
			return _formater.format(val);
			
		}
		
		
	}
}