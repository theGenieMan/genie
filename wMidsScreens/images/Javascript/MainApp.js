// Controlling script for mainapp.htm
// uses soapclinet.js to perform web service requests and populate varaious div elements
// ver 1.0 alpha 
// Mark Compton Autum Consulting
// - change at 26/10/2007
// change to FTSCallBack - to allow differnt xslt sheet for each force
// - Change at 29/10/2007
// Added CloseGPMS function
// - Change 2/11/2007
// Add force password change functionality
// - Change at 7/11/2007
// Removal of flash
// - cHNAGES 13 / 14 nOV 2007
// Added functions for IMS
//MC 28/12/2007
// Changes for various tracker issues
// -- Change to login functions to prevent time out issues
// Changes to dosearch function - to prevent zero lenght Fquery options
// 
var CurrentTime = 30;
var ReloadTime = 30;
var tickTimerId;
var relTimerId;
var fDoing = false;
var _Int=0;
var detPos = 0;
var murl; // = "../../FlintsInfoStore/FlintsDataService.asmx";
var settingsXML = XMLFuncs.GetDom();
var menuLoaded = false;
var mUserId = "";
var mForceId = "";
var mUserLevel = "";
var mSessionId = "";
var mSessKey = "";
var FSSelection = "<FSSelection>All</FSSelection>";
var SVGNs = "http://www.w3.org/2000/svg";
var xlink ="http://www.w3.org/1999/xlink";
var PageCount = 0;
var DateRangeValue = 0;
var cache_div;
var cache_type = '';
var prog_img_html = '<img src="../images/pyramid.gif">';
var curr_search_req = '';
var gdrequestData = "";
var gdresid = "";
var lastSelNode;
var SearchTerms = new Array();
var ProgEle;
var ProgEleIntervalID;
var mWST;
var PrintStamp;
var AuditType = "Login";
var mDomId;
var mSystemId;
var CurImg = 1;
var CurrentSubmit = null;
var OldSubmit = null;
var SourcesSelected = 0;
var ChangePass;
var printForce = "";
var TabTips = new Array();
var startTime;
function f(o){
  o.value=o.value.toUpperCase().replace(/([^0-9A-Z])/g,"");
}
function checkKeyCode(e)
{
	//Function to stop F5 and backspace page refresh / go back
	var key, node;
	if (e)
	{
		key = e.which;
		node = e.target;
	}
	else
	{
		key = event.keyCode;
		node = event.srcElement;
	}
	//dfslksdf();
	// || 
	if(key == 116)
	{
		if (e)
		{
			e.which = 0;
			e.returnValue = false;
		}
		else
		{
			event.keyCode=0;
			event.returnValue = false;
		}
		return false
	}
	if (key == 8) //|| key == 13)
	{
		if (node.tagName != 'INPUT' && node.tagName != 'TEXTAREA')
		{
			return false;
		}
		if (node.tagName == 'INPUT')
		{
			if (node.type != "text" && node.type != "password")
			{
				return false;
			}	
		}
	}
	if (key ==13)
	{
		if (CurrentSubmit)
		{
			//alert("CS");
			CurrentSubmit.click();
			return false;
		}
	}
    return true;
}
function uppercase()
{
	key = window.event.keyCode;
	if (event.srcElement.tagName == 'INPUT')
	{
	var DisallowedKeyCodes = event.srcElement.getAttribute("DisallowedKeyCodes");
	if ((key > 96) && (key < 123))
		{window.event.keyCode = key -32;return true;}
	else
		{
		if ((key > 64) && (key < 92))
			{return true}
		else
			{
			if ((key > 47) && (key < 59))
				{return true;}
			else
				{
				if (key != 8 && key != 45 && key != 39 && key != 13 && key !=32 && key!=47 && key != 95)
					{
						return false;
					}
				else
					if (DisallowedKeyCodes)
					{
						var DisKeys = DisallowedKeyCodes.split(',');
						for  (d=0;d<DisKeys.length;d++)
						{
							if (key == parseInt(DisKeys[d]))
							{
								return false;
							}
						}
					}
				}
			}
		}
	}
}
document.onkeydown = checkKeyCode;
document.onkeypress = uppercase;
function CheckIsDigit(e)
{
	uppercase(e);
}
function IncValue()
		{
			//timer incrementer
			_Int=_Int+1;
			if (_Int<1000) {window.setTimeout(IncValue,1000)};
		}
function GetPage(i)
{
		//Get a page on clicking of a menus item
		//alert('getpage');
		
		//trrtere();
		HideElement("DateRangeSel");
		HideElement("ForceSourceDiv");		
		PlayProcess();
		PageCount++;
		var mItems = settingsXML.getElementsByTagName("MENU_ITEMS");
		var obj = document.getElementById("FlintsMenu");
	//sfdsdf();
		var xmlString = "";
		var jsNode = mItems[0].childNodes[i].lastChild.firstChild.childNodes[3];
		if (jsNode)
		{
			var JSFile = jsNode.firstChild.nodeValue;
			LoadJS(JSFile);
		}
		for (k=0;k<3;k++)
		{
		 var callNode = mItems[0].childNodes[i].lastChild.firstChild;
		 var theNode = callNode.childNodes[k];
		//gflgfl;
		 xmlString = xmlString + XMLFuncs.GetXMLStr(theNode);
		}
		var tabText = mItems[0].childNodes[i].childNodes[3].firstChild.nodeValue;
		//TODO: Change to configuration option
		var drVis = "none";
		if (tabText=="Free Text Search")
		{
		    drVis = "block";
		}
		document.getElementById("DateRangeLabel").style.display = drVis;
		req = xmlString;
		var DivId = "PageDiv" + PageCount;
		var pageDiv = document.createElement("div");
		pageDiv.id = DivId;
		pageDiv.className = "FlintsPage";
		document.body.appendChild(pageDiv);
		setInfoBar(tabText);
		addTab(tabText,DivId);
		//alert(req);
	    SOAPClient.invoke(murl, "GetXMLDocument", req, true, GenCallBack_callBack,DivId);
	}
