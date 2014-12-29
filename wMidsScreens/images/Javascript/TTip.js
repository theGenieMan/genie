var SVGDocument = null;
      var SVGRoot = null;
      var SVGViewBox = null;
      var svgns = 'http://www.w3.org/2000/svg';
      var xlinkns = 'http://www.w3.org/1999/xlink';
      var toolTip = null;
      var TrueCoords = null;
      var tipBox = null;
      var tipText = null;
      var tipTitle = null;
      var tipDesc = null;
      var tipImg = null;
      var lastElement = null;
      var titleText = '';
      var titleDesc = '';
	  var currPos = 0;
	  var bPopup = false;
	  var menuElement = null;
	  var currMenuElement = null;
      function Init(evt)
      {
         SVGDocument = evt.target.ownerDocument;
         SVGRoot = SVGDocument.documentElement;
         TrueCoords = SVGRoot.createSVGPoint();
         toolTip = SVGDocument.getElementById('ToolTip');
         tipBox = SVGDocument.getElementById('tipbox');
         tipText = SVGDocument.getElementById('tipText');
         tipTitle = SVGDocument.getElementById('tipTitle');
         tipDesc = SVGDocument.getElementById('tipDesc');
         tipImg = SVGDocument.getElementById('tipimg');
         menuElement = SVGDocument.getElementById('PopupMenu');
         //window.status = (TrueCoords);
         //create event for object
         SVGRoot.addEventListener('mousemove', ShowTooltip, false);
         SVGRoot.addEventListener('mouseout', HideTooltip, false);
         if (menuElement) 
         {
			SVGRoot.addEventListener('mousedown', PopupMenu, false);
		 }
      };
      function GetTrueCoords(evt)
      {
         // find the current zoom level and pan setting, and adjust the reported
         //    mouse position accordingly
         var newScale = SVGRoot.currentScale;
         var translation = SVGRoot.currentTranslate;
         TrueCoords.x = (evt.clientX - translation.x)/newScale;
         TrueCoords.y = (evt.clientY - translation.y)/newScale;
      };
      function HideTooltip( evt )
      {
         toolTip.setAttributeNS(null, 'visibility', 'hidden');
         tipImg.setAttributeNS(null, 'visibility', 'hidden');
      };
      function ShowTooltip( evt )
      {
		if (bPopup){return;}
//	return;
//	   alert('S');'
	            GetTrueCoords( evt );
         var tipScale = 1/SVGRoot.currentScale;
         var textWidth = 0;
         var tspanWidth = 0;
         var boxHeight = 20;
         tipBox.setAttributeNS(null, 'transform', 'scale(' + tipScale + ',' + tipScale + ')' );
         tipText.setAttributeNS(null, 'transform', 'scale(' + tipScale + ',' + tipScale + ')' );
         tipImg.setAttributeNS(null,'visibility','hidden');
         var tipHt = 10;
         var titleValue = '';
         var descValue = '';
         var targetElement = evt.target;
         if (menuElement) {menuElement.setAttributeNS(null, 'visibility', 'hidden')};
         //alert(targetElement);
         if ( lastElement != targetElement )
         {
            var targetTitle = targetElement.getElementsByTagName('title').item(0);
            if ( targetTitle )
            {
               // if there is a 'title' element, use its contents for the tooltip title
               titleValue = targetTitle.firstChild.nodeValue;
            }
            var targetDesc = targetElement.getElementsByTagName('desc').item(0);
            if ( targetDesc )
            {
               // if there is a 'desc' element, use its contents for the tooltip desc
               descValue = targetDesc.firstChild.nodeValue;
               if ( '' == titleValue )
               {
                  // if there is no 'title' element, use the contents of the 'desc' element for the tooltip title instead
                  titleValue = descValue;
                  descValue = '';
               }
            }
            // if there is still no 'title' element, use the contents of the 'id' attribute for the tooltip title
            if ( '' == titleValue )
            {
               titleValue = targetElement.getAttributeNS(null, 'id');
            }
            // selectively assign the tooltip title and desc the proper values,
            //   and hide those which don't have text values
            //
            var titleDisplay = 'none';
            if ( '' != titleValue )
            {
               tipTitle.firstChild.nodeValue = titleValue;
               titleDisplay = 'inline';
            }
            tipTitle.setAttributeNS(null, 'display', titleDisplay );
            var descDisplay = 'none';
            if ( '' != descValue )
            {
			  // alert(descValue);
			   if (descValue.substr(0,4) != 'cimg')
			   {
               tipDesc.firstChild.nodeValue = descValue;
               descDisplay = 'inline';
               }
               else
               {
               var boxObj = tipText.getBBox(); 
               var imgX = (boxObj.width / 2) - 40;
               var ImgName = "../helpers/getcustimage.aspx?ID=" + descValue.substring(5) + "&IMGNO=1&FORCE=20"
               tipImg.setAttributeNS(xlinkns,"xlink:href",ImgName);
               tipImg.setAttributeNS(null,"visibility","visible");
               tipImg.setAttributeNS(null,"x",imgX);
               tipHt = 110;
               }
            }
            tipDesc.setAttributeNS(null, 'display', descDisplay );
         }
         // if there are tooltip contents to be displayed, adjust the size and position of the box
         if ( '' != titleValue )
         {
            var xPos = TrueCoords.x + (10 * tipScale);
            var yPos = TrueCoords.y + (10 * tipScale);
            //alert(xPos + ':' + yPos);
            //return rectangle around text as SVGRect object
            var outline = tipText.getBBox();
            tipBox.setAttributeNS(null, 'width', Number(outline.width) + 10);
            tipBox.setAttributeNS(null, 'height', Number(outline.height) + tipHt);
            if (xPos > 300)
            {
				xPos = xPos - (Number(outline.width) + 30);
            }
            if (yPos > 300)
            {
				yPos = yPos - (Number(outline.height) + tipHt + 20);
            }
            // update position
            toolTip.setAttributeNS(null, 'transform', 'translate(' + xPos + ',' + yPos + ')');
            toolTip.setAttributeNS(null, 'visibility', 'visible');
         }
         //alert(tipImg.getAttributeNS(xlinkns, "href"));
      };
	function ShowNodes(UpDown,Count)
	{ 
	 var sn = "ShowNodes2(" + UpDown + "," + Count + ")";
	 if (currPos == 0)
	 {
	   if (UpDown == 1){animcollapse();setTimeout(sn,1500);}
	          }
       else
	 {
	   if (UpDown == 1)
		{
			if ((currPos + 1) * 20 < Count) {animcollapse();setTimeout(sn,1500);}
            }
         else {animcollapse();setTimeout(sn,1500);}
       }
      }
      function ShowNodes2(UpDown,Count)
       {
	// alert(UpDown + ':' + Count);
      // alert(currPos);
       currPos = currPos + UpDown;
       //alert(currPos);
	 var i ;
	 var bot = (currPos * 20) + 1;
	 var top = Count + 1;
	 var obj;
	 for (i=1;i<top;i++)
       {
		obj = SVGDocument.getElementById('FlintsNode' + i);
		obj.setAttributeNS(null, 'visibility', 'hidden');
       }
	 top = bot + 20; 
	 if (top > Count) {top = Count + 1};
       for (i=bot;i<top;i++)
       {
		obj = SVGDocument.getElementById('FlintsNode' + i);
		obj.setAttributeNS(null, 'visibility', 'visible');
		//obj.setAttributeNS(null, 'filter', 'url(#MyFilter)');
       }
	 var dnOpac = 1;
	 if (currPos == 0) {dnOpac = .4;}
	 var upOpac = .4;
	if ((currPos + 1) * 20 < Count) {upOpac = 1;}
	 obj = SVGDocument.getElementById('UpNodes');
	 obj.setAttributeNS(null,'opacity',upOpac);
       obj = SVGDocument.getElementById('DnNodes');
	 obj.setAttributeNS(null,'opacity',dnOpac);
		obj = SVGDocument.getElementById('NodePosLab');
		obj.firstChild.nodeValue = bot + ' to ' + (top - 1) + ' of ' + Count;
		animexpand();
		}
	function PopupMenu(evt)
	{	
		GetTrueCoords( evt );
         var tipScale = 1/SVGRoot.currentScale;
         var textWidth = 0;
         var tspanWidth = 0;
         var boxHeight = 20;
         var targetElement = evt.target;
         bPopup = false;
		if (evt.button == 2)
		{
			evt.preventDefault();
			var PopMenu = SVGDocument.getElementById('PopMenu');
			var MenuItems = PopMenu.getElementsByTagName('tspan');
			for (i=0;i<6;i++)
			{
				MenuItems.item(i).setAttributeNS(null,'display','none');
				MenuItems.item(i).firstChild.nodeValue='';
			}
			var PopRect = SVGDocument.getElementById('PopRect');
			var nt = targetElement.getElementsByTagName('nodetype').item(0);
			var MenItems = 0;
			if (nt) {
				//node type found]
				bPopup = true;
				if (nt.firstChild.nodeValue == 'IMS') {
					MenuItems.item(0).firstChild.nodeValue = 'Center';
					}
				else
				{
				MenuItems.item(1).firstChild.nodeValue = 'Center';
				if (nt.firstChild.nodeValue == 'nominal') {
					MenuItems.item(2).firstChild.nodeValue = 'Name Search';
					}
				}
			}
			else
			{
				MenuItems.item(0).firstChild.nodeValue = 'First Level Network';
			}
			var lt = targetElement.getElementsByTagName('linetype').item(0);
			if (lt) {bPopup = true};
			var gt = targetElement.getElementsByTagName('graphicstype').item(0);
			if (gt) {bPopup = true};
			if (bPopup) 
			{
				MenItems = 0;
				for (i=0;i<6;i++)
				{	
				if (MenuItems.item(i).firstChild.nodeValue!='')
				{
				MenuItems.item(i).setAttributeNS(null,'display','inline');
				MenItems ++;
				}
				currMenuElement = targetElement;
			}
			HideTooltip( evt );
			var xPos = (TrueCoords.x + (10 * tipScale)) - 90;
			var yPos = (TrueCoords.y + (10 * tipScale)) - 50;
			//return rectangle around text as SVGRect object
			var outline = PopMenu.getBBox();
			//PopRect.setAttributeNS(null, 'width', Number(outline.width) + 10);
			PopRect.setAttributeNS(null, 'height', (MenItems * 15) + 10); //Number(outline.height) + 20);
			
			// update position
			menuElement.setAttributeNS(null, 'transform', 'translate(' + xPos + ',' + yPos + ')');
			menuElement.setAttributeNS(null, 'visibility', 'visible');
		}
		}
		else
		{
			bPopup = false;
			menuElement.setAttributeNS(null, 'visibility', 'hidden');
			var eleId = targetElement.getAttributeNS(null,'id');
			if (eleId.substr(0,5) == 'PMenu')
				{
					PopupMenuClick(targetElement.firstChild.nodeValue);
				}
		}
		return false;
	}
	function PopupMenuClick(MnuTxt)
	{
		var nt = currMenuElement.getElementsByTagName('nodetype').item(0);
		var MenItems = 0;
		if (nt) {
			//node type found]
			var nr = currMenuElement.getElementsByTagName('noderef').item(0);
			switch (MnuTxt)
				{
				case 'Center':
					//alert ("Centering: " + nr.firstChild.nodeValue);
					animcollapse();
					var tobj = SVGDocument.getElementById('centernodetext1');
					var cobj = currMenuElement.getElementsByTagName('title').item(0);
					var ctext = cobj.firstChild.nodeValue;
					tobj.firstChild.nodeValue = ctext.substr(0,ctext.indexOf(',',0));
					tobj = SVGDocument.getElementById('centernodetext2');
					tobj.firstChild.nodeValue = "Loading....";
					tobj = SVGDocument.getElementById('centernodetext3');
					tobj.firstChild.nodeValue = "....";
					var fobj = SVGDocument.getElementById('centericon');
					fobj.setAttributeNS(null,'visibility','hidden');
					fobj = SVGDocument.getElementById('FLINTSLOGO');
					fobj.setAttributeNS(null,'visibility','visible');
					fobj = SVGDocument.getElementById('StausBar');
					fobj.setAttributeNS(null,'visibility','hidden');
					var resid2 = "PageDiv2";
					rnName = "FLINTSGRAPHICSMAIN";
					var	requestData	= '<DETREQUEST><SEARCH_RESULTS><FORCE>20</FORCE><SOURCE>CRIME</SOURCE><SYSID>' + nr.firstChild.nodeValue + '</SYSID><TEXT1>SPITTLE</TEXT1><TEXT2>BRETT</TEXT2><TEXT3>30/05/1984</TEXT3></SEARCH_RESULTS><CORE_DETAILS><FORCE>20</FORCE><SYSTEM>NAMESEARCH</SYSTEM><SYSTEM_NAME></SYSTEM_NAME><FORCE_NAME>West Midlands Police </FORCE_NAME><REFERENCE></REFERENCE></CORE_DETAILS></DETREQUEST>';
					req = "<FORCE>20</FORCE><SOURCE>FLINTSGRAPHICS</SOURCE><Parameters>" + requestData + "</Parameters>"
					//alert(req)
					svgHTML = '<embed name=\"' + resid2 + 'SVG\" src=\"../svg/blank.svg\" pluginspage=\"http://www.adobe.com/svg/viewer/install/\" width=\"1000\" height=\"605\" type=\"image/svg+xml\"/><div style=\"display:none\">';
					SOAPClient.invoke(murl, "GetXMLDocument", req, true, GvCallBack_callBack,resid2);
					break;
				case 'Name Search':
					alert ("N S " + nr.firstChild.nodeValue);
					break;
				case  'More Details':
					alert("M D " + nr.firstChild.nodeValue);
					break;
				}
			}
	}
	function animcollapse()
	{
		animele = SVGDocument.getElementById("Anim3");
		animele.beginElement();      
		animele = SVGDocument.getElementById("Anim4");
		animele.beginElement();      
	}
	function animexpand()
	{
		animele = SVGDocument.getElementById("Anim1");
		animele.beginElement();      
		animele = SVGDocument.getElementById("Anim2");
		animele.beginElement();      
	}
	

