package com.goldpricecafe.mobile.skins
{


	public class ButtonBarLastButton extends CustomButtonSkin
	{
		
		protected override function drawBorder( borderColor:uint, radius:Number ) : void {

			graphics.drawRoundRectComplex(0,0,unscaledWidth,unscaledHeight,0,radius/2,0,radius/2);			
			
		}			
		
	}
}