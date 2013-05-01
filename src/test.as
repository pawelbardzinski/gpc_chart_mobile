zoomCheck(); 
if (chartbtn.selectedIndex==2) 
	if ((USDh[0] == '') || (USDh[0] == null)) 
		loadHistory() 
	else populateChart('history') 
else latestSilverBtn.enabled = latestPlatinumBtn.enabled = latestPalladiumBtn.enabled = latestGoldBtn.enabled = radioGram.enabled = radioOunce.enabled = gldpltratioBtn.enabled = gldslvratioBtn.enabled = goldozcalc.enabled = silvozcalc.enabled = platozcalc.enabled = pallozcalc.enabled = indivChartBtn.enabled = true; 
if (indivChartBtn.emphasized) 
	populateChart('individual') 
else 
	if (gldslvratioBtn.emphasized) 
		populateChart('goldsilverratio') 
	else 
		if (newButton.emphasized) 
			populateChart('user') 
		else 
			if (gldpltratioBtn.emphasized) 
				populateChart('goldplatinumratio') 
			else 
				populateChart('');