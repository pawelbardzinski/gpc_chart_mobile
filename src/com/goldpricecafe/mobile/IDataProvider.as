package com.goldpricecafe.mobile
{
	import flash.events.IEventDispatcher;

	public interface IDataProvider extends IEventDispatcher
	{	
		function getData( currency:String ) : Object;	
		function getNextUpdateTime() : Date;
	}
}