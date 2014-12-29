var monthLabels = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
var oYears;
var oMonths;
var cMonth;
var cYear = 1;
var fVals;
var MonthCount;
var YearCount = 0;
var DnImg = "../images/Larr.gif";
var DnImgDis = "../images/RarrDis.gif";
var UpImg = "../images/Rarr.gif";
var UpImgDis = "../images/LarrDis.gif";
UpDisImage = new Image(); 
UpDisImage.src = UpImgDis;
DnDisImage = new Image(); 
DnDisImage.src = DnImgDis;
function SetYear()
{
	var sMonths = "";
	var sMonthv = "";
	MonthCount = 0;
	for (j=1; j < fVals.length; j++)
	{
		var cDate = fVals[j].split(";")[0];
		if (IsDateValid(cDate))
		{
			var nDate = cDate.substring(6,10);
			var sMonth;
			//alert(cDate);
			if (nDate == oYears[cYear -1]) 
			{
				sMonth = cDate.substring(2,5).replace("/0","/").replace("/","");
				if (sMonthv.indexOf(sMonth)<1)
				{
					sMonthv = sMonthv + "," + sMonth;
					sMonths = sMonths + "," + monthLabels[parseInt(sMonth) -1];
					MonthCount ++;
				}
			}
		}
	}
	sMonths = sMonths.substring(1);
	sMonthv = sMonthv.substring(1);
	//alert(sMonthv);
	oMonths = sMonths.split(",");
	oMonthsVal = sMonthv.split(",");
	cMonth = 1;
	ChangeMonth(0);
}
function ChangeMonth(Change)
{
	cMonth = cMonth + Change;
	document.getElementById("bMonthDown").src=DnImg;
	document.getElementById("bMonthUp").src=UpImg;
	if (cMonth <= 1)
	{
		cMonth = 1;
		document.getElementById("bMonthUp").src=DnImgDis;
	}
	if (cMonth >=  MonthCount)
	{
		cMonth = MonthCount;
		document.getElementById("bMonthDown").src=UpImgDis;
	}
	var nDay;
	for (j=1; j < fVals.length; j++)
	{
		var cDate = fVals[j].split(";")[0];
		var nDate = cDate.substring(6,10);
		if (nDate == oYears[cYear -1]) 
		{
			var sMonth = cDate.substring(2,5).replace("/0","/").replace("/","");
			if (sMonth==oMonthsVal[cMonth-1])
			{
				//alert(sMonth);
				nDay = cDate.substring(0,2);
				if (nDay.substring(0,1) == "0") 
				{
					nDay = nDay.substring(1);
				}
				break;
			}
		}
	}
	document.getElementById("calopts_day").value = nDay;
	document.getElementById("calopts_month_tx").value=oMonths[cMonth-1];
	document.getElementById("calopts_month").value=oMonthsVal[cMonth-1];
	document.getElementById("calopts").value= oYears[cYear -1] + "/" + oMonthsVal[cMonth-1] + "/" + nDay ;
	CreateCalendar(oMonthsVal[cMonth-1],oYears[cYear-1],nDay);
	//alert(document.getElementById("calopts").value);
	if (nDay.length == 1) {nDay = "0" + nDay;}
	var nMonth = oMonthsVal[cMonth-1];
	if (nMonth.length == 1) {nMonth = "0" + nMonth;}
	nDay = nDay + "/" + nMonth + "/" + oYears[cYear -1];
	//alert(nDay);
	ShowDate(nDay);
}
function ChangeYear(Change)
{
	cYear = cYear + Change;
	ChangeButt("bYearDown",DnImg);
	ChangeButt("bYearUp",UpImg);
	//alert(cYear);
	//alert(cYear + " " + cMonth);
	if (cYear <= 1)
	{
		cYear = 1;
		document.getElementById("bYearUp").src=DnImgDis;
	}
	if (cYear >=  YearCount)
	{
		cYear = YearCount;
		document.getElementById("bYearDown").src=UpImgDis;
	}
	document.getElementById("calopts_year").value=oYears[cYear-1];	
	//alert(oYears[cYear-1]);
	SetYear();
}
function ChangeButt(ButtId,ImgUrl)
{
	//alert('Changing' + ButtId);
	document.getElementById(ButtId).src=ImgUrl;
}
function ShowDate(eDate,icell)
{
	  if (icell) {
		for (k=1;k<42;k++)
		{
			var tcell = document.getElementById("calcell_" + k);
			var sDate = tcell.innerHTML + eDate.substring(2);
			if (tcell.className == "cal_today")
			{
				tcell.className = "cal_event";
				eval("document.getElementById(\"" + tcell.id + "\").onclick = function () {ShowDate(\""+sDate+"\", this);}");
			}
		}
		icell.className = "cal_today";
	  }
	  var i;var objName;var obVis;var i;
	  i=1;
	  objName = "dRow_" + i;
	  objDiv = document.getElementById(objName);
	  while (objDiv)
		{
		 //alert(objDiv.innerHTML);
		 obVis = "block";
		 if (objDiv.innerHTML.indexOf(eDate) <1)
		 {
		  obVis = "none";
		 }
		 objDiv.style.display = obVis;
		 i ++;
		 objName = "dRow_" + i;
		 objDiv = document.getElementById(objName);
		}
	//SetPrintDet();
}
function CreateCalendar(m,iyear,selD)
{
	m = m -1;
	//alert(m +  "/" + y + "/" + selD);
	var daysArr = new Array(42);
	for (j=0;j<43;j++)
	{
		daysArr[j] = 0;
	}
	dowArray = new Array("Sunday", "Monday", "Tuesday", "Wednesday",
"Thursday", "Friday", "Saturday");
	calVar = new Date(iyear,m,1);
	var opHTML = "<table class='cal_calendar'><tr align='center' class='cal_header'><td class='cal_cell'>Sun</td><td class='cal_cell'>Mon</td><td class='cal_cell'>Tue</td><td class='cal_cell'>Wed</td><td class='cal_cell'>Thu</td><td class='cal_cell'>Fri</td><td class='cal_cell'>Sat</td><tr>";
	var i= 0;
	var odd = 1;
	var sd = calVar.getDay();
	while (calVar.getMonth() == m)
	{	
		i ++;
		daysArr[i + sd] = i;
		calVar.setDate(calVar.getDate() + 1);					
		//alert(calVar);
	}				
	i = 0;
	var tdStyle = "";
	for (x=0;x<6;x++)
	{	
		odd ++;
		var bCol = "cal_evenweek";
		if (odd == 2)
		{
			odd = 0;
			bCol = "cal_oddweek";
		}
		opHTML += "<tr align='center' class='" + bCol + "'>";
		for (y=0;y<7;y++)
		{
			i ++;
			tdStyle = "";
			var RV = "";
			if (daysArr[i] > 0)
			{
				RV = daysArr[i];
				if (daysArr[i] == selD)
				{
					tdStyle = "cal_today";
				}
				else
				{
					for (j=0;j<fVals.length;j++)
					{
						var cFv = fVals[j].split(";");
						sDate = cFv[0];
						if (cFv[0].substring(0,1) == "0") {cFv[0] = cFv[0].substring(1).replace("/0","/");}
						cFv[0] = cFv[0].replace("/0","/");
						var cD = RV + "/" + (m + 1) + "/" + iyear;
						//alert(cFv[0] +  " " + cD);
						if (cFv[0] == cD)
						{
							tdStyle = "cal_event' onClick='ShowDate(\"" + sDate + "\",this)";							
						}
					}
				}
			}
			opHTML += "<td id='calcell_" + i + "' class='" + tdStyle + "'>" + RV  + "</td>";
		}
		opHTML += "</tr>";
	}
	opHTML += "</table>";
	//alert(opHTML);
	document.getElementById("CalDiv").innerHTML = opHTML;
	document.getElementById("CalDiv").style.display="block";
}