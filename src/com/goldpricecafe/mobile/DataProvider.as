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
			load();
		}
		
		public function getData(currency:String) : Object
		{
			var data:Object = {}
			data[Constants.GOLD] = getGoldPrices( currency );
			data[Constants.GLD_SLV_RATIO] = getGldSlvRatios();
			data[Constants.GLD_PLT_RATIO] = getGldPltRatios();
			data[Constants.GLD_PLD_RATIO] = getGldPldRatios();
			
			return data;
		}
		
		public function getGoldPrices(currency:String):Array
		{
			if(_data) {
				return _data[currency];
			}
			
			return [];
		}
		
		public function getGldSlvRatios():Array
		{
			if(_data) {
				return _data[Constants.GLD_SLV_RATIO];
			}
			return [];
		}
		
		public function getGldPltRatios():Array
		{
			if(_data) {
				return _data[Constants.GLD_PLT_RATIO];
			}			
			return [];
		}
		
		public function getGldPldRatios():Array
		{
			if(_data) {
				return _data[Constants.GLD_PLD_RATIO];
			}			
			return [];
		}		
		
		public function getNextUpdateTime():Date
		{
			return _nextUpdate;
		}
		
		protected function load() : Boolean {
			
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
			
			load();
			
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
					
					data[type][itr] = [parseTime(record[0]), parsePrice(record[1]), parsePrice(record[2]), parsePrice(record[3])];
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