<!---

Module      : caseDocCrimes.cfm

App         : GENIE

Purpose     : Delivers the Crimes Case Document

Requires    : 

Author      : Nick Blackham

Date        : 05/11/2014

Revisions   : 

--->


<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_case_doc_title.xsl"  variable="xml_case_doctitle">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_case_doc_details.xsl"  variable="xml_case_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_case_person_details.xsl"  variable="xml_defendant_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_case_procdecs.xsl"  variable="xml_proc_decs">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_case_flocs.xsl"  variable="xml_flocs">

<cfquery name="qry_CaseRef" datasource="#Application.WarehouseDSN#">
SELECT TO_CHAR(DATE_CREATED,'YYYY') AS CASE_YEAR, TO_CHAR(DATE_CREATED,'MM') AS CASE_MONTH,
            TO_CHAR(DATE_CREATED,'DD') AS CASE_DAY
FROM BROWSER_OWNER.PD_SEARCH
WHERE CASE_ORG=<cfqueryparam value="#ListGetAt(caseRef,1,"/")#" cfsqltype="cf_sql_varchar">		
AND CASE_SERIAL=<cfqueryparam value="#Int(ListGetAt(caseRef,2,"/"))#" cfsqltype="cf_sql_numeric">		
AND CASE_YEAR=<cfqueryparam value="#Int(ListGetAt(caseRef,3,"/"))#" cfsqltype="cf_sql_vnumeric">		
</cfquery>

<cfset str_Case_doc="#Application.str_Case_CRM_Path#\#qry_CaseRef.CASE_YEAR#\#qry_CaseRef.CASE_MONTH#\#qry_CaseRef.CASE_DAY#\#Replace(caseRef,"/","_","ALL")#.xml">

<cfif FileExists(str_Case_Doc)>
	
<!--- if we have been passed a search UUID then this is part of a series of cases 
      so work out the previous cases and next case and display links to them
	  searchUUID file contains a csv list of case refs and type --->
<cfif isDefined('searchUUID')>
  <cfif Len(searchUUID) GT 0>
   <cfif FileExists(application.caseTempDir&searchUUID&".txt")>
	<cffile action="read" file="#application.caseTempDir##searchUUID#.txt" variable="fileCaseList">
	<cfset caseList=StripCr(Trim(fileCaseList))>
	<cfset iCasePos=ListContains(fileCaseList,caseRef,",")>
	<cfset iPrevCase=iCasePos-1>
	<cfset iNextCase=iCasePos+1>
	
	<cfif iPrevCase GT 0>
		<cfset caseRefP=ListGetAt(ListGetAt(caseList,iPrevCase,","),1,"|")>
		<cfset caseType=ListGetAt(ListGetAt(caseList,iPrevCase,","),2,"|")>			
		<cfset prevCaseLink='<a href="#caseRefP#" caseType="#caseType#" searchUUID="#searchUUID#" class="genieCaseLink" inList="Y"><b>&lt;&lt;&lt; Previous Case #caseRefP#</b></a>'>
	</cfif>
	
	<cfif iNextCase LTE ListLen(caseList,",")>
		<cfset caseRefN=ListGetAt(ListGetAt(caseList,iNextCase,","),1,"|")>
		<cfset caseType=ListGetAt(ListGetAt(caseList,iNextCase,","),2,"|")>					
		<cfset nextCaseLink='<a href="#caseRefN#" caseType="#caseType#" searchUUID="#searchUUID#" class="genieCaseLink" inList="Y"><b>Next Case #caseRefN# &gt;&gt;&gt;</b></a>'>
	</cfif>
   </cfif>
  </cfif>
</cfif>			

<cfset xmldoc=XmlParse(str_Case_Doc)>

<cfset arr_Flocs = XmlSearch(xmldoc, "Case_Document/File_Locations")>
<cfif ArrayLen(arr_Flocs) GT 0>
 <cfset s_Flocs="YES">
