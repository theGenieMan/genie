<!---

Module      : westMidsWarnings.cfm

App         : General Enquiry

Purpose     : Displays the West Mids Warnings from IMS Logs. Is opened in a CF Window by the enquiry screens

Requires    : 

Author      : Nick Blackham

Date        : 05/11/2009

Revisions   : 

--->

<cfif isDefined("closeWindow")>
 <cfoutput>
 <script>
  closeWarnings('#closeRef#');
 </script>
 </cfoutput>
 <cfabort>
</cfif>

<!---
<cfdump var="#url#">
--->

<cfset searchTerms=StructNew()>
<cfset searchTerms.appRef=url.AppRef>
<cfset searchTerms.sysId=url.sysId>
<cfset searchTerms.forceId=url.forceId>


<cfset infoMark=Application.genieService.getIMSInfo(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>

<!---
<cfdump var="#infoMark#">
--->

<html>
 <head>
  	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/genie_assets/risp/css/flintsweb.css" media="screen">
 </head>
 
 <body>

	<cfoutput>
        
	 <cfform action="#SCRIPT_NAME#?#session.URLToken#" method="post" style="margin:0px;">
	  <input type="hidden" name="closeRef" value="#ListGetAt(url.sysId,2,":")#">
	  <input type="hidden" name="closeWindow" value="YES">
	  <input type="submit" name="frmClose" value="Close (X)">
	 </cfform>        
        
     <div align="center" style="font-weight:bold; font-size:120%">#url.title#</div>
     <br>
	 <cfloop from="1" to="#arrayLen(infoMark)#" index="i">
	 <table width="90%" align="center" border="1">
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
	 </cfloop>
	</cfoutput>

 </body>
</html>

<!---
<cfset searchTerms=StructNew()>
<cfset searchTerms.appRef=url.AppRef>
<cfset searchTerms.sysId=url.sysId>
<cfset searchTerms.forceId=url.forceId>

<cfif isDefined("url.NominalRef")>
 <cfset sourceRef=nominalRef>
<cfelse>
 <cfset sourceRef="">
</cfif>

<cfswitch expression="#url.summaryType#">
    <cfcase value="PERSON">
      <cfset westMidsSummary=application.genieService.doWestMidsPersonSummary(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>         
    </cfcase>
    <cfcase value="ADDRESS">
      <cfset westMidsSummary=application.genieService.doWestMidsAddressSummary(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>             
    </cfcase>
    <cfcase value="VEHICLE">
      <cfset westMidsSummary=application.genieService.doWestMidsVehicleSummary(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>             
    </cfcase>    
    <cfcase value="TELEPHONE">
      <cfset westMidsSummary=application.genieService.doWestMidsTelephoneSummary(searchTerms=searchTerms,userId=session.user.getUserId(),terminalId=Session.hostname,SessionId=Session.thisUUID)>             
    </cfcase>      
</cfswitch>

<cfset summaryDetails=XmlSearch(westMidsSummary.resultXml,'//record')>

<cfoutput>
    
<html>
<head>
	<title>West Midlands Region Summary Information</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm" media="screen">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
    <cfif isDefined("url.checkBoxLink")>
     <script>
       document.getElementById('#url.checkBoxLink#').checked=true;
     </script>
    </cfif>
</head>

<body>

<div class="header">
 GENIE West Midlands Region Summary
</div>


<div class="tabs">
<table width="100%">
<tr>
 <cfform action="#SCRIPT_NAME#?#session.URLToken#" method="post" style="margin:0px;">
  <input type="hidden" name="closeRef" value="#Replace(url.sysId,":","","ALL")##url.appRef#">
  <input type="hidden" name="closeWindow" value="YES">
  <input type="submit" name="frmClose" value="Close West Mids Summary (X)">
  <!---
  <input type="button" name="frm_WestMidsSummary" value="Close West Mids Summary (X)" onClick="closeWestMidsSummary('#Replace(url.sysId,":","","ALL")##url.appRef#')" AccessKey="X">  
  --->
 </cfform>
 </td>
</tr>
</table>
</div>

<h3 align="center">
 #titleInfo#
</h3>    
    
<div style="font-size:120%; padding:5px">    
<b>#ArrayLen(summaryDetails)# matches found for #titleInfo#(#url.sysId#) on #url.appRef#</b>

<Br><Br>
<cfset session.westMidsSummaryList=ArrayNew(1)>
<cfloop from="1" to="#ArrayLen(summaryDetails)#" index="x">
  
  <div style="padding-bottom:5px;">
  #x#.  
  <a href="nominal_details/code/westMidsNominalDetail.cfm?summaryNo=#x#&appRef=#summaryDetails[x].xmlChildren[1].app_ref.xmlText#&sysid=#summaryDetails[x].xmlChildren[1].sys_ref.xmlText#&forceId=#summaryDetails[x].xmlChildren[1].force_ref.xmlText#&detailType=PERSON&sourceRef=#sourceRef#&#Session.URLToken#" target="_blank">
  #summaryDetails[x].xmlChildren[2].xmlText#  
  </a>
  </div>
  
  <cfset session.westMidsSummaryList[x]=StructNew()>
  <cfset session.westMidsSummaryList[x].appRef=summaryDetails[x].xmlChildren[1].app_ref.xmlText>
  <cfset session.westMidsSummaryList[x].sysid=summaryDetails[x].xmlChildren[1].sys_ref.xmlText>
  <cfset session.westMidsSummaryList[x].forceId=summaryDetails[x].xmlChildren[1].force_ref.xmlText>
  <cfset session.westMidsSummaryList[x].detailType="PERSON">  
  
</cfloop>
</div>

</body>
</html>

</cfoutput> --->

