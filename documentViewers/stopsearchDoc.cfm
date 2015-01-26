<!DOCTYPE html>
<!---

Module      : stopsearchDoc.cfm

App         : GENIE

Purpose     : Delivers the Stop Search Document

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\stopsearch.xsl"  variable="xml_stopsearch">

<cfquery name="qry_SSDetails" datasource="#Application.WarehouseDSN#">
SELECT  TO_CHAR(DATE_CREATED,'YYYY') AS SS_YEAR,TO_CHAR(DATE_CREATED,'MM') AS SS_MON,TO_CHAR(DATE_CREATED,'DD') AS SS_DAY
FROM    browser_owner.STOP_SEARCH
WHERE   SS_URN=<cfqueryparam value="#URN#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset xmltoparse="#Application.str_SS_Path#\#qry_SSDetails.SS_YEAR#\#qry_SSDetails.SS_MON#\#qry_SSDetails.SS_DAY#\#Replace(URN,"/","_","ALL")#.xml">

<html>
<head>
<title>GENIE Stop Search Record - <cfoutput>#URN#</cfoutput></title>
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

<cfset headerTitle="STOP SEARCH RECORD - "&URN>	
<cfinclude template="/header.cfm">

<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="stopSearchDocument" printTitle="GENIE Stop Search Record- #URN#" printUser="#session.user.getFullName()#">
</div>
 
	<cfif FileExists(xmltoparse)>
		
	<!--- if we have been passed a search UUID then this is part of a series of stop searches
	      so work out the previous ss and next ss and display links to them
		  searchUUID file contains a csv list ofss refs --->
	<cfif isDefined('searchUUID')>
	  <cfif Len(searchUUID) GT 0>
	   <cfif FileExists(application.ssTempDir&searchUUID&".txt")>
		<cffile action="read" file="#application.ssTempDir##searchUUID#.txt" variable="fileSSList">
		<cfset ssList=StripCr(Trim(fileSSList))>
		<cfset iSSPos=ListContains(fileSSList,URN,",")>
		<cfset iPrevSS=iSSPos-1>
		<cfset iNextSS=iSSPos+1>
		
		<cfif iPrevSS GT 0>
			<cfset ssRef=ListGetAt(ListGetAt(ssList,iPrevSS,","),1,"|")>						
			<cfset prevSSLink='<a href="#ssRef#" searchUUID="#searchUUID#" class="genieStopSearchLink" inList="Y"><b>&lt;&lt;&lt; Previous Stop Search #ssRef#</b></a>'>
		</cfif>
		
		<cfif iNextSS LTE ListLen(ssList,",")>
			<cfset ssRef=ListGetAt(ListGetAt(ssList,iNextSS,","),1,"|")>										
			<cfset nextSSLink='<a href="#ssRef#" searchUUID="#searchUUID#" class="genieStopSearchLink" inList="Y"><b>Next Stop Search #ssRef# &gt;&gt;&gt;</b></a>'>
		</cfif>
	   </cfif>
	  </cfif>
	</cfif>				
	
		<cffile action="read" file="#xmltoparse#" charset="utf-8" variable="theXml">
		
		<cfset lisReplaceChars="#chr(14)#,#chr(15)#,#chr(16)#,#chr(17)#,#chr(18)#,#chr(19)#,#chr(20)#,#chr(21)#,#chr(22)#,#chr(23)#,#chr(24)#,#chr(25)#,#chr(26)#,#chr(27)#,#chr(28)#,#chr(29)#,#chr(30)#,#chr(31)#">
		<cfset lisReplaceWith=" , , , , , , , , , , , , , , , , , ">
		
		<cfset theXml=ReplaceList(theXml,lisReplaceChars,lisReplaceWith)>
		
		<cfset xmldoc=XmlParse(theXml)>
			
		<cfset s_Doc=XmlTransform(xmldoc, xml_stopsearch)>		
		    	    	    
	    <cfset showPrint=true>
	
	<cfelse>		
		<cfset s_Doc='<h3 align="center">No Document available for the supplied reference no #urn#...#xmltoparse#</h3>'>
		<cfset showPrint=false>
	</cfif>
	
	<cfoutput>
	<div style="clear:all; padding-top:2px">	
	<cfif isDefined('prevSSLink')>
		<div style="float:left; width:48%" class="docLink">
		 #prevSSLink#
		</div>
	</cfif>
	<cfif isDefined('nextSSLink')>
		<div style="float:right; width:48%; text-align:right" class="docLink">
		 #nextSSLink#
		</div>
	</cfif>
	</div>
	</cfoutput>	
	
	<cfif showPrint>
	   <div align="center" style="clear:all;">
		<form action="stopSearchPdf.cfm?#session.URLToken#" method="post" target="_blank">
			<input type="hidden" name="docHTML" value="#UrlEncodedFormat(s_Doc)#">
			<input type="hidden" name="URN" value="#Replace(URN,"/","_","ALL")#">
			<input type="submit" name="btnPrint" value="Click For Printable (PDF) Version">
		</form>
	   </div>	
	</cfif>
	
	<div id="stopSearchDocument">
	#s_Doc#
	</div>

</cfoutput>

</body>
</html>

<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Stop Search","","#urn#",0,session.user.getDepartment())>