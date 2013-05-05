package com.goldpricecafe.mobile
{
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	
	import spark.managers.PersistenceManager;

	public class CustomStyleManager	
	{
		protected static const _styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;		
		protected static const _selectors:Array = ["global",".selected",".button","s|Application","s|TextInput","s|BusyIndicator"];
		protected static const _styles:Array = ["color","borderColor","chromeColor","fontFamiliy","backgroundColor","symbolColor"];
		protected static const _defaultStyles:Object = getDefaultStyles();
		
		private static function getDefaultStyles() : Object {
			
			var styles:Object = {};
			
			styles["global"] = {};
			styles["global"]["color"] = "0xEEDD00";
			styles["global"]["borderColor"] = "0x998800";					
			
			styles[".button"] = {};
			styles[".button"]["chromeColor"] = "0x121212";
			
			styles[".selected"] = {};
			styles[".selected"]["chromeColor"] = "0x121212";
			styles[".selected"]["borderColor"] = "0xFFFF00";
			
			styles["s|Application"] = {};
			styles["s|Application"]["backgroundColor"] = "0x0";
			
			styles["s|BusyIndicator"] = {};
			styles["s|BusyIndicator"]["symbolColor"] = "0xEEDD00";
			
			return styles;
			
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
		
		public static function resetStyles() : void {
					
			for (var styleDeclaration:String in _defaultStyles) {
				
				for( var style:String in _defaultStyles[styleDeclaration] ) {
					
					setStyle( styleDeclaration, style, _defaultStyles[styleDeclaration][style] );
					
				}
			}
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
		
	}
}