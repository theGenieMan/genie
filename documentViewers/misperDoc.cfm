<!DOCTYPE html>
<!---

Module      : intelDoc.cfm

App         : GENIE

Purpose     : Delivers the Intelligence Document

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\misper_header.xsl"  variable="xml_misper_header">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\misper_details.xsl"  variable="xml_misper_details">

<cfquery name="qry_MisperDocDetails" datasource="#Application.WarehouseDSN#">
SELECT CASE_NO, TO_CHAR(MISSING_START,'DD') AS REC_DAY, TO_CHAR(MISSING_START,'MM') AS REC_MON, TO_CHAR(MISSING_START,'YYYY') AS REC_YEAR
FROM browser_owner.COMP_CASES
WHERE CASE_NO=<cfqueryparam value="#caseNo#" cfsqltype="cf_sql_vharchar">
</cfquery>

<cfset xmltoparse="#Application.str_Misper_XML_Path#\#qry_MisperDocDetails.REC_YEAR#\#qry_MisperDocDetails.REC_MON#\#qry_MisperDocDetails.REC_DAY#\#Replace(qry_MisperDocDetails.CASE_NO,"/","_","ALL")#.xml">

<html>
<head>
<title>GENIE Missing Persons Record - <cfoutput>#caseNo#</cfoutput></title>
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

<a name="top"></a>
<cfset headerTitle="MISSING PERSONS REPORT - "&caseNo>	
<cfinclude template="/header.cfm">

<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="misperDocument" printTitle="GENIE Missing Persons Record- #caseNo#" printUser="#session.user.getFullName()#">
</div>

<h3 align="center" style="clear:both">
    MISSING PERSONS REPORT<br><br>
    ADDITIONAL INFORMATION ABOUT THIS CASE CAN BE FOUND ON THE COMPACT SYSTEM
</h3>

<cfif FileExists(xmltoparse)>
     
     <cfset xmldoc=XmlParse("#xmltoparse#")>
     
     <cfset s_Doc=XmlTransform(xmldoc, xml_misper_details)>
     
   <div id="misperDocument">   
   	<div>
     #s_Doc#
    </div>  
   </div>  
<cfelse>  
     <h3 align="center">No Document Available For This Missing Persons Record '#caseNo#'</h3>
</cfif>  

</cfoutput>

</body>
</html>