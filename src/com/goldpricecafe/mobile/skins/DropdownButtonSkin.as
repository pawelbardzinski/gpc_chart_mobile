////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
package com.goldpricecafe.mobile.skins {
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import mx.utils.ColorUtil;

	/**
	 *  ActionScript-based custom skin for Button controls in mobile applications. 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5 
	 *  @productversion Flex 4.5
	 */
	public class DropdownButtonSkin extends CustomButtonSkin
	{		
		
		protected var _arrowPartWidth:Number = 30;
		
		public function DropdownButtonSkin() {
			
			super();
			useCenterAlignment = false;
			
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredWidth += _arrowPartWidth;
			measuredMinWidth = measuredWidth;
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.drawBackground(unscaledWidth,unscaledHeight);
			
			if(isDown()) return;
			
			var chromeColor:uint = getStyle(CHROME_COLOR_STYLE);
			var glossiness:uint = getStyle(GLOSSINESS_STYLE);
			var separatorWidth:uint = 2 * layoutBorderSize;
			var colorLight:uint = ColorUtil.adjustBrightness2(chromeColor,glossiness);
			
			graphics.lineStyle(layoutBorderSize,colorLight, 1.0, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
			graphics.moveTo(unscaledWidth - _arrowPartWidth,4 * layoutBorderSize);
			graphics.lineTo(unscaledWidth - _arrowPartWidth, unscaledHeight - 4 * layoutBorderSize);
			graphics.lineStyle(layoutBorderSize,chromeColor, 1.0, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
			graphics.moveTo(unscaledWidth - _arrowPartWidth+1,4 * layoutBorderSize);
			graphics.lineTo(unscaledWidth - _arrowPartWidth+1, unscaledHeight - 4 * layoutBorderSize);
			
			var partWidth:Number = _arrowPartWidth - 3 * layoutBorderSize - separatorWidth;
			var arrowWidth:Number = partWidth*0.45;
			var x1:Number = unscaledWidth - _arrowPartWidth + separatorWidth + (partWidth - arrowWidth)/2;
			var x2:Number = x1 + arrowWidth;
			var x3:Number = x1 + arrowWidth/2;
			var y1:Number = unscaledHeight/2 - arrowWidth*0.35;
			var y2:Number = y1;
			var y3:Number = unscaledHeight/2 + arrowWidth*0.35;
			
			var colorLight:uint = ColorUtil.adjustBrightness2(chromeColor,glossiness);

			graphics.beginFill(colorLight);
			graphics.moveTo(x1,y1);
			graphics.lineTo(x2,y2);
			graphics.lineTo(x3,y3);
			graphics.lineTo(x1,y1);
			graphics.endFill();
	
		}
		
		
		
	}
	
	

}