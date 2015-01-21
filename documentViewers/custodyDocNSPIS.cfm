<!---

Module      : custodyDocNPSIS.cfm

App         : GENIE

Purpose     : Delivers the NSPIS Custody Document

Requires    : 

Author      : Nick Blackham

Date        : 05/11/2014

Revisions   : 

--->


<!---
<cffile action="read" file="#Application.str_Transforms#\custody_doc_title.xsl"  variable="xml_custody_doctitle">
<cffile action="read" file="#Application.str_Transforms#\custody_doc_details.xsl"  variable="xml_custody_details">
<cffile action="read" file="#Application.str_Transforms#\custody_detainee_details.xsl"  variable="xml_detainee_details">
<cffile action="read" file="#Application.str_Transforms#\custody_appropriateadult_details.xsl"  variable="xml_appropriateadult_details">
<cffile action="read" file="#Application.str_Transforms#\custody_charge_details.xsl"  variable="xml_charge_details">
<cffile action="read" file="#Application.str_Transforms#\custody_caution_details.xsl"  variable="xml_caution_details">
<cffile action="read" file="#Application.str_Transforms#\custody_reprimand_details.xsl"  variable="xml_reprimand_details">
<cffile action="read" file="#Application.str_Transforms#\custody_finalwarning_details.xsl"  variable="xml_finalwarning_details">
<cffile action="read" file="#Application.str_Transforms#\custody_otherdisp_details.xsl"  variable="xml_otherdisp_details">
<cffile action="read" file="#Application.str_Transforms#\custody_courtbail_details.xsl"  variable="xml_courtbail_details">
<cffile action="read" file="#Application.str_Transforms#\custody_policebail_header.xsl"  variable="xml_policebail_header">
<cffile action="read" file="#Application.str_Transforms#\custody_policebail_details.xsl"  variable="xml_policebail_details">
<cffile action="read" file="#Application.str_Transforms#\custody_refusecharge_details.xsl"  variable="xml_refusecharge_details">
--->

<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_doc_title.xsl"  variable="xml_custody_doctitle">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_doc_details.xsl"  variable="xml_custody_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_detainee_details.xsl"  variable="xml_detainee_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_appropriateadult_details.xsl"  variable="xml_appropriateadult_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_charge_details.xsl"  variable="xml_charge_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_caution_details.xsl"  variable="xml_caution_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_reprimand_details.xsl"  variable="xml_reprimand_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_finalwarning_details.xsl"  variable="xml_finalwarning_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_otherdisp_details.xsl"  variable="xml_otherdisp_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_courtbail_details.xsl"  variable="xml_courtbail_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_policebail_header.xsl"  variable="xml_policebail_header">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_policebail_details.xsl"  variable="xml_policebail_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\custody_refusecharge_details.xsl"  variable="xml_refusecharge_details">

<cfquery name="qry_CustRef" datasource="#Application.WarehouseDSN#">
SELECT TO_CHAR(CREATION_DATE,'YYYY') AS CUST_YEAR, TO_CHAR(CREATION_DATE,'MM') AS CUST_MONTH,
            TO_CHAR(CREATION_DATE,'DD') AS CUST_DAY, CREATION_DATE
FROM BROWSER_OWNER.CUSTODY_SEARCH
WHERE CUSTODY_REF=<cfqueryparam value="#custodyRef#" cfsqltype="cf_sql_varchar">			
</cfquery>

<cfset str_Cust_Doc=Application.str_NSPIS_Cust&"\"&qry_CustRef.CUST_YEAR&"\"&qry_CustRef.CUST_MONTH&"\"&qry_CustRef.CUST_DAY&"\"&Replace(custodyRef,"/","_","ALL")&".xml">

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

<cfset arr_CBails = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/COURT_BAIL")>
<cfif ArrayLen(arr_CBails) GT 0>
<cfset i_MaxBail=0>
 <cfloop index="i" from="1" to="#ArrayLen(arr_CBails)#" step="1">
  
  <cfset isCompleteBail = XmlSearch(arr_CBails[i], "BAIL/STATUS")>
  
  <cfif isCompleteBail[1].XMLText IS NOT "Preparation">
    <cfset s_CourtBails="YES">
  </cfif>
 </cfloop>
</cfif>
<cfset arr_CBails="">

