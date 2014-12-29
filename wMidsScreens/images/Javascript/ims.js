// Javascript for IMS functionalit
// v1.0 
// Mark COmpton
// Intitial create :  16/11/2007
function LoadLog(obj,detid,maxPos)
{
	var logRef = obj.options[obj.selectedIndex].value; 
	detPos = obj.selectedIndex + 1;
	var obj = document.getElementById(detid + 'DetsLab');
	obj.innerHTML = detPos + " of " + maxPos;
	SetUPDNImg(detid,maxPos);
	LoadDet(detPos,detid);
}
function LoadIMSMemo(ref,stype,memotype,resid)
{
	var DetsId = resid + "DetsDiv";
	var MemoId = resid + "MemoDiv";
	ProgEle = document.getElementById(MemoId);
	document.getElementById(MemoId).style.display = "block";
	document.getElementById(DetsId).style.display = "none";
	PlayProcess();
	printForce = "20";
    req = "<FORCE>20</FORCE><SOURCE>GETIMSMEMO</SOURCE><RESID>" + resid +  "</RESID><Parameters><REFERENCE>" + ref +  "</REFERENCE><MEMOTYPE>" + memotype + "</MEMOTYPE><STYPE>" + stype + "</STYPE><USER_ID>" + mUserId +"</USER_ID></Parameters>";
    //alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, false, GenCallBack_callBack,MemoId);
	//var _detid = document.getElementById(resid).firstChild.innerHTML;
}
function CloseMemo(resid)
{
	var DetsId = resid + "DetsDiv";
	var MemoId = resid + "MemoDiv";
	document.getElementById(MemoId).style.display = "none";
	document.getElementById(DetsId).style.display = "block";
}
function GetImsLinkedItems(obj)
{
	var requestData = obj.parentNode.lastChild.innerHTML;
		var source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		source.loadXML(requestData); //q[0].firstChild.xml);
		var residn = source.firstChild;
		var resid = residn.getAttribute("resid");
		var resid2 = resid + "SubDetails";
		var RefNo = source.selectSingleNode("/DETREQUEST/SEARCH_RESULTS/SYSID").firstChild.nodeValue;
		var SType = source.selectSingleNode("/DETREQUEST/SEARCH_RESULTS/CHILD_REQUEST/PARAMETERS/SEARCH/NSTAXONOMY").firstChild.nodeValue;
		//SType = substr(SType,0,1);
		ProgEle = document.getElementById(resid2); 
		PlayProcess();
		rnName = "FLINTSGRAPHICS";
		
    // load XSLT stylesheet document
	req = "<FORCE>20</FORCE><SOURCE>IMS_LINKED_ITEMS</SOURCE><Parameters><Request><FORCE>20</FORCE><SOURCE>IMS</SOURCE><SYSID>" + RefNo + "</SYSID><STYPE>" + SType + "</STYPE><USER_ID>" + mUserId + "</USER_ID></Request></Parameters>";
	SOAPClient.invoke(murl, "GetXMLDocument", req, true, GenCallBack_callBack,resid2);
}
function SetLtype(resid,ltype)
{
	document.getElementById(resid + "LTYPE").innerText = ltype + " ";
}