function RevalidateSession()
{
	var Pwd = document.getElementById("Password").value;
	if (Pwd =="")
	{
	}
	else
	{
		//alert(EncryptText(Pwd));
		var ReValidateReq = "<RevalidateSession><UserID>" + mUserId + "</UserID><Pwd>" + Pwd + "</Pwd><SessionId>" + mSessionId + "</SessionId></RevalidateSession>";
		SOAPClient.invoke(murl,"GetXMLDocument",ReValidateReq,true,RevalidateCallBack,null);
	}
}
function RevalidateCallBack(r,g,DID)
{
	//Call back for revalidation web service call - lowers security div if revalidation is successfull
	var Resp = g.getElementsByTagName("Response")[0]
	if (Resp.firstChild.nodeValue=='Failed') 
	{alert("Bad credentials supplied!");}
	else
	{
		////Check response
		
		document.getElementById("FireCurtain").style.display = "none";
		document.getElementById("MainApp").style.display = "block";
		document.getElementById("MainApp").style.top = 0;
		document.getElementById("Password").value = "";
		StartTimer();
		CurrentSubmit = OldSubmit;
		OldSubmit = null;
	}
}
function LaunchSearch(Stype,tabText,clickObj)
{
    //Create a search request and post to the webservice
    //gfhgfg();
	PlayProcess();
	PageCount++;
	var reqXML = clickObj.lastChild.innerHTML;
	var source = new ActiveXObject("Microsoft.XMLDOM");
	source.async = false;
	reqXML = reqXML.replace(/<SPAN class=qterm>/g,'');
	reqXML = reqXML.replace(/<\/SPAN>/g,'');
	source.loadXML(reqXML);
	req = "<FORCE>20</FORCE><SOURCE>FLINTSSEARCH</SOURCE><ID>" + Stype + "</ID>";
	var DivId = "PageDiv" + PageCount;
	var pageDiv = document.createElement("div");
	pageDiv.id = DivId;
	pageDiv.className = "FlintsPage";
	document.body.appendChild(pageDiv);
	addTab(tabText,DivId);
	//alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, GenCallBack_callBack,DivId);
	var SearchDiv = document.getElementById(DivId);
	var inputEles = SearchDiv.getElementsByTagName("input");
	var inp = 0;
	for (inp = 0;inp < inputEles.length;inp++)
	{
		var InpId = inputEles[inp].id;	
		/*if (InpId == 'DS') {DSButton = inputEles[inp];}*/
		var searchEle = source.selectSingleNode('//SEARCHATTRIBUTES/SEARCHATTRIB[@aName="' + InpId + '"]');
		//dfksdfdfkl();
		if (searchEle)
			{
				if (searchEle.firstChild)
				{	
					var inpVal = searchEle.firstChild.nodeValue;
					inputEles[inp].value = trim(inpVal.toUpperCase());
				}
			}
	}
	CurrentSubmit.click();
}
function trim(inpString) 
{
	return inpString.replace(/^\s+|\s+$/g,"");
}
function GenCallBack_callBack(r,g,DID)
{
	//Generic call back for web service requests
	//Combines response XML with an Xslt style sheet to populate a div object with HTML
	//StopProcess();
	if(r.constructor.toString().indexOf("function Error()") != -1)
	{
	     handleError(r,g,DID);
	}
	else
	{
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var jsfile = g.getElementsByTagName("JS_FILE");
		//asddas();
		if (jsfile)
		{
			for (z=0;z<jsfile.length;z++)
			{
				var jsurl = jsfile[z].firstChild.nodeValue; 
				LoadJS(jsurl);
			}
		}
		var source = XMLFuncs.GetDom(); //Get an XML Dom object
		source = q[0].firstChild.nextSibling;
		var forceNode = source.selectSingleNode("//CORE_DETAILS/FORCE");
		if (forceNode)
		{
			rnName = forceNode.firstChild.nodeValue + "/" + rnName;
			//alert(rnName);
		}
	    var XSLPath = "../xsl/" + rnName + ".xslt";
		XMLFuncs.PopDiv(source,XSLPath,DID);
		FindPageDefBut(DID);
	}
}
function DoSearch(ID)
{
	//Generate a search request and post it to the web service 
	// Navigates input elements on selected search page to create request
	HideElement("ForceSourceDiv");
	HideElement("DateRangeSel");
	if (SourcesSelected > 0)
	{
		PlayProcess();
		//window.setTimeout(IncValue,1000);
		ClearDetsDiv(ID);
		var stab = document.getElementById(ID);
		var PageIDStr;
		if (window.ActiveXObject) 
		{
			PageIDStr = stab.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id;
		}
		else
		{
			PageIDStr = stab.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.id;
		}
		var PageId = PageIDStr.replace('PageDiv','');
		var trNode = stab.lastChild.firstChild;
		var sTp = trNode.lastChild.firstChild.getAttribute("VALUE");
		//alert(sTp);
		var pageTTip = "<Table class='small'>";
		var validrequest = true;
		var req = "";
		var qLength = 0;
		do 
		{
			var id = "";
			var nv = "";
			var vtagName = trNode.lastChild.lastChild.tagName;
			switch(vtagName)
			{
				case "INPUT":
					id = trNode.lastChild.lastChild.getAttribute("ID");
					nv = trNode.lastChild.lastChild.value;
					var nt = trNode.lastChild.lastChild.getAttribute("type"); 
					if (nt == "text")
					{
						qLength = qLength + nv.length;
					}
					nv = nv.replace(/^\s+|\s+$/g, '') ;
					var vregex = trNode.lastChild.lastChild.getAttribute("regex");
					if (vregex) 
					{
						var obj = trNode.lastChild.lastChild;
						obj.style.color = "Black";
						RExp = new RegExp(vregex);
						var FailedMessage = trNode.lastChild.lastChild.getAttribute("failedmessage");
						var RequiredField = trNode.lastChild.lastChild.getAttribute("requiredfield");
						var FailedMessage = trNode.lastChild.lastChild.getAttribute("failedmessage");
						if (validrequest)
						{
							if (!nv)
							{
								if (RequiredField=="Y")
								{
									validrequest = false;
									alert(FailedMessage);
									obj.style.color = "Red";
								}
							}
							else
							{
								validrequest = validateRegex(obj,RExp,FailedMessage);
							}
						}
					}
					if (id != 'TAXONOMY_LEVEL')
					{
						if(nv) {pageTTip = pageTTip  + "<tr><td>" + id + " :</TD><TD>" + nv  + "</TD></TR>"}; 
					}
					break;
				case "SELECT":
					id = trNode.lastChild.lastChild.getAttribute("ID");
					nv = trNode.lastChild.lastChild.value; //getAttribute("value");
					break;
				case "TABLE":
					var thNode = trNode.lastChild.lastChild.firstChild;
					for (var tN=0;tN<thNode.childNodes.length;tN++)
					{
					var trNode1 = thNode.childNodes[tN].lastChild.firstChild;
					if (trNode1.checked)
						{
						id = trNode1.getAttribute("ID");
						nv = trNode1.value;
						break;
						}
					}
				default:
					break;
			}
			if (id != "")
			{req = req + "<" + id + ">" + nv + "</" + id + ">";}
			trNode = trNode.nextSibling;
		} while (trNode);
		// Poulate search term array - used to highlight search terms in the result documents
		//alert(pageTTip);
		pageTTip = pageTTip + "</Table>";
		var TabPageDiv = document.getElementById("SelTabPageDiv" +  PageId);
		TabTips[PageId] = pageTTip;
		TabPageDiv.attachEvent("onmouseover",TabTip);
		TabPageDiv.attachEvent("onmouseout",function() {HideTip(event)});
		if (validrequest && qLength > 0)
		{
			PopulateSTermArray(req,PageId);
			req = "<FORCE>20</FORCE><SOURCE>" + sTp + "</SOURCE><Parameters><DateRange>" + DateRangeValue + "</DateRange>" + FSSelection + "<Search><USER_ID>" + mUserId + "</USER_ID>" + req + "</Search></Parameters>";
	//	alert(req);
			var DID = ID + "Results";
			document.getElementById(DID).innerHTML = prog_img_html + "<span class='small' style='font-weight:bold'>Searching.</span>";
			SOAPClient.invoke(murl, "GetXMLDocument", req, true, Search_callBack,DID);
		}
		else
		{
			StopProcess();
		}
	}
	else
	{
		alert("You have no sources selected!");
	}
}
function TabTip(e)
{
	var TabId = event.srcElement.id.substring(13);
	ShowTip(e,TabTips[TabId]);
}
function Search_callBack(r,g,DID)
{
	//Call back for asynch search request web service
	//topProcess();
	//fsdjk();
	if(r.constructor.toString().indexOf("function Error()") != -1)
	   {  handleError(r,g,DID);}
	else
		{
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var source = XMLFuncs.GetXMLObj(XMLFuncs.GetXMLStr(q[0].firstChild.nextSibling));
		var resid;
		var residtext;
		if (window.ActiveXObject)
		{
			resid = source.createElement("resid");
			residtext = source.createTextNode(DID.replace('Results',''));
		}
		else
		{
			resid = document.createElement("resid");
			residtext = document.createTextNode(DID.replace('Results',''));
		}
		resid.appendChild(residtext);
		source.documentElement.appendChild(resid);
		if (rnName != 'FREE_TEXT_SEARCH')
		{
		XMLFuncs.PopDiv(source,"../XSL/AJAXSEARCHRESULTSC.xslt",DID);
		}
		else
		{
			//alert("fs");
			XMLFuncs.PopDiv(source,"../XSL/AJAXSEARCHRESULTSD.xslt",DID);
		}
		}
}
function GetCachedBranchResults(CacheId,CurPos,ID)
{
    //alert(CacheId);
    var req = "<FORCE>20</FORCE><SOURCE>GETCACHEDSEARCHRESULTS</SOURCE><CacheId>" + CacheId + "</CacheId><CachePos>" + CurPos + "</CachePos>";
    var DID = ID + "Results";
    document.getElementById(DID).innerHTML = prog_img_html + "<span class='small' style='font-weight:bold'>Searching.</span>";
	SOAPClient.invoke(murl, "GetXMLDocument", req, true, Search_callBack,DID);
    
}
function GetDetHead(obj)
{
	//Create request for detail header request (RHS)
	if (lastSelNode) {lastSelNode.className = "PrvSel";}
	lastSelNode = obj.parentNode;
	lastSelNode.className = "SelBorder";
	gdrequestData = obj.lastChild.innerHTML.replace(/CACHED_RESULT>/g,'SEARCH_RESULTS>');
	//Todo: Artfiact 1257
		var source =XMLFuncs.GetXMLObj(gdrequestData);
		var residn = source.firstChild;
		gdresid = residn.getAttribute("resid");
		gdresid = gdresid + "Details";
		CurrentSearchType = source.firstChild.lastChild.childNodes[1].firstChild.nodeValue;
	    gdrequestData = gdrequestData.replace(/CACHED_RESULT>/g,'SEARCH_RESULTS>');
	    gdrequestData = gdrequestData.replace(/SEARCH_RESULTS>/,'SEARCH_RESULTS>');//<USER_ID>' + mUserId + '</USER_ID>');
		ProgEle = document.getElementById(gdresid); //.innerHTML = prog_img_html + "<span>Loading....</span>";
		//Hack to allow loading of progress gif
		PlayProcess();
		self.setTimeout('GetDetAsynch()', 500);
}
function GetDetHead2(obj)
{
	//Get secondary header - called once detail head has loaded
	gdrequestData = obj.parentNode.lastChild.innerHTML;
	var source = XMLFuncs.GetXMLObj(gdrequestData);
	var residn = source.firstChild;
	var gdresid = residn.getAttribute("resid");
	gdresid = gdresid + "Details";
	ProgEle = document.getElementById(gdresid);
	PlayProcess();
	self.setTimeout('GetDetAsynch()', 1000); //\"' + requestData + '\",\"' + resid + '\"
}
function GetDetAlt(obj,newType)
{
	gdrequestData = obj.parentNode.lastChild.innerHTML;
	//var regeFinder = /<SOURCE>?</gi
	//gdrequestData = gdrequestData.replace(regeFinder,"<SOURCE>" + newType + "<");
	var source = XMLFuncs.GetXMLObj(gdrequestData);
	var sourceEle = source.selectSingleNode('/DETREQUEST/SEARCH_RESULTS/SOURCE').firstChild;
	sourceEle.nodeValue = newType;
	gdrequestData = source.xml;
	var residn = source.firstChild;
	var gdresid = residn.getAttribute("resid");
	gdresid = gdresid + "Details";
	ProgEle = document.getElementById(gdresid);
	PlayProcess();
	self.setTimeout('GetDetAsynch()', 1000); //\"' + requestData + '\",\"' + resid + '\"
}
function GetDetAsynch()
{
	//Asynch hack - allows loading of animated gif
	req = "<FORCE>20</FORCE><SOURCE>GETDETHEAD</SOURCE><Parameters>" + gdrequestData + "</Parameters>";
	//alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, GenCallBack_callBack,gdresid);
	GetDetails(gdrequestData);
}
function SetTabSel(obj)
{
	//Deprecated - i think
	var pobj = obj.parentElement;
	var g = 0;
	for (var t=0;t<pobj.childNodes.length;t++)
	{
		g = t;
	}
}
function GetDetails(reqdata)
{
	//Get inner details page - (RHS)
	var requestData = reqdata; //obj.lastChild.innerHTML;
	var source = XMLFuncs.GetXMLObj(requestData) //q[0].firstChild.xml);
	var residn = source.firstChild;
	var resid = residn.getAttribute("resid");
	resid = resid + "SubDetails";
	ProgEle = document.getElementById(resid);
	PlayProcess();
    req = "<FORCE>20</FORCE><SOURCE>GETDETS</SOURCE><Parameters>" + requestData + "</Parameters>";
    //alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, GenCallBack_callBack,resid);
	var _detid = document.getElementById(resid).firstChild.innerHTML;
	LoadDet(1,_detid);
	detPos = 1;
}
function LoadDet(detNumber,detid)
{
	//Load sub details page
	//dfjkdfjk();
	obj = document.getElementById(detid + '-' + detNumber);
	if (obj)
	{
		var requestData = obj.innerHTML;
		requestData = requestData.replace('<DETAIL>','');
		requestData = requestData.replace('<\/DETAIL>','');
		//requestData = requestData + '<USER_ID>' + mUserId + '<\/USER_ID>';
		var resid = detid + "DetsDiv";
		ProgEle = document.getElementById(resid);
		PlayProcess();
		SOAPClient.invoke(murl, "GetXMLDocument", requestData, true, FTSDetCallBack_callBack,resid);
    }
}
function FTSDetCallBack_callBack(r,g,DID)
{
	//Call back for free text search requests
	if(r.constructor.toString().indexOf("function Error()") != -1)
	  {  
		handleError(r,g,DID);
	  }
	else
		{
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var source = XMLFuncs.GetXMLObj(XMLFuncs.GetXMLStr(q[0].firstChild.nextSibling)); //q[0].firstChild.xml);
		if (fdebugon) {AddDebOutput(source.xml,'IN');}
		//change to allow force identifier in stylesheet location
		var force = source.selectSingleNode("//CORE_DETAILS/FORCE").firstChild.nodeValue;
	    var stylesheetDoc ="../XSL/" + force + "/" + rnName + ".xslt";
		var TempHTML = XMLFuncs.GetHTMLStr(source,stylesheetDoc);
		var DetsDiv = document.getElementById(DID);
		var STermID;
		if (window.ActiveXObject)
		{
			STermID=DetsDiv.parentElement.parentElement.parentElement.id.replace('PageDiv','');
		}
		else
		{
			STermID=DetsDiv.parentNode.parentNode.parentNode.id.replace('PageDiv','');
		}
		//High light search terms in result document
		//if (1 == 2) {
		if (SearchTerms[STermID].length)
		{
			for (t=0;t<SearchTerms[STermID].length;t++)
			{
				var STerm = '';
				STerm = SearchTerms[STermID][t];
				var RepTerm = STerm.toUpperCase();
				var re = new RegExp(RepTerm, "g");
				TempHTML = doHighlight(TempHTML,RepTerm); // TempHTML.replace(re,'<span class="qterm">' + RepTerm + '</span class="qterm">');
			}
		}//}
		StopProcess();
		DetsDiv.innerHTML = TempHTML;
	//	var MessageDiv = document.getElementById("InfoBar");
		//MessageDiv.innerHTML = rnName + ".xslt";
		}
}
function GetAlternateDetails(obj,alternatecall)
{
	//Used when alternative views of detail data are available - ie time analysis for crimes data
	alert(alternateCall);
	var requestData = obj.lastChild.innerHTML;
	var source = new ActiveXObject("Microsoft.XMLDOM");
	source.async = false;
	source.loadXML(requestData); //q[0].firstChild.xml);
	var residn = source.firstChild;
	var resid = residn.getAttribute("resid");
	resid = resid + "SubDetails";
	req = "<FORCE>20</FORCE><SOURCE>" + alternatecall + "</SOURCE><Parameters>" + requestData + "</Parameters>"
	ProgEle = document.getElementById(resid);
	PlayProcess();
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, GenCallBack_callBack,resid);
}
function UpLink(maxPos,detid)
{
	//Used to navigate detail pages wher more than one exists
	var obj = document.getElementById(detid + 'DetsLab');
	var lablVal = obj.innerHTML;
	var ofInd = lablVal.indexOf(' of');
	detPos = lablVal.substr(0,ofInd);
	detPos ++;
	if (detPos > maxPos)
	{
		detPos = maxPos;
		return;
	}
	else
	{
		obj.innerHTML = detPos + " of " + maxPos;
		SetUPDNImg(detid,maxPos)
		LoadDet(detPos,detid);
	}
}
function DownLink(detid,maxPos,ListObj)
{
	//Used to navigate detail pages wher more than one exists
	var obj = document.getElementById(detid + 'DetsLab');
	var lablVal = obj.innerHTML;
	var ofInd = lablVal.indexOf(' of');
	detPos = lablVal.substr(0,ofInd);
	detPos --;
	if (detPos <= 0)
	{
		detPos = 1;
		return;
	}
	else
	{
		obj.innerHTML = detPos + " of " + maxPos;
		SetUPDNImg(detid,maxPos);
		LoadDet(detPos,detid);
	}
}
function SetUPDNImg(detId,maxPos)
{
	//Set enable / disable image for navigation buttons
	var dnImg = "../Images/Larr.gif";
	var upImg = "../Images/Rarr.gif"
	if (detPos < 2)
		{dnImg = "../Images/Larrdis.gif";}
	if (detPos >= maxPos)
		{upImg = "../Images/Rarrdis.gif";}
	var obj = document.getElementById(detId + 'DetsUp');
	obj.src= upImg;
	obj = document.getElementById(detId + 'DetsDn');
	obj.src= dnImg;
	var ListObj = document.getElementById(detId + "ListObj");
	if (ListObj)
	{
		ListObj.selectedIndex = detPos - 1;
	}
}
function GetSettings()
{	
	//Load initial settings for appliaction
	var refr = document.referrer;
		PlayProcess();
		var qs = new Querystring();
		mUserId = getCookieValue("FU");
		if (mUserId)
		{
			mUserLevel = qs.get("UL");
			mSessKey = qs.get("APP");
			mForceId = qs.get("UF");
			murl = qs.get("WSURL");
			mWST = qs.get("WST");
			mWST = mWST.replace(".wmpad.local","");
			ChangePass = qs.get("PWCHANGE","NCP");
			if (ChangePass == 'ACP')
			{
				alert("Your password will expire soon - please re-set!");
			}
			else if (ChangePass == 'FCP')
			{
				alert("You must change your password on this login!");
			}
			//window.document.body.onmousemove="ResetTimer3();";
			req = "<FORCE>" + mForceId + "</FORCE><SOURCE>FLSETTINGS</SOURCE><ID>" + mUserId + "</ID>";
			SOAPClient.invoke(murl, "GetXMLDocument", req, true, GotSettings,"DID");	
		}
		else
		{
			alert("Invalid session");
			{
				location.replace("../Unauthorised.html");
			}
	}
}
function GotSettings(r,g,DID)
{
	//Asynch call back for settings response
	StopProcess();
	//SFDSDF();
	if(r.constructor.toString().indexOf("function Error()") != -1)
		{	 handleError(r,g,DID);}
	else
		{
		var ForceName = g.selectSingleNode("//FLSETTINGS/CORE_DETAILS/FORCE_NAME").text;
		mSessionId = g.selectSingleNode("//FLSETTINGS/SESSION_SETTINGS/SESSION_SETTING/SESSION_ID").text;
		document.title = "Flints User: " + mUserId + "(Role:" + mUserLevel + ") - " + ForceName;
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		if (window.ActiveXObject)
			{
				settingsXML.async = false;
				settingsXML.loadXML(g.xml) //q[0].firstChild.xml);
			}
			// code for Mozilla, Firefox, Opera, etc.
			else
			{
				var parser=new DOMParser();
				settingsXML=g; //parser.parseFromString(g.xml,"text/xml");
			}
		//source.
		var sesReason = '10';
		var mItems = settingsXML.selectSingleNode("//FLSETTINGS/USER_SETTINGS/USER_SETTING/SETTING_NAME[. ='SESSION_REASON']");
		if (mItems) {sesReason = mItems.parentNode.getElementsByTagName('SETTING_VALUE')[0].text;}
		var reasonOptions = settingsXML.getElementsByTagName('SESSION_REASON');
		var optCount = reasonOptions.length;
		var i = 0;
		var sessionReasonSelect = document.getElementById("SessionReason");
		for (i=0;i<optCount;i++)
		{
			var optVal = '';
			var optText = '';
			if (window.ActiveXObject)
			{
				//IE / Firefox hack
				var cNode = reasonOptions[i].childNodes[0];
				optVal = cNode.text;
				optText = cNode.text + " - " + reasonOptions[i].childNodes[1].text;
			}
			else
			{
				optVal = reasonOptions[i].childNodes[0].textContent;
				optText = reasonOptions[i].childNodes[0].textContent + " - " + reasonOptions[i].childNodes[1].textContent;
			}
			var optEle = document.createElement("option");
			optEle.value = optVal;
			if (optEle.value == sesReason){optEle.selected=true};
			optEle.appendChild(document.createTextNode(optText));
			sessionReasonSelect.appendChild(optEle);
		}
		//var SessionIdNode = settingsXML.selectSingleNode("//FLSETTINGS/SESSION_SETTINGS/SESSION_SETTINGS/SESSION_ID")
		var userReason;
		createForceSourceTable();
		if (ChangePass == "FCP")
		{
			DisplayChangePass(false);
		}
		else
		{
			ShowElement("secAudit");
		}
		}
}
function createForceSourceTable()
{
	//Create table for force / source collection
	//dssflfsdk();
	mSearches = settingsXML.getElementsByTagName("SEARCH");
	var searchIds = new Array(mSearches.length -1);
	for (var ss=0;ss<mSearches.length;ss++)
	{
		searchIds[ss] = mSearches[ss].selectSingleNode("SEARCH_CODE").firstChild.nodeValue;
	}
	mSources = settingsXML.getElementsByTagName("SEARCH_SOURCE");
	var f = 0;
	var fsTable = document.createElement("table");
	fsTable.ID = "FSSel";
	var trEle = document.createElement("tr");
	var tr2Ele = document.createElement("tr");
	var thEle = document.createElement("th");
	var tdEle = document.createElement("td");
	AppendTextEle(trEle,"Source","th");
	AppendTextEle(tr2Ele,"Force","th");
	var cbEle = AppendCBEle(tr2Ele,"SelectAll","Toggle all")
	cbEle.bgcolor="#808080";
	cbEle.onClick = "SelFSAll(this)";
	thEle =  GetImgEle("BlankButt.gif","optButt");
	trEle.appendChild(thEle);
	var sourceIDS = new Array(mSources.length - 1);
	//Create header row
	for (f=0;f<mSources.length;f++)
	{
		sourceIDS[f] = mSources[f].getElementsByTagName("SOURCE_NAME")[0].firstChild.nodeValue;
		var mNode = mSources[f];
		var fn = mNode.getElementsByTagName("COLUMN_ICON")[0].firstChild.nodeValue
		var altText = mSources[f].getElementsByTagName("COLUMN_TOOLTIP")[0].firstChild.nodeValue;
		thEle = GetImgEle(fn,"optButt",altText);
		thEle.firstChild.width = "16";
		thEle.firstChild.height = "16";
		//Apeend column header
		trEle.appendChild(thEle);
		cbEle = AppendCBEle(tr2Ele,"FSSel" + sourceIDS[f],"Toggle " + altText);
		cbEle.bgcolor = "#808080";
		cbEle.onClick = "SelFSCol(this)";
	}
	fsTable.appendChild(trEle);
	fsTable.appendChild(tr2Ele);
	var mForces = settingsXML.getElementsByTagName("AVAILABLE_FORCE");
	//create force rows
	for (f=0;f<mForces.length;f++)
	{
		var mForce = mForces[f];
		//create row header
		var iForceId = mForce.getElementsByTagName("FORCE_CODE")[0].firstChild.nodeValue;
		trEle = document.createElement("tr");
		var sAbbr = mForce.getElementsByTagName("ABBREVIATION")[0].firstChild.nodeValue;
		var tipText = mForce.getElementsByTagName("FORCE_NAME")[0].firstChild.nodeValue;
		AppendTextEle(trEle,sAbbr,"td",tipText).ID = "Force" + iForceId;
		cbEle = AppendCBEle(trEle,"FSSel" + iForceId,"Toggle " + sAbbr)
		cbEle.bgcolor = "#808080";
		cbEle.onClick = "SelFSCol(this)";
		var s = 0;
		//find relevant rows in xml node to createcheck boxes  or unavailable images
		for (s=0;s<sourceIDS.length;s++)
		{
			var cellId = "FSSel|" + iForceId + "|" + sourceIDS[s];
			var xPath = "//FLSETTINGS/FORCE_SOURCES/FORCE_SOURCE[FORCE_ID = '" + iForceId + "' and SOURCE_NAME= '" + sourceIDS[s] + "']"
			//GGD();
			var ttipText = "";
			var forceSourceNodes = settingsXML.selectNodes(xPath);
			var AvailSearches = new Array(searchIds.length);
			for (var q=0;q<searchIds.length;q++) {AvailSearches[q] = "Unavailable";}
			if (forceSourceNodes.length > 0)
			{
				var subEle;
				var fSelected = false
				var systemsAvail = 0;
				for (var fsn = 0;fsn<forceSourceNodes.length;fsn++)
				{
					var sysStatus = forceSourceNodes[fsn].selectSingleNode("STATUS").firstChild.nodeValue;
					if (sysStatus == "Available") {systemsAvail++;}
					var sysName = forceSourceNodes[fsn].selectSingleNode("SEARCH_TYPE").firstChild.nodeValue;
					for (var q=0;q<searchIds.length;q++)
					{
						if (sysName==searchIds[q])
						{
							AvailSearches[q] = sysStatus;
						} 
					}
				}
				var bgColor = "silver";
				//dfgdfldf();
				if (systemsAvail > 0)
				{
					//if all searches are not available highlight cell and set tooltip available then 
					if(systemsAvail < searchIds.length) 
					{
						ttipText = "<table class=small><caption>Availability in searches</caption>";
						for (var q=0;q<searchIds.length;q++)
						{	
							var imgFn = "tick.gif"
							if (AvailSearches[q]!="Available")
								{
									imgFn = "cross.gif"
								}
							ttipText = ttipText + "<tr><td><img src=\"../images/" + imgFn + "\"/></td><td>" + decodeSearchType(searchIds[q]) + "</td></tr>"
						}
						bgColor="silver";
						ttipText = ttipText + "</table>";
					}
					else
					{
						ttipText = "All searches available";
					}
					tdEle = AppendCBEle(trEle,cellId,ttipText);
					tdEle.bgcolor = bgColor;
				}
				else
				{
					trEle.appendChild(GetImgEle("notAvail.gif","optCell","Source not available"));
				}
			}
			else
			{
				trEle.appendChild(GetImgEle("notAvail.gif","optCell","Source not available"));
			}
		}
		fsTable.appendChild(trEle);
	}
	var divWidth = (sourceIDS.length * 24) + 95;
	var divHeight = (mForces.length * 26) + 52;
	var divObj = document.getElementById("ForceSourceSelect");
//	alert(fsTable.outerHTML);
	divObj.style.height = divHeight + "px";
	divObj.style.width = divWidth + "px";
	if (window.ActiveXObject)
	{
		divObj.innerHTML = fsTable.outerHTML;
	}
	else
	{
	divObj.appendChild(fsTable);
	}
	SetFSSelLabel();
}
function decodeSearchType(SType)
{
	var dStype = SType;
	switch(SType)
	{
		case "AS":
			dStype = "Addresses";
			break;
		case "NS":
			dStype = "Names";
			break;
		case "VS":
			dStype = "Vehicles";
			break;
		case "PS":
			dStype = "Telephones";
			break;
		case "FS":
			dStype = "Free text";
	}
	return dStype;
}
function AppendCBEle(RowEle,ID,tipText)
{
	//Helper function to append check box elements
		var tdEle = document.createElement("td");
		tdEle.className = "optCell";
		var mCBele = document.createElement("input");
		mCBele.type="checkbox";
		mCBele.defaultChecked=true;
		tdEle.id = ID
		tdEle.appendChild(mCBele);
		RowEle.appendChild(tdEle);
		if (tipText)
		{
			tdEle.onMouseOver="ShowTip(event,'" + tipText + "')";
			tdEle.onMouseOut = "HideTip(event)";
		}	
		return(tdEle);
}
function AppendTextEle(RowEle,sText,EleType,tipText)
{
	//Helper function to create text box elements
	var thEle = document.createElement(EleType);
	thEle.className = "optCell";
	thEle.innerHTML = sText;
	if (tipText)
	{
		thEle.onMouseOver="ShowTip(event,'" + tipText + "')";
		thEle.onMouseOut = "HideTip(event)";
	}
	RowEle.appendChild(thEle);
	return(thEle);
}
function GetImgEle(fn,className,tipText)
{
	//Create an image element
	var thEle = document.createElement("td");
	thEle.className = className;
	var imgEle = document.createElement("img");
	imgEle.src = "../Images/" + fn;
	thEle.appendChild(imgEle);	
	if (tipText)
	{
		thEle.onMouseOver="ShowTip(event,'" + tipText + "')";
		thEle.onMouseOut = "HideTip(event)";
	}
	return thEle;
}
function LoadMOTD()
	//Create and post a request for a message of the day - TODO fix for user name and force
	{
		PlayProcess();
		req = "<FORCE>20</FORCE><SOURCE>MOTD</SOURCE><ID>" + mUserId  + "</ID>";
		SOAPClient.invoke(murl, "GetXMLDocument", req, true, GenCallBack_callBack,"ResDiv");				
	}
