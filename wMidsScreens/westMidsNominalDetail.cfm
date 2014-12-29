<!---

Module      : westMidsDetails.cfm

App         : GENIE

Purpose     : Displays the westMids Nominal Detail request results

Requires    : 

Author      : Nick Blackham

Date        : 14/07/2009

Revisions   : 

--->

<!--- check if the session exists, if it doesn't read from the temp file again --->

<cfif not isDefined('session.westMidsSummaryList')>
  <cffile action="read" file="#application.westMidsTempDir##session.user.getUserId()#.txt" variable="summaryListFile">
  
  <cfset x=1>
  <cfset session.westMidsSummaryList=ArrayNew(1)>
  <cfloop list="#summaryListFile#" index="summaryLine" delimiters="#chr(10)#">
  	  <cfset summaryLine=Trim(StripCR(summaryLine))>
	  <cfset session.westMidsSummaryList[x]=StructNew()>
      <cfset session.westMidsSummaryList[x].appRef=ListGetAt(summaryLine,1,"|")>
   	  <cfset session.westMidsSummaryList[x].sysid=ListGetAt(summaryLine,2,"|")>
      <cfset session.westMidsSummaryList[x].forceId=ListGetAt(summaryLine,3,"|")>
      <cfset session.westMidsSummaryList[x].detailType=ListGetAt(summaryLine,4,"|")>
	  <cfset x=x+1>	
  </cfloop>     
</cfif>

<cfoutput>

<cfset searchTerms=StructNew()>
<cfset searchTerms.appRef=url.AppRef>
<cfset searchTerms.sysId=url.sysId>
<cfset searchTerms.forceId=url.forceId>
<cfset displayWarning=false>

