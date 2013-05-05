////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
package com.goldpricecafe.mobile.skins {
	
	import flash.display.CapsStyle;

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
		
		public function DropdownButtonSkin() {
			
			super();
			useCenterAlignment = false;
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			// Call super's implementation
			super.updateDisplayList(unscaledWidth, unscaledHeight)
			
			// Draw divider and arrow
			if( currentState != "down" ) {
				
				var dividerPos:Number = 0.7;
				var dividerX:uint = unscaledWidth - 30;//dividerPos * unscaledWidth;
				
				var borderColor:uint = 0;//getStyle(borderColorStyleName);
				graphics.lineStyle(1,borderColor,1.0,false,"normal",CapsStyle.NONE);
				graphics.moveTo(dividerX,0);
				graphics.lineTo(dividerX,unscaledHeight);	
				
				graphics.beginFill(borderColor);
				
				graphics.moveTo( (unscaledWidth + dividerX)/2-5, unscaledHeight/2-3 );
				graphics.lineTo( (unscaledWidth + dividerX)/2+5, unscaledHeight/2-3 );
				graphics.lineTo( (unscaledWidth + dividerX)/2, unscaledHeight/2+3 );
				
				graphics.endFill();
				
			}
			
		}
		
	}
	
	

}