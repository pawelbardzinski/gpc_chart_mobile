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
		protected static const DEFAULT_STYLE_SWF:String = "com/goldpricecafe/mobile/assets/goldpricecafe_styles.swf";
		protected static const _styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;		
		protected static const _eventDispacher:IEventDispatcher = new EventDispatcher();
		protected static const _selectors:Array = ["global",".selected",".button","s|Application","s|TextInput","s|BusyIndicator"];
		protected static const _styles:Array = ["color","borderColor","chromeColor","fontFamiliy","backgroundColor","symbolColor"];						
		
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