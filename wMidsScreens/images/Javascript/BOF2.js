function SetUpBof()
{
//alert("SettingUp");
LoadJS("DatePicker.js");
}
function NextImg()
{
    prevImg = currImg;
    if (currImg == 0 || currImg == maxImg)
    {
        return;
    }
    currImg++;
    SetImg(currImg);
}
function PrevImg()
{
    prevImg = currImg;
    if (currImg == 0 || currImg == 1)
    {
        return;
    }
    currImg--;
    SetImg(currImg);
}
function SetImg(imgno)
{
    document.getElementById("NextImg").src = ".\\images\\Rarr.gif";
    document.getElementById("PrevImg").src = ".\\images\\Larr.gif";
    if (imgno<=1)
    {
        currImg=1;
        document.getElementById("PrevImg").src = ".\\images\\LarrDis.GIF";
    }
    if (currImg>=maxImg)
    {
        currImg=maxImg;
        document.getElementById("NextImg").src = ".\\images\\RarrDis.GIF";
    }
    currImg = imgno;
    document.getElementById("capcount").innerText = currImg + " of " + maxImg;
    var currSource = document.getElementById("CAPIMAGE").src;
    var newSource = currSource.replace("CAPINDEX=" + prevImg,"CAPINDEX=" + currImg);
    document.getElementById("CAPIMAGE").src = newSource;
    try
    {
        for (i=1;i<=maxImg;i++)
        {
            document.getElementById("capthumb" + i).style.border = "1 solid black";
        }
        document.getElementById("capthumb" + imgno).style.border = "2 solid blue";
    }
    catch (e)
    {
        null;
    }
    prevImg = currImg;
}
function closeImage()
{
    document.getElementById("mapstuff").style.display = "block";
    document.getElementById("CAPIMAGEDV").style.display= "none";
    document.getElementById("CAPIMAGE").src = ".\\images\\imgload.GIF";
}
function setCount()
{
    var areas = document.getElementsByTagName("AREA");
    var _count = 0;
    var _lcount = 0;
    for (i=0;i<areas.length;i++)
    {
        var _coords = areas[i].coords;
        var _xyr = _coords.split(",");
        var x = parseInt(_xyr[0]);
        var y = parseInt(_xyr[1]);
        var x2 = parseInt(_xyr[2]);
        var y2 = parseInt(_xyr[3]);
        var oh = areas[i].outerHTML;
        var c = oh.substr(oh.indexOf('CAPTURES') + 16);
        c = c.substr(0,c.indexOf("\\"));
        if (x>0 && x<470 && y>0 && y <420)
        {
            _count = _count + parseInt(c);
            _lcount ++;
        }
       // areas[i].coords = (x + 12) + "," + (y+12) + "," + (x2 + 12) + "," + (y2 + 12);
        //blip();
    }
    document.getElementById("featCount").innerText = _count;
    document.getElementById("locCount").innerText = _lcount;
}
function datePickerClosed(obj)
{
    var _resid = obj.id.replace("DateLimit","");
    SetDRs(obj,_resid);
}
function SetDRs(obj,resid)
{
    if (obj.id.replace(resid,'')=="TimePeriod")
    {
        var selPer =  document.getElementById(resid + "TimePeriod");
        if (selPer.selectedIndex!=0)
        {
        document.getElementById(resid + "DateLimit").value = "ANY";
        }
    }
    else
    {
        if (obj.id.replace(resid,'')=="DayLimit")
        {
            var selPer =  document.getElementById(resid + "DayLimit");
            if (selPer.selectedIndex!=0)
                {
                document.getElementById(resid + "DateLimit").value = "ANY";
                }
        }   
        else
        {
            if (obj.value!='ANY')
            {
            document.getElementById(resid + "TimePeriod").selectedIndex = 0;
            document.getElementById(resid + "DayLimit").selectedIndex = 0;
            }
        }
    }
    //document.getElementById("reloaddata").value = "Y";
}
function checkHours(resid)
{
   var fromHour = document.getElementById(resid + "HourLimitFrom").selectedIndex;
   var toHour = document.getElementById(resid + "HourLimitTo").selectedIndex;
   if (fromHour>toHour)
   {
    document.getElementById(resid + "HourLimitTo").selectedIndex = fromHour + 1;
   }
}
function UpdateRows(resid)
{
    var Caps= 0;
    var DateSel = document.getElementById(resid + "DateLimit").value;
    var DaySel = document.getElementById(resid + "DayLimit").value;
    var DaysSel = document.getElementById(resid + "TimePeriod").value;
    var TimeFromSel = document.getElementById(resid + "HourLimitFrom").value;
    var TimeLimitTo = document.getElementById(resid + "HourLimitTo").value;
    var RowTable = document.getElementById(resid + "BofRows");
    var trs = RowTable.getElementsByTagName('TR');
    for (i=1;i<trs.length;i++)
    {
        trs[i].style.display="block";
        var tds = trs[i].cells;
        var dhour = parseInt(tds[3].innerHTML.substring(0,2));
        var dday = tds[1];
        if (DateSel!="ANY")
        {
            var ddate = tds[2];
            if (DateSel != ddate.innerHTML)
            {
                trs[i].style.display="none";
            }
            else
            {           
            if (!(dhour > TimeFromSel && dhour < TimeLimitTo))
                {
                    trs[i].style.display="none";
                }
                else
                {
                    Caps++;
                }
            }
        }
        else
        {
           // dssa();
            var dday = tds[1].innerHTML;
             DaysOld = parseInt(tds[0].innerHTML);
             if (DaysOld > DaysSel)
                {
                    trs[i].style.display="none";
                }
             else
                {   
                if (DaySel != dday && DaySel != "ANY")
                {
                    trs[i].style.display="none";
                }        
                else
                    {
                     if (!(dhour > TimeFromSel && dhour < TimeLimitTo))
                        {
                            trs[i].style.display="none";
                        }
                     else
                        {
                        Caps++;
                        }
                    }
                }
            } 
        }
        document.getElementById(resid + "FeatCount").innerHTML = "Captures:" + Caps;
}
function ShowBofImage(resid,VRM,URN,CAPTUREDATE)
{
//sfd();
    document.getElementById(resid + "BofImgDiv").style.display = "block";
    document.getElementById(resid + "BofDetDiv").style.display = "none";
    var req = "<FORCE>20</FORCE><SOURCE>BOFIMAGES</SOURCE><Parameters><VRM>" + VRM + "</VRM><CAPTUREDATE>" + CAPTUREDATE + "</CAPTUREDATE></Parameters>";
    SOAPClient.invoke(murl, "GetXMLDocument", req, false,GenCallBack_callBack, resid + "BofImgDiv");
}
function ShowBofImages(OBJ,VRM,DATESEL,PERSEL,DAYSEL,HOURFROM,HOURTO,URNS)
{
sfd();
    var resid = OBJ.frameElement.id.replace('BofIframe','');
    document.getElementById(resid + "BofImgDiv").style.display = "block";
    document.getElementById(resid + "BofDetDiv").style.display = "none";
    var req = "<FORCE>20</FORCE><SOURCE>BOFIMAGES</SOURCE><Parameters><VRM>" + VRM + "</VRM><PERIOD>" + PERSEL + "</PERIOD><DATESEL>" + DATESEL +"</DATESEL><DAYSEL>" + DAYSEL + "</DAYSEL><HOURFROM>" + HOURFROM + "</HOURFROM><HOURTO>" + HOURTO + "</HOURTO><URNS>" + URNS + "</URNS></Parameters>";
    SOAPClient.invoke(murl, "GetXMLDocument", req, false,GenCallBack_callBack, resid + "BofImgDiv");
}
function closeBofImage(obj)
{
    obj.parentElement.style.display = "none";
    obj.parentElement.nextSibling.style.display = "block";
}
function switchBofImage(obj,resid)
{
    var imgs = obj.parentElement.parentElement.parentElement.getElementsByTagName("img");
    for (i=0;i<imgs.length ;i++)
    {
        imgs[i].style.border = "2 solid blue";
    }
    obj.style.border = "2 solid purple";
    document.getElementById(resid + "theBofImage").src = obj.src;
}