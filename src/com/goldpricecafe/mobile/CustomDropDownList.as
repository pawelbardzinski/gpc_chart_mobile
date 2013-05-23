package com.goldpricecafe.mobile
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.DropDownList;
	
	public class CustomDropDownList extends DropDownList
	{
		
		protected var _preventDropdownClose:Boolean = false;
		protected var _openButtonStyle:String = "";
		
		public function set openButtonStyle( style:String ) : void 
		{
			_openButtonStyle = style;
			if(openButton != null) {
				openButton.styleName = _openButtonStyle;
			}
		}
		
		public function CustomDropDownList()
		{
			super();	
			
			addEventListener(Event.CHANGE, changeHandler);
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
	
		}
		
		override public function closeDropDown(commit:Boolean):void
		{
			if(!_preventDropdownClose)
				super.closeDropDown(commit);
		}
			
		protected function creationCompleteHandler(event:FlexEvent):void
		{
			openButton.styleName = _openButtonStyle; 			
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			_preventDropdownClose = true;
			super.item_mouseDownHandler(event);
			_preventDropdownClose = false;

		}
		
		protected function changeHandler( e:Event ) : void {
			
			callLater(closeDropDown,[false]);
		}
		
	}
}