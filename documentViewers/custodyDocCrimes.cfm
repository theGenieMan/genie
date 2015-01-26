<!DOCTYPE html>
<!---

Module      : custodyDocCrime.cfm

App         : GENIE

Purpose     : Delivers the CRIMES Custody Document

Requires    : 

Author      : Nick Blackham

Date        : 05/11/2014

Revisions   : 

--->
	
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_doc_title.xsl"  variable="xml_custody_doctitle">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_doc_details.xsl"  variable="xml_custody_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_detainee_details.xsl"  variable="xml_detainee_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_detentions.xsl"  variable="xml_detention_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_policebail_details.xsl"  variable="xml_policebail_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_courtbail_details.xsl"  variable="xml_courtbail_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_interest_markers.xsl"  variable="xml_interest_markers">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_notes.xsl"  variable="xml_notes">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_warrants.xsl"  variable="xml_warrants">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_reviews.xsl"  variable="xml_reviews">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_extensions.xsl"  variable="xml_extensions">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_intsearch.xsl"  variable="xml_intsearch">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crm_custody_procdecs.xsl"  variable="xml_procdecs">

<cfquery name="qry_CustRef" datasource="#Application.WarehouseDSN#">
SELECT TO_CHAR(CREATION_DATE,'YYYY') AS CUST_YEAR, TO_CHAR(CREATION_DATE,'MM') AS CUST_MONTH,
            TO_CHAR(CREATION_DATE,'DD') AS CUST_DAY
FROM BROWSER_OWNER.CUSTODY_SEARCH
WHERE CUSTODY_REF=<cfqueryparam value="#custodyRef#" cfsqltype="cf_sql_varchar">			
</cfquery>

<cfset str_Cust_Doc=Application.str_CRIMES_Cust&"\"&qry_CustRef.CUST_YEAR&"\"&qry_CustRef.CUST_MONTH&"\"&qry_CustRef.CUST_DAY&"\"&Replace(custodyRef,"/","_","ALL")&".xml">


<cfif FileExists(str_Cust_Doc)>
	
<!--- if we have been passed a search UUID then this is part of a series of custodies 
      so work out the previous custody and next cusotdy and display links to them
	  searchUUID file contains a csv list of custody refs and type --->
<cfif isDefined('searchUUID')>
  <cfif Len(searchUUID) GT 0>
   <cfif FileExists(application.custodyTempDir&searchUUID&".txt")>
	<cffile action="read" file="#application.custodyTempDir##searchUUID#.txt" variable="fileCustodyList">
	<cfset custodyList=StripCr(Trim(fileCustodyList))>
	<cfset iCustodyPos=ListContains(fileCustodyList,custodyRef,",")>
	<cfset iPrevCust=iCustodyPos-1>
	<cfset iNextCust=iCustodyPos+1>
	
	<cfif iPrevCust GT 0>
		<cfset custRef=ListGetAt(ListGetAt(custodyList,iPrevCust,","),1,"|")>
		<cfset custType=ListGetAt(ListGetAt(custodyList,iPrevCust,","),2,"|")>			
		<cfset prevCustodyLink='<a href="#custRef#" custodyType="#custType#" searchUUID="#searchUUID#" class="genieCustodyLink" inList="Y"><b>&lt;&lt;&lt; Previous Custody #custRef#</b></a>'>
	</cfif>
	
	<cfif iNextCust LTE ListLen(custodyList,",")>
		<cfset custRef=ListGetAt(ListGetAt(custodyList,iNextCust,","),1,"|")>
		<cfset custType=ListGetAt(ListGetAt(custodyList,iNextCust,","),2,"|")>					
		<cfset nextCustodyLink='<a href="#custRef#" custodyType="#custType#" searchUUID="#searchUUID#" class="genieCustodyLink" inList="Y"><b>Next Custody #custRef# &gt;&gt;&gt;</b></a>'>
	</cfif>
   </cfif>
  </cfif>
</cfif>		

<cfset xmldoc=XmlParse(str_Cust_Doc)>

<cfset arr_CBails = XmlSearch(xmldoc, "Custody_Document/Court_Bails")>
<cfif ArrayLen(arr_CBails) GT 0>
 <cfset s_CourtBails="YES">
