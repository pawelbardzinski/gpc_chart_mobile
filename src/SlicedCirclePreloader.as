package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	[Style(name="radius", inherit="no", type="int")]
	public class SlicedCirclePreloader extends DownloadProgressBar 
	{
	    private var bgSprite:SlicedCircle;
	    private var txtBox:TextField =  new TextField();
	    private var txtFormat:TextFormat= new TextFormat();
	    
	    /**
	    * Change the number of slices, radius and color here
	    */
	    private var slices:int=30;
	    private var radius:int=150;
	    private var sliceColor:uint=0xffff00;
	    
	    /**
	    * Change the text font,color, size here
	    */
	    private var txtFont:String="Arial";
	    private var txtFontSize:String="16";
	    private var txtFontColor:uint=0xeaed00;
	    
		public function SlicedCirclePreloader():void
		{
			super(); 
			
			bgSprite= new SlicedCircle(slices,radius,sliceColor);
			txtBox.text="0%";
			txtFormat.font=txtFont;
			txtFormat.size=txtFontSize;
			txtFormat.color=txtFontColor;
			txtFormat.align=TextFormatAlign.CENTER;
			txtBox.defaultTextFormat=txtFormat;
		}
		
		public function onStageResize(e : Event) : void {  
			centerPreloader();
		}
		
		public function centerPreloader():void {
			
			if(!stage) return;
			
			var centerX:Number=(this.stage.stageWidth) / 2;
            var centerY:Number=(this.stage.stageHeight) / 2;
            if(bgSprite!=null) {
            	bgSprite.x=centerX;
            	bgSprite.y=centerY;
            }
            if(txtBox!=null) {
				txtBox.x=centerX-radius;
            	txtBox.y=centerY-Number(txtFontSize)/2;
            }
		}
		
        public override function set preloader(preloader:Sprite):void 
        {              
        	stage.addEventListener(Event.RESIZE, onStageResize);
        	bgSprite.width=radius*2; 
			bgSprite.height=radius*2; 
			txtBox.width=radius*2;
        	this.addChild(bgSprite);
        	this.addChild(txtBox);
     		centerPreloader();
            preloader.addEventListener(FlexEvent.INIT_COMPLETE, onComplete); 
            preloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        }	
        
        private function onProgress(event:ProgressEvent):void {
        	if(isNaN(event.bytesLoaded) || event.bytesLoaded==0) return;
        	var num:Number=Math.floor(100*(event.bytesLoaded/event.bytesTotal));
        	 var str:String = String(num)+"%";
             txtBox.text=str;
        }
        
        private function onComplete(event:FlexEvent):void
        {
            dispatchEvent( new Event(Event.COMPLETE)); 
        }
        
	}
}