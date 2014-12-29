var iSecond=1000;	 // Dates are represented in milliseconds
var iMinute=60*iSecond;
var iHour=60*iMinute;
var iDay=24*iHour;
var ct = '';
function GetDate(inDate,inTime)
	{
		var ds = inDate.replace('#0','');
	ds = ds.replace('#','');
	ds = ds.replace('#','');
	ds = ds.replace('/0','/');
	var dss = ds.split("/");
	var ts = inTime.replace(':0',':');
	if (ts.substr(0,1) == '0')
	{
		ts = ts.substring(1);
	}
	var tss = ts.split(':');
	var hs = tss[0];
	var mis = parseInt(tss[1]);
	var t_q  = 0;
	var ys = dss[2];
	var ms = dss[1] -1;
	var ds = dss[0];
	var s_date = new Date(ys,ms,ds,hs,mis);
	return s_date;
	}
function GetDayCount(DATE_START,DATE_END,DAY)
{	
	var s_date = GetDate(DATE_START,'00:00');
	var dt_start = s_date;
	var dt_end = GetDate(DATE_END,'00:00');
	var ret_count = 0;
	var n_days = 0;
	while (s_date <= dt_end)
	{
		n_days++;
		if (s_date.getDay() == DAY)
		{
				ret_count++;
		}
		s_date = new Date(s_date.getTime()+iDay);;
	}
	ret_count = ret_count / n_days;
	return ret_count;
}
function GetHourCount(DATE_START,DATE_END,TIME_START,TIME_END,HOUR)
{	
	var s_date = GetDate(DATE_START,TIME_START);
	var dt_start = s_date;
	var dt_end = GetDate(DATE_END,TIME_END);
	//alert(dt_end);
	//return 'fgh';
	var ret_count = 0;
	var n_days = 0;
	while (s_date <= dt_end)
	{
		n_days++;
		if (s_date.getHours() == HOUR)
		{
				ret_count++;
		}
		s_date = new Date(s_date.getTime()+iHour);;
	}
	ret_count = ret_count / n_days;
	//alert(n_days);
	//alert(ret_count);
	return ret_count;
}
function DoTimeAnalysis(obj)
{
	//alert(obj.lastChild.innerHTML);
	fsdjds();
	var requestData = obj.parentNode.lastChild.innerHTML;
		var source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		source.loadXML(requestData); //q[0].firstChild.xml);
		var residn = source.firstChild;
		var resid = residn.getAttribute("resid");
		var resid2 = resid + "SubDetails";
		ProgEle = document.getElementById(resid2); 
		PlayProcess();
    // load XSLT stylesheet document
	    req = "<FORCE>20</FORCE><SOURCE>CRIMETIMECHART</SOURCE><Parameters>" + requestData + "</Parameters>"
	SOAPClient.invoke(murl, "GetXMLDocument", req, true, TimeAnalysis_callBack,resid2);
}
function TimeAnalysis_callBack(r,g,DID)
{
	//alert(g.xml);
	if(r.constructor.toString().indexOf("function Error()") != -1)
	    alert("ERROR\r\n\r\n" + r.description + "\r\n\r\n[" + r.number + "]");
	else
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var tasource = new ActiveXObject("Microsoft.XMLDOM");
		tasource.async = false;
		tasource.loadXML(q[0].firstChild.nextSibling.xml) //q[0].firstChild.xml);
		 var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
		stylesheet.async = false;
		stylesheet.load("../XSL/" + rnName + ".xslt");
		document.getElementById(DID).innerHTML = tasource.transformNode(stylesheet);
		StopProcess();
		GenerateTimeChart(DID);
}
function GenerateTimeChart(DivId)
{
		var resId = DivId.replace("SubDetails","");
		//alert(resId);
		var DivObj = document.getElementById(DivId);
		var tasource = new ActiveXObject("Microsoft.XMLDOM");
		var t = 0;
		var dtFr;
		var dtTo;
		asdad();
		tasource.async = false;
		var xmlObj = document.getElementById(resId + "XMLDiv");
		tasource.loadXML(xmlObj.innerHTML) //q[0].firstChild.xml);
		var fd = document.getElementById(resId + "FromDate");
		dtFr = GetDate("#" + fd.value + "#" ,'00:00');
		var td = document.getElementById(resId + "ToDate");
		dtTo = GetDate("#" + td.value + "#",'00:00');
		if (ct =="")
			{ct = "DayAnalysis";}
		//asdsd();
		var dayTimes = tasource.getElementsByTagName("CRIME_TIME");
		var dTots = new Array(7);
		for (var td=0;td<7;td++)
		{dTots[td] = 0;}
		var hTots = new Array(24);
		var hMax = 0;
		var dMax = 0;
		for (var hd=0;hd<24;hd++)
		{hTots[hd] = 0;}
		for (var dt=0;dt<dayTimes.length;dt++)
		{
			var ds = "#" +  dayTimes[dt].getElementsByTagName("DATE_FIRST_COMMITED")[0].firstChild.nodeValue + "#";
			var de = "#" +  dayTimes[dt].getElementsByTagName("DATE_LAST_COMMITED")[0].firstChild.nodeValue + "#";
			var ts = dayTimes[dt].getElementsByTagName("TIME_FIRST_COMMITED")[0].firstChild.nodeValue;
			var te = dayTimes[dt].getElementsByTagName("TIME_LAST_COMMITED")[0].firstChild.nodeValue;
			var dst = GetDate(ds,ts);
			var det = GetDate(de,te);
			if (dst >= dtFr)
			{
				if (det <= dtTo)
				{
				switch (ct)
					{
						case 'DayAnalysis':
							for (var td=0;td<7;td++)
								{
									dTots[td] = dTots[td] + GetDayCount(ds,de,td);
									if (dTots[td] > dMax) {dMax =  dTots[td]}
								}
							break;
						case 'HourAnalysis':		
							for (var hd=0;hd<24;hd++)
								{
									hTots[hd] = hTots[hd] + GetHourCount(ds,de,ts,te,hd);
									if (hTots[hd] > hMax) {hMax = hTots[hd];}
								}
							break;
						default:
							alert('Duff ct');
							break;
					}
				}
			}
		}
		switch (ct)
			{
				case 'DayAnalysis':
					CreateChart(dTots,dMax,new Array('Mon','Tue','Wed','Thur','Fri','Sat','Sun'),DivId);
					break;
				case 'HourAnalysis':
					CreateChart(hTots,hMax,new Array('00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23'),DivId);
					break;
			}
		//alert(dTots + "," + dMax);
		//alert(hTots + "," + hMax);
    // load XSLT stylesheet document	    
}
function CreateChart(totVals,maxVal,collabels,DivId)
{
	var resId = DivId.replace("SubDetails","") + 'DetsDiv';
	//dasjasdk();
	var topVal = Math.round(maxVal)
	if (topVal < maxVal) {topVal = topVal + 1};
	var chartHTML = '<table style=\'font-size:8pt;position:absolute;top:10px\' width=550px><tr><td valign=bottom><img src=\'../images/blank.gif\' height=400 width=40></td>';
	var colWidth = 350 / collabels.length;
	for (var cl=0;cl<collabels.length;cl++)
	{
		var colHeight = 400 * (totVals[cl] / topVal);
		chartHTML = chartHTML + '<td valign=bottom><img src=\'../images/bar.gif\' height=\'' + colHeight + '\' width=\'' + colWidth + '\' alt=\'' + totVals[cl] + '\'\/></td>';
	}
	chartHTML = chartHTML + '<td valign=bottom><img src=\'../images/blank.gif\' height=400 width=40 ></img></td></tr><tr><td></td>'
	for (var cl=0;cl<collabels.length;cl++)
	{
		chartHTML = chartHTML + '<td align=center>' + collabels[cl] + '</td>';
	}
	chartHTML = chartHTML + '<td></td></tr></table>';
	chartHTML = chartHTML + '<div style=\'position:absolute;width:505px;height:101px;top:13px;left:31;border:1 solid black;\'/>'
	chartHTML = chartHTML + '<div style=\'position:absolute;width:505px;height:101px;top:99px;left:-1;border:1 solid black;\'/>'
	chartHTML = chartHTML + '<div style=\'position:absolute;width:505px;height:101px;top:99px;left:-1;border:1 solid black;\'/>'
	chartHTML = chartHTML + '<div style=\'position:absolute;width:505px;height:101px;top:99px;left:-1;border:1 solid black;\'/>'
	chartHTML = chartHTML + '<div style=\'font-size:8pt;text-align:right;position:absolute;width:585px;top:-310px;left:-30;width:29\'>' + topVal + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;text-align:right;position:absolute;width:585px;top:-210px;left:-30;width:29\'>' + (topVal * 0.75) + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;text-align:right;position:absolute;width:585px;top:-110px;left:-30;width:29\'>' + (topVal * 0.5) + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;text-align:right;position:absolute;width:585px;top:-10px;left:-30;width:29\'>' + (topVal * 0.25) + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;text-align:right;position:absolute;width:585px;top:90px;left:-30;width:29\'>0</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;position:absolute;width:585px;top:-310px;left:505\'>' + topVal + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;position:absolute;width:585px;top:-210px;left:505\'>' + (topVal * 0.75) + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;position:absolute;width:585px;top:-110px;left:505\'>' + (topVal * 0.5) + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;position:absolute;width:585px;top:-10px;left:505\'>' + (topVal * 0.25) + '</div>';
	chartHTML = chartHTML + '<div style=\'font-size:8pt;position:absolute;width:585px;top:90px;left:505\'>0</div>';
	//asdsd();
	document.getElementById(resId).innerHTML = chartHTML;
}
function DateDragFinished(lx,rx,resId)
	{
		var MonthEnd = Math.round((600 - rx) /10);
		var MonthBeg = Math.round((600 - lx) /10);
		var RefDate = GetDate(document.getElementById('EndDateIn').value,'00:00');
		var RefMonth = RefDate.getMonth();
		var yRef = RefDate.getFullYear();
		var refDay = RefDate.getDate(); 
		var mBout = 0;
		var yBout = 0;
		var mEout = 0;
		var yEout = 0;
		for (var q=0;q<61;q++)
		{
			if (RefMonth < 0) {
			RefMonth = 11;
			yRef = yRef - 1;
			}
			if (q==MonthEnd) {mEout = RefMonth + 1;yEout=yRef;}
			if (q==MonthBeg) {mBout = RefMonth + 1;yBout=yRef;}
			RefMonth = RefMonth - 1;
		}
		var dB = '01';
		var dE = '01';
		if (refDay < 10) {dB='0' + refDay;dE='0' + refDay;}
		if(refDay > 9 && refDay <28) {dB=refDay;dE=refDay;}
		if(refDay > 27)
		{
			if (days_in_month(yEout,mEout - 1) < refDay) {dE = days_in_month(yEout,mEout -1);} else {dE = refDay;}
			if (days_in_month(yBout,mBout - 1) < refDay) {dB = days_in_month(yBout,mBout -1);} else {dB = refDay;}
		}
		if (mEout < 10) {	document.getElementById(resId + 'ToDate').value = dE +  '/0' + mEout + '/' + yEout};
		if (mEout > 9) {	document.getElementById(resId + 'ToDate').value = dE + '/' + mEout + '/' + yEout};
		if (mBout < 10) {document.getElementById(resId + 'FromDate').value = dB +'/0' + mBout + '/' + yBout};
		if (mBout > 9) {document.getElementById(resId + 'FromDate').value = dB + '/' + mBout + '/' + yBout};
		GenerateTimeChart(resId)
	}
	function days_in_month (year, month) {
		return 32 - new Date(year, month, 32).getDate();
	}