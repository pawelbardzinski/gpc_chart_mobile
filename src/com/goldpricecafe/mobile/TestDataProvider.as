package com.goldpricecafe.mobile
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class TestDataProvider extends EventDispatcher implements IDataProvider 
	{
		
		public static const NEW_DATA:String = "newData";	
		private var _timer:Timer = new Timer(5*1000);
		private var _nextUpdate:Date;
		
		
		public function TestDataProvider()
		{
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
			_nextUpdate = new Date();
			_nextUpdate.milliseconds = _nextUpdate.milliseconds + _timer.delay;
		}
		
		protected function timerHandler( e:Event ) : void {

			_nextUpdate = new Date();
			_nextUpdate.milliseconds = _nextUpdate.milliseconds + _timer.delay;
			var myEvent:Event = new Event(NEW_DATA);
			dispatchEvent( myEvent );
			
		}
		
		public function getGoldPrices( currency:String ) : Array {
			
			var data:Array = [];
			var min:uint = 0;
			var hour:uint = 0;
			var i:uint = 0;
			
			while( (hour < 24) || (min == 0) ) {
				
				var ts:String = "05/03/2013 ";
				ts += ( hour < 10 ? "0" + hour.toString() : hour.toString() );
				ts += ( min  < 10 ? ":0" + min.toString() : ":" + min.toString() );
				ts += ":00 UTC";
				
				data[i] = [ts, Math.random(), Math.random(), Math.random() ];
				
				min += 2;
				if( min == 60 ) {
					min = 0;
					hour += 1;
				}
				
				i++;
				
			}
			
			return data;
			
		}
		
		public function getGldSlvRatios() : Array {
			
			var data:Array = [];
			var min:uint = 0;
			var hour:uint = 0;
			var i:uint = 0;
			
			while( (hour < 24) || (min == 0) ) {
				
				var ts:String = "05/03/2013 ";
				ts += ( hour < 10 ? "0" + hour.toString() : hour.toString() );
				ts += ( min  < 10 ? ":0" + min.toString() : ":" + min.toString() );
				ts += ":00 UTC";
				
				data[i] = [ts, Math.random(), Math.random(), Math.random() ];
				
				min += 2;
				if( min == 60 ) {
					min = 0;
					hour += 1;
				}
				
				i++;
				
			}
			
			return data;
			
		}
		
		public function getGldPltRatios() : Array {
			
			var data:Array = [];
			var min:uint = 0;
			var hour:uint = 0;
			var i:uint = 0;
			
			while( (hour < 24) || (min == 0) ) {
				
				var ts:String = "05/03/2013 ";
				ts += ( hour < 10 ? "0" + hour.toString() : hour.toString() );
				ts += ( min  < 10 ? ":0" + min.toString() : ":" + min.toString() );
				ts += ":00 UTC";
				
				data[i] = [ts, Math.random(), Math.random(), Math.random() ];
				
				min += 2;
				if( min == 60 ) {
					min = 0;
					hour += 1;
				}
				
				i++;
				
			}
			
			return data;
			
		}
		
		public function getGldPldRatios() : Array {
			
			var data:Array = [];
			var min:uint = 0;
			var hour:uint = 0;
			var i:uint = 0;
			
			while( (hour < 24) || (min == 0) ) {
				
				var ts:String = "05/03/2013 ";
				ts += ( hour < 10 ? "0" + hour.toString() : hour.toString() );
				ts += ( min  < 10 ? ":0" + min.toString() : ":" + min.toString() );
				ts += ":00 UTC";
				
				data[i] = [ts, Math.random(), Math.random(), Math.random() ];
				
				min += 2;
				if( min == 60 ) {
					min = 0;
					hour += 1;
				}
				
				i++;
				
			}
			
			return data;
			
		}		
		
		public function getNextUpdateTime() : Date {			
			
			return _nextUpdate;
			
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
		
		public function parseTime( time:String ) : Date {
			
			if( (!time) || (time == "") ) return null;
						
			var parts:Array = time.split(":");	
			if( parts.length != 2 ) {
				return null;
			}
			
			var hours:Number = parseInt( parts[0] );
			if( isNaN(hours) ) return null;
			var minutes:Number = parseInt( parts[1] );
			if( isNaN(minutes) ) return null;	
			
			var date:Date = new Date();
			date.setHours( hours, minutes, 0, 0 );
			
			return date;
			
		}
		
		public function parsePrice( price:String ) : Number {
			
			if( (!price) || (price=="") ) return Number.NaN;
			return Number(price);
			
		}

	}
	
}