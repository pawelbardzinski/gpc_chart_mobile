package com.goldpricecafe.mobile
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;

	public class AsyncDataParser
	{
		private var _loopCounter:uint = 0;
		private var _chunkCallback:Function;
		private var _completedCallback:Function;
		private var _strings:Array;
		private var _stepLimit:int = 2000;
		private var _timerDylay:int = 20;
		private var _chunk:Array;
		private var _chunkItr:int;
		private var _chunkType:String;
		private var _weekend:Boolean = false;
		
		public function AsyncDataParser()
		{
		}
		
		public function parseHistDataAsync( zipFile:ZipFile, chunkCallback:Function, completedCallback:Function ) : void {
			
			var entry:ZipEntry = zipFile.entries[0];   
			var rawData:ByteArray = zipFile.getInput(entry);
		
			_strings = rawData.toString().split("\n");	
			_chunkCallback = chunkCallback;
			_completedCallback = completedCallback;
			_loopCounter = 0;
			_chunk = null;
			
			var timer:Timer = new Timer(30,1);
			timer.addEventListener(TimerEvent.TIMER, parseHist);
			timer.start();			
			
		}
		
		private function parseHist( e:Event ) : void {
			
			var step:int = 0;
			
			while( _loopCounter < _strings.length ) {
				
				var record:Array = (_strings[_loopCounter] as String).split(",");
				
				if( record.length == 1 ) { // Type: currency or ratio name
					
					if(_chunk) _chunkCallback(_chunkType,_chunk);
						
					_chunkType = record[0]; 
					_chunk = [];
					_chunkItr=0;

					
				} else if (record.length == 2) { // Data: date,price
					
					var time:Date = parseTime(record[0]);
					
					if( time ) {
						
						_chunk[_chunkItr] = {};
						_chunk[_chunkItr][Constants.TIME] = parseTime(record[0]);
						_chunk[_chunkItr][Constants.TODAY] = parsePrice(record[1]);
						
						_chunkItr++;
						
					}
					
				} 
				
				_loopCounter++;
				step++;
				
				if( step >= _stepLimit ) break;
				
			}
			
			if( _loopCounter < _strings.length ) {
				
				var timer:Timer = new Timer(30,1);
				timer.addEventListener(TimerEvent.TIMER, parseHist);
				timer.start();
				
			} else {
				
				_completedCallback();
				
			}
			
		}
		
		public function parseLiveDataZipAsync( zipFile:ZipFile, chunkCallback:Function, completedCallback:Function) : void {
			
			var entry:ZipEntry = zipFile.entries[0];   
			var rawData:ByteArray = zipFile.getInput(entry);
			
			parseLiveDataCSVAsync(rawData.toString(),chunkCallback,completedCallback);			
			
		}
		
		public function parseLiveDataCSVAsync( data:String, chunkCallback:Function, completedCallback:Function) : void {
			
			_strings = data.split("\n");
			_weekend = (_strings.pop() == "weekend"); 
			var lines:String = _strings.pop();
			var todayDate:Date = new Date( Date.parse(_strings.pop()) );	
			var yesterday:Date = new Date( Date.parse(_strings.pop()) );
			var twoDaysAgo:Date = new Date( Date.parse(_strings.pop()) );
			
			_chunkCallback = chunkCallback;
			_completedCallback = completedCallback;
			_loopCounter = 0;
			_chunk = null;
			
			var timer:Timer = new Timer(30,1);
			timer.addEventListener(TimerEvent.TIMER, parseLive);
			timer.start();			
			
		}		
		
		private function parseLive( e:Event ) : void {
			
			var step:int = 0;
			
			while( _loopCounter < _strings.length ) {
				
				var record:Array = (_strings[_loopCounter] as String).split(",");
				
				if( record.length == 1 ) { // Type: currency or ratio name
					
					if(_chunk) _chunkCallback(_chunkType,_chunk);
					
					_chunkType = record[0]; 
					_chunk = [];
					_chunkItr=0;
					
					
				} else if (record.length == 4) { // Data: date,price
					
					var time:Date = parseTime(record[0]);
					
					if( time ) {

						_chunk[_chunkItr] = {};
						_chunk[_chunkItr][Constants.TIME] = time;
						_chunk[_chunkItr][Constants.TODAY] = parsePrice(record[1]);
						_chunk[_chunkItr][Constants.ONE_DAY_AGO] = parsePrice(record[2]);
						_chunk[_chunkItr][Constants.TWO_DAYS_AGO] = parsePrice(record[3]);
					
						_chunkItr++;
						
					}
					
				} 
				
				_loopCounter++;
				step++;
				
				if( step >= _stepLimit ) break;
				
			}
			
			if( _loopCounter < _strings.length ) {
				
				var timer:Timer = new Timer(30,1);
				timer.addEventListener(TimerEvent.TIMER, parseLive);
				timer.start();
				
			} else {
				
				_completedCallback();
				
			}
			
		}
		
		public function isWeekend() : Boolean {
			return _weekend;
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
				
				return new Date( (new Date()).setHours(hours,minutes,0,0) );
				
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