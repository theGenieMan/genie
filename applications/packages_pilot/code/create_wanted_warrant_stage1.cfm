<!--- <cftry> --->
<!---

Module      : create_wanted_warrant_stage1.cfm

App         : STEP Packages

Purpose     : Package Creation Screen for wanted on warrant, needs a crimes warrant ref

              Details will then be loaded from Crimes / Warehouse for user to confirm

Requires    : 

Author      : Nick Blackham

Date        : 26/09/2012

Revisions   : 

--->


<!--- include the lookups info --->
<cfinclude template="lookups.cfm">

<!--- has the user asked for the form to be processed? --->
<cfif isDefined("hidAction")>
	<!--- yes, process the form --->	
	
	<!--- get the warrant detail --->
	<cfset warrant=application.genieService.getWarrantDetails(warrantRef=Form.frm_TxtCrimesWarrantRef)>	
		
	<!--- if the result of the processing comes back as valid then display the success message to the
	      user --->
	
	<cfset showWarrant=false>
	      
	<cfif Len(warrant.getNOMINAL_REF()) IS 0>	   

		   <!--- let's try crimes for the warrant --->
	   <cfquery name="qCrimesWarrant" datasource="#application.crimesDSN#">
	   	   SELECT *
		   FROM   crime.WARRANTS
		   WHERE  WARRANT_REF=<cfqueryparam value="#Form.frm_TxtCrimesWarrantRef#" cfsqltype="cf_sql_integer" >
	   </cfquery>	
	   
	   <cfif qCrimesWarrant.recordCount GT 0>
	   	    <cfset showWarrant=true>
			<cfset warrant=CreateObject('component','genieObj.warrants.warrant')>
			<cfset warrant.setWARRANT_REF(qCrimesWarrant.WARRANT_REF)>
			<cfset warrant.setNOMINAL_REF(qCrimesWarrant.NOMINAL_REF_SUBJECT)>
			<cfset warrant.setDATE_ISSUED(qCrimesWarrant.DATE_ISSUED)>
			<cfset warrant.setCOURT_NAME(qCrimesWarrant.ORG_CODE_COURT)>
			<cfset warrant.setDATE_EXECUTED(qCrimesWarrant.DATE_EXECUTED)>
			<cfset warrant.setEXECUTION_METHOD(qCrimesWarrant.HOW_WARRANT_EXECUTED)>
			<cfset warrant.setOFFENCE(qCrimesWarrant.OFFENCE)>
			<cfset warrant.setWARRANT_EXECUTED(qCrimesWarrant.WARRANT_EXECUTED)>
			<cfset warrant.setWARRANT_TYPE(qCrimesWarrant.WT_TYPE)>
			<cfset warrant.setBAIL(qCrimesWarrant.BAIL)>
			<cfset warrant.setNOTEPAD(qCrimesWarrant.NOTEPAD)>
			<cfset warrant.setADDRESS(qCrimesWarrant.ADDRESS)>
			<cfset warrant.setORG_CODE_POLICE(qCrimesWarrant.ORG_CODE_POLICE)>
			<cfset warrant.setOWN_SECT_CODE(qCrimesWarrant.OWN_SECT_CODE)>
			<cfset warrant.setCLASSIFICATION(qCrimesWarrant.CLASSIFICATION)>
			<cfset warrant.setWARRANT_REFERENCE(qCrimesWarrant.WARRANT_REFERENCE)>
	   <cfelse> 		
	   		<cfset sMessage="Warrant Ref: "&Form.frm_TxtCrimesWarrantRef&" is not valid / does not exist">
	   </cfif>
	<cfelse>
		<cfset showWarrant=true>
	</cfif>
	
	<cfif showWarrant>
		<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=warrant.getNOMINAL_REF())>
	   <cfset photo=application.genieService.getWestMerciaNominalLatestPhoto(nominalRef=warrant.getNOMINAL_REF())>
	</cfif>
	
	<!--- if it's not valid then we display the form again with errors and allow the user
	      to resubmit --->
		
    <!--- end of form processing --->		
<cfelse>
	<cfset frm_TxtCrimesWarrantRef="">
	<cfset showWarrant=false>
</cfif>		


<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="step.css">		
</head>

