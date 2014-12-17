<!DOCTYPE HTML>
<!--- <cftry> --->
<cfsilent>
<!---

Module      : /nominalViewers/nflsm/nominal.cfm

App         : GENIE

Purpose     : Displays NFLMS nominal personal information and details of addresses and certificates

Requires    : PERSON_URN of the nominal to display

Author      : Nick Blackham

Date        : 03/12/2014

Revisions   : 
--->

<!--- queries.. Nominal Info, Address Info and Certificate Info --->

<cfquery name="qry_NominalDetails" datasource="#Application.WarehouseDSN#" >
SELECT p.*
FROM   browser_owner.NFLMS_PERSON p
WHERE  PERSON_URN='#PERSON_URN#'
</cfquery>

<cfquery name="qry_AddressDetails" datasource="#Application.WarehouseDSN#" >
SELECT   DECODE(LINE_1,'','',LINE_1||', ')||
				DECODE(LINE_2,'','',LINE_2||', ')||
				DECODE(LINE_3,'','',LINE_3||', ')||
				DECODE(LINE_4,'','',LINE_4||', ')||
				DECODE(LINE_5,'','',LINE_5||', ')||
				DECODE(POSTCODE,'','',POSTCODE) Address,a.*
FROM   browser_owner.NFLMS_ADDRESS a
WHERE  PERSON_URN='#PERSON_URN#'
</cfquery>

<cfquery name="qry_NominalCertif" datasource="#Application.WarehouseDSN#" >
SELECT nc.*
FROM   browser_owner.NFLMS_CERTIFICATE nc
WHERE  PERSON_URN='#PERSON_URN#'
</cfquery>

<!--- find the photo --->
<cfset s_PersonRef=qry_NominalDetails.PERSON_URN>
<!--- remove the prefix 22 and the suffix P --->
<cfset s_ForcePrefix=Left(s_PersonRef,2)>
 <cfif s_ForcePrefix IS "22">
	<cfset s_PersonRef=Right(s_PersonRef,Len(s_PersonRef)-2)>
	<cfset s_PersonRef=Left(s_PersonRef,Len(s_PersonRef)-1)>
	<!--- convert to an in to remove the 0s --->
	<cfset s_PersonRef=Int(s_PersonRef)>	
 <cfelse>
	<cfset s_PersonRef=Right(s_PersonRef,Len(s_PersonRef)-2)>
	<cfset s_PersonRef=Left(s_PersonRef,Len(s_PersonRef)-1)>    
    <cfset s_PersonRef=s_ForcePrefix&"-"&Int(s_PersonRef)>
 </cfif>

<cfset s_NFLMSFile=Application.NFLMS_Photos&s_PersonRef&".jpg">

<cfif FileExists(s_NFLMSFile)>
 <cfset s_DestFile=Application.str_Image_Temp_Dir&"\NFLMS\NFLMS_"&s_PersonRef&".jpg">
 <cfset s_DestURL=Application.str_Image_URL&"\NFLMS\NFLMS_"&s_PersonRef&".jpg">
 <cffile action="copy" source="#s_NFLMSFile#" destination="#s_DestFile#">
<cfelse>
 <cfset s_DestURL=Application.str_Image_URL&"NFLMS_noimage.jpg">
</cfif>

</cfsilent>

<cfset Form_Title="GENIE #Application.Version# #Application.Env# - Firearms Nominal #qry_NominalDetails.Forenames# #qry_NominalDetails.Surname# #qry_NominalDetails.Person_URN#">

<html>	
<head>
	<title><cfoutput>#qry_NominalDetails.FORENAMES# #qry_NominalDetails.SURNAME#</cfoutput> - GENIE NFLMS</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">			
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
</head>

<body>
			
<cfinclude template="/header.cfm">	
			
  <div class="nominalTitle">
	<cfoutput>
	  <b>#qry_NominalDetails.Forenames# #qry_NominalDetails.Surname#</b>
    </cfoutput>	  
  </div> 
  <cfoutput query="qry_NominalDetails">
  <table width="50%" id="nflmsData">
  <tr>
   <td valign="top">
	 <!---Photo--->
	   <img src="#s_DestURL#" height="130" width="100" style="padding:1px; border:1px solid black" alt="Image of #FORENAMES# #SURNAME#">
   </td>
   <td width="2%">&nbsp;</td>
   <td valign="top" width="99%">
      <table align="center" width="100%" class="nominalData">
	  <tr>
	    <th width="35%"><b>Name</b></th>
		<td width="65%" class="row_colour0">#FORENAMES# #SURNAME#</td>
	  </tr>
	  <tr>
	    <th><b>Person Ref</b></th>
		<td class="row_colour1">#PERSON_URN#</td>
	  </tr>
	  <tr>
	    <th><b>PNC ID</b></th>
		<td class="row_colour0"><cfif Len(PNCID) GT 0>#PNCID#<cfelse>&nbsp;</cfif></td>
	  </tr>
	  <tr>
	    <th><b>Date Of Birth</b></th>
		<td class="row_colour1"><cfif Len(DOB) GT 0>#DateFormat(DOB,"DD/MM/YYYY")#<cfelse>&nbsp;</cfif></td>
	  </tr>	  	  	  
	  <tr>
	    <th><b>Age</b></th>
		<td class="row_colour0"><cfif Len(DOB) GT 0>#DateDiff("yyyy",DOB,now())#<cfelse>&nbsp;</cfif></td>
	  </tr>	  
	  <tr>
	    <th><b>Height</b></th>
		<td class="row_colour1"><cfif Len(HEIGHT) GT 0>#HEIGHT#<cfelse>&nbsp;</cfif></td>
	  </tr>	  
	  <tr>
	    <th><b>Mobile Tel No</b></th>
		<td class="row_colour0"><cfif Len(MOBILE_TEL) GT 0>#MOBILE_TEL#<cfelse>&nbsp;</cfif></td>
	  </tr>	  	  
	  </table>
   </td>
 </tr>
 </table>
	</cfoutput>
 <br>
