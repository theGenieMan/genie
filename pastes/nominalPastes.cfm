<!---

Module      : nominalPastes.cfm

App         : GENIE

Purpose     : ALLOWS THE PASTING OF CERTAIN INFORMATION ABOUT A NOMINAL TO A NEW WINDOW

Requires    : 

Author      : Nick Blackham

Date        : 24/11/2014

Version     : 1.0

Revisions   :
--->

<!---
<cfif not isDefined("type")>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Nominal Details</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="<cfoutput>#Application.CSS#</cfoutput>">	
	<META HTTP-EQUIV="imagetoolbar" CONTENT="no">
	<cfif session.user.getUserId() IS NOT "n_bla003">
	<script language="JavaScript" src="right_click.js"></script>
  </cfif>
	<cfif isDefined("OMS")>
	<script>
	 window.opener.close();
	</script>
	</cfif>
</head>

<cfif not isDefined("TYPE")>
<cfif not isDefined("str_NomRef")>
 <cfset str_NomRef=str_CRO>
</cfif>
--->

<!--- get custody ref's available for this nominal --->
<CFQUERY NAME="qry_CustRefs" DATASOURCE="#Application.WarehouseDSN#"  cachedwithin="#application.sTimespan#">
SELECT CUSTODY_REF, TO_CHAR(ARREST_TIME,'DD/MM/YYYY HH24:MI') AS ARR_DATE
FROM browser_owner.CUSTODY_SEARCH
WHERE NOMINAL_REF='#nominalRef#'
ORDER BY ARREST_TIME DESC
</CFQUERY>

<!--- get bail ref's available for this nominal --->
<cfquery name="qry_BAILS" DATASOURCE="#Application.WarehouseDSN#"  cachedwithin="#application.sTimespan#">			
SELECT BAIL_REF,CUSTODY_REF,TO_CHAR(DATE_SET,'DD/MM/YYYY') AS BAIL_DATE
FROM   browser_owner.BAIL_SEARCH B
WHERE  b.NOMINAL_REF='#nominalRef#'
ORDER BY DATE_SET DESC
</cfquery>

<!--- get all the warrant refs available for this nominal --->
<cfquery name="qry_Warrants" DATASOURCE="#Application.WarehouseDSN#"  cachedwithin="#application.sTimespan#">	
Select Warrant_ref, Date_Issued
From   browser_owner.warrants w
Where  w.nominal_ref='#nominalRef#'
Order By Date_Issued DESC
</cfquery>


<h2>Paste Options</h2>
<cfoutput>
<div style="display:inline; width:55%; float:left; padding-right:5px;"> 
	<br>  
	<ul>
	 <li><a href="#nominalRef#" class="pasteNominalDetails">Paste Nominal Details</a>
	 <li><a href="#nominalRef#" class="pasteNominalWarnings">Paste Warning Information</a>
	 <li><a href="#nominalRef#" class="pasteNominalRoles">Paste Roles Information</a>
	 <li><a href="#nominalRef#" class="pasteNominalAddresses">Paste Address Information</a>
	 <li><a href="#nominalRef#" class="pasteNominalVehicles">Paste Vehicles Information</a>
	 <cfif qry_CustRefs.RecordCount GT 0>
	 <li>Paste Custody Info : <select class="pasteNominalCustodyDetail">
	 	 						 <option value="">-- Select --</option>
								 <cfloop query="qry_CustRefs">
								  <option value="#CUSTODY_REF#">#CUSTODY_REF# - #ARR_DATE#</option>
								 </cfloop>
							  </select> 	      
	 </cfif>
	 <cfif qry_Bails.RecordCount GT 0>
	 <li>
	      Paste Bail Info : <select class="pasteNominalBailDetail">
	      		 <option value="">-- Select --</option>
				 <cfloop query="qry_Bails">
				  <option value="#BAIL_REF#|#nominalRef#">Cust:#CUSTODY_REF# - #BAIL_DATE#</option>
				 </cfloop>
				</select> 	      
	 </cfif>	 
	 <cfif qry_Warrants.RecordCount GT 0>
	 <li>
	      Paste Warrant Info : <select class="pasteNominalWarrantDetail">
	      	     <option value="">-- Select --</option>
				 <cfloop query="qry_Warrants">
				  <option value="#WARRANT_REF#|#nominalRef#">Warrant:#WARRANT_REF#, #DateFormat(Date_Issued,"DD/MM/YYYY")#</option>
				 </cfloop>
				</select> 	      
	 </cfif>	 
	</ul>
</div>
<div style="display:inline; width:43%; float:left; padding-right:5px; vertical-align:top;">   
<div id="dataContainer">
	 <div class="ui-widget-header">
	 How do I Paste to OIS?
	 </div>
   <div>
	<strong>To copy the details into OIS do the following : </strong>
	<ol type="1">
	 <li>Click on the link that describes the data you want to paste into OIS
	 <li>A new window will open with the data in. If there is more than one block/page of information
	 you need to highlight ONE block/page at a time using the mouse and paste into seperate OIS PNC pages. 
	 If ONLY ONE block/page exists you can press CTRL+A to highlight all the text.
	 <li>Type Ctrl-C to copy the data
	 <li>When you go back into OIS you will be able to paste the same way you did from CRIMES and PNC.
   </div>
   <div><br>
	<b>PLEASE NOTE : </b>If the results of the Address or Warnings pastes contain more than 1 block/page
	then these need to be invidually pasted into the PNC pages on OIS. i.e follow the above steps for
	each available block/page.
   </div>
  </div>
</div>
</cfoutput>

<!---
<cfelse>
 <cfswitch expression="#type#">
  <cfcase value="DETAILS">
	 <cfinclude template="../../common/code/paste_nominal_details.cfm">
	</cfcase> 
  <cfcase value="ROLES">
	 <cfinclude template="../../common/code/paste_offences.cfm">
	</cfcase>
  <cfcase value="WARNINGS">
	 <cfinclude template="../../common/code/paste_warnings.cfm">
	</cfcase>	
   <cfcase value="CUSTODY">
	 <cfinclude template="../../common/code/paste_custody.cfm">
	</cfcase>		
  <cfcase value="BAILS">
	 <cfinclude template="../../common/code/paste_bails.cfm">
	</cfcase>	
  <cfcase value="ADDRESS">
	 <cfinclude template="../../common/code/paste_addresses.cfm">
	</cfcase>	
  <cfcase value="WARRANTS">
	 <cfinclude template="../../common/code/paste_warrants.cfm">
	</cfcase>	
 </cfswitch>
</cfif> --->

