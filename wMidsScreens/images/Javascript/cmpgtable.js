var dayLabels = new Array("SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT","Time");
var SQCounts; //= new Array("Monday;10","Wednesday;2","Monday;10");
var RowColors = new Array("silver","gray");
var RowTxColors = new Array("black","white");
var locnames = new Array("Point Charlie","M6 Jct.4a-5 ","M42 Jct 3a","M42 Jct 11-10","M5 Jct 4a-5","M6 Jct 1-2","M54 Jct 3-2","M6 Jct 12-13");
var fVals;
function GetTable()
{
	
	var odd = 0;
	var sHTM = "";
	sHTM = "<table width='100%' border=0 class='cal_calendar'>";
	for (x=0;x<8;x++)
	{
	 odd ++;
	 if (odd == 2) {odd=0;}
	 sHTM += ("<tr bgcolor='" + RowColors[odd] + "' style='color:" + RowTxColors[odd] + "'><td>" + dayLabels[x] + "</td>");
	 for (y=1;y<25;y++)
	 {
	  var lV = 0;
	  var vParam = "";
	  for (j=0;j<SQCounts.length;j++)
	  {
	    var SQt = SQCounts[j].split(";");
	    if (SQt[0].substring(0,3) == dayLabels[x])
		{
		   if (SQt[1] == y)
		   {
		   	lV ++; 
			var sSeled = "";
			var sTime = document.getElementById("SEL_TIME").value;
			var sDay =  document.getElementById("SEL_DAY").value;
			if (y == sTime)
			{
			 if (dayLabels[x] == sDay)
			 {
			  sSeled = "_sel";
			 }
			}
			vParam = "bgcolor='white' class='cmpg_event" + sSeled + "' onclick='ShowDay(\"" + dayLabels[x] + "\",\"" + y + "\")'";
		   }
		}
	  }
	  var sLv = "";
	  if (x==7)
	  {
	   vParam = "style='layout-flow : vertical-ideographic'";
	   sLv = y + ":00";
	  }
	  if (lV > 0)
	  {sLv = lV}
	  sHTM += ("<td width='4%' align='center' " + vParam + ">" + sLv + "</td>");
	 }
	 sHTM += ("</tr>");
	}
	sHTM += ("</table>");
	//alert(sHTM);
	document.getElementById("tDiv").innerHTML = sHTM;
}
function ShowDay(iday,itime)
{
	  document.getElementById("SEL_DAY").value = iday;
	  document.getElementById("SEL_TIME").value = itime;
	  var i;var objName;var obVis;var i;
	  i=1;
	  var optList = document.getElementById("CAMERA_SEL");
	  //alert(optList.selectedIndex);
	  var optSel = document.getElementById("CAMERA_SEL").options[optList.selectedIndex].value;
	 // alert(optSel);
	  objName = "dRow_" + i;
	  objDiv = document.getElementById(objName);
	  while (objDiv)
		{
		 //alert(objDiv.innerHTML);
		 obVis = "none";
		 var iCells = objDiv.innerHTML.split("</TD>");
		 var tDay = iCells[1].substring(6,9);
		 var tDate = iCells[0].replace("<TD>","");
		 if (IsDateValid(tDate))
		 {
			if (tDay == iday)
			{
		 		//alert(iCells[3]);
		 		var tHour = iCells[3].substring(6,8);
		 		if (tHour.substr(0,1) == "0") {tHour = tHour.substring(1,2)}
		 		//alert(tHour);
		 		if (tHour == itime)
		 			{
		 			//alert(iCells[4]);
		 			var iReader =  iCells[4].substring(iCells[4].indexOf(">") + 1);
		 			
		 			//alert(iReader +  optSel);
		 			//alert(iReader);
		 			if (optSel == iReader) 
		 				{
		 				obVis = "block";
		 				}
		 			}
			}
		 }
		 objDiv.style.display = obVis;
		 i ++;
		 objName = "dRow_" + i;
		 objDiv = document.getElementById(objName);
		}
	GetTable();
	//SetPrintDet();
}
function PopCameraOpts()
{
	var opHTML = "<select name='CAMERA_SEL' id='CAMERA_SEL' onchange='ChangeCamera()'>";
	var opts = "";
	var optCount = 0;
	for (j=1;j<fVals.length;j++)
		{
			SPL = fVals[j].split(";");
			if (IsDateValid(SPL[0]))
			{
				var SelCam = SPL[5];
				//alert(SelCam);
				//SelCam = GetCleanCam(SelCam);
				if (opts.indexOf(SelCam)<0)
				{
				optCount ++;
				opts += "," + SelCam;
				opHTML += "<option value='" + SPL[1] + "'>" + SelCam + "</option>";
				}
			}
		}
	opHTML += "</select>";
	//alert(opHTML);
	document.getElementById("CameraOptDiv").innerHTML = opHTML;
	document.getElementById("CameraOptDiv").style.display = "block";
	document.getElementById("tDiv").style.display = "block";
}
function BuildArray(arrNum)
	{
		//alert(arrNum);
		var ArrVals = "";
		var SPL;
		var SelCam = document.getElementById("CAMERA_SEL").options[arrNum-1].value;
		var dPos = 1;
		for (j=0;j<fVals.length;j++)
		{
			SPL = fVals[j].split(";");
			var RL = SPL[1]
			//alert(RL);
			if (SelCam == RL)
			{
				if (IsDateValid(SPL[0]))
				{
					if (dPos == 1)
					{
						document.getElementById("SEL_DAY").value = SPL[4].substring(0,3);
						var sD = SPL[3].substring(0,2);
						if (sD.substring(0,1) == 0)
						{
							sD = sD.substring(1);
						}
						document.getElementById("SEL_TIME").value = sD;
						dPos = 2;
					}
					var H = SPL[3].substring(0,2);
					if (H.substring(0,1) == "0") {H = H.substring(1);}
					ArrVals += "," + SPL[4] + ";" + H;
				}
			}
		}
		ArrVals = ArrVals.substring(1);
		SQCounts = ArrVals.split(",");
	}
