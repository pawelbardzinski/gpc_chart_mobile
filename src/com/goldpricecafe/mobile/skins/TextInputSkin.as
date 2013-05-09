package com.goldpricecafe.mobile.skins
{
	
	import mx.core.DPIClassification;
	import spark.skins.mobile.TextInputSkin;
	
	public class TextInputSkin extends spark.skins.mobile.TextInputSkin
	{
		public function TextInputSkin()
		{
			
			super();			
			
			switch (applicationDPI)
			{
				/*case DPIClassification.DPI_320:
				{
					borderClass = spark.skins.mobile320.assets.TextInput_border;
					layoutCornerEllipseSize = 24;
					measuredDefaultWidth = 600;
					measuredDefaultHeight = 66;
					layoutBorderSize = 2;
					
					break;
				}
				case DPIClassification.DPI_240:
				{
					borderClass = spark.skins.mobile240.assets.TextInput_border;
					layoutCornerEllipseSize = 12;
					measuredDefaultWidth = 440;
					measuredDefaultHeight = 50;
					layoutBorderSize = 1;
					
					break;
				}*/
				default:
				{
					//layoutCornerEllipseSize = 12;
					measuredDefaultWidth = 300;
					measuredDefaultHeight = 33;
					//layoutBorderSize = 1;
					
					break;
				}
			}			
		}
		
	}
}