<cfoutput>
<div class="dataContainer">
 <div class="nominalTitle">
 ADDRESSES
 </div>

 <div>
 <table width="100%" class="genieData">
  <thead>
   <tr>
	<th>Address</th>
	<th>Type</th>
    <th>Tel No</th>			
	<th>Security Type</th>
	<th>Location</th>	
   </tr>
  </thead>
  <tbody>
 <cfset i=1>
 <cfloop query="qry_AddressDetails">
  <tr class="row_colour#i MOD 2#">
   <td>#ADDRESS#</td>
   <td>#ADDRESS_TYPE#</td>
   <td>#TEL_NO#</td>
   <td>#SECURITY_TYPE#</td>
   <td>#SECURITY_LOCATION#</td>
  </tr>
  <cfset i=i+1>
 </cfloop>
 </tbody>
 </table>
 </div>

<br>

 <div class="nominalTitle">
 CERTIFICATES
 </div>

 <div>
 <table width="100%" class="genieData">
 <cfset i=1>
 <cfloop query="qry_NominalCertif">
 <!--- get the weapon info for this certif --->
	<cfquery name="qry_CertifWeapons" datasource="#Application.WarehouseDSN#"  >
	SELECT nw.*
	FROM   browser_owner.NFLMS_WEAPON nw
	WHERE  CERT_NO='#CERT_NO#'
	</cfquery>
  <thead>
  <tr>
	<th width="25%">Certif No</th>
	<th width="12%">Valid From</th>
	<th width="12%">Valid To</th>
	<th width="25%">Type</th>	
	<th width="25%">Status</th>		
  </tr>	
  </thead>
  <tbody>
  <tr class="row_colour#i MOD 2#">
   <td rowspan="3" style="font-size:150%; font-weight:bold;" valign="middle" align="center">#CERT_NO#</td>
   <td>#DateFormat(VALID_FROM,"DD/MM/YYYY")#</td>
   <td>#DateFormat(VALID_To,"DD/MM/YYYY")#</td>
   <td>
	<cfset i_FindDesc=ListFind(Application.NFLMS_CertCode,CERT_TYPE,",")>
	<cfif i_FindDesc IS 0>
	 <cfset s_CertDesc=CERT_TYPE>
	<cfelse>
	 <cfset s_CertDesc=ListGetAt(Application.NFLMS_CertDesc,i_FindDesc,",")>
	</cfif>	
	#s_CertDesc#
   </td>
   <td align="center">
	<cfset i_FindDesc=ListFind(Application.NFLMS_StatusCode,CERT_STATUS,",")>
	<cfif i_FindDesc IS 0>
	 <cfset s_StatusDesc=CERT_STATUS>
	<cfelse>
	 <cfset s_StatusDesc=ListGetAt(Application.NFLMS_StatusDesc,i_FindDesc,",")>
	</cfif>
	<cfif CERT_STATUS IS "L">
	<div style="background-color:##00BB00">
	<cfelse>
	<div>
	</cfif>
	<b>#s_StatusDesc#</b>
	</div>
   </td>
  </tr>
  </tbody>
  <thead>
  <tr>
   <th colspan="5">Weapons</th>
  </tr>
  </thead>
  <tbody>
  <tr>
   <td colspan="5" class="row_colour#i MOD 2#">
    <cfloop query="qry_CertifWeapons">
	 <strong>#MANUFACTURER# #WEAPON_TYPE#</strong> #WEAPON_ACTION# #CALIBRE# (Serial No : <b>#Serial_NO#</b>)<br>
    </cfloop>
   </td>
  </tr>
  <cfif i LT qry_NominalCertif.RecordCount>
  <tr>
	<td colspan="5"><hr></td>
  </tr>
  </cfif>
  <cfset i=i+1>
  </tbody>
 </cfloop>
 
 </table>
 </div>
</div>

</cfoutput>
</body>
</html>
						
<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL FIREARMS INFO (nominalinformation_firearms.cfm)","","Person URN:#qry_NominalDetails.PERSON_URN# #Replace(qry_NominalDetails.Forenames,",","","ALL")# #Replace(qry_NominalDetails.Surname,",","","ALL")#",0,session.user.getDepartment())>

		<!--- Error Trapping  
		<cfcatch type="any">
		 <cfset str_Subject="#Form_Title# - Error">
		 <cfset ErrorScreen="nominalinformation.cfm"> 
		 <cfinclude template="../../error/cfcatch_include.cfm">
		</cfcatch> 
		</cftry>--->