package com.goldpricecafe.mobile
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;

	
	public class TestDataProvider extends EventDispatcher implements IDataProvider 
	{
		
		public static const NEW_DATA:String = "newData";	
		private var _timer:Timer = new Timer(30*1000);
		private var _nextUpdate:Date;
		
		
		public function TestDataProvider()
		{
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
			_nextUpdate = new Date();
			_nextUpdate.milliseconds = _nextUpdate.milliseconds + _timer.delay;
			
			FlexGlobals.topLevelApplication.callLater( function() : void {
				dispatchEvent( new Event(NEW_DATA) );
			});
			
		}
		
		protected function timerHandler( e:Event ) : void {

			_nextUpdate = new Date();
			_nextUpdate.milliseconds = _nextUpdate.milliseconds + _timer.delay;
			
			dispatchEvent( new Event(NEW_DATA)  );
			
		}
		
		public function getData(currency:String) : Object
		{
			
			var data:Object = {}
			data[Constants.GOLD] = getGoldPrices(currency);
			data[Constants.GLD_SLV_RATIO] = getGldSlvRatios();
			data[Constants.GLD_PLT_RATIO] = getGldPltRatios();
			data[Constants.GLD_PLD_RATIO] = getGldPldRatios();
			data[Constants.SILVER] = [];
			data[Constants.PLATINUM] = [];
			data[Constants.PALLADIUM] = [];
			
			if( !data[Constants.GOLD] ) return data;
			
			for( var i:uint = 0; i<data[Constants.GOLD].length; i++ ) {
				
				var time:Number = data[Constants.GOLD][i][Constants.TIME];
				var gldPriceToDay:Number = data[Constants.GOLD][i][Constants.TODAY];
				var gldPrice1DayAgo:Number = data[Constants.GOLD][i][Constants.ONE_DAY_AGO];
				var gldPrice2DaysAgo:Number = data[Constants.GOLD][i][Constants.TWO_DAYS_AGO];
				
				data[Constants.SILVER][i] = {};
				data[Constants.SILVER][i][Constants.TIME] = time;
				data[Constants.SILVER][i][Constants.TODAY] = gldPriceToDay / data[Constants.GLD_SLV_RATIO][i][Constants.TODAY];
				data[Constants.SILVER][i][Constants.ONE_DAY_AGO] = gldPrice1DayAgo / data[Constants.GLD_SLV_RATIO][i][Constants.ONE_DAY_AGO];
				data[Constants.SILVER][i][Constants.TWO_DAYS_AGO] = gldPrice2DaysAgo / data[Constants.GLD_SLV_RATIO][i][Constants.TWO_DAYS_AGO];	
				
				data[Constants.PLATINUM][i] = {};
				data[Constants.PLATINUM][i][Constants.TIME] = time;
				data[Constants.PLATINUM][i][Constants.TODAY] = gldPriceToDay / data[Constants.GLD_PLT_RATIO][i][Constants.TODAY];
				data[Constants.PLATINUM][i][Constants.ONE_DAY_AGO] = gldPrice1DayAgo / data[Constants.GLD_PLT_RATIO][i][Constants.ONE_DAY_AGO];
				data[Constants.PLATINUM][i][Constants.TWO_DAYS_AGO] = gldPrice2DaysAgo / data[Constants.GLD_PLT_RATIO][i][Constants.TWO_DAYS_AGO];				
				
				data[Constants.PALLADIUM][i] = {};
				data[Constants.PALLADIUM][i][Constants.TIME] = time;
				data[Constants.PALLADIUM][i][Constants.TODAY] = gldPriceToDay / data[Constants.GLD_PLD_RATIO][i][Constants.TODAY];
				data[Constants.PALLADIUM][i][Constants.ONE_DAY_AGO] = gldPrice1DayAgo / data[Constants.GLD_PLD_RATIO][i][Constants.ONE_DAY_AGO];
				data[Constants.PALLADIUM][i][Constants.TWO_DAYS_AGO] = gldPrice2DaysAgo / data[Constants.GLD_PLD_RATIO][i][Constants.TWO_DAYS_AGO];
			}
			
			return data;
		}
		
		public function isWeekend() : Boolean {
			return false;
		}
		
		public function getGoldPrices( currency:String ) : Array {
			
			return generateRandomPrices();
			
		}
		
		public function getGldSlvRatios() : Array {
			
			return generateRandomPrices();
			
		}
		
		public function getGldPltRatios() : Array {
			
			return generateRandomPrices();
			
		}
		
		public function getGldPldRatios() : Array {
			
			return generateRandomPrices();
			
		}
		
		protected function generateRandomPrices() : Array {
			
			var data:Array = [];
			
			for( var min:uint = 0; min < 60*24; min ++ ) {
				
				data[min] = {};
				data[min][Constants.TIME] = min;
				data[min][Constants.TODAY] = Math.random();
				data[min][Constants.ONE_DAY_AGO] = Math.random();				
				data[min][Constants.TWO_DAYS_AGO] = Math.random();			
				
			}
			
			return data;			
			
		}		
		
		public function getNextUpdateTime() : Date {			
			
			return _nextUpdate;
			
		}	
			

	}
	
}