</cfif>

<cfset arr_PBails = XmlSearch(xmldoc, "Custody_Document/Police_Bails")>
<cfif ArrayLen(arr_PBails) GT 0>
 <cfset s_PoliceBails="YES">
</cfif>

<cfset arr_PDecs = XmlSearch(xmldoc, "Custody_Document/Process_Decisions/Process_Decision")>
<cfif ArrayLen(arr_PDecs) GT 0>
 <cfset s_ProcDecs="YES">
</cfif>

<cfset arr_IMark = XmlSearch(xmldoc, "Custody_Document/Interest_Markers")>
<cfif ArrayLen(arr_IMark) GT 0>
 <cfset s_IMark="YES">
</cfif>

<cfset arr_CustNote = XmlSearch(xmldoc, "Custody_Document/Custody_Notes")>
<cfif ArrayLen(arr_CustNote) GT 0>
 <cfset s_CustNote="YES">
</cfif>

<cfset arr_ExWarr = XmlSearch(xmldoc, "Custody_Document/Executed_Warrants")>
<cfif ArrayLen(arr_ExWarr) GT 0>
 <cfset s_Warrant="YES">
</cfif>

<cfset arr_Review = XmlSearch(xmldoc, "Custody_Document/Reviews")>
<cfif ArrayLen(arr_Review) GT 0>
 <cfset s_Review="YES">
</cfif>

<cfset arr_Extens = XmlSearch(xmldoc, "Custody_Document/Extensions")>
<cfif ArrayLen(arr_Extens) GT 0>
 <cfset s_Extens="YES">
</cfif>

<cfset arr_IntSearch = XmlSearch(xmldoc, "Custody_Document/Intimate_Search")>
<cfif ArrayLen(arr_IntSearch) GT 0>
 <cfset s_IntSearch="YES">
</cfif>

<!--- 1st do the cutody detail front sheet --->

<html>
<head>
<title><cfoutput>GENIE CRIMES Custody Record - #custodyRef#</cfoutput></title> 
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
<cfset headerTitle="CRIMES CUSTODY RECORD - "&custodyRef>	
<cfinclude template="/header.cfm">
<cfoutput>
<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="custodyDocument" printTitle="GENIE CRIMES Custody Record - #custodyRef#" printUser="#session.user.getFullName()#">
</div>

<div style="clear:all; padding-top:2px">	
<cfif isDefined('prevCustodyLink')>
	<div style="float:left; width:48%" class="docLink">
	 #prevCustodyLink#
	</div>
</cfif>
<cfif isDefined('nextCustodyLink')>
	<div style="float:right; width:48%; text-align:right" class="docLink">
	 #nextCustodyLink#
	</div>
</cfif>
</div>
</cfoutput>
<div style="clear:both;"><br></div>
<div class="ui-widget-header">
 <div style="padding:2px;">
 <a href="#front_sheet">FRONT SHEET</a> | <a href="#detainee">DETAINEE</a> | <a href="#detentions">DETENTIONS</a> 
 <cfif isDefined("s_ProcDecs")> | <a href="#pdecs">PROCESS DECISIONS</a></cfif>
 <cfif isDefined("s_CourtBails")> | <a href="#cbails">COURT BAILS</a></cfif>
 <cfif isDefined("s_PoliceBails")> | <a href="#pbails">POLICE BAILS</a></cfif>  
 <cfif isDefined("s_IMark")> | <a href="#imark">INTEREST MARKERS</a></cfif>  
 <cfif isDefined("s_CustNote")> | <a href="#notes">NOTES</a></cfif>  
 <cfif isDefined("s_Warrant")> | <a href="#pbails">WARRANTS</a></cfif>  
 <cfif isDefined("s_Reviews")> | <a href="#review">REVIEWS</a></cfif>  
 <cfif isDefined("s_Extens")> | <a href="#extens">EXTENSIONS</a></cfif>  
 <cfif isDefined("s_IntSearch")> | <a href="#intsearch">INTIMATE SEARCH</a></cfif>
 </div>  
</div>

<cfoutput>