<cfset arr_PBails = XmlSearch(xmldoc, "CUSTODY_RECORD/POLICE_BAIL")>
<cfif ArrayLen(arr_PBails) GT 0>
<cfset i_MaxBail=0>
 <cfloop index="i" from="1" to="#ArrayLen(arr_PBails)#" step="1">
  
  <cfset isCompleteBail = XmlSearch(arr_PBails[i], "BAIL/STATUS")>
  
  <cfif isCompleteBail[1].XMLText IS NOT "Preparation">
    <cfset s_PoliceBails="YES">
	<cfset sMaxBail = XmlSearch(arr_PBails[i], "VER_NO")>
	<cfset i_ThisBail=sMaxBail[1].XMLText>
    <cfif i_ThisBail GT i_MaxBail>
     <cfset i_MaxBail=i_ThisBail>
    </cfif>	
  </cfif>
 </cfloop>
</cfif>
<cfset arr_PBails="">

<cfset arr_AppropAdult = XmlSearch(xmldoc, "CUSTODY_RECORD/FRONT_SHEET/THIRD_PARTY")>
<cfset arr_AppropAdult1 = XmlSearch(xmldoc, "CUSTODY_RECORD/RIGHTS/THIRD_PARTY")>

<cfif ArrayLen(arr_AppropAdult) GT 0>
 <cfloop index="i" from="1" to="#ArrayLen(arr_AppropAdult)#">
  <cfif arr_AppropAdult[i].Role.XmlText IS "Appropriate Adult" OR arr_AppropAdult[i].Role.XmlText IS "Parent/Guardian">
	<cfset s_AppropAdult="YES">
  </cfif>
 </cfloop>
</cfif>

<cfif ArrayLen(arr_AppropAdult1) GT 0>
 <cfloop index="i" from="1" to="#ArrayLen(arr_AppropAdult1)#">
  <cfif arr_AppropAdult1[i].Role.XmlText IS "Appropriate Adult" OR arr_AppropAdult1[i].Role.XmlText IS "Parent/Guardian">
	<cfset s_AppropAdult1="YES">
  </cfif>
 </cfloop>
</cfif>
<cfset arr_AppropAdult="">
<cfset arr_AppropAdult1="">

<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif selectedElements[i].XMLTExt IS "Charge">
	<cfset isCompleteCharge = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/COMPLETED")>
	<cfif isCompleteCharge[i].XMLText IS NOT "0">
	  <cfset s_HaveCharges="YES">
	</cfif>
	<cfset isCompleteCharge="">
 </cfif>
</cfloop>
<cfset selectedElements="">

<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT")>

<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif selectedElements[i].XMLTExt IS "Caution" OR selectedElements[i].XMLTExt IS "Simple Caution" OR selectedElements[i].XMLTExt IS "Conditional Caution" OR selectedElements[i].XMLTExt IS "Youth Simple Caution" OR selectedElements[i].XMLTExt IS "Youth Conditional Caution">
	<cfset isCompleteCharge = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/COMPLETED")>
	<cfif isCompleteCharge[i].XMLText IS NOT "0">
      <cfset s_HaveCautions="YES">
	</cfif>
	<cfset isCompleteCharge="">
 </cfif>
</cfloop>
<cfset selectedElements="">

<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif selectedElements[i].XMLTExt IS "Reprimand">
   <cfset isCompleteCharge = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/COMPLETED")>
   <cfif isCompleteCharge[i].XMLText IS NOT "0">
     <cfset s_HaveReprimands="YES">
   </cfif>
   <cfset isCompleteCharge="">	
 </cfif>
</cfloop>
<cfset selectedElements="">

<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif selectedElements[i].XMLTExt IS "Final Warning">
   <cfset isCompleteCharge = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/COMPLETED")>
   <cfif isCompleteCharge[i].XMLText IS NOT "0">
     <cfset s_HaveFinalWarning="YES">
   </cfif>
 </cfif>
</cfloop>
<cfset selectedElements="">

<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/REFUSE_CHARGE")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
  <cfset s_HaveRefuseCharge="YES">
</cfloop>
<cfset selectedElements="">

<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL/DISPOSAL_TYPE_CV_TEXT")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
  <cfset s_HaveOtherDisposals="YES">
</cfloop>
<cfset selectedElements="">

<!---
<cfset lis_DepartureReasons="">
<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif ArrayLen(selectedElements[i].XMLChildren) GTE 2>
  <cfset s_Date=DateFormat(Left(selectedElements[i].XMLChildren[2].XMLText,10),"DD/MM/YYYY")&" "&Mid(selectedElements[i].XMLChildren[2].XMLText,12,8)>
  <cfset lis_DepartureReasons=ListAppend(lis_DepartureReasons,selectedElements[i].XMLChildren[1]&" "&s_Date,"|")>
 </cfif>