<cfoutput>
<body>

<a name="top"></a>
<cfinclude template="header.cfm">

    <h3 align="center">Created Wanted on Warrant STEP Package - Warrant Ref</h3>

	<!--- some errors have been reported from the add so show them --->
	<cfif isDefined("sMessage")>	 
	  <div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		#sMessage#
		</div>	 
	</cfif> 
	
	<cfform action="#SCRIPT_NAME#?#session.URLToken#" method="post">
	
	<div align="center">	
		<label class="warrantRef">CRIMES Warrant Ref</label>: 
		<input type="text" class="warrantRef" name="frm_TxtCrimesWarrantRef" id="frm_TxtCrimesWarrantRef" value="#frm_TxtCrimesWarrantRef#" size="7">
		<input type="hidden" name="hidAction" value="lookupWarrant">
		<input type="submit" class="warrantButton" value="Lookup Warrant">
	</div>
	
	</cfform>
	
	<cfif showWarrant>
	  <hr>
	  	
	  <div align="center">	
		<h3 align="center">#nominal.getFULL_NAME()#</h3>		
		 <table width="80%" border="1" cellpadding="2" cellspacing="0">
		 	<tr>
		 		<td width="200"><b>Warrant Ref</b></th>
				<td>#warrant.getWarrant_Ref()#</td>
				<td rowspan="10" width="200" align="center">
					<img src="#application.geniePhotos##photo.getPhoto_URL()#" height="240">
					<b>#DateFormat(photo.getCREATION_DATE(),"DD/MM/YYYY")#</b>
				</td>
		 	</tr>
			<tr>
		 		<td><b>Nominal Ref</b></td>
				<td>#warrant.getNominal_Ref()#</td>
		 	</tr>
			<tr>
		 		<td><b>Date / Place Issued</b></td>
				<td>#DateFormat(warrant.getDate_Issued(),'DDD DD/MM/YYYY')# #warrant.getCOURT_NAME()#</td>
		 	</tr>
			<tr>
		 		<td><b>Warrant Type</b></td>
				<td>#warrant.getWarrant_Type()#</td>
		 	</tr>
			<tr>
		 		<td><b>Offence</b></td>
				<td>#warrant.getOffence()#</td>
		 	</tr>
			<tr>
		 		<td><b>Classification</b></td>
				<td>#warrant.getClassification()#</td>
		 	</tr>
			<tr>
		 		<td><b>Bail</b></td>
				<td>#warrant.getBail()#</td>
		 	</tr>	
			<tr>
		 		<td><b>Location</b></td>
				<td>#warrant.getORG_CODE_POLICE()#</td>
		 	</tr>						
			<tr>
		 		<td><b>Section Code</b></td>
				<td>#warrant.getOwn_Sect_Code()#</td>
		 	</tr>
			<tr>
		 		<td><b>Case Number</b></td>
				<td>#warrant.getWARRANT_REFERENCE()#</td>
		 	</tr>																					
		 </table>		
		 
		 <!--- only allow user to select if the warrant has NOT been executed --->
		 <cfif warrant.getWARRANT_EXECUTED() IS "Y">
		   <h3 align="center">This Warrant has been executed on #DateFormat(warrant.getDATE_EXECUTED(),"DD/MM/YYYY")# #warrant.getEXECUTION_METHOD()#</h3>
		 <cfelse>
		   <form action="create_wanted_warrant_stage2.cfm?#session.URLToken#" method="post">
		   	  <input type="hidden" name="warrantRef" value="#warrant.getWARRANT_REF()#">
			  <input type="hidden" name="nominalRef" value="#warrant.getNOMINAL_REF()#">
			  <input type="hidden" name="divForWarrant" value="#warrant.getORG_CODE_POLICE()#">
			  <input type="hidden" name="warrantType" value="#warrant.getWARRANT_TYPE()#">
			  <input type="hidden" name="categoryId" value="32">
			  <input type="submit" name="btnAddWarrant" value="Continue to Create Step Package">
		   </form>
		 </cfif>
		 
	  </div>
		
	</cfif>
	
	
   	
</body>
</cfoutput>

</html>


<!---

 <cfcactch>
 </cfcatch>

</cftry>

--->