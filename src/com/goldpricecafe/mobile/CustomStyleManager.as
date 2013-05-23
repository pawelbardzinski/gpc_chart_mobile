package com.goldpricecafe.mobile
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.events.StyleEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	
	import spark.managers.PersistenceManager;

	[Event(name="stylesUpdated", type="flash.events.Event")]
	public class CustomStyleManager	extends EventDispatcher implements IEventDispatcher
	{
		protected static const DEFAULT_STYLE_SWF:String = "assets/goldpricecafe_styles.swf";
		protected static const _styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;		
		protected static const _eventDispacher:IEventDispatcher = new EventDispatcher();
		protected static const _selectors:Array = ["global",".selected",".button","s|Application","s|TextInput","s|BusyIndicator"];
		protected static const _styles:Array = ["color","borderColor","chromeColor","fontFamiliy","backgroundColor","symbolColor"];	
		
		protected static var _scheme:String = "default";
		protected static var _requestedScheme:String;
		
		//////////////////////////////////////////////
		
		public static function loadPreset( name:String ) : void {
			
			if(!_styleManager) {
				trace("No styleManager");
				return;
			}
			
			_requestedScheme = name.toLocaleLowerCase();
			var fileName:String = (_requestedScheme == "default") ? DEFAULT_STYLE_SWF : ("assets/" + _requestedScheme + ".swf");
			
 
			var myEvent:IEventDispatcher = _styleManager.loadStyleDeclarations(fileName);
			myEvent.addEventListener( StyleEvent.COMPLETE, function() : void {
				_scheme = _requestedScheme;
				_eventDispacher.dispatchEvent(new Event("stylesUpdated"));
			});
			
		}
		
		public static function getTheme() : String {
			
			return _scheme;
			
		}		
		
		/* Top line */
		
		public static function setTopLinePriceColor(color:Number) : void {			
			
			setStyle("#headerLabel","color",color);
			
		}
		
		public static function getTopLinePriceColor() : Number {
			
			return Number( getStyle("#headerLabel","color") );
			
		}
		
		public static function setTopLineCountdownColor(color:Number) : void {			
			
			setStyle("#timeLabel","color",color);
			
		}
		
		public static function getTopLineCountdownColor() : Number {
			
			return Number( getStyle("#timeLabel","color") );
			
		}
		
		/* Fonts */

		public static function setFontFamily(val:String) : void {
			
			var fontFamily:String = val.toLowerCase();

			setStyle("global","fontFamily", fontFamily);
			setStyle(".button","fontFamily", fontFamily);
			setStyle(".radioBtn","fontFamily", fontFamily);
			setStyle(".myLabel","fontFamily", fontFamily+"CFF");

		}
		
		public static function getFontFamily() : String {
			
			return String( getStyle(".button","fontFamily") );
			
		}
		
		public static function setFontColor(color:uint) : void {
			
			setStyle("global","color", color);
			setStyle("s|TextInput","color", color);
		}		
		
		public static function getFontColor() : Number {
			
			return Number( getStyle("global","color") );
			
		}
		
		public static function setFontSize(size:uint) : void {
			
			setStyle(".fontBig","fontSize",  size);
			
		}		
		
		public static function getFontSize() : Number {
			
			return Number( getStyle(".fontBig","fontSize") );
			
		}		
		
		public static function setChartFontFamily(val:String) : void {
			
			var fontFamily:String = val.toLowerCase();			
			setStyle("#chartPanel","fontFamily", fontFamily); 
	
		}
		
		public static function getChartFontFamily() : String {
			
			return String( getStyle("#chartPanel","fontFamily") );
			
		}		
		
		public static function setChartFontColor(color:uint) : void {
			
			setStyle("#chartPanel","color", color);

		}
		
		public static function getChartFontColor() : Number {
			
			return Number( getStyle("#chartPanel","color") );
			
		}
		
		public static function setChartFontSize(size:uint) : void {
			
			setStyle(".fontChart","fontSize",  size);
			setStyle(".chartPanel","fontSize",  size);
			
		}		
		
		public static function getChartFontSize() : Number {
			
			return Number( getStyle(".fontChart","fontSize") );
			
		}
		
		public static function setSelectedFontColor(color:uint) : void {
			
			setStyle(".selected","color", color);
			setStyle("#fullScreenBtn","color", color);
			setStyle("chartClasses|DataTip","color", color);
		
		}
		
		public static function getSelectedFontColor() : Number {
			
			return Number( getStyle(".selected","color") );
			
		}
		
		/* Borders */
		
		public static function setBorderColor(color:uint) : void {
			
			setStyle("global","borderColor", color);
			setStyle(".myDropDown","borderColor", color);
			
		}
		
		public static function getBorderColor() : Number {
			
			return Number( getStyle("global","borderColor") );
			
		}
		
		public static function setSelectedBorderColor(color:uint) : void {
			
			setStyle(".selected","borderColor", color);
			setStyle("mx|DataTip","borderColor", color);
			
		}
		
		public static function getSelectedBorderColor() : Number {
			
			return Number( getStyle(".selected","borderColor") );
			
		}
		
		/* Button color */
			
		
		public static function setButtonColor(color:uint) : void {
			
			setStyle(".button","chromeColor", color);
			setStyle("s|ButtonBar *","chromeColor", color);
			
		}
		
		public static function getButtonColor() : Number {
			
			return Number( getStyle(".button","chromeColor") );
			
		}
		
		public static function setSelectedChromeColor(color:uint) : void {
			
			setStyle(".selected","chromeColor", color);
			setStyle(".selected","backgroundColor", color);
			setStyle("#fullScreenBtn","chromeColor", color);
	
		}
		
		public static function getSelectedChromeColor() : Number {
			
			return Number( getStyle(".selected","chromeColor") );
			
		}
		
		/* Background color */
		
		public static function setBackgroundColor(color:uint) : void {
			
			setStyle(".application","backgroundColor", color);
			setStyle(".myDropDown","contentBackgroundColor", color);
			
		}
		
		public static function getBackgroundColor() : Number {
			
			return Number( getStyle(".application","backgroundColor") );
			
		}
		
		/* Grid */
		
		public static function setChartBackgroundColor(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_CHART_BACKGROUND_COLOR, color);
			
		}
		
		public static function getChartBackgroundColor() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_CHART_BACKGROUND_COLOR) );
			
		}
		
		public static function setChartBackgroundAlpha(alpha:Number) : void {
			
			setStyle("#chartPanel",Chart.STYLE_CHART_BACKGROUND_ALPHA, alpha);
			
		}
		
		public static function getChartBackgroundAlpha() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_CHART_BACKGROUND_ALPHA) );
			
		}		
		
			/* horizontal */
		
		public static function setHGridStrokeColor(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_H_GRID_STROKE_COLOR, color);
			
		}
		
		public static function getHGridStrokeColor() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_H_GRID_STROKE_COLOR) );
			
		}
		
		public static function setHGridStrokeAlpha(alpha:Number) : void {
			
			setStyle("#chartPanel",Chart.STYLE_H_GRID_STROKE_ALPHA, alpha);
			
		}
		
		public static function getHGridStrokeAlpha() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_H_GRID_STROKE_ALPHA) );
			
		}
		
		public static function setHGridFillColor(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_H_GRID_FILL_COLOR, color);
			
		}
		
		public static function getHGridFillColor() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_H_GRID_FILL_COLOR) );
			
		}
		
		public static function setHGridFillAlpha(alpha:Number) : void {
			
			setStyle("#chartPanel",Chart.STYLE_H_GRID_FILL_ALPHA, alpha);
			
		}
		
		public static function getHGridFillAlpha() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_H_GRID_FILL_ALPHA) );
			
		}
			/* vertical */
		
		public static function setVGridStrokeColor(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_V_GRID_STROKE_COLOR, color);
			
		}
		
		public static function getVGridStrokeColor() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_V_GRID_STROKE_COLOR) );
			
		}
		
		public static function setVGridStrokeAlpha(alpha:Number) : void {
			
			setStyle("#chartPanel",Chart.STYLE_V_GRID_STROKE_ALPHA, alpha);
			
		}
		
		public static function getVGridStrokeAlpha() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_V_GRID_STROKE_ALPHA) );
			
		}
		
		public static function setVGridFillColor(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_V_GRID_FILL_COLOR, color);
			
		}
		
		public static function getVGridFillColor() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_V_GRID_FILL_COLOR) );
			
		}
		
		public static function setVGridFillAlpha(alpha:Number) : void {
			
			setStyle("#chartPanel",Chart.STYLE_V_GRID_FILL_ALPHA, alpha);
			
		}
		
		public static function getVGridFillAlpha() : Number {
			
			return Number( getStyle("#chartPanel",Chart.STYLE_V_GRID_FILL_ALPHA) );
			
		}
		
		/* Series */
		
		public static function setMainSerieColor(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_SERIE_TODAY_COLOR, color);
			
		}
		
		public static function getMainSerieColor() : Number {
			
			return Number(getStyle("#chartPanel",Chart.STYLE_SERIE_TODAY_COLOR));
			
		}
		
		public static function setMainSerieWidth(width:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_SERIE_TODAY_WIDTH, width);
			
		}
		
		public static function getMainSerieWidth() : Number {
			
			return Number(getStyle("#chartPanel",Chart.STYLE_SERIE_TODAY_WIDTH));
			
		}
		
		public static function setSerie2Color(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_SERIE_1_DAY_AGO_COLOR, color);
			
		}
		
		public static function getSerie2Color() : Number {
			
			return Number(getStyle("#chartPanel",Chart.STYLE_SERIE_1_DAY_AGO_COLOR));
			
		}
		
		public static function setSerie2Width(width:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_SERIE_1_DAY_AGO_WIDTH, width);
			
		}
		
		public static function getSerie2Width() : Number {
			
			return Number(getStyle("#chartPanel",Chart.STYLE_SERIE_1_DAY_AGO_WIDTH));
			
		}
		
		public static function setSerie3Color(color:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_SERIE_2_DAYS_AGO_COLOR, color);
			
		}
		
		public static function getSerie3Color() : Number {
			
			return Number(getStyle("#chartPanel",Chart.STYLE_SERIE_2_DAYS_AGO_COLOR));
			
		}
		
		public static function setSerie3Width(width:uint) : void {
			
			setStyle("#chartPanel",Chart.STYLE_SERIE_2_DAYS_AGO_WIDTH, width);
			
		}
		
		public static function getSerie3Width() : Number {
			
			return Number(getStyle("#chartPanel",Chart.STYLE_SERIE_2_DAYS_AGO_WIDTH));
			
		}
		//////////////////////////////////////////////////
		
		public static function setStyle( selector:String, style:String, value:Object ) : void {
			
			if(!_styleManager) {
				trace("No styleManager");
				return;
			}
			
			var sd:CSSStyleDeclaration = _styleManager.getStyleDeclaration( selector );
			if(!sd) {
				trace("Style declaration '" + selector + "' not found.");
				return;
			}
			
			try {
				sd.setStyle(style,value);
			} catch( e:Error ) {
				trace(e.message);
			}
			
		}
		
		public static function getStyle( styleDeclaration:String, style:String ) : Object {
			
			if(!_styleManager) {
				trace("No styleManager");
				return null;
			}
			
			var sd:CSSStyleDeclaration = _styleManager.getStyleDeclaration( styleDeclaration );
			if(!sd) {
				trace("Style declaration '" + styleDeclaration + "' not found.");
				return null;
			}
			
			var value:String = "";
			try {
				value = sd.getStyle(style);
			} catch( e:Error ) {
				trace(e.message);
			}
			
			return value;
			
		}		
		
		public static function resetStyles() : void {
					
			if(!_styleManager) {
				trace("No styleManager");
				return;
			}
			
			var myEvent:IEventDispatcher = _styleManager.loadStyleDeclarations(DEFAULT_STYLE_SWF);
			myEvent.addEventListener( StyleEvent.COMPLETE, function() : void {
				_eventDispacher.dispatchEvent(new Event("stylesUpdated"));
			});

			
		}
		
		
		
		public static function loadStyles() : Boolean {
			
			var persistenceManager:PersistenceManager = new PersistenceManager();
			var styles:Object = persistenceManager.getProperty("styles");
			
			if( styles ) {
				
				for (var styleDeclaration:String in styles) {
					
					for( var style:String in styles[styleDeclaration] ) {
						
						setStyle( styleDeclaration, style, styles[styleDeclaration][style] );
						
					}
				}
				
				return true;
				
			}
			
			return false;
			
		}
		
		public static function saveStyles() : void {
			
			var styles:Object = {};
			
			
			for( var i:uint = 0; i < _selectors.length; i++ ) {
								
				var selector:String = _selectors[i];
				var sd:CSSStyleDeclaration = _styleManager.getStyleDeclaration( selector );
				
				if(sd) {
					
					styles[selector] = {};
					for( var j:uint = 0; j < _styles.length; j++ ) {
						
						var style:String = _styles[j];
						var value:Object = sd.getStyle( style );
						
						if( _styleManager.isValidStyleValue(value) ) {
							styles[selector][style] = value;
						}
						
					}
				}
				
			}
			
			var persistenceManager:PersistenceManager = new PersistenceManager();
			persistenceManager.setProperty("styles",styles);
			
		}
		
		
		/* IEventHandler interface implementation */
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispacher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return _eventDispacher.dispatchEvent(event);
		}
		
		public static function hasEventListener(type:String):Boolean
		{
			return _eventDispacher.hasEventListener(type);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispacher.removeEventListener(type, listener, useCapture);
		}
		
		public static function willTrigger(type:String):Boolean
		{
			return _eventDispacher.willTrigger(type);
		}
		
		
		
	}
}