function ChangeCamera()
	{
		//alert(document.getElementById("CAMERA_SEL").value);
		BuildArray(document.getElementById("CAMERA_SEL").selectedIndex + 1);
		var sDay = document.getElementById("SEL_DAY").value;
		var sTime = document.getElementById("SEL_TIME").value;
		if (sTime.substring(0,1) == 0) {sTime = sTime.substring(1)};
		ShowDay(sDay,sTime);
		SetPrintDet();
	}
function GetDateSel()
	{
		iDate = fVals[1].split(";")[0];
		var iDay = iDate.substring(0,2);
		if (iDay.substring(0,1) == "0") {iDay = iDay.substring(1);}
		var  iMonth = iDate.substring(3,5);
		if (iMonth.substring(0,1) == "0") {iMonth = iMonth.substring(1);}
		iMonth --;
		var iYear = iDate.substring(6);
//					alert(iDate + " " + iDay + " " + iMonth + " " + iYear);
		var hD = new Date(iYear,iMonth,iDay);
		var tD = new Date();
		var tDiff = (tD - hD) / 86400000;				
		var opHtml = "<table width='90%'><tr class='small'><td><input type='radio' name='DateGroup1' value='-1' checked='checked' onclick='SetMinDate(-1)'>All Dates</input></td>";
		if (tDiff<91)
		{
			opHtml += "<td><input type='radio' name='DateGroup1' value='90' onclick='SetMinDate(90)'>Last 90 Days</input></td>";
		}
		if (tDiff<31)
		{ 
			opHtml += "<td><input type='radio' name='DateGroup1' value='30' onclick='SetMinDate(30)'>Last 30 Days</input></td>";
		}
		opHtml += "<td><input type='hidden' id='MinDate' value='-1'/></td>";
		opHtml += "</tr></table>";
		document.getElementById("DSelDiv").innerHTML = opHtml;
	}
