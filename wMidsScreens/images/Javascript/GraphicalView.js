var embedsLoaded = 0;
var SVGSource;
var SVGId = "";
var rnName = "";
var svgHTML = "";
function triggerSVGLoading(evt) {
    embedsLoaded++;
	loadSVG(SVGSource,SVGId);
	SVGSOurce = null;
    Init(evt);
}

function loadSVG(imageXML, embedID) {
    var svg = getDOMFromXML(imageXML);
    domtodom(svg, embedID);
}

function getDOMFromXML(XML) {
    DOM = new ActiveXObject('Msxml2.FreeThreadedDOMDocument');
    DOM.async = false;
    DOM.validateOnParse = false;
    DOM.loadXML(XML);
    if (DOM.parseError.errorCode != 0) {
        alert('Error parsing XML:\n' + explainParseError(DOM.parseError));
        return;
    }
    return DOM;
}

function GetNominalGraphic(obj)
{
	//PlayProcess();
	//alert(obj.lastChild.innerHTML);
	var requestData = obj.parentNode.lastChild.innerHTML;
		var source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		source.loadXML(requestData); //q[0].firstChild.xml);
		var residn = source.firstChild;
		var resid = residn.getAttribute("resid");
		var resid2 = resid + "SubDetails";
		ProgEle = document.getElementById(resid2); 
		PlayProcess();
		//jsdfkjsd();
		rnName = "FLINTSGRAPHICS";
    // load XSLT stylesheet document
	req = "<FORCE>20</FORCE><SOURCE>FLINTSGRAPHICS</SOURCE><Parameters>" + requestData + "</Parameters>"
	//alert(req);
	//sdfdfssdfdfs();
	svgHTML = '<div><embed name=\"' + resid2 + 'SVG\" src=\"../svg/blank.svg\" pluginspage=\"http://www.adobe.com/svg/viewer/install/\" width=\"600\" height=\"525\" type=\"image/svg+xml\"/><input type=\"button\" onclick=\"LoadGraphics(this)\" value=\"Load into graphical view page"/><div style=\"display:none\">' ;
	SOAPClient.invoke(murl, "GetXMLDocument", req, true, GvCallBack_callBack,resid2);
}
function GvCallBack_callBack(r,g,DID)
{
	//alert(g.xml);
	//ioseio();
	StopProcess();
	if(r.constructor.toString().indexOf("function Error()") != -1)
	    alert("ERROR\r\n\r\n" + r.description + "\r\n\r\n[" + r.number + "]");
	else
		var q = g.getElementsByTagName("RESULT_DOCUMENT");
		//alert(g.xml);
		var source = new ActiveXObject("Microsoft.XMLDOM");
		source.async = false;
		source.loadXML(q[0].firstChild.nextSibling.xml);
		var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
		stylesheet.async = false;
	//	alert(rnName);
		stylesheet.load("../XSL/" + rnName + ".xslt");
	//	alert(DID);
	//SDFFSDF();
    // transform the source using the XSLT stylesheet
		SVGSource = source.transformNode(stylesheet);
		//alert(SVGSource);
		document.getElementById(DID).innerHTML = svgHTML + source.xml + '</div></div>';
		SVGId = DID + 'SVG';
//		var MessageDiv = document.getElementById("InfoBar");
//		MessageDiv.innerHTML = rnName + ".xslt";
}
function LoadGraphics(obj)
{
	var source = new ActiveXObject("Microsoft.XMLDOM");
	source.async = false;
	source.loadXML(obj.parentNode.lastChild.innerHTML);
	alert(obj.parentNode.lastChild.innerHTML);
	var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
	stylesheet.async = false;
//	alert(rnName);
	stylesheet.load("../XSL/FLINTSGRAPHICSMAIN.xslt");
	SVGSource = source.transformNode(stylesheet);
	PageCount++;
	var DivId = "PageDiv" + PageCount;
	var pageDiv = document.createElement("div");
	pageDiv.id = DivId;
	pageDiv.className = "FlintsPage";
	document.body.appendChild(pageDiv);
	addTab("Graphical view",DivId);
	svgHTML = '<embed name=\"' + DivId + 'SVG\" src=\"../svg/blank.svg\" pluginspage=\"http://www.adobe.com/svg/viewer/install/\" width=\"1000\" height=\"605\" type=\"image/svg+xml\"/>';
   	document.getElementById(DivId).innerHTML = svgHTML;
   	SVGId = DivId + 'SVG';
}