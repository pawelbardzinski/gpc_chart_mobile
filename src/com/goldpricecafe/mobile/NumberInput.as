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
		public function set numericValue( val:Number ) : void {
			
			_value = val;
			text = format( _value );
			
		}			
		public function get numericValue() : Number { 
			return _value;		
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
		
		protected var _value:Number;
		protected var _formater:spark.formatters.NumberFormatter;
		protected var _editing:Boolean = false;
		protected var _maxChars:Number;
		
		protected override function focusInHandler(event:FocusEvent) : void {
			
			super.focusInHandler(event);
			
			_editing = true;	
			text = format(numericValue);
			super.maxChars = NaN;

		}
		
		protected override function focusOutHandler(event:FocusEvent) : void {
			
			
			var newValue:Number = Number( text );
			
			if( isNaN(newValue) ) {		
				numericValue = 0;		
			} else {
				numericValue = newValue;
			}
			
			_editing = false;		
			text = format(numericValue);
			super.maxChars = _maxChars;	
			super.focusOutHandler(event);			
	
		}		
				
		
		protected function format( val:Number ) : String {
			
			if( _editing || (!_formater) ) {
				return isNaN(val) ? null : val.toString();
			}
			
			return _formater.format(val);
			
		}
		
	}
}