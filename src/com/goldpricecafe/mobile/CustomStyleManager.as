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
		protected static const _styleDefs:Object = generateStyleDefs();
		
		/* Predefined themes */
		protected static const CUSTOM_THEME:String = "custom";
		
		/* Style names */
		public static const STYLE_APP_BACK_COLOR:String = "appBackColor";
		public static const STYLE_TOP_LINE_PRICE_COLOR:String = "topLinePriceColor";
		public static const STYLE_TOP_LINE_TIME_COLOR:String = "topLineTimeColor";
		public static const STYLE_MAIN_FONT_FAMILY:String = "mainFontFamily";
		public static const STYLE_MAIN_FONT_COLOR:String = "mainFontColor";
		public static const STYLE_MAIN_FONT_SIZE:String = "mainFontSize";
		
		public static const STYLE_BUTTON_COLOR:String = "buttonColor";
		public static const STYLE_BORDER_COLOR:String = "borderColor";		
		
		public static const STYLE_SELECTED_COLOR:String = "selectedFontColor";
		public static const STYLE_SELECTED_FONT_COLOR:String = "selectedFontColor";
		public static const STYLE_SELECTED_BORDER_COLOR:String = "selectedBorderColor";
		
		public static const STYLE_CHART_FONT_FAMILY:String = "chartFontFamily";
		public static const STYLE_CHART_FONT_COLOR:String = "chartFontColor";
		public static const STYLE_CHART_FONT_SIZE:String = "chartFontSize";
		public static const STYLE_CHART_BACK_COLOR:String = "chartBackColor";
		public static const STYLE_CHART_BACK_ALPHA:String = "chartBackAlpha";
		
		public static const STYLE_H_GRID_STROKE_COLOR:String = "hGridStrokeColor";
		public static const STYLE_H_GRID_STROKE_ALPHA:String = "hGridStrokeAlpha";
		public static const STYLE_H_GRID_FILL_COLOR:String = "hGridFillColor";
		public static const STYLE_H_GRID_FILL_ALPHA:String = "hGridFillAlpha";		
		
		public static const STYLE_V_GRID_STROKE_COLOR:String = "vGridStrokeColor";
		public static const STYLE_V_GRID_STROKE_ALPHA:String = "vGridStrokeAlpha";
		public static const STYLE_V_GRID_FILL_COLOR:String = "vGridFillColor";
		public static const STYLE_V_GRID_FILL_ALPHA:String = "vGridFillAlpha";
		
		public static const STYLE_TODAY_SERIES_COLOR:String = "todaySeriesColor";		
		public static const STYLE_TODAY_SERIES_WIDTH:String = "todaySeriesWidth";
		public static const STYLE_YESTERDAY_SERIES_COLOR:String = "yesterdaySeriesColor";		
		public static const STYLE_YESTERDAY_SERIES_WIDTH:String = "yesterdaySeriesWidth";		
		public static const STYLE_TWO_DAYS_AGO_SERIES_COLOR:String = "twoDaysAgoSeriesColor";		
		public static const STYLE_TWO_DAYS_AGO_SERIES_WIDTH:String = "twoDaysAgoSeriesWidth";		
		
		public static var themeNames:Array;
		public static var currentTheme:String;
		
		//////////////////////////////////////////////
		
		protected static var _requestedTheme:String;
		protected static var _externChange:Boolean = true;
		protected static var _savedThemes:Object;
		public static var swfThemes:Array = ["default","test"];

		//////////////////////////////////////////////
		
		public static function generateStyleDefs() : Object {
			
			var styles:Object = {};
			
			/* Application background color */
			
			styles[STYLE_APP_BACK_COLOR] = [
				{selector:".application",style:"backgroundColor"},
				{selector:".myDropDown",style:"contentBackgroundColor"}
			];
			
			/* Top line */
			
			styles[STYLE_TOP_LINE_PRICE_COLOR] = [{selector:"#headerLabel",style:"color"}];
			
			styles[STYLE_TOP_LINE_TIME_COLOR] = [{selector:"#timeLabel",style:"color"}];
			
			/* Main font */
			
			styles[STYLE_MAIN_FONT_FAMILY] = [
				{selector:"global", style:"fontFamily"},
				{selector:".button", style:"fontFamily"},
				{selector:".radioBtn", style:"fontFamily"},
				{selector:".myLabel", style:"fontFamily"}
			];
			
			styles[STYLE_MAIN_FONT_COLOR] = [
				{selector:"global", style:"color"},
				{selector:"s|TextInput", style:"color"}
			];
			
			styles[STYLE_MAIN_FONT_SIZE] = [{selector:".fontBig",style:"fontSize"}];
			
			/* Buttons */
		
			styles[STYLE_BUTTON_COLOR] = [
				{selector:".button", style:"chromeColor"}
			];
			
			styles[STYLE_BORDER_COLOR] = [
				{selector:"global", style:"borderColor"},
				{selector:".myDropDown", style:"borderColor"}
			];			
			
			/* Selected */
			
			styles[STYLE_SELECTED_FONT_COLOR] = [
				{selector:".selected", style:"color"},
				{selector:"#fullScreenBtn", style:"color"},
				{selector:"chartClasses|DataTip", style:"color"}
			];	
						
			styles[STYLE_SELECTED_COLOR] = [
				{selector:".selected", style:"chromeColor"},
				{selector:".selected", style:"backgroundColor"},
				{selector:"#fullScreenBtn", style:"chromeColor"}
			];
								
			styles[STYLE_SELECTED_BORDER_COLOR] = [
				{selector:".selected", style:"borderColor"},
				{selector:"mx|DataTip", style:"borderColor"}
			];			
			
			/* Chart font */
			
			styles[STYLE_CHART_FONT_FAMILY] = [
				{selector:"#chartPanel", style:"fontFamily"}
			];
			
			styles[STYLE_CHART_FONT_COLOR] = [
				{selector:"#chartPanel", style:"color"}
			];
			
			styles[STYLE_CHART_FONT_SIZE] = [
				{selector:".fontChart",style:"fontSize"},
				{selector:"#chartPanel",style:"fontSize"},				
			];
			
			/* Chart background */
			
			styles[STYLE_CHART_BACK_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_CHART_BACKGROUND_COLOR },
				{selector:"#chartUpdatedLbl", style: "backgroundColor" }
			];
			
			styles[STYLE_CHART_BACK_ALPHA] = [
				{selector:"#chartPanel", style: Chart.STYLE_CHART_BACKGROUND_ALPHA }
			];
			
			/* Horizontal grid */
			
			styles[STYLE_H_GRID_STROKE_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_H_GRID_STROKE_COLOR },
			];
			
			styles[STYLE_H_GRID_STROKE_ALPHA] = [
				{selector:"#chartPanel", style: Chart.STYLE_H_GRID_STROKE_ALPHA },
			];
			
			styles[STYLE_H_GRID_FILL_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_H_GRID_FILL_COLOR },
			];
			
			styles[STYLE_H_GRID_FILL_ALPHA] = [
				{selector:"#chartPanel", style: Chart.STYLE_H_GRID_FILL_ALPHA },
			];
			
			/* Vertical grid */
			
			styles[STYLE_V_GRID_STROKE_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_V_GRID_STROKE_COLOR },
			];
			
			styles[STYLE_V_GRID_STROKE_ALPHA] = [
				{selector:"#chartPanel", style: Chart.STYLE_V_GRID_STROKE_ALPHA },
			];
			
			styles[STYLE_V_GRID_FILL_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_V_GRID_FILL_COLOR },
			];
			
			styles[STYLE_V_GRID_FILL_ALPHA] = [
				{selector:"#chartPanel", style: Chart.STYLE_V_GRID_FILL_ALPHA },
			];
			
			/* Series */
			
			styles[STYLE_TODAY_SERIES_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_SERIE_TODAY_COLOR },
			];
			styles[STYLE_TODAY_SERIES_WIDTH] = [
				{selector:"#chartPanel", style: Chart.STYLE_SERIE_TODAY_WIDTH },
			];
			styles[STYLE_YESTERDAY_SERIES_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_SERIE_1_DAY_AGO_COLOR },
			];
			styles[STYLE_YESTERDAY_SERIES_WIDTH] = [
				{selector:"#chartPanel", style: Chart.STYLE_SERIE_1_DAY_AGO_WIDTH },
			];
			styles[STYLE_TWO_DAYS_AGO_SERIES_COLOR] = [
				{selector:"#chartPanel", style: Chart.STYLE_SERIE_2_DAYS_AGO_COLOR },
			];
			styles[STYLE_TWO_DAYS_AGO_SERIES_WIDTH] = [
				{selector:"#chartPanel", style: Chart.STYLE_SERIE_2_DAYS_AGO_WIDTH },
			];
			
			return styles;
		}
		

		/* Background color */
		
		public static function setBackgroundColor(color:uint) : void 
		{		
			setCustomStyle(STYLE_APP_BACK_COLOR, color );			
		}
		
		public static function getBackgroundColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_APP_BACK_COLOR) );			
		}
		
		/* Top line */
		
		public static function setTopLinePriceColor(color:Number) : void 
		{					
			setCustomStyle(STYLE_TOP_LINE_PRICE_COLOR, color );			
		}
		
		public static function getTopLinePriceColor() : Number 
		{		
			return Number( getCustomStyle(STYLE_TOP_LINE_PRICE_COLOR) );		
		}
		
		public static function setTopLineCountdownColor(color:Number) : void 
		{					
			setCustomStyle(STYLE_TOP_LINE_TIME_COLOR, color );		
		}
		
		public static function getTopLineCountdownColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_TOP_LINE_TIME_COLOR) );			
		}
		
		/* Main font */

		public static function setFontFamily(val:String) : void 
		{			
			setCustomStyle(STYLE_MAIN_FONT_FAMILY, val.toLowerCase() );
		}
		
		public static function getFontFamily() : String 
		{			
			return String( getCustomStyle(STYLE_MAIN_FONT_FAMILY) );			
		}
		
		public static function setFontColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_MAIN_FONT_COLOR, color );
		}		
		
		public static function getFontColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_MAIN_FONT_COLOR) );		
		}
		
		public static function setFontSize(size:uint) : void 
		{			
			setCustomStyle(STYLE_MAIN_FONT_SIZE, size );			
		}		
		
		public static function getFontSize() : Number 
		{		
			return Number( getCustomStyle(STYLE_MAIN_FONT_SIZE) );					
		}	
		
		/* Chart font */
		
		public static function setChartFontFamily(val:String) : void 
		{			
			setCustomStyle(STYLE_CHART_FONT_FAMILY, val.toLowerCase() );	
		}
		
		public static function getChartFontFamily() : String 
		{			
			return String( getCustomStyle(STYLE_CHART_FONT_FAMILY) );		
		}		
		
		public static function setChartFontColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_CHART_FONT_COLOR, color );
		}
		
		public static function getChartFontColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_CHART_FONT_COLOR) );				
		}
		
		public static function setChartFontSize(size:uint) : void 
		{		
			setCustomStyle(STYLE_CHART_FONT_SIZE, size );		
		}		
		
		public static function getChartFontSize() : Number 
		{		
			return Number( getCustomStyle(STYLE_CHART_FONT_SIZE) );				
		}
		
		/* Chart background */
		
		public static function setChartBackgroundColor(color:uint) : void 
		{			
			setCustomStyle( STYLE_CHART_BACK_COLOR, color);			
		}
		
		public static function getChartBackgroundColor() : Number 
		{		
			return Number( getCustomStyle(STYLE_CHART_BACK_COLOR) );			
		}
		
		public static function setChartBackgroundAlpha(alpha:Number) : void 
		{		
			setCustomStyle( STYLE_CHART_BACK_ALPHA, alpha);			
		}
		
		public static function getChartBackgroundAlpha() : Number 
		{			
			return Number( getCustomStyle(STYLE_CHART_BACK_ALPHA) );			
		}
		
		/* Selected */
		
		public static function setSelectedFontColor(color:uint) : void
		{			
			setCustomStyle(STYLE_SELECTED_FONT_COLOR,color);		
		}
		
		public static function getSelectedFontColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_SELECTED_FONT_COLOR) );			
		}
		
		public static function setSelectedBorderColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_SELECTED_BORDER_COLOR,color);			
		}
		
		public static function getSelectedBorderColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_SELECTED_BORDER_COLOR) );			
		}	
		
		public static function setSelectedChromeColor(color:uint) : void
		{		
			setCustomStyle(STYLE_SELECTED_COLOR,color);			
		}
		
		public static function getSelectedChromeColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_SELECTED_COLOR) );			
		}
		
		/* Buttons */
		
		public static function setBorderColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_BORDER_COLOR,color);			
		}
		
		public static function getBorderColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_BORDER_COLOR) );			
		}
			
		
		public static function setButtonColor(color:uint) : void 
		{		
			setCustomStyle(STYLE_BUTTON_COLOR,color);			
		}
		
		public static function getButtonColor() : Number
		{			
			return Number( getCustomStyle(STYLE_BUTTON_COLOR) );			
		}
		
		
		/* Horizontal grid */
		
		public static function setHGridStrokeColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_H_GRID_STROKE_COLOR, color);			
		}
		
		public static function getHGridStrokeColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_H_GRID_STROKE_COLOR) );			
		}
		
		public static function setHGridStrokeAlpha(alpha:Number) : void 
		{			
			setCustomStyle(STYLE_H_GRID_STROKE_ALPHA, alpha);			
		}
		
		public static function getHGridStrokeAlpha() : Number 
		{			
			return Number( getCustomStyle(STYLE_H_GRID_STROKE_ALPHA) );			
		}
		
		public static function setHGridFillColor(color:uint) : void 
		{		
			setCustomStyle(STYLE_H_GRID_FILL_COLOR, color);		
		}
		
		public static function getHGridFillColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_H_GRID_FILL_COLOR) );			
		}
		
		public static function setHGridFillAlpha(alpha:Number) : void 
		{			
			setCustomStyle(STYLE_H_GRID_FILL_ALPHA, alpha);			
		}
		
		public static function getHGridFillAlpha() : Number 
		{			
			return Number( getCustomStyle(STYLE_H_GRID_FILL_ALPHA) );			
		}
		
		/* Vertical grid */
		
		public static function setVGridStrokeColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_V_GRID_STROKE_COLOR, color);			
		}
		
		public static function getVGridStrokeColor() : Number 
		{		
			return Number( getCustomStyle(STYLE_V_GRID_STROKE_COLOR) );			
		}
		
		public static function setVGridStrokeAlpha(alpha:Number) : void 
		{			
			setCustomStyle(STYLE_V_GRID_STROKE_ALPHA, alpha);			
		}
		
		public static function getVGridStrokeAlpha() : Number 
		{		
			return Number( getCustomStyle(STYLE_V_GRID_STROKE_ALPHA) );			
		}
		
		public static function setVGridFillColor(color:uint) : void 
		{			
			setCustomStyle(STYLE_V_GRID_FILL_COLOR, color);			
		}
		
		public static function getVGridFillColor() : Number 
		{			
			return Number( getCustomStyle(STYLE_V_GRID_FILL_COLOR) );			
		}
		
		public static function setVGridFillAlpha(alpha:Number) : void 
		{			
			setCustomStyle(STYLE_V_GRID_FILL_ALPHA, alpha);			
		}
		
		public static function getVGridFillAlpha() : Number 
		{			
			return Number( getCustomStyle(STYLE_V_GRID_FILL_ALPHA) );			
		}
		
		/* Series */
		
		public static function setMainSerieColor(color:uint) : void 
		{		
			setCustomStyle(STYLE_TODAY_SERIES_COLOR, color);		
		}
		
		public static function getMainSerieColor() : Number 
		{			
			return Number(getCustomStyle(STYLE_TODAY_SERIES_COLOR));			
		}
		
		public static function setMainSerieWidth(width:uint) : void
		{			
			setCustomStyle(STYLE_TODAY_SERIES_WIDTH, width);			
		}
		
		public static function getMainSerieWidth() : Number 
		{		
			return Number(getCustomStyle(STYLE_TODAY_SERIES_WIDTH));		
		}
		
		public static function setSerie2Color(color:uint) : void 
		{			
			setCustomStyle(STYLE_YESTERDAY_SERIES_COLOR, color);			
		}
		
		public static function getSerie2Color() : Number 
		{		
			return Number(getCustomStyle(STYLE_YESTERDAY_SERIES_COLOR));			
		}
		
		public static function setSerie2Width(width:uint) : void 
		{		
			setCustomStyle(STYLE_YESTERDAY_SERIES_WIDTH, width);			
		}
		
		public static function getSerie2Width() : Number
		{			
			return Number(getCustomStyle(STYLE_YESTERDAY_SERIES_WIDTH));			
		}
		
		public static function setSerie3Color(color:uint) : void 
		{			
			setCustomStyle(STYLE_TWO_DAYS_AGO_SERIES_COLOR, color);		
		}
		
		public static function getSerie3Color() : Number 
		{			
			return Number(getCustomStyle(STYLE_TWO_DAYS_AGO_SERIES_COLOR));			
		}
		
		public static function setSerie3Width(width:uint) : void 
		{			
			setCustomStyle(STYLE_TWO_DAYS_AGO_SERIES_WIDTH, width);			
		}
		
		public static function getSerie3Width() : Number 
		{			
			return Number(getCustomStyle(STYLE_TWO_DAYS_AGO_SERIES_WIDTH));			
		}
		
		//////////////////////////////////////////////////
		
		public static function setCustomStyle( name:String, value:Object ) : void {
			
			var styles:Array = (_styleDefs[name] as Array);
			for( var i:int = 0; i < styles.length; i++ ) {
				
				var selector:String = styles[i]["selector"];
				var style:String = styles[i]["style"];
				var val:Object = ( selector == ".myLabel" && style == "fontFamily") ? value + "CFF" : value;
				
				setStyle( selector, style, val );
			}
			
		}
		
		public static function getCustomStyle( name:String ) : Object {
			
			var styles:Array = (_styleDefs[name] as Array);
			if( styles.length > 0 ) {
				return getStyle( styles[0]["selector"], styles[0]["style"]);
			}
			
			return null;
			
		}
		
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
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		
		public static function resetTheme() : void {
					
			loadTheme( currentTheme );
		
		}
		
		public static function saveTheme( name:String ) : void {
			
			var theme:Object = {};
			
			for( var style:String in _styleDefs ) {
				
				theme[style] = getCustomStyle(style);
				
			}
			
			_savedThemes[ name ] = theme;
			if( themeNames.indexOf(name) < 0 ) {
				themeNames.push( name );
			}
			currentTheme = name;
			
			var persistenceManager:PersistenceManager = new PersistenceManager();
			persistenceManager.setProperty("themes", _savedThemes);
			
		}
		
		public static function loadThemes() : Boolean {
			
			var names:Array = [];
			
			for( var i:int = 0; i < swfThemes.length; i++ ) {
				names.push(swfThemes[i]);
			}
			
			var persistenceManager:PersistenceManager = new PersistenceManager();
			var savedThemes:Object = persistenceManager.getProperty("themes");
			
			if(savedThemes) {
				
				for( var theme:String in savedThemes ) {
					names.push(theme);
				}
				
				_savedThemes = savedThemes;
				
			} else {
				
				_savedThemes = {};
			}
			
			themeNames = names;
			
			var current:Object = persistenceManager.getProperty("currentTheme");
			currentTheme = current ? String(current) : "default";
			
			loadTheme( currentTheme );
			
			return true;
			
		}
		
		public static function loadTheme( name:String ) : void  {
			
			if( swfThemes && swfThemes.indexOf(name) >= 0 ) {
				
				applySwfTheme( name );
				
			} else if( _savedThemes && _savedThemes.hasOwnProperty(name) ) {
				
				applyTheme( name );
				
			} else {
				
				return;
			}
			
			currentTheme = name;
			
			var persistenceManager:PersistenceManager = new PersistenceManager();
			persistenceManager.setProperty("currentTheme", currentTheme);	
			
		}
		
		protected static function applyTheme( name:String ) : void  {
			
			var theme:Object = _savedThemes[name];
			
			for( var style:String in theme ) {
					
				setCustomStyle(style, theme[style] );
					
			}
			
			currentTheme = name;
			_eventDispacher.dispatchEvent(new Event("stylesUpdated"));
			
		}
		
		protected static function applySwfTheme( name:String ) : void  {
			
			var swfName:String = (name == "default") ? DEFAULT_STYLE_SWF : "assets/" + name.toLowerCase() + ".swf";		
			_requestedTheme = name;
			
			var myEvent:IEventDispatcher = _styleManager.loadStyleDeclarations(swfName);
			myEvent.addEventListener( StyleEvent.COMPLETE, function() : void {
				currentTheme = _requestedTheme;
				_eventDispacher.dispatchEvent(new Event("stylesUpdated"));
			});			
			
			
		}		
		
		//////////////////////////////////////////////////////////////////////////////
		
		
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