</cfif>

<cfset arr_Defs = XmlSearch(xmldoc, "Case_Document/Defendants")>
<cfif ArrayLen(arr_Defs) GT 0>
 <cfset s_Defs="YES">
</cfif>

<!--- 1st do the cutody detail front sheet --->
<!doctype html>
<html>
<head>
<title><cfoutput>GENIE CRIMES Case Record - #caseRef#</cfoutput></title> 
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
<a name="top"></a>
<cfset headerTitle="CRIMES CASE RECORD - "&caseRef>	
<cfinclude template="/header.cfm">
<cfoutput>
<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="caseDocument" printTitle="GENIE CRIMES Case Record - #caseRef#" printUser="#session.user.getFullName()#">
</div>

	<div style="clear:all; padding-top:2px">	
	<cfif isDefined('prevCaseLink')>
		<div style="float:left; width:48%">
		 #prevCaseLink#
		</div>
	</cfif>
	<cfif isDefined('nextCaseLink')>
		<div style="float:right; width:48%; text-align:right">
		 #nextCaseLink#
		</div>
	</cfif>
	</div>
	</cfoutput>	

<div style="clear:both;"><br></div>

<div class="ui-widget-header">
 <div style="padding:2px;">
 <a href="#front_sheet">FRONT SHEET</a> 
 <cfif isDefined("s_Defs")>| <a href="#defs">DEFENDANTS</a></cfif>
 <cfif isDefined("s_Flocs")> | <a href="#flocs">FILE LOCATIONS</a></cfif>
 </div>
</div>
<cfoutput>

<br>
<div id="caseDocument">
<!--- Custody Front Sheet Details --->
<a name="front_sheet"><div align="right">
<a href="##top" class="tabs">Back To Top</a>
<h2 align="center">CASE</h2></div>
</a>
#XmlTransform(xmldoc, xml_case_details)#

<cfif isDefined("s_Defs")>
<!--- Court Bail Details --->
<hr>
<a name="defs"><div align="right">
<a href="##top" class="tabs">Back To Top</a><h2 align="center">CASE FILE DEFENDANTS</h2></div></a>

<cfloop from="1" to="#ArrayLen(arr_Defs)#" index="x">
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
   #XmlTransform(XMLParse(arr_Defs[x]), xml_defendant_details)#
  </table>  	

 <cfset arr_PDecs = XmlSearch(XMLParse(arr_defs[x]), "Defendants/Process_Decision")>

 <cfloop from="1" to="#ArrayLen(arr_PDecs)#" index="y">
 <hr>
  <cfset s_ProcDecPath=arr_PDecs[y].XmlChildren[2].XmlText>

		<!--- setup Soco report to parse --->
		<cfset xmltoparse=Application.str_CRIMES_Cust & "process\" & Trim(s_ProcDecPath) & ".xml">

		<cfif FileExists(#xmltoparse#)>
			
			<div align="left">				
				<cfset xmlpddoc=XmlParse(xmltoparse)>
				#XmlTransform(xmlpddoc, xml_proc_decs)#
			</div>
		</cfif>
 </cfloop>
  </div>
</cfloop>

</cfif>

<cfif isDefined("s_Flocs")>
<!--- POlice Bail Details --->
<hr> 
<a name="flocs"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a><h2 align="center">CASE FILE LOCATIONS</h2></div></a>
#XmlTransform(xmldoc, xml_flocs)#
</cfif>
</div>
</cfoutput>
</body>

</html>

<cfelse>
<cfoutput>
<html>
<head>
<title>#caseRef# - No Document Available</title>
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">			
<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
</head>

<body>
<a name="top"></a>
<div class="ui-widget-header">
 CRIMES Case -  #caseRef#
</div>

<br>
<div style="clear:both">
	<br>
<b>No Document Available For This CRIMES Case Reference #caseRef#</b>
</div>
</body>
</html>
</cfoutput>
</cfif>