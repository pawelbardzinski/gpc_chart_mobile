package com.goldpricecafe.mobile.skins {

	import flash.display.Shape;
	import spark.skins.mobile.ButtonSkin;


	public class CustomButtonSkin extends ButtonSkin
	{
		
		protected var borderColorStyleName:String = "borderColor";
		protected var borderWidthStyleName:String = "borderWidth";
		
		protected var borderColor:uint = 0;
		protected var myBorder:Shape;
		
		override protected function commitCurrentState():void
		{			
			
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
			
			
			super.commitCurrentState();
		}
		
		protected function isSelected():Boolean {
			
			return (currentState.indexOf("Selected") > -1) || (currentState.indexOf("selected") > -1);
			
		}		
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			myBorder = new Shape();
			var width:uint = getStyle(borderWidthStyleName);
			if(width==0) layoutBorderSize=1;
			myBorder.graphics.lineStyle(width,getStyle(borderColorStyleName));
			myBorder.graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, layoutCornerEllipseSize, layoutCornerEllipseSize);			
			this.addChild(myBorder);
			
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {
						
			super.drawBackground(unscaledWidth,unscaledHeight);
			
			if( currentState.indexOf("down") >= 0 ) {
				
				myBorder.visible = false;
				
			} else {
				
				myBorder.visible = true;
				myBorder.graphics.clear();
				
				var width:uint = getStyle(borderWidthStyleName);
				if(width==0) layoutBorderSize=1;
				myBorder.graphics.lineStyle(width,getStyle(borderColorStyleName));
				myBorder.graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, layoutCornerEllipseSize, layoutCornerEllipseSize);
				
			}
			
		}
		
		
	}
	
	

}