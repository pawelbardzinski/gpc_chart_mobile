package com.goldpricecafe.mobile
{
	import flash.events.IEventDispatcher;

	public interface IDataProvider extends IEventDispatcher
	{	
		function getData( currency:String ) : Object;
		function getGoldPrices( currency:String ) : Array;
		function getGldSlvRatios() : Array;
		function getGldPltRatios() : Array;
		function getGldPldRatios() : Array;		
		function getNextUpdateTime() : Date;
	}
}