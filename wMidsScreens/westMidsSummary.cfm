<!---

Module      : westMidsSummary.cfm

App         : General Enquiry

Purpose     : Displays the Summary Records from a west mids search. Is opened in a CF Window by the enquiry screens

Requires    : 

Author      : Nick Blackham

Date        : 05/11/2009

Revisions   : 

--->

<cfif isDefined("closeWindow")>
 <cfset StructDelete(session,"westMidsSummaryList")>
 <cfoutput>
 <script>
  closeWestMidsSummary('#closeRef#');
 </script>
 </cfoutput>
 <cfabort>
</cfif>

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

<!---
<cfdump var="#summaryDetails#">
--->

<cfoutput>

<!---
<html>
<head>
	<title>West Midlands Region Summary Information</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm" media="screen">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
--->
    <cfif isDefined("url.checkBoxLink")>
     <script>
       document.getElementById('#url.checkBoxLink#').checked=true;
     </script>
    </cfif>
<!----    
</head>

<body>
--->
    
<div style="font-size:120%; padding:5px">   
<b>#nominalName# - #url.appRef#</b><br> 
<b>#ArrayLen(summaryDetails)# matches found for #url.sysId# on #url.appRef#</b>

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
    
  <!--- write the data to a temp file in case of session swap between servers --->
  <cfset sessionFile=session.user.getUserId()&".txt">
  
  <cfif x is 1>
  	  <cfset fileAction="write">
  <cfelse>
  	  <cfset fileAction="append">
  </cfif>
      
  <cffile action="#fileAction#" file="#application.westMidsTempDir##sessionFile#" output="#summaryDetails[x].xmlChildren[1].app_ref.xmlText#|#summaryDetails[x].xmlChildren[1].sys_ref.xmlText#|#summaryDetails[x].xmlChildren[1].force_ref.xmlText#|PERSON">
  
</cfloop>
</div>

<!---
</body>
</html>
--->

</cfoutput>

