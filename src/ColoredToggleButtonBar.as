package{
	import mx.controls.Button;
	import mx.controls.ToggleButtonBar;
	
	public class ColoredToggleButtonBar extends ToggleButtonBar{
		public function ColoredToggleButtonBar(){
			super();
		}
		
		public var selectedButtonColor:String;
		public var selectedButtonBorderColor:String;
		public var selectedFontColor:String;
		
		override protected function hiliteSelectedNavItem(index:int):void{
			var child:Button;
			
			// remove hilite
			if(selectedIndex > -1){
				child = Button(getChildAt(selectedIndex));
				child.clearStyle('fillColors');
				child.clearStyle('themeColor');
				child.clearStyle('color');
			}
			
			// run old hilite handler
			super.hiliteSelectedNavItem(index);
			
			// add new hilite
			if (index > -1){
				child = Button(getChildAt(selectedIndex));
				if(selectedButtonColor)
					child.setStyle('fillColors', [selectedButtonColor, selectedButtonColor]);
				if(selectedButtonBorderColor)
					child.setStyle('themeColor', selectedButtonBorderColor);
				if (selectedFontColor)
					child.setStyle('color', selectedFontColor);
			} 
			
		}
	}
}