<br>
<div id="custodyDocument">
<div>
<!--- Custody Front Sheet Details --->
<a name="front_sheet"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div>
<h2 align="center">CUSTODY RECORD FRONT SHEET</h2>
</a>
#XmlTransform(xmldoc, xml_custody_details)#

<!---
<cfif ListLen(lis_DepartureReasons,"|") GT 0>
<br>
<div style="width:95%; border:1px solid; padding:2px; margin:2px;"> 
  <h2>DEPARTURE REASONS</h2>	
  <p>
   <cfloop list="#lis_DepartureReasons#" index="str_Reason" delimiters="|">
    #str_Reason#<br>
   </cfloop>
  </p>
</div>
</cfif> --->


<!--- Detainee Details --->
<hr>
<a name="detainee"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD DETAINEE DETAILS</h2></a>
#XmlTransform(xmldoc, xml_detainee_details)#

<hr>
<a name="detentions"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">DETENTION DETAILS</h2></a>
#XmlTransform(xmldoc, xml_detention_details)#

<cfif isDefined("s_CourtBails")>
<!--- Court Bail Details --->
<hr>
<a name="cbails"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD COURT BAILS</h2></a>
#XmlTransform(xmldoc, xml_courtbail_details)#

</cfif>

<cfif isDefined("s_PoliceBails")>
<!--- POlice Bail Details --->
<hr> 
<a name="pbails"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD POLICE BAILS</h2></a>
#XmlTransform(xmldoc, xml_policebail_details)#

</cfif>

<cfif isDefined("s_ProcDecs")>

 <a name="pdecs"><div style="width:95%" align="right">
 <a href="##top" class="tabs">Back To Top</a></div><h2 align="center">PROCESS DECISIONS</h2></a>
 

	<cfloop index="i" from="1" to="#ArrayLen(arr_PDecs)#"> 
    <cfset s_ProcDecPath=arr_PDecs[i].XmlChildren[2].XmlText>

		<!--- setup Soco report to parse --->
		<cfset xmltoparse=Application.str_CRIMES_Cust & "process\" & Trim(s_ProcDecPath) & ".xml">
		<cfif FileExists(#xmltoparse#)>
			
			<div align="left">				
				<cfset xmlpddoc=XmlParse(xmltoparse)>
				#XmlTransform(xmlpddoc, xml_procdecs)#
			</div>
			<hr>
		</cfif>
		
	</cfloop>

</cfif>


<cfif isDefined("s_IMark")>
<!--- Interest Markers --->
<hr> 
<a name="imark"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD INTEREST MAKERS</h2></a>
#XmlTransform(xmldoc, xml_interest_markers)#

</cfif>

<cfif isDefined("s_CustNote")>
<!--- Interest Markers --->
<hr> 
<a name="notes"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD NOTES</h2></a>
#XmlTransform(xmldoc, xml_notes)#

</cfif>

<cfif isDefined("s_Warrant")>
<!--- Executed Warrants --->
<hr> 
<a name="notes"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD EXECUTED WARRANTS</h2></a>
#XmlTransform(xmldoc, xml_warrants)#

</cfif>

<cfif isDefined("s_Review")>
<!--- Reviews --->
<hr> 
<a name="notes"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD REVIEWS</h2></a>
#XmlTransform(xmldoc, xml_reviews)#

</cfif>

<cfif isDefined("s_Extens")>
<!--- Extensions --->
<hr> 
<a name="notes"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD EXTENSIONS</h2></a>
#XmlTransform(xmldoc, xml_extensions)#

</cfif>

<cfif isDefined("s_IntSearch")>
<!--- Extensions --->
<hr> 
<a name="notes"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD INTIMATE SEARCH</h2></a>
#XmlTransform(xmldoc, xml_intsearch)#

</cfif>
</div>
</div>
</cfoutput> 

</body>

</html>

<cfelse>
<cfoutput>
<html>
<head>
<title>#custodyRef# - No Document Available</title>
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
 CRIMES Custody -  #custodyRef#
</div>
<br>
<div style="clear:both">
	<br>
<b>No Document Available For This CRIMES Custody Reference #custodyRef#</b>
</div>
</body>
</html>
</cfoutput>
</cfif>

<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Custody","","#custodyRef#",0,session.user.getDepartment())>