function LoadMenu()
{
	//Load menu XML and set XML variable of Flash menu movie
	var mItem = settingsXML.getElementsByTagName("MENU_ITEMS");
	var mItems = mItem[0].childNodes;
	var obj;
	//Ie Hack
	/*if(window.FlintsMenu) obj = window.document["FlintsMenu"];
	if(document.FlintsMenu) obj =  document.FlintsMenu;
	var xmlString = XMLFuncs.GetXMLStr(mItems[0]);
	obj.SetVariable("myXmlStr",xmlString);
	obj.GotoFrame(2);
	obj.Play();*/
	//Crerate a tble of menu items
	var xmlstr = XMLFuncs.GetXMLStr(mItem[0]);
	var MenuDiv = document.getElementById("FlintsMenu");
	//var TabEle = document.createElement("table");
	//TabEle.border = "1";
	for (i=0;i<mItems.length;i++)
	{
		var CellEle = document.createElement("td");
		var ImgEle = document.createElement("img");
		var MenuNode = mItems[i];
		//cdffd
		var LinkEle = document.createElement("a");
		LinkEle.href = "#";
		LinkEle.id = "MenuItem" + i;
		LinkEle.onblur = "this.blur()";
		LinkEle.attachEvent('onclick',MenuClicked); //onclick = "alert('click');GetPage(1);";
		var ImgFN =  MenuNode.childNodes[2].text + ".gif";
		ImgEle.alt = MenuNode.childNodes[3].text;
		ImgEle.src = "../images/" + ImgFN;
		ImgEle.height = 32;
		ImgEle.width = 32;
		ImgEle.border = 0;
		LinkEle.appendChild(ImgEle);
		CellEle.appendChild(LinkEle);
		MenuDiv.firstChild.firstChild.appendChild(CellEle);
	}
	return;
}
function ReloadMainAppJS()
{
	var hedobj = document.getElementsById("MainAppJS");
	hedobj.removeChild(e); 
	LoadJS("MainApp.js");
	alert("MainAppReloaded");
}
function createSVGEle(nodeName,nodeAttribs)
	//Create an SVG element
	{
	var retEle = SVGDocument.createElementNS(SVGNs,nodeName);
	var attribPairs = nodeAttribs.split(";");
	for (w=0;w<attribPairs.length;w++)
	{
		var attributeName = attribPairs[w].split("=")[0]
		var attributeVal = attribPairs[w].split("=")[1]
		retEle.setAttributeNS(null,attributeName,attributeVal);
	}
	return retEle;
}
function setAuditReason()
{
	//Create a request to set the reason for a session and post to web service
	var sesText = document.getElementById("SessionText").value;
	if (!sesText)
	{
		alert("You must enter a reason!");
		ShowElement("secAudit");
	}
	else
	{
		var sesBut = document.getElementById("SesBut");
		var sesReason = document.getElementById("SessionReason").value;
		sesBut.alt = sesText + " (Click to change)";
		var insParms = "<ReasonAudit><SESSION_ID>" + mSessionId + "</SESSION_ID><SESSION_REASON>" + AuditType + "</SESSION_REASON><SESSION_CODE>" + sesReason + "</SESSION_CODE><SESSION_TEXT>" + sesText + "</SESSION_TEXT><USER_ID>" + mUserId + "</USER_ID></ReasonAudit>";
		var req = "<FORCE>" + mForceId + "</FORCE><SOURCE>FLINTSSETSESSIONREASON</SOURCE><Parameters>" + insParms + "</Parameters>"
		//alert(req);
		SOAPClient.invoke(murl, "GetXMLDocument", req, true, SessionReasonSet,"ResDiv");
	}
}
function SessionReasonSet(r,g,DID)
{
	//Asynch response to set audit reaso - closes audit reason box and loads menus if not already loaded
	//alert(g.xml);
	document.getElementById("secAudit").style.display="none";
	document.getElementById("SecurityFrame").style.display="block";
	document.getElementById("MainApp").style.display="block";
	if (!menuLoaded)
	{
		LoadMOTD();
		menuLoaded=true;
		LoadMenu();
		StartTimer();
		//document.getElementById("SecurityFrame").src = "Security.htm";
		AuditType = "Change";
	}
	if (AuditType == "Print")
	{
		AuditType = "Change";
		self.setTimeout('ContinuePrint()',500);
	}
	CurrentSubmit = OldSubmit;
}
function getCookieValue(cookieName)
{	
	//Helper function to retrieve cooie values
	var cookieValue = document.cookie;
	var cookieStartsAt = cookieValue.indexOf(" " + cookieName + "=");
	if (cookieStartsAt == -1)
	{
		cookieStartsAt = cookieValue.indexOf(cookieName + "=");
	}
	if (cookieStartsAt == -1)
	{
		cookieValue = null;
	}
	else
	{
		cookieStartsAt = cookieValue.indexOf("=",cookieStartsAt) + 1;
		var cookieEndsAt = cookieValue.indexOf(";",cookieStartsAt);
		if (cookieEndsAt == -1)
		{
			cookieEndsAt = cookieValue.length;
		}
		cookieValue = unescape(cookieValue.substring(cookieStartsAt,cookieEndsAt));
	}
	return cookieValue;
}
function addTab(TabName,DivId)
{
	//Add a new tab page - for searching etc.
	var tabLeft = (PageCount - 1) * 75;
	var tabTop = (PageCount - 1) * -21;
	//Create a tab for the new page
	var vT = "";
	if (PageCount > 13) {vT = "v";}
	var tabDiv = document.createElement("div");
	if (PageCount == 1)
	{
		tabDiv.className = "SelPageDiv1";
	}
	else
	{
		tabDiv.className = vT + "SelPageDiv";
	}
	tabDiv.style.left = tabLeft;
	tabDiv.id = "SelTabBorder" + DivId;
	var textDiv = document.createElement("div");
	textDiv.className = vT + "tabTextDiv";
	textDiv.id = TabName;
	var imgTag = document.createElement("img");
	imgTag.src = "../images/" + TabName + ".gif"
	//imgTag.alt = TabName;
	imgTag.height = "16";
	imgTag.width = "16";
	imgTag.id = "SelTab" +  DivId;
	textDiv.appendChild(imgTag); //document.createTextNode(TabName));
	//textDiv.id = "SelTab" +  DivId;
	var closeTab = document.createElement("div");
	closeTab.className = "CloseTabDiv";
	closeTab.id = "CloseDiv" + DivId;
	closeTab.appendChild(document.createTextNode("X"));
	//Add event listeners to close tab button
	if (!window.ActiveXObject)
	{
		closeTab.addEventListener('click',CloseTab,false);
		textDiv.addEventListener('click',ShowTab,false);
	}
	else
	{
		closeTab.attachEvent('onclick',CloseTab);
		textDiv.attachEvent('onclick',ShowTab);
	}
	tabDiv.appendChild(closeTab);
	tabDiv.appendChild(textDiv);
	if (PageCount < 14)
	{
		document.body.appendChild(tabDiv);
	ShowNewTab(DivId);
	}
	else
	{
		tabDiv.className = "VertSelPageDiv";
		tabDiv.style.left = 0;
		tabDiv.style.top = ((PageCount-14) * 75);
		tabDiv.style.height = "75px";
		var tabListObj = document.getElementById("AddlTabs");
		tabListObj.appendChild(tabDiv);
		tabListObj.style.display="block"
		if (PageCount > 21)
		{
			tabListObj.className = "scrolltabs";
		}
		ShowNewTab(DivId);
		tabListObj.scrollTop = tabListObj.scrollHeight;
	}
}
function MenuClicked()
{	
	//Called from flash menu movie to open relevant page
	var g = event.srcElement.parentElement.id;
	//alert(g);
	var nodId = g.charAt(g.length - 1);
	GetPage(nodId);
}
function MenuHovered(g)
{	
	//Used by  flash menu movie to set status bar text
	var mItems = settingsXML.getElementsByTagName("MENU_ITEMS");
	var obj = document.getElementById("FlintsMenu");
	var nodId = g.charAt(g.length - 1);
	var xmlString = mItems[0].childNodes[nodId].childNodes[3].firstChild.nodeValue;
	//var MessageDiv = document.getElementById("InfoBar");
	//MessageDiv.innerHTML = xmlString;
}
function PlayProcess()
{
	//Sets cursor to hourglass and starts flash movie progress bar
	startTime = new Date();
	document.body.style.cursor = "wait";
	var ppobj;
	if (ProgEle)
	{
		ProgEle.innerHTML = prog_img_html + "<span class='small' style='font-weight:bold'>Please wait, records being obtained for display</span>";
		//ProgEleIntervalID = self.setInterval(IncrLoadText,1000);
	}
	if(window.ActiveXObject) 
	{ 
		ppobj = window.document.getElementById("ProcessBar");
		ppobj.style.display = "block";
		ppobj = window.document.getElementById("blankbit");
		ppobj.style.display = "block";
	}
	else
	{
		ppobj =  document.ProcessBar;
		ppobj.style.display = "block";
		ppobj =  document.blankbit;
		ppobj.style.display = "block";
	}
}
function StopProcess()
{
	//Set curosr back to default and stop flash progress bar
	document.body.style.cursor = "auto";
	var ppobj;
	if (ProgEle)
	{
		clearInterval(ProgEleIntervalID);
		ProgEle = null;
	}
	if(window.ActiveXObject) 
	{ 
		ppobj = window.document.getElementById("ProcessBar");
		ppobj.style.display = "none";
		ppobj = window.document.getElementById("blankbit");
		ppobj.style.display = "none";
	}
	else
	{
		ppobj =  document.ProcessBar;
		ppobj.style.display = "none";
		ppobj =  document.blankbit;
		ppobj.style.display = "none";
	}
	if (fdebugon)
	{
		var endtime = new Date();
		var timeDif = (endtime - startTime) / 1000; 
		setInfoBar(timeDif);
	}
}
function setInfoBar(_Txt)
{
	document.getElementById("infobar").innerHTML = _Txt;
}
function  IncrLoadText()
{
	try
	{
		var CurrProgText = ProgEle.childNodes[1].childNodes[1].innerHTML;
		CurrProgText = CurrProgText + ".";
		ProgEle.childNodes[1].innerHTML = CurrProgText;
	}
	catch (exp)
	{
		clearInterval(ProgEleIntervalID);
		ProgEle = null;
	}
}
function AdvOptions()
{
	//Open force / source selction list
	var _objId = "ForceSourceDiv";
	var AdvOpt = document.getElementById(_objId);
	AdvOpt.style.display = "block";
}
function ShowTip(evt,TipText)
{
	//Show tool tip div
	var ttipDiv = document.getElementById("ToolTip");
	ttipDiv.style.left = evt.clientX + 5;
	ttipDiv.style.top = evt.clientY + 5;
	ttipDiv.innerHTML = TipText;
}
function HideTip(evt)
{
	//Hide tooltip div
	var ttipDiv = document.getElementById("ToolTip");
	ttipDiv.style.left = -100;
	ttipDiv.style.top = -100;
}
function SelFSCol(tdObj)
{
	//Selct a force source column
	var colId = tdObj.id;
	colId = colId.substring(5,colId.length);
	SetFStabSel(colId,tdObj.firstChild.checked);
}
function SelFSAll(tdObj)
{
	//select all forces sources
	SetFStabSel("SSel",tdObj.firstChild.checked)
}
function SetFStabSel(LikeClause,fChecked)
{
	//Set the force / source selection clause
	var fsTable1 = document.getElementById("FSSel");
	var fsRows = fsTable1.firstChild.childNodes
	for (var r=1;r<fsRows.length;r++)
		{
			var fsCells = fsRows[r].childNodes;
			for (var c=1;c<fsCells.length;c++)
			{
				var fsCell = fsCells[c].firstChild;
				var fsID = fsCells[c].id;
				//alert(fsID);
				if (fsCell.type=="checkbox")
				{
					if (fsID.indexOf(LikeClause) > 0){fsCell.checked=fChecked;}
				}
			}
		}
	//alert(fsTable.cells.length);
	
}
function SetFSSelLabel(LikeClause,fChecked)
{
	//Set label for force / source selection
	var iChecked = 0;
	var iCheckedRow = 0;
	var iNotChecked = 0;
	var selText = "All"
	var fsTable1 = document.getElementById("FSSel").firstChild; //document.getElementById("ForceSourceSelect").firstChild; //document.getElementById("FSSel");
	var fsRows = fsTable1.childNodes;
	var selCB = "";
	var selCB1 = "";
	var splCB;
	var rowId = "";
	for (var r=2;r<fsRows.length;r++)
		{
			iCheckedRow = 0;
			rowId = fsRows[r].childNodes[1].id;
			rowId = rowId.substring(5,rowId.length);
			selCB1 = "<Force><ForceId>" + rowId + "</ForceId><Sources>"
			var fsCells = fsRows[r].childNodes;
			for (var c=2;c<fsCells.length;c++)
			{
				var fsCell = fsCells[c].firstChild;
				var fsID = fsCells[c].id;
				//alert(fsID);
				if (fsCell.type=="checkbox")
				{
					if (fsCell.checked==false)
					{iNotChecked++}
					else
					{
						iChecked++;
						iCheckedRow++;
						splCB = fsID.split("|");
						selCB1 = selCB1 + "<Source>" +  splCB[2] + "</Source>";
					}
				}
			}
			selCB1 = selCB1 + "</Sources></Force>";
			if (iCheckedRow) {selCB = selCB + selCB1;}
		}
	SourcesSelected = iChecked;
	if (iNotChecked>0) 
		{
			if (iChecked>0) 
			{
				selText = "Some";
				FSSelection = "<FSSelection>" + selCB + "</FSSelection>";
			}
			else
			{
				selText = "No";
				FSSelection = "<FSSelection>None</FSSelection>";
			}
		}
	else
		{
			selText = "All";
			FSSelection = "<FSSelection>" + selCB + "</FSSelection>";
		}
	document.getElementById("FSSelLabel").innerHTML = selText + " Forces / Sources Selected";
	var _objId = "ForceSourceDiv";
	var AdvOpt = document.getElementById(_objId);
	AdvOpt.style.display = "none";
}
function ResSetFSSel()
{
	SetFStabSel("SSel|",false);
	var fsselDom = XMLFuncs.GetXMLObj(FSSelection);
	var fsel = fsselDom.firstChild.childNodes;
	//sdfsdffd();
	for (f=0;f<fsel.length;f++)
	{
		var FSId = '';
		var force = fsel[f];
		FSId = 'FSSel|' + force.firstChild.text;
		var Sources = force.lastChild.childNodes
		for (s=0;s<Sources.length;s++)
		{
			var CBId = FSId + '|' + Sources[s].text;
			var cb = document.getElementById(CBId);
			//alert(cb.checked);
			cb.firstChild.checked = true;
		}
	}
	HideElement("ForceSourceDiv");
}
function ShowTab()
{
	//bring selected tab to focus
	var TabId = event.srcElement.id.substring(6);
	if (document.getElementById(TabId)) 
	{
		setInfoBar(event.srcElement.parentElement.id);
		ShowNewTab(TabId);
	}
}
function ShowNewTab(TabId)
{
	//Show tab
	for (var pn=1;pn<PageCount+1;pn++)
	{
		var tab = document.getElementById("PageDiv" + pn);
		tab.style.display='none';
		tab = document.getElementById("SelTabBorderPageDiv" + pn) ;
		//tab.style.height = "5px";
		if (pn<14)
		{
		tab.className = "UnSelPageDiv";
		}
		else
		{
		tab.className = "VertUnSelPageDiv";
		}
	}
	var tab = document.getElementById(TabId)
	tab.style.display='block';
	FindPageDefBut(TabId);
	tab = document.getElementById("SelTabBorder" + TabId)
	var drVis = "none";
	//TODO : Make configable
	if (tab.lastChild.id=="Free Text Search")
	{
	    drVis = "block";
	}
	document.getElementById("DateRangeLabel").style.display = drVis;
	var tn = TabId.substring(7);
	if (tn == 1)
	{
	tab.className = "SelPageDiv1";
	}
	else
	{
	if (tn < 14){tab.className = "SelPageDiv";}
	else {tab.className = "VertSelPageDiv";}
	}
}
function CloseTab()
{
	//Close a selected tab 
	//flob();
		var TabId = event.srcElement.id.substring(8);
		var pn = document.getElementById(TabId);
		pn.parentNode.removeChild(pn);
		pn = null;
		pn = document.getElementById("SelTabBorder" + TabId);
		pn.parentNode.removeChild(pn);
		pn = null;
		var currId = parseInt(TabId.substring(7));
		for (var t=currId + 1;t<PageCount+1;t++)
		{
			var tn = pn = document.getElementById("SelTabBorderPageDiv" + t);
			tn.id = "SelTabBorderPageDiv" + (t -1);
			var li = (t-2) * 75;
			var ls = li + "px";
			if (t == 14)
			{
				tn.parentNode.removeChild(tn);
				tn.style.left = ls;
				tn.style.top = 40;
				tn.style.height = 21;
				tn.className = "SelPageDiv"; 
				document.body.appendChild(tn);
				tn.lastChild.className = "tabTextDiv";
			}
			else
			{
				if (t < 14)
				{
				tn.style.left = ls;
				}
				else
				{
					var newTop = tn.style.top.replace("px","");
					newTop = newTop - 75;
					tn.style.top = newTop;
				}
			}
			if (t==2) {ls.className = "SelPageDiv1"};
			var tn = pn = document.getElementById("CloseDivPageDiv" + t);
			tn.id = "CloseDivPageDiv" + (t -1);
			var tn = pn = document.getElementById("SelTabPageDiv" + t);
			tn.id = "SelTabPageDiv" + (t -1);
			var tn = pn = document.getElementById("PageDiv" + t);
			tn.id = "PageDiv" + (t -1);
			SearchTerms[t-1] = SearchTerms[t];
			TabTips[t-1] = TabTips[t];
		}
		PageCount = PageCount - 1;
		if (PageCount > 0)
		{
			if (currId<=PageCount)
			{
			ShowNewTab("PageDiv" + currId);
			}
			else
			{
			ShowNewTab("PageDiv" + (currId-1));
			//TabTips[PageCount] = "";
			}
		}
		var tabListObj = document.getElementById("AddlTabs");
		if (PageCount < 22)
		{
			tabListObj.className = "noscrolltabs";
		}
		if (PageCount < 14)
		{
			tabListObj.style.display = "none";
		}
}
function ShowDiv(DivObj)
{
	//Used by detail page tab elements
	var SelDivId = DivObj.id;
	var ParDivObj = DivObj.parentElement.parentElement.parentElement.parentElement.parentElement;
	var DivEles = ParDivObj.getElementsByTagName("DIV");
	for (var di = 0;di<DivEles.length;di++)
	{
		var DivId = DivEles[di].id; 
		//alert(DivId);
		if (DivId.indexOf('Sel') > 0)
			{
			if (DivId == SelDivId)
				{
					DivEles[di].className = "cmpgdivsel";
				}
			else
				{
					DivEles[di].className = "cmpgdiv";
				}
			}
		else
			{
				if (DivId + "Sel" == SelDivId)
				{
					DivEles[di].style.display="block";
				}
				else
				{
					if (DivId !='')
					{DivEles[di].style.display="none";}
				}
			}
	}
}
function OpenDateRange()
{
	//Open the date range selection dialog
	document.getElementById("DateRangeSel").style.display="block";
}
function SetDateRange(obj,TextVal)
{
	//Set date range option
	DateRangeValue = obj.value;
	document.getElementById("DateRangeLabel").innerHTML = TextVal;
	document.getElementById("DateRangeSel").style.display="none";
}
function TaxGetNextLevel(SType,Force,Source,CacheID,ResId,node)
{
	//Used by search pages to ge next level of a taxonomy
	ClearDetsDiv(ResId);
	if (node.nextSibling.style.display == 'none')
	{
		// Change the image (if there is an image)
		if (node.childNodes.length > 0)
		{
			if (node.childNodes[0].nodeName == "IMG")
			{
				node.childNodes[0].src = "../images/minus.gif";
			}
		}

		node.nextSibling.style.display = 'block';
	}
	// Collapse the branch if it IS visible
	else
	{
		// Change the image (if there is an image)
		if (node.childNodes.length > 0)
		{
			if (node.childNodes[0].nodeName == "IMG")
			{
				node.childNodes[0].src = "../images/plus.gif";
			}
		}

		node.nextSibling.style.display = 'none';
	}
	cache_type = SType;
	cache_div = node.parentNode.lastChild;
	var req = "";
	if (cache_div.childNodes.length == 0) {
		var searchcrit = node.parentNode.firstChild.defaultValue;
		searchcrit = searchcrit.replace(/SEARCH>/g,'Search>');
		var sourcename = SType; //"GETCACHEDRESULTS";
		if (SType == "FREE_TEXT_SEARCH")
		{
			sourcename = "FREE_TEXT_SEARCH_RESULTS";
			req = "<FORCE>20</FORCE><SOURCE>" + sourcename +  "</SOURCE><Parameters><DateRange>" + DateRangeValue + "</DateRange><FSSelection><Force><ForceId>" + Force + "</ForceId><Sources><Source>" + Source + "</Source></Sources></Force></FSSelection><SType>" + SType + "</SType>" + searchcrit + "</Parameters>"
		}
		else
		{
		req = "<FORCE>20</FORCE><SOURCE>" + sourcename + "</SOURCE>" + searchcrit;
		}
		//var req = "<FORCE>20</FORCE><SOURCE>" + sourcename +  "</SOURCE><Parameters><DateRange>" + DateRangeValue + "</DateRange><FSSelection><Force><ForceId>" + Force + "</ForceId><Sources><Source>" + Source + "</Source></Sources></Force></FSSelection><SType>" + SType + "</SType>" + searchcrit + "</Parameters>"
	//alert(req);
		var DID = ResId;
		ProgEle = cache_div; // .innerHTML = prog_img_html + 'Loading...';
		PlayProcess();
		SOAPClient.invoke(murl, "GetXMLDocument", req, true, async_callBack,DID);
		}
}
function async_callBack(r,g,DID)
{
	//Asynch call back function
	cache_div.innerHTML = prog_img_html + "<span class='small' style='font-weight:bold'>Rendering....</span>";
	//StopProcess();
	if(r.constructor.toString().indexOf("function Error()") != -1)
	   {  handleError(r,g,DID);}
	else
		{
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var lXML = XMLFuncs.GetXMLStr(q[0].firstChild.nextSibling);
		lXML = lXML.replace(/>GETCACHEDRESULTS/,'>' + cache_type);
		lXML = lXML.replace(/>FREE_TEXT_SEARCH_RESULTS/,'>' + cache_type);
		var source = XMLFuncs.GetXMLObj(lXML);
		var resid;
		var residtext;
		if (window.ActiveXObject)
		{
			resid = source.createElement("resid");
			residtext = source.createTextNode(DID.replace('Results',''));
		}
		else
		{
			resid = document.createElement("resid");
			residtext = document.createTextNode(DID.replace('Results',''));
		}
		resid.appendChild(residtext);
		source.documentElement.appendChild(resid);
		if (cache_type == "FREE_TEXT_SEARCH")
		{
			XMLFuncs.PopDivObj(source,"../XSL/AJAXCACHERESULTS.xslt",cache_div);
		}
		else
		{
			XMLFuncs.PopDivObj(source,"../XSL/AJAXSEARCHRESULTSC.xslt",cache_div);
		}
		cache_div.style.display = "block";
		cache_div = null;
		}
}
function initializecmpg(arrText)
{
	//Used by CMPG details page
	fVals = arrText.split(',');
	SetUp1();
}
function ShowHelp(HelpFile)
{
	//Show a help file windows
	var url = './Help Files/' + HelpFile;
	window.open(url, 'myHelpWin', 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=500, height=350, left=250, top=130'); 
}
function PopulateSTermArray(SearchXML,SearchID)
{
	//Populate a search term array for free text search
	var xml = '<FTS>' + SearchXML + '</FTS>';
	var source = XMLFuncs.GetXMLObj(xml);
	var AllWords = '';
	var AnyWords = '';
	var Phrase = '';
	var ArrLength = 0;
	var LocalArray = new Array();
	if (source.firstChild.childNodes[0].childNodes.length) {
		AllWords = source.firstChild.childNodes[0].firstChild.nodeValue;
		var AllWordsArray = AllWords.split(' ');
		for (ALC=0;ALC<AllWordsArray.length;ALC++)
		{
			LocalArray[ALC] = AllWordsArray[ALC];
			ArrLength++;
		}
	}
	if (source.firstChild.childNodes[1].childNodes.length) 
	{
		Phrase = source.firstChild.childNodes[1].firstChild.nodeValue
		LocalArray[ArrLength] = Phrase;
		ArrLength++;
	};
	if (source.firstChild.childNodes[2].childNodes.length) 
	{
		AnyWords = source.firstChild.childNodes[2].firstChild.nodeValue;
		var AnyWordsArray = AnyWords.split(' ');	
		for (ALC=0;ALC<AnyWordsArray.length;ALC++)
		{
			LocalArray[ArrLength] = AnyWordsArray[ALC];
			ArrLength++;
		}
	}
	SearchTerms[SearchID] = LocalArray;
}
function ClearSearchResults(ResId)
{
	//Clear previous search results div
	HideElement("ForceSourceDiv");
	HideElement("DateRangeSel");
	var searcobj = document.getElementById(ResId + 'Results');
//	var PID = searcobj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id.substring(7);
//	TabTips[PID]="";
	searcobj.innerHTML = '';
	ClearDetsDiv(ResId);
}
function ClearDetsDiv(ResId)
{
	//Clear the detail page div
	document.getElementById(ResId + 'Details').innerHTML = '';
}
function FireCurtainUp()
{
	//Show the security curtain
	OldSubmit = CurrentSubmit;
	CurrentSubmit = document.getElementById("ReactButton");
	HideElement("MainApp");
	document.getElementById("MainApp").style.height = 0;
	ShowElement("FireCurtain");
	document.getElementById("UnLabel").innerHTML = "User Name: " + mUserId;
	document.getElementById("Password").focus();
}
function DisplayChangePass(CancelAllowed)
{
	//Display change password dialog
	HideElement("CancelChangePass")
	if (CancelAllowed)
	{
		ShowElement("CancelChangePass")
	}
	HideElement("MainApp");
	HideElement("SecurityFrame");
	ShowElement("PwdReset");
}
function CancelChangePass()
{
	//Cancel password change
	ClearPasswordBoxes();
	HideElement("PwdReset");
	ShowElement("SecurityFrame");
	ShowElement("MainApp");
}
function ClearPasswordBoxes()
{
	//Clear password boxes
	document.getElementById("ExPass").value = "";
	document.getElementById("NewPass").value = "";
	document.getElementById("NewPassConf").value = "";
}
function ChangePassFunc()
{
	//Create a chnge password request
	var ExPass = document.getElementById("ExPass").value;
	var NewPass = document.getElementById("NewPass").value;
	var NewPassConf = document.getElementById("NewPassConf").value;
	if (NewPass == '' | NewPass.length < 6)
	{
		alert("Your new password must be at least 6 characters in length");
		document.getElementById("NewPass").focus();
	}
	else
	{
		if (NewPass != NewPassConf)
		{
			alert("Confirmation does not match");
			document.getElementById("NewPass").focus();
		}
		else
		{
			if (NewPass == ExPass) 
			{
				alert("Your new password must be different to you old password");
				document.getElementById("NewPass").value = "";
				document.getElementById("NewPassConf").value = "";
				document.getElementById("NewPass").focus();
			}
			else
			{
				var PWDreq = "<ResetPassword><UserName>" + mUserId + "</UserName><OldPassword>" + ExPass + "</OldPassword><NewPassword>" + NewPass + "</NewPassword></ResetPassword>";
				SOAPClient.invoke(murl,"GetXMLDocument",PWDreq,true,ResetPassCallBack,null);
			}
		}
	}
}
function ResetPassCallBack(r,g,DID)
{
	//todo : check for validation in response xml
	var PWDResp = g.selectSingleNode("//ResetPassword/Response");
	if (PWDResp.firstChild.nodeValue == "OK")
	{
		ClearPasswordBoxes();
		HideElement("PwdReset");
		ShowElement("SecurityFrame");
		ShowElement("MainApp");
		alert("Password change succeeded");
		if (ChangePass == "FCP")
		{
			ShowElement("secAudit");
			ChangePass = "NCP";
		}
	}
	else
	{
		alert("Password change failed!");
		document.getElementById("ExPass").focus();
	}
}
function GenericGetXML(requestingDivId,requestId,resultsDivId,objectIDS)
{
	//sdfkjfkfsdj();
	PlayProcess();
	var ReqPars ="";
	var aFieldsArray = objectIDS.split(",");
	var arrLength = aFieldsArray.length;
	for (i=0;i<arrLength;i++)
	{
		var EleId = requestingDivId + '_' + aFieldsArray[i];
		var EleVal = document.getElementById(EleId).innerHTML;
		EleVal = EleVal.replace("selected","selected='true'");
		ReqPars = ReqPars + "<" + aFieldsArray + ">" + EleVal + "</" + aFieldsArray + ">"
	}
	//Need to cahnge this for other force ID values???
	var req = "<FORCE>20</FORCE><SOURCE>" + requestId + "</SOURCE><Parameters>" + ReqPars + "</Parameters>";
	//alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, true, GenCallBack_callBack,resultsDivId);	
}
function GetPrintStamp()
{
	var req = "<FORCE>20</FORCE><SOURCE>WEBPRINTSTAMP</SOURCE><ID>" + mUserId + "</ID>";
	//alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, PrintStampCallBack,null);	
}
function PrintStampCallBack(r,g,DID)
{
	///soap:Envelope/soap:Body/GetXMLDocumentResponse/GetXMLDocumentResult/RESULT_DOCUMENT/WEBPRINTSTAMP/PRINT_STAMP/STAMP/PRINTSTAMP
	PrintStamp = g.selectSingleNode("//WEBPRINTSTAMP/PRINT_STAMP/STAMP/PRINTSTAMP").text;
	PrintStamp = PrintStamp.replace("WEB",mWST);
	myWin.document.getElementById("PrintStamp").innerHTML = "<font color=\"#FF0000\" size=\"-4\">" + PrintStamp + "</font>";
	myWin.document.getElementById("PW").style.display = "none";
	myWin.document.getElementById("Record").style.display = "block";
	myWin.window.print();
	//alert(PrintStamp);
}
function LaunchPrintPage(DomId,SystemId,Force)
{
	//fdksfd;
	mDomId = DomId;
	mSystemId = SystemId;
	printForce = Force;
	AuditType = "Print";
	document.getElementById("SecTitle").innerHTML="Please complete audit reason for printing";
	document.getElementById("SecurityFrame").style.display="none";
	document.getElementById("secAudit").style.display = "block";
}
function ContinuePrint()
{
	myWin = window.open('',  'myPrintWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=700, height=600');
	var source = new ActiveXObject("Microsoft.XMLDOM");
	source.async = false;
	var lXML = document.getElementById(mDomId + 'SourceXML').innerHTML;
	//alert(lXML);
	var re = new RegExp("<SPAN class=qterm>", "g");
	lXML = lXML.replace(re,"");
	re = new RegExp("</SPAN>", "g");
	lXML = lXML.replace(re,"");
	source.loadXML(lXML); 
	var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
	stylesheet.async = false
	var SheetName = '../XSL/' + printForce + '/print/PRINT' + mSystemId + '.xslt';
	stylesheet.load(SheetName);
	var NewHTML = source.transformNode(stylesheet);
	myWin.document.write(NewHTML);				
	myWin.document.title = "FLINTS Printing";
	myWin.document.close();
	GetPrintStamp();
}
function ShowCCLog(intref)
{
	PlayProcess();
	req = "<FORCE>20</FORCE><SOURCE>COCOREP</SOURCE><ID>" + intref + "</ID>";
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, CCLogCb,null);
}
function CCLogCb(r,g,DID)
{
	StopProcess();
	if(r.constructor.toString().indexOf("function Error()") != -1)
	{
	     handleError(r,g,DID);
	}
	else
	{
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var source = XMLFuncs.GetDom(); //Get an XML Dom object
		var gs = q[0].lastChild.xml;
		source.loadXML(gs);
		var forceNode = source.selectSingleNode("//CORE_DETAILS/FORCE");
		if (forceNode)
		{
			rnName = forceNode.firstChild.nodeValue + "/" + rnName;
			//alert(rnName);
		}
	    var XSLPath = "../xsl/" + rnName + ".xslt";
		myWin = window.open('',  'myccWin', 'toolbar=yes, directories=no, location=no,top=0,left=0 status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=1000, height=600');
		var stylesheet =  XMLFuncs.GetDom();
		stylesheet.async = false
		var SheetName = '../XSL/20/cocorep.xslt';
		stylesheet.load(SheetName);
		var NewHTML = source.transformNode(stylesheet);
		//alert(NewHTML);
		myWin.document.write(NewHTML);				
		myWin.document.title = "FLINTS COCO Report";
		myWin.document.close();
		myWin.focus();
	}
}
function ShowCrimeRep(intref)
{
	PlayProcess();
	req = "<FORCE>20</FORCE><SOURCE>CRIMEREPX</SOURCE><ID>" + intref + "</ID>";
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, GetCrimeCb,null);
}
function GetCrimeCb(r,g,DID)
{
	StopProcess();
	if(r.constructor.toString().indexOf("function Error()") != -1)
	{
	     handleError(r,g,DID);
	}
	else
	{
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		var rnName = q[0].firstChild.nextSibling.nodeName;
		var source = XMLFuncs.GetDom(); //Get an XML Dom object
		var gs = q[0].lastChild.xml;
		source.loadXML(gs);
		var forceNode = source.selectSingleNode("//CORE_DETAILS/FORCE");
		if (forceNode)
		{
			rnName = forceNode.firstChild.nodeValue + "/" + rnName;
			//alert(rnName);
		}
	    var XSLPath = "../xsl/" + rnName + ".xslt";
		myWin = window.open('',  'mycrWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no,top=0,left=0, width=1000, height=600');
		var stylesheet =  XMLFuncs.GetDom();
		stylesheet.async = false
		var SheetName = '../XSL/20/crimerep.xslt';
		stylesheet.load(SheetName);
		var NewHTML = source.transformNode(stylesheet);
		//alert(NewHTML);
		myWin.document.write(NewHTML);				
		myWin.document.title = "FLINTS Crime Report";
		myWin.document.close();
		myWin.focus();
	}
}
function validateRegex(obj,RE,FailedMessage)
{
	var retVal = true;
	var reText = obj.value;
	//if (reText)
	//	{
	//	alert(obj.value.match(RE));
		if (!reText.match(RE))
			{	
				alert(FailedMessage);
				retVal = false;
				obj.style.color = "Red";
			}
	//	}
	return retVal;
}
function SetCurImg()
{	CurImg = 1;	}
function PrintCustodyImage(resid) 
{
		//sdfofsd();
		myWin = null;
		myWin = window.open('',  'myWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=600, height=600');
		var source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		var lXML = document.getElementById(resid + 'SourceXML').innerHTML;
		//alert(lXML);
		source.loadXML(lXML); //q[0].firstChild.xml);
		//alert(source.xml);
		//sdfdfssdf;
		var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
		stylesheet.async = false
		var SheetName = '../XSL/PRINT/PRINTCUSTIMG.xslt';
		stylesheet.load(SheetName);
		var newHtml = "helo"; // source.transformNode(stylesheet);
		myWin.document.title = "FLINTS Printing";
		myWin.document.write(newHtml);
		myWin.document.close();
}
function ChangeCImg(TopImg,DivId,ChangeBy)
{
	CurImg = CurImg + ChangeBy;
	if (CurImg == 0) {CurImg = 1;return;}
	if (CurImg == TopImg +1) {CurImg = TopImg;return;}
	var cimg = document.getElementById(DivId + "CustImg");
	var ImgUrl = cimg.src;
	ImgUrl = ImgUrl.substr(0,ImgUrl.lastIndexOf('=') + 1);
	ImgUrl = ImgUrl + CurImg;
	cimg.src = ImgUrl;
	document.getElementById(DivId + "CimgLab").innerText = CurImg + " of " + TopImg;
	var RImg = 'Rarr.gif';
	var LImg = 'Larr.gif';
	if (CurImg == TopImg) {RImg='RarrDis.gif';}
	if (CurImg == 1) {LImg='LarrDis.gif';}
	document.getElementById(DivId + "RBut").src = '..\\images\\' + RImg;
	document.getElementById(DivId + "LBut").src = '..\\images\\' + LImg;
}
function LoadImageFile(byteData,imgId)
{
	var LocImg = new Image();
	LocImg
}
function EndSession()
{
//if (1>2) 
//{
	if (mSessKey && menuLoaded)
	{
		eraseCookie("FU");
		eraseCookie("UL");
		eraseCookie("APP");
		eraseCookie("UF");
		eraseCookie("WST");
		var sesText = document.getElementById("SessionText").value;
		if (!sesText) {sesText = "None Given"};
		var sesReason = document.getElementById("SessionReason").value;
		var SignOutUrl = '../SignOut.aspx?SK=' + mSessKey + '&SCODE=' + sesReason + '&STEXT=' + sesText + "&SID=" + mSessionId + "&USER_ID=" + mUserId;
		window.open(SignOutUrl,  'LoWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=400, height=200');
	}
//}
}
function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}
function eraseCookie(name) {
	createCookie(name,"",-1);
}
function doHighlight(bodyText, searchTerm) 
{
	if (bodyText)
 {
  // the highlightStartTag and highlightEndTag parameters are optional
  var highlightStartTag = "<span class='qterm'>" ; //"<font style='color:blue; background-color:yellow;'>";
  var highlightEndTag = "</span class='qterm'>";
  // find all occurences of the search term in the given text,
  // and add some "highlight" tags to them (we're not using a
  // regular expression search, because we want to filter out
  // matches that occur within HTML tags and script blocks, so
  // we have to do a little extra validation)
  var newText = "";
  var i = -1;
  var lcSearchTerm = searchTerm; //.toLowerCase();
  var lcBodyText = bodyText; //.toLowerCase();
    
  while (bodyText.length > 0) {
    i = lcBodyText.indexOf(lcSearchTerm, i+1);
    if (i < 0) {
      newText += bodyText;
      bodyText = "";
    } else {
      // skip anything inside an HTML tag
      if (bodyText.lastIndexOf(">", i) >= bodyText.lastIndexOf("<", i)) {
        // skip anything inside a <script> block
        if (lcBodyText.lastIndexOf("/script>", i) >= lcBodyText.lastIndexOf("<script", i)) {
        if (lcBodyText.lastIndexOf("/th>", i) >= lcBodyText.lastIndexOf("<th", i)) {
          newText += bodyText.substring(0, i) + highlightStartTag + bodyText.substr(i, searchTerm.length) + highlightEndTag;
          bodyText = bodyText.substr(i + searchTerm.length);
          lcBodyText = bodyText.toLowerCase();
          i = -1;}
        }
      }
    }
  }
  }
  return newText;
}
function FindPageDefBut(DID)
{
//	dffsddslksdf();
	var ResDivObj = document.getElementById(DID);
	var ButObjs = ResDivObj.getElementsByTagName("input");
	for (i = 0; i < ButObjs.length;i++)
	{
		var ButObj = ButObjs[i];
		if (ButObj.type == "submit")
		{
			if (ButObj.id.indexOf("DefBut")>0)
			{
				CurrentSubmit = ButObj;
			}
		}
	}
}
function CloseGPMS()
{
	document.getElementById("GPMSWarning").style.display = "none";
	GetSettings();
}
function HideElement(_ElementName)
{
	document.getElementById(_ElementName).style.display="none";
}
function ShowElement(_ElementName)
{
	document.getElementById(_ElementName).style.display="block";
	if (_ElementName == "secAudit")
	{
		document.getElementById("SessionText").focus();
	}
}
function handleError(r,g,did)
{
	if (document.getElementById(did))
	{
		StopProcess();
		//alert("ERROR\r\n\r\n" + r.description + "\r\n\r\n[" + r.number + "]");
		var q = g.getElementsByTagName("FLINTS_ERROR");
		var source = XMLFuncs.GetDom(); //Get an XML Dom object
		source = q[0];
		var XSLPath = "../xsl/FLINTS_ERROR.xslt";
		XMLFuncs.PopDiv(source,XSLPath,did);
	}
	else
	{	
		handleNonDivError(r,g);
	}
}
function handleNonDivError(r,g)
{
	StopProcess();
	//alert("ERROR\r\n\r\n" + r.description + "\r\n\r\n[" + r.number + "]");
	var q = g.getElementsByTagName("FLINTS_ERROR");
	var source = XMLFuncs.GetDom(); //Get an XML Dom object
	source.loadXML(q[0].xml);
	myWin = window.open('',  'myErrWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=700, height=300');
	var SheetName = "../xsl/FLINTS_ERROR.xslt";
	var NewHTML = XMLFuncs.GetHTMLStr(source,SheetName);
	//alert(NewHTML);
	myWin.document.write(NewHTML);				
	myWin.document.title = "FLINTS Error Report";
	myWin.document.close();
	StopProcess();
}
function ShowXML(RESID)
{
	myWin = window.open('',  'xmlWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=400, height=600');
	var lXML = document.getElementById(RESID + 'SourceXML').innerHTML;
	//alert(lXML);
	var docele =  myWin.document;
	var ih = docele.createElement("textarea");
	ih.id = "XMLAREA";
	ih.rows = "100";
	ih.cols =  "100";
	ih.value = lXML;
	var docele =  myWin.document.body.appendChild(ih);
}
function SetDefFocus(PageId)
{
		var SDiv = document.getElementById("SearchDiv" + PageId);
		var SEles = SDiv.getElementsByTagName("input");
		for (el=0;el<SEles.length;el++)
		{
			var DF = SEles[el].getAttribute("defaultfocus");
			if (DF)
			{
				if (DF == "Y")
				{
					SEles[el].focus();
				}
			}
		}
}
function SetDebugOn()
{
	if (window.prompt("Enter Debug Password","") == "5c00b!")
	{
		if (!fdebugon)
		{
			document.getElementById("InfoBar").style.backgroundColor = "lightblue";
		}
		else
		{
			document.getElementById("InfoBar").style.backgroundColor = "silver";
		}
		fdebugon = !fdebugon;	
	}
}
function ShowAuditReason()
{
	AuditType = 'Change';
	OldSubmit = CurrentSubmit;
	CurrentSubmit = null;
	document.getElementById("SecTitle").innerHTML="Please select and change your audit reason";
	document.getElementById("SecurityFrame").style.display="none";
	document.getElementById("secAudit").style.display = "block";
	document.getElementById("MainApp").style.display="none";
}
function NoAcknowledge()
{
	if (!menuLoaded)
	{
	window.close();
	}
}
function LoadJS(url)
{ 
    //alert('Loading' + url);
	var sId = url.replace(".","");
	var e = document.createElement("script");
	var nd = new Date();
	var nds = "";
	nds = nd.getMilliseconds() + "a" + nd.getSeconds();
	url = "../Javascript/" + url + "?" + nds;
	//alert(url);
	e.src = url;
	e.type="text/javascript";
	e.id = sId;
	var hedobj = document.getElementsByTagName("head")[0];
	var doLoad = true;
	var jsFiles = hedobj.getElementsByTagName("script");
	for (j=0;j<jsFiles.length;j++)
	{
		if (jsFiles[j].src == url)
		{
			doLoad = false;
		}
	}
	if (jsFiles)
	{
		hedobj.appendChild(e); 
	}
}
function TimeDown()
	{
	CurrentTime = CurrentTime - 1;
	//alert(CurrentTime);
	}
