function GetNominalMap(obj)
{
	PlayProcess();
	//alert(obj.lastChild.innerHTML);
	var requestData = obj.parentNode.lastChild.innerHTML;
		var source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		source.loadXML(requestData); //q[0].firstChild.xml);
		var residn = source.firstChild;
		var resid = residn.getAttribute("resid");
		var resid2 = resid + "SubDetails";
		document.getElementById(resid2).innerHTML = prog_img_html + "Loading....";
		//jsdfkjsd();
    // load XSLT stylesheet document
	    req = "<FORCE>20</FORCE><SOURCE>FLINTSNOMINALMAP</SOURCE><Parameters>" + requestData + "</Parameters>"
	//alert(req);
	SOAPClient.invoke(murl, "GetXMLDocument", req, true, GenCallBack_callBack,resid2);
	//var _detid = document.getElementById(resid).firstChild.innerHTML;
	//alert(_detid);
	//LoadDet(1,_detid);
	//detPos = 1;
}