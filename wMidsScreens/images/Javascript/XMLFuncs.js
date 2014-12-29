function XMLFuncs() {}
XMLFuncs.PopDiv = function(xmlSource,XSLdocPath,DivToPop)
	{	
		if (fdebugon)
		{
			AddDebOutput(xmlSource.xml,'IN');
		}
		var theHTML = XMLFuncs.GetHTMLStr(xmlSource,XSLdocPath);
		StopProcess();
		document.getElementById(DivToPop).innerHTML = theHTML;
		theHTML = null;
	}
XMLFuncs.GetHTMLStr = function(xmlSource,XSLdocPath)
	{
	if(document.implementation && document.implementation.createDocument)
		{
			// *** Mozilla
			var xsltProcessor = new XSLTProcessor();
			// *** load the XSL file
			var xslStylesheet =  XMLFuncs.GetDom();
			xslStylesheet.async = false;
			xslStylesheet.load(XSLdocPath);
			var s = new XMLSerializer();
			//alert(s.serializeToString(xslStylesheet));
			//alert(s.serializeToString(xmlSource));
			xsltProcessor.importStylesheet(xslStylesheet);
			// *** transform
			var resultDocument = xsltProcessor.transformToFragment(xmlSource,XMLFuncs.GetDom());
			var xmlStr = s.serializeToString(resultDocument); 
			//alert(xmlStr);
			return xmlStr;
		}
		else  if(window.ActiveXObject)
		{
			// *** IE
			// *** Load XML
			// *** Load XSL<BR>
			var xml = new ActiveXObject("Microsoft.XMLDOM");
			xml.async = false;
			xml.loadXML(xmlSource.xml);
			//alert(xmlSource.xml);
			xsl = new ActiveXObject("Microsoft.XMLDOM");
			xsl.async = false;
			xsl.load(XSLdocPath);
			//Transform
			try
			{
				return xml.transformNode(xsl);
			}
			catch (exp)
			{
				alert("An error occured retrieving you document!(" + XSLdocPath + ")");
				alert(exp.message);
				StopProcess();
			}
		}
		else
		{
			//*** Browser unknown
			alert("Browser unknown");
		}
}
XMLFuncs.GetDom = function()
{
	if (window.ActiveXObject)
	{
		//IE
		 return new ActiveXObject("Microsoft.XMLDOM");
	}
	else
	{
		//Firefox
		return document.implementation.createDocument("", "", null);
	}
}
XMLFuncs.GetXMLObj = function(xmlString)
{
	var xmlObj = XMLFuncs.GetDom();
	if (window.ActiveXObject)
	{
		xmlObj.async = false;
		xmlObj.loadXML(xmlString);
	}
	else
	{
		var xmlParser = new DOMParser
		xmlObj = xmlParser.parseFromString(xmlString,"text/xml");
	}
	return xmlObj;
}
XMLFuncs.GetXMLStr = function(XMLNodeIn)
{
	var xmlSting = "";
	if (window.ActiveXObject)
	{	xmlString = XMLNodeIn.xml;}
	else
	{	//sdasdl;
		var s = new XMLSerializer();
		xmlString = s.serializeToString(XMLNodeIn);
	}
	return xmlString;
}
XMLFuncs.PopDivObj = function(xmlSource,XSLdocPath,DivToPop)
	{
	if (fdebugon)
	{
		AddDebOutput(xmlSource.xml,'IN');
	}
	if(document.implementation && document.implementation.createDocument)
		{
			// *** Mozilla
			var xsltProcessor = new XSLTProcessor();
			// *** load the XSL file
			var xslStylesheet =  XMLFuncs.GetDom();
			xslStylesheet.async = false;
			xslStylesheet.load(XSLdocPath);
			var s = new XMLSerializer();
			//alert(s.serializeToString(xslStylesheet));
			//alert(s.serializeToString(xmlSource));
			xsltProcessor.importStylesheet(xslStylesheet);
			// *** transform
			var resultDocument = xsltProcessor.transformToFragment(xmlSource,XMLFuncs.GetDom());
			var xmlStr = s.serializeToString(resultDocument); 
			//alert(xmlStr);
			StopProcess;
			DivToPop.innerHTML = xmlStr; //appendChild(resultDocument);
		}
		else  if(window.ActiveXObject)
		{
			// *** IE
			// *** Load XML
			// *** Load XSL<BR>
			var xml = new ActiveXObject("Microsoft.XMLDOM");
			xml.async = false;
			xml.loadXML(xmlSource.xml);
			xsl = new ActiveXObject("Microsoft.XMLDOM");
			xsl.async = false;
			xsl.load(XSLdocPath);
			//Transform
			var theHTML = xml.transformNode(xsl);
			StopProcess();
			DivToPop.innerHTML=theHTML;
			theHTML = null;
		}
		else
		{
			//*** Browser unknown
			alert("Browser unknown");
		}
}