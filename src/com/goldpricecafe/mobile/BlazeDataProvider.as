package com.goldpricecafe.mobile
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;
	import mx.messaging.ChannelSet;
	import mx.messaging.Consumer;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.StreamingAMFChannel;
	import mx.messaging.events.MessageEvent;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class BlazeDataProvider extends EventDispatcher implements IDataProvider
	{
		
		public static const NEW_DATA:String = "newData";
		public static const HISTORY_LOADED:String = "historyLoaded";
		public static const IO_ERROR:String = IOErrorEvent.IO_ERROR;
		
		/* BlazeDS config */

		private static const _channels:Array = [
			new StreamingAMFChannel( "my-streaming-amf", "http://goldpricecafe.com:8400/alive5/messagebroker/streamingamf" ),
			new AMFChannel("my-polling-amf", "http://goldpricecafe.com:8400/alive5/messagebroker/amfpolling"),
			new AMFChannel("my-amf", "http://goldpricecafe.com:8400/alive5/messagebroker/amf")	
		];
		
		private var _destination:String = "RandomDataPush";
		
		/* End BlazeDS config */
		
		private static const _dataUrl:String = "http://goldpricecafe.com:8400/alive5/Alive6_HiRes/data.csv";
		private static const _historyUrl:String = "http://goldpricecafe.com:8400/alive5/Alive6_HiRes/hi.zip";
		private static const _timeUrl:String = "http://goldpricecafe.com:8400/alive5/Alive6_HiRes/time.txt";
		private static const _updatesPeriod:Number = 2 * 60 * 1000;
		
		private var _amfChannel:StreamingAMFChannel;
		private var _channelSet:ChannelSet;
		private var _consumer:Consumer;				
		private var _nextUpdate:Date;		
		private var _data:Object;
		private var _history:Object;
		private var _weekend:Boolean = false;
		private var _dataLoader:URLLoader;
		private var _historyLoader:URLLoader;
		private var _timeLoader:URLLoader;
		private var _dataLoaded:Boolean = false;
		private var _timeLoaded:Boolean = false;
		private var _lastUpdatedLine:int = 0;

		
		public function BlazeDataProvider()
		{		
			loadData();
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
			
			if( !data[Constants.GOLD] ) 
				return data;
			
			for( var i:uint = 0; i<data[Constants.GOLD].length; i++ ) {
				
				var time:Date = data[Constants.GOLD][i][Constants.TIME];
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
		
		public function getHistory( currency:String ) : Array {
			
			if(_history)
				return _history[currency];
			else 
				return null;

		}
		
		public function getNextUpdateTime():Date {
			
			return _nextUpdate;
		}
		
		public function isWeekend() : Boolean {
			
			return _weekend;
		}
		
		protected function initConsumer() : void {
				
			_channelSet = new ChannelSet();
			
			for( var i:int = 0; i < _channels.length; i++ ) {
				_channelSet.addChannel( _channels[i] );
			}
			
			_consumer = new Consumer();	
			_consumer.channelSet = _channelSet;
			_consumer.destination = _destination; 
			_consumer.addEventListener(MessageEvent.MESSAGE, messageHandler); 
			
			_consumer.subscribe();			
			
		}
		
		public function loadData() : void {
		
			try {
				
				if( !_dataLoader ) {
					_dataLoader = new URLLoader();
					_dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler);	
					_dataLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					_dataLoader.dataFormat = URLLoaderDataFormat.TEXT;	
				}
				_dataLoader.load( new URLRequest(_dataUrl) );
				
			} catch( e:IOError ) {
							
				trace( e.message );
				
			} 
			
		}
		
		public function loadHistory() : void {
			
			try {
				
				if( !_historyLoader ) {
					_historyLoader = new URLLoader();
					_historyLoader.addEventListener(Event.COMPLETE, historyLoaderHandler);	
					_dataLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					_historyLoader.dataFormat = URLLoaderDataFormat.BINARY;	
				}
				_historyLoader.load( new URLRequest(_historyUrl) );
				
			} catch( e:Error ) {
				
				trace( e.message );
				
			}				
			
		}
		
		protected function loadTime() : void {
			
			try {
				
				if( !_timeLoader ) {
					_timeLoader = new URLLoader();
					_timeLoader.addEventListener(Event.COMPLETE, timeLoaderHandler);	
					_timeLoader.dataFormat = URLLoaderDataFormat.TEXT;	
				}
				_timeLoader.load( new URLRequest(_timeUrl) );
				
			} catch( e:Error ) {
							
				trace( e.message );
				
			}				
			
		}
		
		protected function ioErrorHandler( e:IOErrorEvent ) : void {
			
			if(hasEventListener(IO_ERROR)) {
				dispatchEvent( e );
			}
			
		}
		
		protected function zipDataLoaderHandler( e:Event ) : void {			
			
			_data = {};
			
			var zip:ZipFile = new ZipFile( e.target.data ); 
			var entry:ZipEntry = zip.entries[0];   
			var rawData:ByteArray = zip.getInput(entry);
			
			var parser:AsyncDataParser = new AsyncDataParser();
			parser.parseLiveDataCSVAsync( rawData.toString(), liveChunkParsed, liveParsingCompleted );
			
		}
		
		protected function dataLoaderHandler( e:Event ) : void {			
			
			_data = {};

			var parser:AsyncDataParser = new AsyncDataParser();
			parser.parseLiveDataCSVAsync( e.target.data, liveChunkParsed, liveParsingCompleted );
			
		}		
		
		protected function historyLoaderHandler( e:Event ) : void {
			
			_history = {};
			
			var parser:AsyncDataParser = new AsyncDataParser();			
			parser.parseHistDataAsync( new ZipFile( e.target.data ), histChunkParsed, histParsingCompleted );
						
		}
		
		protected function timeLoaderHandler( e:Event ) : void {
			
			var timeStr:String = e.target.data;
			
			var parts:Array = timeStr.split(":");
			var s_num:int = 68 - parseInt(parts[1]);
			var m_num:int =  (parseInt(parts[0]) % 2 == 0) ? 1 : 0;

			_nextUpdate = new Date();
			_nextUpdate.seconds = _nextUpdate.seconds + s_num + m_num*60;
			
			dispatchEvent( new Event(NEW_DATA) );
			
		}
		
		protected function messageHandler( message:MessageEvent ) : void {
			
			extractNewData( (ArrayCollection (message.message.body)).toArray() );
			
			_nextUpdate = new Date();
			_nextUpdate.setMilliseconds( _nextUpdate.getMilliseconds() + _updatesPeriod );
			
			loadTime();
			
		}
		
		
		
		protected function extractNewData( newData:Array ) : void {
			
			_weekend = (newData.pop() == "weekend");
			var line:Number = newData.pop();
			var i:int;
			
			for( i = 0; i< newData.length; i++ ) {
				
				var type:String;
				if( i<Constants.CURRENCIES.length ) {
					
					type = Constants.CURRENCIES[i];
					
				} else {
					
					switch( i - Constants.CURRENCIES.length ) {
						
						case 0 :
							type = Constants.GLD_SLV_RATIO;
							break;
						case 1:
							type = Constants.GLD_PLT_RATIO;
							break;
						case 2:
							type = Constants.GLD_PLD_RATIO;
							break;
					}
					
				}
				
				var record:Array = (newData[i] as String).split(",");
				
				_data[type][line][Constants.TIME] = parseTime(record[0]);
				_data[type][line][Constants.TODAY] = parsePrice(record[1]);
				_data[type][line][Constants.ONE_DAY_AGO] = parsePrice(record[2]);
				_data[type][line][Constants.TWO_DAYS_AGO] = parsePrice(record[3]);
				
			}		
			
		}
		
		
			
		
		/** Not used. Moved to AsyncDataParser. */
		public function parseDataZIP( zipFile:ZipFile ) : Object {
			
			var entry:ZipEntry = zipFile.entries[0];   
			var rawData:ByteArray = zipFile.getInput(entry);	
			var strings:Array = rawData.toString().split("\n");
			
			_weekend = (strings.pop() == "weekend"); 
			var lines:String = strings.pop();
			var todayDate:Date = new Date( Date.parse(strings.pop()) );	
			var yesterday:Date = new Date( Date.parse(strings.pop()) );
			var twoDaysAgo:Date = new Date( Date.parse(strings.pop()) );			
			
			var data:Object = {};
			var itr:uint = 0;
			var type:String;
			
			for( var i:uint = 0; i<strings.length; i++ ) {
				
				var record:Array = (strings[i] as String).split(",");
				
				if( record.length == 1 ) { // Type: currency or ratio name
					
					type = record[0]; 
					data[type] = [];
					itr = 0;
					
				} else if (record.length == 4) { // Data: time, price0, price1, price2
					
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
		
		/** Not used. Moved to AsyncDataParser. */
		public function parseHistoryZIP( zipFile:ZipFile ) : Object {
			
			var entry:ZipEntry = zipFile.entries[0];   
			var rawData:ByteArray = zipFile.getInput(entry);	
			var strings:Array = rawData.toString().split("\n");			
			
			var data:Object = {};
			var itr:uint = 0;
			var type:String;
			
			for( var i:uint = 0; i<strings.length; i++ ) {
				
				var record:Array = (strings[i] as String).split(",");
				
				if( record.length == 1 ) { // Type: currency or ratio name
					
					type = record[0]; 
					data[type] = [];
					itr = 0;
					
				} else if (record.length == 2) { // Data: date,price
					
					data[type][itr] = {};
					data[type][itr][Constants.TIME] = parseTime(record[0]);
					data[type][itr][Constants.TODAY] = parsePrice(record[1]);
					
					itr++;
					
				} 
				
			}
			
			return data;
			
		}
		
		//////////////////////////////////////////////////////
		//                                     				//
		//				AsyncParser callbacks				//
		//													//
		//////////////////////////////////////////////////////
		
		public function histChunkParsed( type:String, data:Array ) : void {
			
			_history[type] = data;
			
		}
		
		public function liveChunkParsed( type:String, data:Array ) : void {
			
			_data[type] = data;
			
		}
		
		public function histParsingCompleted() : void {
			
			dispatchEvent( new Event(HISTORY_LOADED) );
		}
		
		public function liveParsingCompleted() : void {
			
			initConsumer();			
			loadTime();
			
		}		
		
		//////////////////////////////////////////////////////
		//                                     				//
		//					Utilities						//
		//													//
		//////////////////////////////////////////////////////
		
		private static function parseTime( time:String ) : Date {
			
			if( (!time) || (time == "") ) return null
				
			var timeRegExp:RegExp = /\d{1,2}:\d{1,2}/;
			var fullRegExp:RegExp = /\d{1,2}-\d{1,2}-\d{1,4}/;
			var parts:Array;
			
			if( time.match(timeRegExp) ) { // Time only
				
				parts = time.split(":");	
				if( parts.length != 2 ) {
					return null;
				}
				
				var hours:Number = parseInt( parts[0] );
				var minutes:Number = parseInt( parts[1] );	
				
				return new Date( (new Date()).setHours(hours,minutes) );
	
			} else if( time.match(fullRegExp) ) { // Full date
				
				parts = time.split("-");	
				if( parts.length != 3 ) {
					return null;
				}
				
				var day:Number = parseInt( parts[0] );
				var month:Number = parseInt( parts[1] );
				var year:Number = parseInt( parts[2] );
				var date:Date = new Date(year > 1000 ? year : 2000 + year,month,day,0,0,0,0);

				return date;
				
			}
			
			return null;

			
		}
		
		private static function parsePrice( price:String ) : Number {
			
			if( (!price) || (price=="") ) return Number.NaN;
			return Number(price);
			
		}
		
	}
}