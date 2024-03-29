package com.goldpricecafe.mobile.skins {

	import flash.display.CapsStyle;
	import flash.display.DisplayObject;

	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import mx.core.DPIClassification;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.utils.ColorUtil;
	
	import spark.components.IconPlacement;
	import spark.skins.mobile.supportClasses.ButtonSkinBase;
	
	use namespace mx_internal;

	[HostComponent("spark.skins.mobile.supportClasses.ButtonSkinBase")]
	public class CustomButtonSkin extends ButtonSkinBase
	{
		protected static const IS_FLAT_STYLE:String = "flat";
		protected static const CHROME_COLOR_STYLE:String = "chromeColor";
		protected static const GLOSSINESS_STYLE:String = "glossiness";
		protected static const BORDER_COLOR_STYLE:String = "borderColor";
		protected static const PADDING_LEFT_STYLE:String = "paddingLeft";
		protected static const PADDING_RIGHT_STYLE:String = "paddingRight";
		protected static const PADDING_TOP_STYLE:String = "paddingTop";
		protected static const PADDING_BOTTOM_STYLE:String = "paddingBottom";		
		
		protected var borderColor:uint = 0;	
		protected var layoutCornerEllipseSize:Number;		
		protected var CHROME_COLOR_RATIOS:Array = [0, 127.5];
		protected var CHROME_COLOR_ALPHAS:Array = [1, 1];

		
		public function CustomButtonSkin() {
			
			super();
			
			switch (FlexGlobals.topLevelApplication.runtimeDPI)
			{
				/*case DPIClassification.DPI_320:
				{
	
					layoutGap = 10;
					layoutCornerEllipseSize = 10;
					layoutPaddingLeft = 10;
					layoutPaddingRight = 10;
					layoutPaddingTop = 10;
					layoutPaddingBottom = 10;
					layoutBorderSize = 2;
					measuredDefaultWidth = 32;
					measuredDefaultHeight = 32;
					
					break;
				}
				case DPIClassification.DPI_240:
				{	
					layoutGap = 8;
					layoutCornerEllipseSize = 8;
					layoutPaddingLeft = 8;
					layoutPaddingRight = 8;
					layoutPaddingTop = 8;
					layoutPaddingBottom = 8;
					layoutBorderSize = 2;
					measuredDefaultWidth = 24;
					measuredDefaultHeight = 24;
					
					break;
				}*/
				default:  // DPIClassification.DPI_160:
				{				
					layoutGap = 5;
					layoutCornerEllipseSize = 5;
					layoutPaddingLeft = 10;
					layoutPaddingRight = 10;
					layoutPaddingTop = 5;
					layoutPaddingBottom = 5;
					layoutBorderSize = 1;
					measuredDefaultWidth = 16;
					measuredDefaultHeight = 16;
					
					break;
				}
			}			
			
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			
			
			/* Enable padding styling */
			
			var val:Number;
			
			val = getStyle(PADDING_BOTTOM_STYLE);
			layoutPaddingBottom = (!isNaN(val) && val) > 0 ? val : layoutPaddingBottom;
			
			val = getStyle(PADDING_TOP_STYLE);
			layoutPaddingTop = (!isNaN(val) && val) > 0 ? val : layoutPaddingTop;
			
			val = getStyle(PADDING_LEFT_STYLE);
			layoutPaddingLeft = (!isNaN(val) && val) > 0 ? val : layoutPaddingLeft;
			
			val = getStyle(PADDING_RIGHT_STYLE);
			layoutPaddingRight = (!isNaN(val) && val) > 0 ? val : layoutPaddingRight;			
			
		
			super.measure();
			
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var textDescent:Number = 0;
			var iconDisplay:DisplayObject = getIconDisplay();

			if (hostComponent && labelDisplay.isTruncated)
				labelDisplay.text = hostComponent.label;
			
			if (labelDisplay.text != "" || !iconDisplay)
			{			
				labelWidth = getElementPreferredWidth(labelDisplay);
				labelHeight = getElementPreferredHeight(labelDisplay);
				textDescent = labelDisplay.getLineMetrics(0).descent;
			}
			
			var w:Number = layoutPaddingLeft + layoutPaddingRight;
			var h:Number = 0;
			
			var iconWidth:Number = 0;
			var iconHeight:Number = 0;
			
			if (iconDisplay)
			{
				iconWidth = getElementPreferredWidth(iconDisplay);
				iconHeight = getElementPreferredHeight(iconDisplay);
			}
			
			var iconPlacement:String = getStyle("iconPlacement");
			
			var adjustablePaddingBottom:Number = layoutPaddingBottom;
			
			if (iconPlacement == IconPlacement.LEFT ||
				iconPlacement == IconPlacement.RIGHT)
			{
				w += labelWidth + iconWidth;
				if (labelWidth && iconWidth)
					w += layoutGap;
				
				var viewHeight:Number = Math.max(labelHeight, iconHeight);
				h += viewHeight;
			}
			else
			{
				w += Math.max(labelWidth, iconWidth);
				h += labelHeight + iconHeight;
				
				adjustablePaddingBottom = layoutPaddingBottom;
				
				if (labelHeight && iconHeight)
				{
					if (iconPlacement == IconPlacement.BOTTOM)
					{
						h += Math.max(textDescent, layoutGap);
					}
					else
					{
						adjustablePaddingBottom = Math.max(layoutPaddingBottom, textDescent);
						
						h += layoutGap;
					}
				}
			}
			
			h += layoutPaddingTop + adjustablePaddingBottom;
			
			measuredMinWidth = h;
			measuredMinHeight = h;
			
			measuredWidth = w
			measuredHeight = h;
						
		}
		
		override protected function commitCurrentState():void
		{			
			super.commitCurrentState();
			
			var styleName:String = hostComponent.styleName ? hostComponent.styleName.toString() : "";
			
			if(isSelected()) {
				hostComponent.styleName = (styleName + " selected");
			} else {
				var newString:String = styleName;
				while((newString = styleName.replace("selected","")) != styleName) {
					styleName = newString;
				}			
				hostComponent.styleName = styleName;
			}
			
			labelDisplay.commitStyles();
			invalidateDisplayList();
			
		}		
		
		override protected function createChildren():void {
			
			super.createChildren();
			
		}		 
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
						
			super.drawBackground(unscaledWidth,unscaledHeight);						
			
			var chromeColor:uint = getStyle(CHROME_COLOR_STYLE);
			var borderColor:uint = getStyle(BORDER_COLOR_STYLE);
			var isFlat:Boolean = getStyle(IS_FLAT_STYLE);
			var glossiness:uint = getStyle(GLOSSINESS_STYLE);
			var r1:Number = layoutCornerEllipseSize;
			var r2:Number = layoutCornerEllipseSize + layoutBorderSize;
			var r3:Number = layoutCornerEllipseSize + 2 * layoutBorderSize;
			
			/*if(isDown()) {
				labelDisplay.setStyle("color",ColorUtil.adjustBrightness2(getStyle("color"),-getStyle(GLOSSINESS_STYLE))); 
			} else {
				labelDisplay.setStyle("color",getStyle("color")); 
			}*/			
			
			if ( isDown() || isFlat ) {
				
				graphics.beginFill(chromeColor);
				graphics.drawRoundRect(layoutBorderSize, layoutBorderSize, 
					unscaledWidth - 2 * layoutBorderSize, 
					unscaledHeight - 2 * layoutBorderSize, 
					r2, r2);
				graphics.endFill();	
				
			} else {
				
				var colorLight:uint = ColorUtil.adjustBrightness2(chromeColor,glossiness);
				
				graphics.beginFill(colorLight);
				graphics.drawRoundRect(2*layoutBorderSize, 2*layoutBorderSize, 
					unscaledWidth - 4 * layoutBorderSize + 1, 
					unscaledHeight - 4 * layoutBorderSize + 1, 
					r2, r2);
				graphics.endFill();	
				
				graphics.beginFill(chromeColor);
				graphics.drawRoundRect(3*layoutBorderSize, unscaledHeight*0.4, 
					unscaledWidth - 6 * layoutBorderSize + 1, 
					unscaledHeight*0.6 - 3 * layoutBorderSize + 1, 
					r1, r1);
				graphics.endFill();					
				
			}
						
			graphics.lineStyle( isSelected() ? 2 * layoutBorderSize : layoutBorderSize, borderColor, 1.0, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
			drawBorder(borderColor,r3);
			
		}
		
		
		protected function drawBorder( borderColor:uint, radius:Number ) : void {

			graphics.drawRoundRect(0,0,unscaledWidth,unscaledHeight,radius,radius);			
			
		}
		
		protected function isDown() : Boolean {

			return (currentState.indexOf("Down") > -1) || (currentState.indexOf("down") > -1);
			
		}
		
		protected function isSelected() : Boolean {
			
			return (currentState.indexOf("Selected") > -1) || (currentState.indexOf("selected") > -1);
			
		}
		
		
	}
	
	

}