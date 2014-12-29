var IconCount = 0;
var locnames = new Array("Point Charlie","M6 Jct.4a-5 ","M42 Jct 3a","M42 Jct 11-10","M5 Jct 4a-5","M6 Jct 1-2","M54 Jct 3-2","M6 Jct 12-13")
var iSeled = 1;
var fVals;
function DoingIt()
{
	document.body.style.cursor='wait';
	document.getElementById('cmpgrows').style.display='none';
}
function FinishedDoingIt()
{
	document.body.style.cursor='auto';
	document.getElementById('cmpgrows').style.display='block';
}	
function SetUp()
{
	var stYears = "";
	var oMonths;
	YearCount = 0;
	for (j=1; j < fVals.length; j++)
	{
		var cDate = fVals[j].split(";")[0];
		if (IsDateValid(cDate))
		{
			var nDate = cDate.substring(6,10);
			if (stYears.indexOf(nDate)<0) 
			{
				YearCount ++;
				stYears = stYears + "," + nDate;
			}
		}
	}
	stYears = stYears.substring(1);
	cYear=1;
	cMonth=1;
	oYears = stYears.split(",");
	ChangeYear(0);
}
function IsDateValid(iDate)
{
	var tDays = document.getElementById("MinDate").value;
	if (tDays == -1)
	{
		return true;
	}
	var iDay = iDate.substring(0,2);
	if (iDay.substring(0,1) == "0") {iDay = iDay.substring(1);}
	var  iMonth = iDate.substring(3,5);
	if (iMonth.substring(0,1) == "0") {iMonth = iMonth.substring(1);}
	iMonth --;
	var iYear = iDate.substring(6);
//					alert(iDate + " " + iDay + " " + iMonth + " " + iYear);
	var hD = new Date(iYear,iMonth,iDay);
	var tD = new Date();
	var tDiff = (tD - hD) / 86400000
	return tDiff<tDays;
}
function setiSeled(iSel)
{
	iSeled = iSel;
}
function SetDivs()
{
	DoingIt();
	setTimeout('SetDivs2()',150);
}
function SetDivs2()
{
	var ResHeight = new Array(240,220,120);
	document.getElementById("cmpgrows").style.height=ResHeight[iSeled-1];
	switch (iSeled)
	{
		case 1:
		//alert("SettingCal");
		SetUp();
		break;
		case 2:
		//alert("SettingLoc");
		PopCameraOpts();
		BuildArray(1);
		var sTime = document.getElementById("SEL_TIME").value;
		var sDay =  document.getElementById("SEL_DAY").value;
		ShowDay(sDay,sTime);
		break;
		case 3:
		//alert("Map");
		BuildMap();
		break;
	}
	FinishedDoingIt();
	//SetPrintDet();
}
function SetMinDate(MD)
{
	document.getElementById("MinDate").value = MD;
	SetDivs();
}
function BuildMap()
	{
		var IconNames = new Array();
		IconCount = 0;
		var IconCounts = new Array();
		var nEx;
		for (j=1;j<fVals.length;j++)
		{
			SPL = fVals[j].split(";");
			if (IsDateValid(SPL[0]))
			{
				nEx = true;
				//alert(SPL[1] + " " + IconCount);
				for (y=0;y<IconCount;y++)
				{
					if (IconNames[y] == SPL[1])
					{
						//alert("Setting" + IconNames[y] + " " + y + " " + IconCounts[y]);
						IconCounts[y] ++;
						nEx = false;
					}
				}
				//alert(nEx);
				if (nEx)
				{
					IconNames[IconCount] = SPL[1];
					IconCounts[IconCount] = 1;
					IconCount ++;
				}
			}
		}
		//MapArray = mArrVals.split(",");
		var opHTML;
		opHTML = "<img src='..\\images\\CMPGBRMAP2.jpg' width='400px' height='300px' alt=''/>";
		for (j=0;j<IconCount;j++)
		{
			opHTML += "<img id='CarIcon" + j + "' src='..\\images\\car.gif' style='"; // alt='Location " + IconNames[j] + ", Read count :" + IconCounts[j] + "' style='";
			if (j==0){
			opHTML += "border:solid 2 blue;";
			}
			//alert(opHTML);
			opHTML +="position:absolute;width:16px;height:16px;cursor:hand' class='CmpgMapIcon" + IconNames[j] + "' onclick='MapSelection(\"" + IconNames[j] + "\"," + j + ")' onmouseover='OverCar(\"" + IconNames[j] + "\"," + IconCounts[j] + ")' onMouseOut='OffCar()'/>";
		}
		//alert(opHTML);
		//sdfksjdksdfjfk();
		opHTML += "<div id='MWSign' class='cmpgPopUp'>hello</div>";
		document.getElementById("MAP_DIV").innerHTML = opHTML;
		document.getElementById("MAP_DIV").style.display="block";
		MapSelection(IconNames[0],0);
	}
	function MapSelection(SelectedLocn,SelectedCar)
	{
	  var i;var objName;var obVis;var i;
	  i=1;
	  objName = "dRow_" + i;
	  document.body.style.cursor="wait";
	  objDiv = document.getElementById(objName);
	  while (objDiv)
		{
		 //alert(objDiv.innerHTML);
		 obVis = "none";
		 var iCells = objDiv.innerHTML.split("</TD>");
		 var tDate = iCells[0].replace("<TD>","");
		 if (IsDateValid(tDate))
		 {
			tLoc = iCells[4].replace("<TD>","");	
			//alert(tLoc + " " + SelectedLocn + (parseInt(tLoc) == SelectedLocn));		
			if (parseInt(tLoc) == SelectedLocn)
			{
		 		obVis = "block";
		 	}
		 }
		 objDiv.style.display = obVis;
		 i ++;
		 objName = "dRow_" + i;
		 objDiv = document.getElementById(objName);
		 for (j=0;j<IconCount;j++)
		 {	
			var CarObj = document.getElementById("CarIcon" + j);
			if (j==SelectedCar)
			{
				CarObj.style.border="solid 2 blue";
			}
			else
			{
				CarObj.style.border="none";
			}
		 }
		}
		document.body.style.cursor="auto";
		//SetPrintDet();
		
}
function OverCar(LocName,LocCount)
		{
			var MwObj = document.getElementById("MWSign");
			MwObj.innerHTML = locnames[parseInt(LocName) -1] + "<br/>Read count: " + LocCount + "";
			 var left = event.clientX - 400;// + document.body.scrollLeft + 10;
			 var top = event.clientY - 100; //+ document.body.scrollTop + 10;
			MwObj.style.top = top;
			MwObj.style.left = left;
			MwObj.style.display="block";

			
		}
function OffCar()
	{
		document.getElementById("MWSign").style.display="none";
	}