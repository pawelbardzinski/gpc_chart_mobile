package com.goldpricecafe.mobile
{
	import flash.events.IEventDispatcher;

	public interface IDataProvider extends IEventDispatcher
	{	
		function loadData() : void;
		function loadHistory() : void;
		function getData( currency:String ) : Object;
		function getHistory( currency:String ) : Array;
		function getNextUpdateTime() : Date;
		function isWeekend() : Boolean;
	}
}