</cfloop>
--->

<cfset lis_DepartureReasons="">
<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/CHARGE_FORMULATION/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif ArrayLen(selectedElements[i].XMLChildren) GT 0> 
  <cfif ArrayLen(selectedElements[i].XMLChildren) GTE 3>
   <cfset s_Date=DateFormat(Left(selectedElements[i].XMLChildren[3].XMLText,10),"DD/MM/YYYY")&" "&Mid(selectedElements[i].XMLChildren[3].XMLText,12,8)>
  <cfelseif ArrayLen(selectedElements[i].XMLChildren) IS 2>
   <cfset s_Date=DateFormat(Left(selectedElements[i].XMLChildren[2].XMLText,10),"DD/MM/YYYY")&" "&Mid(selectedElements[i].XMLChildren[2].XMLText,12,8)>
  </cfif>
  <cfset lis_DepartureReasons=ListAppend(lis_DepartureReasons,selectedElements[i].XMLChildren[1]&" "&s_Date,"|")>
 </cfif>
</cfloop>
<cfset selectedElements="">

<!--- /DISPOSAL_TYPE_CV_TEXT,  --->
<cfset selectedElements = XmlSearch(xmldoc, "CUSTODY_RECORD/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL")>
<cfloop index="i" from="1" to="#ArrayLen(selectedElements)#" step="1">
 <cfif ArrayLen(selectedElements[i].XMLChildren) GT 0>
  <cfif ArrayLen(selectedElements[i].XMLChildren) IS 3>
   <cfset s_Date=DateFormat(Left(selectedElements[i].XMLChildren[3].XMLText,10),"DD/MM/YYYY")&" "&Mid(selectedElements[i].XMLChildren[3].XMLText,12,8)>
  <cfelseif ArrayLen(selectedElements[i].XMLChildren) IS 2>
   <cfset s_Date=DateFormat(Left(selectedElements[i].XMLChildren[2].XMLText,10),"DD/MM/YYYY")&" "&Mid(selectedElements[i].XMLChildren[2].XMLText,12,8)>
  </cfif>
   <cfset lis_DepartureReasons=ListAppend(lis_DepartureReasons,selectedElements[i].XMLChildren[1]&" "&s_Date,"|")>
 </cfif>
</cfloop>
<cfset selectedElements="">
<!--- 1st do the cutody detail front sheet --->
<!DOCTYPE html>
<html>
<head>
<title><cfoutput>GENIE NSPIS Custody Record - #custodyRef#</cfoutput></title> 
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
<cfset headerTitle="NSPIS CUSTODY RECORD - "&custodyRef>	
<cfinclude template="/header.cfm">
<cfoutput>
<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="custodyDocument" printTitle="GENIE NSPIS Custody Record - #custodyRef#" printUser="#session.user.getFullName()#">
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
 <a href="#front_sheet">FRONT SHEET</a> | <a href="#detainee" >DETAINEE DETAILS</a> 
 <cfif isDefined("s_AppropAdult")> | <a href="#appropadult">APPROPRIATE ADULT</a></cfif>
 <cfif isDefined("s_HaveCharges")> | <a href="#charges">CHARGES</a></cfif>
 <cfif isDefined("s_HaveCautions")> | <a href="#cautions">CAUTIONS</a></cfif>
 <cfif isDefined("s_HaveReprimands")> | <a href="#reprimands">REPRIMANDS</a></cfif>
 <cfif isDefined("s_HaveFinalWarning")> | <a href="#finalwarning">FINAL WARNING</a></cfif>
 <cfif isDefined("s_HaveOtherDisposals")> | <a href="#otherdisp">OTHER DISPOSALS</a></cfif>
 <cfif isDefined("s_HaveRefuseCharge")> | <a href="#refusecharge">REFUSED CHARGE</a></cfif>
 <cfif isDefined("s_CourtBails")> | <a href="#cbails"">COURT BAILS</a></cfif>
 <cfif isDefined("s_PoliceBails")> | <a href="#pbails">POLICE BAILS</a></cfif>
 </div>  
</div>

