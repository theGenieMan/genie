/*****************************************************************************\

 Javascript "SOAP Client" library
 
 @version: 2.0 2006.03.28
 @author: Matteo Casati - http://www.guru4.net/

\*****************************************************************************/
//import "TTip.js";
var browserVer = "";
var fdebugon = false;
function SOAPClientParameters()
{
	var _pl = new Array();
	this.add = function(name, value) 
	{
		_pl[name] = value; 
		return this; 
	}
	this.toXml = function()
	{
		var xml = "";
		for(var p in _pl)
			xml += "<m:" + p + ">" + SOAPClientParameters._serialize(_pl[p]) + "</m:" + p + ">";
			alert(xml);
		return xml;	
	}
}
SOAPClientParameters._serialize = function(o)
{
    var s = "";
    switch(typeof(o))
    {
        case "string":
            s += o.replace(/&/g, "&amp;").replace(/</g, "<").replace(/>/g, ">"); break;
        case "number":
        case "boolean":
            s += o.toString(); break;
        case "object":
            // Date
            if(o.constructor.toString().indexOf("function Date()") > -1)
            {
        
                var year = o.getFullYear().toString();
                var month = (o.getMonth() + 1).toString(); month = (month.length == 1) ? "0" + month : month;
                var date = o.getDate().toString(); date = (date.length == 1) ? "0" + date : date;
                var hours = o.getHours().toString(); hours = (hours.length == 1) ? "0" + hours : hours;
                var minutes = o.getMinutes().toString(); minutes = (minutes.length == 1) ? "0" + minutes : minutes;
                var seconds = o.getSeconds().toString(); seconds = (seconds.length == 1) ? "0" + seconds : seconds;
                var milliseconds = o.getMilliseconds().toString();
                var tzminutes = Math.abs(o.getTimezoneOffset());
                var tzhours = 0;
                while(tzminutes >= 60)
                {
                    tzhours++;
                    tzminutes -= 60;
                }
                tzminutes = (tzminutes.toString().length == 1) ? "0" + tzminutes.toString() : tzminutes.toString();
                tzhours = (tzhours.toString().length == 1) ? "0" + tzhours.toString() : tzhours.toString();
                var timezone = ((o.getTimezoneOffset() < 0) ? "+" : "-") + tzhours + ":" + tzminutes;
                s += year + "-" + month + "-" + date + "T" + hours + ":" + minutes + ":" + seconds + "." + milliseconds + timezone;
            }
            // Array
            else if(o.constructor.toString().indexOf("function Array()") > -1)
            {
                for(var p in o)
                {
                    if(!isNaN(p))   // linear array
                    {
                        (/function\s+(\w*)\s*\(/ig).exec(o[p].constructor.toString());
                        var type = RegExp.$1;
                        switch(type)
                        {
                            case "":
                                type = typeof(o[p]);
                            case "String":
                                type = "string"; break;
                            case "Number":
                                type = "int"; break;
                            case "Boolean":
                                type = "bool"; break;
                            case "Date":
                                type = "DateTime"; break;
                        }
                        s += "<m:" + type + ">" + SOAPClientParameters._serialize(o[p]) + "</m:" + type + ">"
                    }
                    else    // associative array
                        s += "<m:" + p + ">" + SOAPClientParameters._serialize(o[p]) + "</m:" + p + ">"
                }
            }
            // Object or custom function
            else
                for(var p in o)
                    s += "<m:" + p + ">" + SOAPClientParameters._serialize(o[p]) + "</m:" + p + ">";
            break;
        default:
            throw new Error(500, "SOAPClientParameters: type '" + typeof(o) + "' is not supported");
    }
    return s;
}

function SOAPClient() {}

SOAPClient.invoke = function(url, method, request, async, callback,DivID)
{
	if (fdebugon)
	{
		AddDebOutput(request,'OUT');
	}
	if(async)
		SOAPClient._loadWsdl(url, method, request, async, callback,DivID);
	else
		return SOAPClient._loadWsdl(url, method, request, async, callback,DivID);
}

// private: wsdl cache
SOAPClient_cacheWsdl = new Array();

// private: invoke async
SOAPClient._loadWsdl = function(url, method, request, async, callback,DivID)
{
	// load from cache?
	var wsdl = SOAPClient_cacheWsdl[url];
	if(wsdl + "" != "" && wsdl + "" != "undefined")
		return SOAPClient._sendSoapRequest(url, method, request, async, callback, wsdl,DivID);
	// get wsdl
	var xmlHttp = SOAPClient._getXmlHttp();
	xmlHttp.open("GET", url + "?wsdl", async);
	if(async) 
	{
		xmlHttp.onreadystatechange = function() 
		{
			if(xmlHttp.readyState == 4)
				SOAPClient._onLoadWsdl(url, method, request, async, callback, xmlHttp,DivID);
		}
	}
	xmlHttp.send(null);
	if (!async)
		return SOAPClient._onLoadWsdl(url, method, request, async, callback, xmlHttp,DivID);
}
SOAPClient._onLoadWsdl = function(url, method, request, async, callback, req,DivID)
{
	var wsdl = req.responseXML;
	SOAPClient_cacheWsdl[url] = wsdl;	// save a copy in cache
	return SOAPClient._sendSoapRequest(url, method, request, async, callback, wsdl,DivID);
}
SOAPClient._sendSoapRequest = function(url, method, request, async, callback, wsdl,DivID)
{
	// get namespace
	var ns = (wsdl.documentElement.attributes["targetNamespace"] + "" == "undefined") ? wsdl.documentElement.attributes.getNamedItem("targetNamespace").nodeValue : wsdl.documentElement.attributes["targetNamespace"].value;
	// build SOAP request
	var sr = GetSoapMessage(request,mUserId,mSessKey);
	var xmlHttp = SOAPClient._getXmlHttp();
	xmlHttp.open("POST", url, async);
	var soapaction = ((ns.lastIndexOf("/") != ns.length - 1) ? ns + "/" : ns) + method;
	xmlHttp.setRequestHeader("SOAPAction", soapaction);
	xmlHttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
	if(async) 
	{
		xmlHttp.onreadystatechange = function() 
		{
			if(xmlHttp.readyState == 4)
				SOAPClient._onSendSoapRequest(method, async, callback, wsdl, xmlHttp,DivID);
		}
	}
	try
	{
		xmlHttp.send(sr);
	}
	catch (exp)
	{
		async = false;
	}
	if (!async)
		return SOAPClient._onSendSoapRequest(method, async, callback, wsdl, xmlHttp,DivID);
}

SOAPClient._onSendSoapRequest = function(method, async, callback, wsdl, req,DivID) 
{
	var o = null;
	var nd = SOAPClient._getElementsByTagName(req.responseXML, method + "Result");
	if(nd.length == 0)
	{
		if(req.responseXML.getElementsByTagName("faultcode").length > 0)
		{
//			alert("In soap block");
			//KLDVLDFSL();
			var FaultString = req.responseXML.getElementsByTagName("faultstring")[0].childNodes[0].nodeValue;
			var SigErr  = FaultString.indexOf("InvalidUserSignature");
			if (SigErr > -1)
			{
				alert("Your session has timed out");
				document.getElementById("MainApp").style.display = "none";
				document.getElementById("FireCurtain").style.display = "block";
				document.getElementById("UnLabel").innerHTML = "User Name: " + mUserId;
				StopProcess();
				return null;
			}
			else
			{
				if(async || callback)
					o = new Error(500, req.responseXML.getElementsByTagName("faultstring")[0].childNodes[0].nodeValue);
				else
					throw new Error(500, req.responseXML.getElementsByTagName("faultstring")[0].childNodes[0].nodeValue);			
			}
		}
	}
	else
		o = SOAPClient._soapresult2object(nd[0], wsdl);
	if(callback)
		callback(o, req.responseXML,DivID);
	if(!async)
		return o;
}

// private: utils
SOAPClient._getElementsByTagName = function(document, tagName)
{
	try
	{
		// trying to get node omitting any namespaces (latest versions of MSXML.XMLDocument)
		return document.selectNodes(".//*[local-name()=\""+ tagName +"\"]");
	}
	catch (ex) {}
	// old XML parser support
	return document.getElementsByTagName(tagName);
}

SOAPClient._soapresult2object = function(node, wsdl)
{
	return SOAPClient._node2object(node, wsdl);
}
SOAPClient._node2object = function(node, wsdl)
{
	// null node
	if(node == null)
		return null;
	// text node
	if(node.nodeType == 3 || node.nodeType == 4)
		return SOAPClient._extractValue(node, wsdl);
	// leaf node
	if (node.childNodes.length == 1 && (node.childNodes[0].nodeType == 3 || node.childNodes[0].nodeType == 4))
		return SOAPClient._node2object(node.childNodes[0], wsdl);
	var isarray = SOAPClient._getTypeFromWsdl(node.nodeName, wsdl).toLowerCase().indexOf("arrayof") != -1;
	// object node
	if(!isarray)
	{
		var obj = null;
		if(node.hasChildNodes())
			obj = new Object();
		for(var i = 0; i < node.childNodes.length; i++)
		{
			var p = SOAPClient._node2object(node.childNodes[i], wsdl);
			obj[node.childNodes[i].nodeName] = p;
		}
		return obj;
	}
	// list node
	else
	{
		// create node ref
		var l = new Array();
		for(var i = 0; i < node.childNodes.length; i++)
			l[l.length] = SOAPClient._node2object(node.childNodes[i], wsdl);
		return l;
	}
	return null;
}
SOAPClient._extractValue = function(node, wsdl)
{
	var value = node.nodeValue;
	switch(SOAPClient._getTypeFromWsdl(node.parentNode.nodeName, wsdl).toLowerCase())
	{
		default:
		case "s:string":			
			return (value != null) ? value + "" : "";
		case "s:boolean":
			return value+"" == "true";
		case "s:int":
		case "s:long":
			return (value != null) ? parseInt(value + "", 10) : 0;
		case "s:double":
			return (value != null) ? parseFloat(value + "") : 0;
		case "s:datetime":
			if(value == null)
				return null;
			else
			{
				value = value + "";
				value = value.substring(0, value.lastIndexOf("."));
				value = value.replace(/T/gi," ");
				value = value.replace(/-/gi,"/");
				var d = new Date();
				d.setTime(Date.parse(value));										
				return d;				
			}
	}
}
SOAPClient._getTypeFromWsdl = function(elementname, wsdl)
{
	var ell = wsdl.getElementsByTagName("s:element");	// IE
	if(ell.length == 0)
		ell = wsdl.getElementsByTagName("element");	// MOZ
	for(var i = 0; i < ell.length; i++)
	{
		if(ell[i].attributes["name"] + "" == "undefined")	// IE
		{
			if(ell[i].attributes.getNamedItem("name") != null && ell[i].attributes.getNamedItem("name").nodeValue == elementname && ell[i].attributes.getNamedItem("type") != null) 
				return ell[i].attributes.getNamedItem("type").nodeValue;
		}	
		else // MOZ
		{
			if(ell[i].attributes["name"] != null && ell[i].attributes["name"].value == elementname && ell[i].attributes["type"] != null)
				return ell[i].attributes["type"].value;
		}
	}
	return "";
}
// private: xmlhttp factory
SOAPClient._getXmlHttp = function() 
{
	try
	{
		if(window.XMLHttpRequest) 
		{
			var req = new XMLHttpRequest();
			// some versions of Moz do not support the readyState property and the onreadystate event so we patch it!
			if(req.readyState == null) 
			{
				req.readyState = 1;
				req.addEventListener("load", 
									function() 
									{
										req.readyState = 4;
										if(typeof req.onreadystatechange == "function")
											req.onreadystatechange();
									},
									false);
			}
			return req;
		}
		if(window.ActiveXObject) 
			return new ActiveXObject(SOAPClient._getXmlHttpProgID());
	}
	catch (ex) {}
	throw new Error("Your browser does not support XmlHttp objects");
}
SOAPClient._getXmlHttpProgID = function()
{
	if(SOAPClient._getXmlHttpProgID.progid)
		return SOAPClient._getXmlHttpProgID.progid;
	var progids = ["Msxml2.XMLHTTP.5.0", "Msxml2.XMLHTTP.4.0", "MSXML2.XMLHTTP.3.0", "MSXML2.XMLHTTP", "Microsoft.XMLHTTP"];
	var o;
	for(var i = 0; i < progids.length; i++)
	{
		try
		{
			o = new ActiveXObject(progids[i]);
			return SOAPClient._getXmlHttpProgID.progid = progids[i];
		}
		catch (ex) {};
	}
	throw new Error("Could not find an installed XML parser");
}
function AddDebOutput(request,direct)
{
	var DebWin = window.open('',"FlintsDebWin", 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=yes, width=400, height=700, left=1100, top=0');
	var docele = DebWin.document;
	var ih = docele.createElement("textarea");
	ih.rows = "5";
	ih.cols =  "40";
	if (direct =="IN")
	{
		ih.style.backgroundColor="lightblue";
	}
	else
	{
		ih.style.backgroundColor="lightgreen";
	}
	ih.value = request;
	var docele =  DebWin.document.body.appendChild(ih);
}