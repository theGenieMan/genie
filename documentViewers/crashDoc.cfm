<!DOCTYPE html>
<!---

Module      : crashDoc.cfm

App         : GENIE

Purpose     : Delivers the Crash RTC Document

Requires    : 

Author      : Nick Blackham

Date        : 12/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crash_document.xsl"  variable="xmlCrashDocument">

<cfset xmltoparse="#Application.str_Crash_Path#\#ListGetAt(crashDate,3,"/")#\#ListGetAt(crashDate,2,"/")#\#ListGetAt(crashDate,1,"/")#\#Replace(crashRef,"/","_","ALL")#.xml">

<html>
<head>
	<title>GENIE - CRASH Document <cfoutput>#UCase(crashRef)#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">			
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>
</head>

<body>
<cfoutput>

<cfset headerTitle="COLLISION REPORT - "&crashRef>	
<cfinclude template="/header.cfm">

		<div class="tabs">
		   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
			      printDiv="crashDocument" printTitle="GENIE Collision Report - #crashRef#" printUser="#session.user.getFullName()#">
		</div>
<br><br>

<cfif fileExists(xmltoparse)>

<cfset s_Doc=XmlTransform(xmlParse(xmltoParse),xmlCrashDocument)>

<cfset s_NomStart="<nom_ref>">
<cfset s_NomEnd="</nom_ref>">
<!--- find all the <nom_ref></nom_ref> tags and inser genie link --->
<cfset i_DocPos=0>
<cfset i=1>
<cfloop condition="i IS 1">
 <cfset i_DocPos=FindNoCase(s_NomStart,s_Doc,i_DocPos)>
 <cfif i_DocPos GT 0>
  <!--- find the end of the nom ref tag and extract the value --->
  <cfset i_NomEnd=Find(s_NomEnd,s_Doc,i_DocPos)>
  <cfset s_NomRefTag=Mid(s_Doc,i_DocPos,((i_NomEnd-i_DocPos)+Len(s_NomEnd)))>
  <cfset s_NomRef=REReplace(s_NomRefTag,"<[^>]*>","","ALL")>  
  <cfset s_NomRefLink="<b><a href='#s_NomRef#' class='genieNominal'>#s_NomRef#</a></b>">
  <cfset s_Doc=Replace(s_Doc,s_NomRefTag,s_NomRefLink,"ALL")>
  <cfset i_DocPos=i_DocPos+1>
 <cfelse>
  <!--- no more nom ref tags --->
  <cfbreak> 
 </cfif>
</cfloop>

<cfset s_VrmStart="<vrm>">
<cfset s_VrmEnd="</vrm>">
<!--- find all the <nom_ref></nom_ref> tags and inser genie link --->
<cfset i_DocPos=0>
<cfset i=1>
<cfloop condition="i IS 1">
 <cfset i_DocPos=FindNoCase(s_VrmStart,s_Doc,i_DocPos)>
 <cfif i_DocPos GT 0>
  <!--- find the end of the nom ref tag and extract the value --->
  <cfset i_VrmEnd=Find(s_VrmEnd,s_Doc,i_DocPos)>
  <cfset s_VrmRefTag=Mid(s_Doc,i_DocPos,((i_VrmEnd-i_DocPos)+Len(s_VrmEnd)))>
  <cfset s_VrmRef=REReplace(s_VrmRefTag,"<[^>]*>","","ALL")>
  <cfset s_VrmRefLink="../../vehicle_enquiry.cfm?&frm_TxtSpecialVRM=#s_VrmRef#&fromNominal=YES&frm_HidAction=SEARCH&#session.URLToken###The_Results">
  <cfset s_VrmRefLink="<b><a href='#s_VrmRef#' class='genieVehicleSearchLink'>#s_VrmRef#</a></b>">
  <cfset s_Doc=Replace(s_Doc,s_VrmRefTag,s_VrmRefLink,"ALL")>
  <cfset i_DocPos=i_DocPos+1>
 <cfelse>
  <!--- no more nom ref tags --->
  <cfbreak> 
 </cfif>
</cfloop>

<cfset s_OISStart="<incident_number>">
<cfset s_OISEnd="</incident_number>">

<cfset i_DocPos=0>
<cfset i_DocPos=FindNoCase(s_OISStart,s_Doc,i_DocPos)>
 <cfif i_DocPos GT 0>
  <!--- find the end of the nom ref tag and extract the value --->
  <cfset i_OISEnd=Find(s_OISEnd,s_Doc,i_DocPos)>
  <cfset s_OISTag=Mid(s_Doc,i_DocPos,((i_OISEnd-i_DocPos)+Len(s_OISEnd)))>
  <cfset s_OISRef=REReplace(s_OISTag,"<[^>]*>","","ALL")>
  <cfif Len(s_OISRef) IS 11>
     <cfset s_OISRef=Insert(" ",s_OISRef,5)>
  </cfif>  
  <cfset s_OISRefLink="<b><a href="""&s_OISRef&""" class=""genieOISLink"">#s_OISRef#</a></b>">
  <cfset s_Doc=Replace(s_Doc,s_OISTag,s_OISRefLink,"ALL")>
 </cfif>

 <div id="crashDocument">
  <div>
  	#s_Doc#
  </div>    
 </div>

<cfelse>

 <h3 align="center">No information is currently available for RTC #crashRef#</h3>

</cfif>

</cfoutput>

</body>
</html>