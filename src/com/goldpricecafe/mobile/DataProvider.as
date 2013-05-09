package com.goldpricecafe.mobile
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class DataProvider extends EventDispatcher implements IDataProvider
	{
		
		public static const NEW_DATA:String = "newData";	
		
		private var _timer:Timer = new Timer(2*60*1000);
		private var _nextUpdate:Date;
		private var _data:Object;
		private var _url:String = "http://goldpricecafe.com:8400/alive5/Alive6_HiRes/data.zip";
		private var _urlLoader:URLLoader;
		private var _loading:Boolean = false;
		
		public function DataProvider()
		{
			_timer.addEventListener(TimerEvent.TIMER, timerHandler );		
			loadZipFile();
		}
		
		public function getData(currency:String) : Object
		{
			
			var data:Object = {}
			data[Constants.GOLD] = _data ?  _data[currency] : [];
			data[Constants.GLD_SLV_RATIO] = _data ?  _data[Constants.GLD_SLV_RATIO] : [];
			data[Constants.GLD_PLT_RATIO] = _data ?  _data[Constants.GLD_PLT_RATIO] : [];
			data[Constants.GLD_PLD_RATIO] = _data ?  _data[Constants.GLD_PLD_RATIO] : [];
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
		
		public function getNextUpdateTime():Date
		{
			return _nextUpdate;
		}
		
		protected function loadZipFile() : Boolean {
			
			if(_loading) return true;
			
			_timer.stop();
			
			try {
				
				if( !_urlLoader ) {
					_urlLoader = new URLLoader();
					_urlLoader.addEventListener(Event.COMPLETE, loaderHandler);	
					_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;	
				}
				_urlLoader.load( new URLRequest(_url) );
				_loading = true;
				
			} catch( e:Error ) {
				
				_timer.start();
				_nextUpdate = new Date();
				_nextUpdate.setMilliseconds( _nextUpdate.getMilliseconds() + _timer.delay );				
				trace( e.message );
				
				return false;
				
			}	
			
			return true;
			
		}
		
		
		protected function timerHandler( e:Event ) : void {
			
			loadZipFile();
			
		}
		
		protected function loaderHandler( e:Event ) : void {
			
			_data = parseZIP( new ZipFile( e.target.data ) );
			_nextUpdate = new Date();
			_nextUpdate.setMilliseconds( _nextUpdate.getMilliseconds() + _timer.delay );
			
			dispatchEvent( new Event(NEW_DATA) );
			
			_loading = false;
			_timer.start();
			
		}
		
		public function parseZIP( zipFile:ZipFile ) : Object {
			
			var entry:ZipEntry = zipFile.entries[0];   
			var rawData:ByteArray = zipFile.getInput(entry);
			
			return parseRawData(rawData);
			
		}
		
		public function parseRawData( rawData:ByteArray ) : Object {
			
			var strings:Array = rawData.toString().split("\n");
			var weekend:String = strings.pop(); 
			var lines:String = strings.pop();
			var todayDate:Date = new Date();
			
			todayDate.setTime( Date.parse(strings.pop() ) );
			strings.pop();
			strings.pop();
			
			var data:Object = {};
			var itr:uint = 0;
			var type:String;
			
			for( var i:uint = 0; i<strings.length; i++ ) {
				
				var record:Array = (strings[i] as String).split(",");
				
				if( record.length == 1 ) { // Type: currency or ratio name
					
					type = record[0]; 
					data[type] = [];
					itr = 0;
					
				} else if (record.length == 4) { // Data
					
					//data[type][itr] = [parseTime(record[0]), parsePrice(record[1]), parsePrice(record[2]), parsePrice(record[3])];
					
					data[type][itr] = {};
					data[type][itr][Constants.TIME] = parseTime(record[0]);
					data[type][itr][Constants.TODAY] = parsePrice(record[1]);
					data[type][itr][Constants.ONE_DAY_AGO] = parsePrice(record[2]);
					data[type][itr][Constants.TWO_DAYS_AGO] = parsePrice(record[3]);
					
					itr++;
					
				} 
			}
			
			return data;
			
		}		
		
		public function parseTime( time:String ) : Number {
			
			if( (!time) || (time == "") ) return Number.NaN;
			
			var parts:Array = time.split(":");	
			if( parts.length != 2 ) {
				return Number.NaN;
			}
			
			var hours:Number = parseInt( parts[0] );
			if( isNaN(hours) ) return NaN;
			var minutes:Number = parseInt( parts[1] );
			if( isNaN(minutes) ) return NaN;	
			
			return hours * 60 + minutes;
			
		}
		
		public function parsePrice( price:String ) : Number {
			
			if( (!price) || (price=="") ) return Number.NaN;
			return Number(price);
			
		}
		
	}
}