package com.goldpricecafe.mobile
{
	import mx.charts.chartClasses.DataTip;
	
	public class CustomDataTip extends DataTip
	{
		public function CustomDataTip()
		{
			super();
			this.styleName = this.styleName + " selected";
		}
		
	}
}