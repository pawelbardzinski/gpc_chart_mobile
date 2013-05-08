package com.goldpricecafe.mobile.skins {

	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	
	import mx.utils.ColorUtil;
	
	import spark.components.IconPlacement;

	


	public class CustomRadioButtonSkin extends CustomButtonSkin
	{
		
		public function CustomRadioButtonSkin() {
			
			super();
			useCenterAlignment = false;
			
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
			
			/* The rest is copied allmost directly */
			
			super.measure();
			
			var labelWidth:Number = 0;
			var labelHeight:Number = 0;
			var textDescent:Number = 0;
			var iconDisplay:DisplayObject = getIconDisplay();
			
			// reset text if it was truncated before.
			if (hostComponent && labelDisplay.isTruncated)
				labelDisplay.text = hostComponent.label;
			
			// we want to get the label's width and height if we have text or there's
			// no icon present
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
			
			// layoutPaddingBottom is from the bottom of the button to the text
			// baseline or the bottom of the icon.
			// It must be adjusted when descent grows larger than the padding.
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
						// adjust gap if descent is larger
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
			
			// measuredMinHeight for width and height for a square measured minimum size
			measuredMinWidth = h;
			measuredMinHeight = h;
			
			measuredWidth = w + layoutGap + h
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
			
			if(isDown()) {
				labelDisplay.setStyle("color",ColorUtil.adjustBrightness2(getStyle("color"),-getStyle(GLOSSINESS_STYLE))); 
			} else {
				labelDisplay.setStyle("color",getStyle("color")); 
			}
			labelDisplay.commitStyles();
			
			invalidateDisplayList();
			
		}		
		
		override protected function createChildren():void {
			
			super.createChildren();
			
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.layoutContents(unscaledWidth, unscaledHeight);		
			labelDisplay.x = unscaledHeight + layoutGap;
			
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
								
			var chromeColor:uint = getStyle(CHROME_COLOR_STYLE);
			var borderColor:uint = getStyle(BORDER_COLOR_STYLE);
			var isFlat:Boolean = getStyle(IS_FLAT_STYLE);
			var glossiness:uint = getStyle(GLOSSINESS_STYLE);
			var colorLight:uint = ColorUtil.adjustBrightness2(chromeColor,glossiness);
			var h:Number = unscaledHeight/2;
					
			graphics.beginFill(colorLight);
			graphics.drawEllipse(0,0,unscaledHeight, unscaledHeight);
			graphics.endFill();	
			
			var colors:Array = [];
			var colorMatrix:Matrix = new Matrix();
			colorMatrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
			colors[0] = colorLight;
			colors[1] = chromeColor;
			
			graphics.beginGradientFill(GradientType.LINEAR, colors, CHROME_COLOR_ALPHAS, CHROME_COLOR_RATIOS, colorMatrix);	
			graphics.drawEllipse(layoutBorderSize,2*layoutBorderSize,unscaledHeight-2*layoutBorderSize, unscaledHeight-2*layoutBorderSize);
			graphics.endFill();			
			graphics.beginFill(colorLight);	
			graphics.drawEllipse(unscaledHeight/2-h/2,unscaledHeight/2-h/2,h,h);
			graphics.endFill();
				
			if(isSelected()) {				
				
				graphics.beginFill(borderColor);	
				graphics.drawEllipse(unscaledHeight/2-h/2+layoutBorderSize,unscaledHeight/2-h/2+layoutBorderSize,h-layoutBorderSize,h-layoutBorderSize);
				graphics.endFill();
				
			}
				
		
			
		}		
		
		
	}
	
	

}