<cfoutput>
<a name="front_sheet">&nbsp</a>
<div id="custodyDocument">
<div>
<!--- Custody Front Sheet Details --->
<h3 align="center">RESTRICTED</h3>	
<div align="center">
<br>
<b>ALL TIMES IN THIS DOCUMENT ARE IN GMT<br>
IF THE EVENTS DETAILED TOOK PLACE DURING BRITISH SUMMER TIME, ONE HOUR SHOULD BE ADDED TO EACH OF THE TIMES INDICATED</b>
</div>	
<br>
<h2 align="center">CUSTODY RECORD FRONT SHEET</h2>
</a>
#XmlTransform(xmldoc, xml_custody_details)#

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
</cfif>


<!--- Detainee Details --->
<hr>
<a name="detainee"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD DETAINEE DETAILS</h2></a>
#XmlTransform(xmldoc, xml_detainee_details)#

<cfif isDefined("s_AppropAdult")>
<a name="appropadult"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD APPROPRIATE ADULT</h2></a>
#XmlTransform(xmldoc, xml_appropriateadult_details)#
</cfif>

<!---
<cfif isDefined("s_Image")>
 <div align="center" style="width:95%" >
 <br>
  <div>
	 <img src="#str_Link#" alt="Image of person in custody" width="250" height="300" style="border:1px solid;" border="0">
	</div>
 </div>
</cfif> --->

<cfif isDefined("s_HaveCharges")>
<!--- Charge Details --->
<hr>
<a name="charges"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD CHARGES</h2></a>
#XmlTransform(xmldoc, xml_charge_details)#
</cfif>

<cfif isDefined("s_HaveCautions")>
<!--- Caution Details --->
<hr>
<a name="cautions"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD CAUTIONS</h2></a>
#XmlTransform(xmldoc, xml_caution_details)#
</cfif>

<cfif isDefined("s_HaveReprimands")>
<!--- Reprimand Details --->
<hr>
<a name="reprimands"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD REPRIMANDS</h2></a>
#XmlTransform(xmldoc, xml_reprimand_details)#
</cfif>

<cfif isDefined("s_HaveFinalWarning")>
<!--- Reprimand Details --->
<hr>
<a name="finalwarning"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD FINAL WARNINGS</h2></a>
#XmlTransform(xmldoc, xml_finalwarning_details)#
</cfif>

<cfif isDefined("s_HaveRefuseCharge")>
<!--- Other Disp Details --->
<hr>
<a name="refusecharge"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD REFUSED CHARGE</h2></a>
#XmlTransform(xmldoc, xml_refusecharge_details)#
</cfif>

<cfif isDefined("s_HaveOtherDisposals")>
<!--- Other Disp Details --->
<hr>
<a name="otherdisp"><div style="width:95%" align="right">
<a href="##top" class="tabs">Back To Top</a></div><h2 align="center">CUSTODY RECORD OTHER DISPOSALS</h2></a>
#XmlTransform(xmldoc, xml_otherdisp_details)#
</cfif>

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

<cfset arr_PBailsOut = XmlSearch(xmldoc, "CUSTODY_RECORD/POLICE_BAIL")>

<cfloop index="i" from="1" to="#ArrayLen(arr_PBailsOut)#" step="1">
 <cfset sMaxBail = XmlSearch(arr_PBailsOut[i], "VER_NO")>

 <cfif sMaxBail[1].XmlText IS i_MaxBail>
   #XmlTransform(xmldoc, xml_policebail_header)#
   #XmlTransform(XmlParse(arr_PbailsOut[i]), xml_policebail_details)#	
  </cfif>
</cfloop>

<cfset arr_PBailsOut="">

</cfif>
<h3 align="center">RESTRICTED</h3>
</cfoutput> 
</div>
</div>
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
 NSPIS Custody -  #custodyRef#
</div>

<br>
<div style="clear:both">
	<br>
<b>No Document Available For This NSPIS Custody Reference #custodyRef#</b>
</div>
</body>
</html>
</cfoutput>
</cfif>

<cfset xml_custody_doctitle="">
<cfset xml_custody_details="">
<cfset xml_detainee_details="">
<cfset xml_appropriateadult_details="">
<cfset xml_charge_details="">
<cfset xml_caution_details="">
<cfset xml_reprimand_details="">
<cfset xml_finalwarning_details="">
<cfset xml_otherdisp_details="">
<cfset xml_courtbail_details="">
<cfset xml_policebail_header="">
<cfset xml_policebail_details="">
<cfset xml_refusecharge_details="">