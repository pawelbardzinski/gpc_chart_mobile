package com.goldpricecafe.mobile.skins
{	
	import spark.skins.mobile.ButtonBarSkin;
	
	public class ButtonBarSkin extends spark.skins.mobile.ButtonBarSkin
	{

		override protected function createChildren():void
		{
			super.createChildren();
			
			firstButton.skinClass = com.goldpricecafe.mobile.skins.ButtonBarFirstButton;
			middleButton.skinClass = com.goldpricecafe.mobile.skins.ButtonBarMiddleButton;
			lastButton.skinClass = com.goldpricecafe.mobile.skins.ButtonBarLastButton;
		}
		
	}
}