<cfswitch expression="#url.detailType#">
    <cfcase value="PERSON">
      <cfset westMidsDetail=application.genieService.doWestMidsPersonDetail(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>         
    </cfcase>
    <cfcase value="ADDRESS">
      <cfset westMidsDetail=application.genieService.doWestMidsAddressDetail(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>             
    </cfcase>
    <cfcase value="VEHICLE">
      <cfset westMidsDetail=application.genieService.doWestMidsVehicleDetail(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>             
    </cfcase>    
    <cfcase value="TELEPHONE">
      <cfset westMidsDetail=application.genieService.doWestMidsTelephoneDetail(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>             
    </cfcase>      
</cfswitch>

<cfif westMidsDetail.searchOk>
    <!--- search produced a valid result, read in the relevant xslt file to display the detail request --->
    
    <cfset xsltFile=GetDirectoryFromPath(GetCurrentTemplatePath())&"\xslt\"&searchTerms.forceId&"\"&searchTerms.appRef&".xslt">
	<cffile action="read" file="#xsltFile#" variable="xslt">    
    
    <!--- check if we have a custody, if so check the xml to see if we have a image available --->
    <cfif searchTerms.appRef IS "CUST">
	      <cfset isImage=XmlSearch(westMidsDetail.resultxml,"//IMAGE_EXISTS")>
	      <cfif ArrayLen(isImage) GT 0>
	      <cfif isImage[1].xmlText IS "TRUE">
	        <cfset photo=Application.genieService.getRispPhoto(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>
	        <cfset thisCustPhoto='<img src="#photo.getPhoto_url()#" />'>
	      </cfif>
	      </cfif>
      
	    <cfif isDefined("thisCustPhoto")>
	     <cfset xslt=ReplaceNoCase(xslt,"***ImageInfoHere***",thisCustPhoto)>
	    <cfelse>
	     <cfset xslt=ReplaceNoCase(xslt,"***ImageInfoHere***","No Photograph Taken")> 
	    </cfif>      
      
    </cfif>

	<!--- check if we have an IMS log and that the warning if flagged has not been shown --->
    <cfif not isDefined("warningShown")>
     <cfif searchTerms.appRef IS "IMS">
      <cfif Find("TRUE",searchTerms.SYSID) GT 0>
          <cfset imsRequest=Duplicate(searchTerms)>
          <cfset imsRequest.sysId=sourceRef>
          <cfset imsRequestAppRef='IMSFLAG'>
          <cfset infoMark=Application.genieService.getIMSInfo(searchTerms=imsRequest,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>          
		  <cfif ArrayLen(infoMark) GT 0>  	    
	          <cfif StructKeyExists(infoMark[1],"message")>
	            <cfif Len(infoMark[1].message) GT 0>
	                <cfset displayWarning=true>
	            </cfif>
	          </cfif>
	      </cfif>
      </cfif>
     </cfif>
    </cfif>
    
    <!--- transform request into html --->
	<cfset displayHtml=XmlTransform(XmlParse(westMidsDetail.resultXml),xslt)>
<cfelse>    
    <!--- search did not produce a result, so display an error message --->
    <cfset displayHtml="<h2 align='center'>"&westMidsDetail.errorText&"</h2>">
    <cfif westMidsDetail.statusCode IS "408 Request Time-out">
      <cfset displayHtml=displayHtml&"<p align='center'>Your request has timed out, West Mids region requests may not currently be available.</p>">
    </cfif>
</cfif>

<html>
<head>
	<title>West Mids Region Detail. Force #searchTerms.forceId#, Application #searchTerms.appRef#, System Id #searchTerms.sysId#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="css/flintsweb.css" media="screen">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
				
  <!---
  <script>
     if (window.opener.document.getElementById('#url.appref##url.sysid##url.forceid#')){
     window.opener.document.getElementById('#url.appref##url.sysid##url.forceid#').checked=true;
     }              
  </script>    
  --->
  
  <script type="text/javascript">

	 function showWarnings(appRef,sysId,forceId,title){
         w = 500;
	     h = 300;	 
	     xPos = 200;
	     yPos = 200;
  	     config = {x:xPos,y:yPos,height:h,width:w,modal:false,closable:true,draggable:false,resizable:false,initshow:true};

         window.location.hash='top';

         if (document.getElementById('warningsBox_title'))
         {
          var win = ColdFusion.Window.getWindowObject('warningsBox');	
          ColdFusion.navigate('westMidsWarnings.cfm?#session.URLToken#&appRef='+appRef+'&sysId='+sysId+'&forceId='+forceId+'&title='+title,'warningsBox');
          win.setTitle(title);
          ColdFusion.Window.show('warningsBox');
         }
         else
         {
         ColdFusion.Window.create('warningsBox', title , 'westMidsWarnings.cfm?#session.URLToken#&appRef='+appRef+'&sysId='+sysId+'&forceId='+forceId+'&title='+title ,config);
         }

       }

   	 function closeWarnings(ref){
   	 	window.location.hash=ref;
   	    ColdFusion.Window.hide('warningsBox');  
   	 }  
   	 

     
   </script>
  
  <cfinclude template="westMidsJavascript.cfm">

</head>

<body>
<a name="top"></a>

<div class="tabs">
<table width="100%">
<tr>
 <td width="1%">
  <input type="button" name="frm_WestMidsDetailClose" value="Close Window (X)" onClick="window.open('','_self',''); window.close(); opener.focus();" AccessKey="X">  
 </td>
 <td>
  <input type="button" name="frm_WestMidsDetailPrint" value="Print (P)" onClick="window.print()" AccessKey="P">  
 </td>

</tr>
</table>
</div>

<h3>
  West Mids Region Detail. Force #searchTerms.forceId#, Application #searchTerms.appRef#, System Id #searchTerms.sysId#<br>
  <span style="font-size:60%">#DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:mm:ss")#, by #session.user.getFullName()#</span>
</h3>

<cfif displayWarning>

 <h3 align="center">Please note this subject is flagged</h3>
 
 <cfloop from="1" to="#arrayLen(infoMark)#" index="i">
 <table width="50%" align="center" border="1">
  <tr>
   <td width="33%"><b>Start Date</b></td>
   <td width="33%"><b>End Date</b></td>
   <td width="33%"><b>Creator</b></td>        
  </tr>
  <tr>
   <td>#infoMark[i].dateStart#</td> 
   <td>#infoMark[i].dateEnd#</td> 
   <td>#infoMark[i].creator#</td>       
  </tr>
  <tr>
   <td colspan="3">
    <br>
    #infoMark[i].message#
   </td>  
  </tr>
 </table>
 <h3 align="center"><a href="summaryNo=#summaryNo#&appRef=#searchTerms.appref#&sysid=#searchTerms.sysId#&forceId=#searchTerms.forceId#&detailType=PERSON&sourceRef=#sourceRef#&warningShown=YES&#session.urlToken#" class="wMidsDetail" inList="Y">Click Here To Continue</a></h3>
 </cfloop>

<cfelse>
<div class="tabs">
<table width="50%" align="center">
 <tr>
  <td width="25%" align="right" style="font-size:120%; font-weight:bold;">
   <cfif summaryNo is not 1>
    <cfset prevSumm=SummaryNo-1>
    <a href="summaryNo=#prevSumm#&appRef=#session.westMidsSummaryList[prevSumm].appRef#&sysid=#session.westMidsSummaryList[prevSumm].sysId#&forceId=#session.westMidsSummaryList[prevSumm].forceId#&detailType=PERSON&warningShown=YES&#Session.URLToken#" class="wMidsDetail" inList="Y">Previous</a>
   </cfif>  
  </td>
  <td width="50%" align="center" style="font-size:120%; font-weight:bold;">
    Record #summaryNo# of #ArrayLen(session.westMidsSummaryList)#  
  </td>
  <td width="25%" align="left" style="font-size:120%; font-weight:bold;">
   <cfif summaryNo is not ArrayLen(session.westMidsSummaryList)>
    <cfset nextSumm=summaryNo+1>
    <a href="summaryNo=#nextSumm#&appRef=#session.westMidsSummaryList[nextSumm].appRef#&sysid=#session.westMidsSummaryList[nextSumm].sysId#&forceId=#session.westMidsSummaryList[nextSumm].forceId#&detailType=PERSON&warningShown=YES&#Session.URLToken#" class="wMidsDetail" inList="Y">Next</a> 
   </cfif>  
  </td>
 </tr>
</table>
<Br>
</div>

 #displayHTML#
 
</cfif>

</body>
</html>
</cfoutput>