function TimeClick()
{
	if (CurrentTime > 0)
	{
		TimeDown();
		//document.getElementById("CDSpan").innerHTML = CurrentTime;
		//SetSvg(CurrentTime);
		document.getElementById("CDDiv").style.width = 1.5 * CurrentTime;
		if (CurrentTime > 10)
		{
			document.getElementById("CDDiv").style.backgroundColor = 'blue';
		}
		else
		{
			document.getElementById("CDDiv").style.backgroundColor = 'red';
		}	
	}
	else
	{
		//SetRed();
		FireCurtainUp();
		clearInterval(tickTimerId);
	}
}
function ReloadClick()
{
	if (ReloadTime > 0)
	{
		ReloadTime = ReloadTime - 1;
	}
	else
	{
		window.location.replace( sURL );
	}
	}
function StartTimer()
{
	ResetTimer2();
	tickTimerId = setInterval("TimeClick()",60000);
}
function ResetTimer2()
{
	CurrentTime = 30;
	//alert("blah");
	document.getElementById("CDDiv").style.width = "45px";
	document.getElementById("CDDiv").style.backgroundColor = 'blue';
}
function ResetTimer3()
{	
//	alert("blah");
	CurrentTime = 30;
	document.getElementById("CDDiv").style.width = "45px";
	document.getElementById("CDDiv").style.backgroundColor = 'blue';
}

function bofloaded()
			{
				alert('loaded');
				document.getElementById("bofMapFrame").style.display = "block";
				document.getElementById("bofMapProgres").style.display = "none";
			}