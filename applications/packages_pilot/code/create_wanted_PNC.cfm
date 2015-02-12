<!--- <cftry> --->
<!---

Module      : create_wanted_PNC.cfm

App         : STEP Packages

Purpose     : Package Creation Screen for PNC Wanted, needs a nominal reference
              to be passed in as this type of package requries a nominal

              Defaults are loaded from file

Requires    : 

Author      : Nick Blackham

Date        : 26/09/2012

Revisions   : 

--->

<!--- use the genie service to get data about the nominal --->
<cfset nominal=Application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>

<!--- get the activities for this type of package --->
<cfset activities=Application.stepService.getActivities(categoryId=categoryId,level='OFFICER',preSub='Y')>

<!--- load in the defaults for this category --->
<cffile action="read" file="#Application.lookupsDir#defaults_#categoryId#.txt" variable="defaultsFile">

<!--- include the lookups info --->
<cfinclude template="lookups.cfm">

<!--- has the user asked for the form to be processed? --->
<cfif isDefined("hidAction")>
	<!--- yes, process the form --->	
	
	<!--- send the form off to the service for processing --->
	<cfset processResult=application.stepService.processPNCWanted(Form)>	
		
	<!--- if the result of the processing comes back as valid then display the success message to the
	      user --->
	      
	<cfif  processResult.valid>
		  <!--- add the nominal as a favourite for the OIC who is filling this form in --->
		  <cfset application.genieService.addNominalFavourite(nominalRef=nominalRef,userId=session.user.getUserId(),showUpdates="Y")>
		
		  <cflocation url="creationSuccess.cfm?urn=#processResult.URN#" addtoken="true">
    <cfelse>
		<!--- just check the target date, if that isn't valid then we need to reset it otherwise
		      the page will error 
		<cfif not isDate(frm_TxtTargDate)>
			<cfset frm_TxtTargDate=DateFormat(DateAdd("m","3",now()),"DD/MM/YYYY")>
		</cfif>--->
		<cfset frm_TxtTargDate=frm_HidTargDate>
	</cfif>
	
	<!--- if it's not valid then we display the form again with errors and allow the user
	      to resubmit --->
		
    <!--- end of form processing --->		
<cfelse>
	<!--- no, it's the first time into the page --->

	<!--- setup the activity variables for the form --->
	<cfloop query="activities">
		<cfset "frm_SelActivity#ACTIVITY_ID#"="N">
		<cfset "frm_TxtActivity#ACTIVITY_ID#"="">
		<cfset "frm_TxtActivityDate#ACTIVITY_ID#"="">
	</cfloop>	
	
	<!--- setup any variables we can id advance to save the user having to worry about it --->
	<cfset frm_SelDivision=session.Div>
	<cfset frm_SelSendCon=UCase(session.user.getUserId())>
	<cfset frm_TxtTargDate="">
	<cfset frm_HidTargDate="">
	<!--- setup variables we need to capture --->
	<cfset frm_SelSection="">
	<cfset frm_SelCrimeType="">
	<cfset frm_SelSendSgt="">
	<cfset frm_SelRiskLevel="">
    <cfset frm_TxtCrimeNo="">
	<cfset frm_TxtOISNo="">		
	<cfset frm_SelWantedType="">
</cfif>		


<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="step.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/ui/css/base/jquery-ui.css">  
    <script type="text/javascript" src="/jQuery/jQuery.js"></script>		
	<script type="text/javascript" src="/jquery-ui-1.9.1.custom/js/jquery-ui-1.9.1.custom.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript" src="/jQuery/date-en-GB.js"></script>
	
	<script type="text/javascript">         
		$(document).ready(function() {
			$.support.cors = true;
			$('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});		
			
			// jQuery to create the hr for the allocated officer
			$('#allocateOfficer').hrQuickSearch(
				{
					returnUserId: 'frm_SelSendSgt',
					returnFullName: 'frm_TxtSendName',
					returnCollarNo: 'frm_TxtSendCollar',
					returnRank: 'frm_TxtSendRank',
					searchBox: 'allocateSearch',
					searchBoxClass: 'mandatory',
					searchBoxName: 'allocateNameSearch',
					scrollToResults:false,
					initialValue: $('#allocateOfficer').attr('initialValue')
				}
			);
				
			$('#frm_SelRiskLevel').change(
			  function()
			  {
			  	var daysReturn=parseInt($('option:selected', this).attr('returnDays'));
				var returnDate=Date.today().add(daysReturn).days();
				
				if (isNaN(daysReturn)){								
					$('#frm_TxtTargDate').val('');
					$('#frm_HidTargDate').val('');				
				}
				else
				{				
					$('#frm_TxtTargDate').val(returnDate.toString('dd/MM/yyyy'));
					$('#frm_HidTargDate').val(returnDate.toString('dd/MM/yyyy'));					
				}
			  }
			)		
			
		   $('#frm_SelDivision').change(
			  function()
			  {
			  	var thisDiv=$(this).val();				
				if (thisDiv=='N' || thisDiv=='S' || thisDiv=='W'){
					$('#mgFileRow').hide();
				}
				else{
					$('#mgFileRow').show();
				}
			  }
			)				
				
		})
    </script>		
</head>

<cfoutput>
<body>

<a name="top"></a>
<cfinclude template="header.cfm">

    <h3 align="center">Created PNC Wanted STEP Package - #nominal.getFULL_NAME()# (#nominal.getNOMINAL_REF()#) #nominal.getDATE_OF_BIRTH_TEXT()# #nominal.getPNCID_NO()#</h3>

	<!--- some errors have been reported from the add so show them --->
	<cfif isDefined("processResult.errors")>
	 <cfif ListLen(processResult.errors,"|") GT 0>
	  <div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		#Replace(processResult.errors,"|","<br>","ALL")#
		</div>
	 </cfif>
	</cfif> 
	
	<div align="center">
	  <div style="width:95%">
	  	
		<cfform action="#SCRIPT_NAME#?#session.URLToken#" method="post" enctype="multipart/form-data">
		
		<fieldset>
		 <legend>Activities</legend>	
			<table width="98%" align="center">
				<tr>
					<td width="55%" class="table_title">Activity / Check</td>
					<td width="5%" class="table_title">Done?</td>
					<td width="10%" class="table_title">Date</td>
					<td width="30%" class="table_title">Notes</td>
				</tr>
				<cfset i=1>
				<cfloop query="activities">
				<tr class="row_colour#i mod 2#">
					<td valign="top">
					  #ACTIVITY_TEXT#
					  <cfif Len(LINK_TEXT) GT 0>
					  	  <br>
						  <cfif Len(LINK_APPEND) GT 0>
						  	 <cfset iLink=1>
							 <cfset sUrl=LINK_URL>
						     <cfloop list="#LINK_APPEND#" index="linkType" delimiters=",">
							 	 <cfif iLink IS 1>
								  	  <cfset sUrl &= "?">
								 <cfelse>
								      <cfset sUrl &= "&">
								 </cfif> 	  
								 <cfswitch expression="#linkType#">
								 	 <cfcase value="nominalRef">
									  	  <cfset sUrl &= "nominalRef="&nominalRef>
									 </cfcase>
									 <cfcase value="session">
									 	  <cfset sUrl &= session.URLToken>
									 </cfcase>
								 </cfswitch>
								 <cfset iLink++>
							 </cfloop>
						  <cfelse>
						  	  <cfset sUrl=LINK_URL>	  
						  </cfif>
					  	  (<a href="#sUrl#" target="_blank">#LINK_TEXT#</a>)
					  </cfif>
					</td>
					<td valign="top">
						<cfselect name="frm_SelActivity#ACTIVITY_ID#">
							<option value="N" #iif(Evaluate('frm_SelActivity'&ACTIVITY_ID) IS 'N',de('selected'),de(''))#>N</option>
							<option value="Y" #iif(Evaluate('frm_SelActivity'&ACTIVITY_ID) IS 'Y',de('selected'),de(''))#>Y</option>
						</cfselect>
					</td>
					<td valign="top">					  
						<input type="text" name="frm_TxtActivityDate#ACTIVITY_ID#" id="frm_TxtActivityDate#ACTIVITY_ID#" size="7" value="#Evaluate("frm_TxtActivityDate"&ACTIVITY_ID)#" datepicker>
					</td>
					<td valign="top">
						<cfif HTML_BOX_TYPE IS "INPUT">
						<cfinput type="text" name="frm_TxtActivity#ACTIVITY_ID#" value="#Evaluate("frm_TxtActivity"&ACTIVITY_ID)#" size="40">
						<cfelseif HTML_BOX_TYPE IS "TEXTBOX">
						<textarea name="frm_TxtActivity#ACTIVITY_ID#" rows="4" cols="42">#Evaluate("frm_TxtActivity"&ACTIVITY_ID)#</textarea>
						</cfif>
						<cfinput type="hidden" name="frm_HidActivityDesc#ACTIVITY_ID#" value="#ACTIVITY_TEXT#">
					</td>
				</tr>
				<cfset i++>
				</cfloop>
			</table>
		</fieldset>

		<fieldset>
		 <legend>Package Information</legend>
		    <br>	
			<table width="98%" align="center">
				<tr>
					 <td width="25%" valign="top"><label for="frm_SelDivision">TPU</label> *</td>
					 <td>
				     <cfselect name="frm_SelDivision" id="frm_SelDivision" class="mandatory">
				      <option value="">-- Select --</option>
					  <cfloop query="Application.qry_Division">
					   	 <option value="#AREAID#" <cfif frm_SelDivision IS AREAID>selected</cfif>>#AREANAME#</option>
					  </cfloop>
					 </cfselect>		
					 </td>
				</tr>			
				<tr>
				 	 <td valign="top"><label for="frm_SelSection">Section</label> *</td>
				     <td>				     
					   <cfdiv bind="url:sections_cfdiv.cfm?thisDiv={frm_SelDivision}&currentSection=#frm_SelSection#" ID="section" />				
					 </td>	 
				</tr>
				<tr>
				 	 <td valign="top"><label for="frm_SelWantedType">Wanted Type</label> *</td>
				     <td>
				     <cfselect name="frm_SelWantedType"  id="frm_SelWantedType" class="mandatory">
				      <option value="">-- Select --</option>		     					  
					  <option value="Warwickshire / West Mercia PNC Wanted" <cfif frm_SelWantedType IS "Warwickshire / West Mercia PNC Wanted">selected</cfif>>Warwickshire / West Mercia PNC Wanted</option>
					  <option value="Other Force Arrest Request" <cfif frm_SelWantedType IS "Other Force Arrest Request">selected</cfif>>Other Force Arrest Request</option>
					 </cfselect>		
					 </td>	 
				</tr>				
				<tr>
				 	 <td valign="top"><label for="frm_SelCrimeType">Offence Type</label> *</td>
				     <td>
				     <cfselect name="frm_SelCrimeType"  id="frm_SelCrimeType" class="mandatory">
				      <option value="">-- Select --</option>		     
					  <cfloop query="application.qry_CrimeType">
					   	 <option value="#Crime_Type_ID#" <cfif frm_SelCrimeType IS CRime_Type_ID>selected</cfif>>#Description#</option> *
					  </cfloop>
					 </cfselect>		
					 </td>	 
				</tr>
				
				<tr>
					<td valign="top"><label for="frm_SelRiskLevel">Risk Level</label> *</td>
				     <td>
				     <cfselect name="frm_SelRiskLevel"  id="frm_SelRiskLevel" class="mandatory">
				      <option value="">-- Select --</option>		     
					  <cfloop query="application.qry_RiskLevel">
				        <option value="#RISK_LEVEL#" returnDays="#NO_DAYS_RETURN#" <cfif frm_SelRiskLevel IS RISK_LEVEL>selected</cfif> class="risk#risk_level#">#RISK_LEVEL#</option> *        	        
					  </cfloop>
					 </cfselect>						 	
					 </td>	 	
		        </tr> 			

			    <tr>
			 	   <td valign="top"><label for="frm_TxtCrimeNo">Crime No</label><br>(format 22XX/SSSSSA/YY or 23XX/SSSSSA/YY) *</td>
			       <td>
			       	    <input type="text" name="frm_TxtCrimeNo" id="frm_TxtCrimeNo" value="#frm_TxtCrimeNo#" size="16" class="mandatory">						
				   </td>
			     </tr>

				 <tr>
			 	   <td valign="top"><label for="frm_TxtOISNo">OIS / STORM No</label><br>(format 1234S 010413 or WK-20140126 0316) *</td>
			       <td>
			       	    <input type="text" name="frm_TxtOISNo" id="frm_TxtOISNo" value="#frm_TxtOISNo#" size="16" class="mandatory">
						<b>You must enter one or both of Crime No or OIS / STORM No</b>						
				   </td>
			     </tr>
				<!---				
			    <tr>
			 	   <td valign="top"><label for="frm_TxtTargDate">Return Date</label> *</td>
			       <td>
			       	    <input type="text" name="frm_TxtTargDate" id="frm_TxtTargDate" value="#frm_TxtTargDate#" size="7" class="mandatory" disabled>
						<input type="hidden" name="frm_HidTargDate" id="frm_HidTargDate" value="#frm_HidTargDate#">
				   </td>
			     </tr>
				--->
				 
				 <tr>
				 	     <td valign="top"><label for="frm_SelSendSgt">Sgt For Review</label> *</td>
						 <td>
						 	<div id="allocateOfficer" initialValue="#frm_SelSendSgt#"></div>
							<!---
        					<cfdiv bind="url:officers_cfdiv.cfm?thisDiv={frm_SelDivision}&Order=surname&Rank=SGT&ItemName=frm_SelSendSgt&currentItem=#frm_SelSendSgt#&mandatory=yes&size=100" ID="sgt" />
							--->
	 					 </td>					
				 </tr>
				 												
			</table>
		</fieldset>
		
		<fieldset>
		 <legend>Attachments</legend>
		    <br>	
			<table width="98%" align="center">
				<tr id="mgFileRow">
					 <td width="25%" valign="top"><label for="frm_FilMGFile">Scanned MG File</label> *</td>
					 <td>
				      <cfinput type="file" name="frm_FilMGFile" size="50" class="mandatory">	
					 </td>
				</tr>			
				<tr>
					 <td width="25%" valign="top"><label for="frm_FilRiskAssessment">Risk Assessment</label> *</td>
					 <td>
				      <cfinput type="file" name="frm_FilRiskAssessment" size="50" class="mandatory">	
					 </td>
				</tr>	
				<tr>
					 <td width="25%" valign="top"><label for="frm_FilPNC209">A209 PNC Wanted Form</label> *</td>
					 <td>
				      <cfinput type="file" name="frm_FilPNC209" size="50" class="mandatory">	
					 </td>
				</tr>							
				 												
			</table>
		</fieldset>		
        <br>
	    <!--- create the hidden variables for the form defaults --->
		<cfloop list="#defaultsFile#" index="hiddenVars" delimiters="#chr(10)#">
			<cfset fileLine=StripCR(hiddenVars)>						
			<input type="hidden" name="#ListGetAt(fileLine,1,",")#" value="#Trim(ListGetAt(fileLine,2,","))#">
		</cfloop>	
	
	    <!--- add other hidden variables we need to create the package --->
		<input type="hidden" name="frm_HidTargDate" id="frm_HidTargDate" value="#frm_HidTargDate#">	
		<input type="hidden" name="frm_SelSendCon" value="#frm_SelSendCon#">
	    <input type="hidden" name="frm_TxtNomRef" value="#nominalRef#">
		<input type="hidden" name="nominalRef" value="#nominalRef#">	
		<!--- set the problem outline to be the nominals full name, dob, nominal ref and pnc id --->
		<input type="hidden" name="frm_TxtProbOutline" value="#nominal.getFULL_NAME()# (#nominal.getNOMINAL_REF()#) #nominal.getDATE_OF_BIRTH_TEXT()# #nominal.getPNCID_NO()#">	        
		<input type="hidden" name="categoryId" value="#categoryId#">
		<input type="hidden" name="userId" value="#session.user.getUserId()#">
		<input type="hidden" name="emailAddress" value="#session.user.getEmailAddress()#">
		<input type="hidden" name="hidAction" value="">
		<input type="submit" name="frm_SubPackage" value="Create Package">
		
	   </cfform>
    </div>
   </div>
</body>
</cfoutput>

</html>


<!---

 <cfcactch>
 </cfcatch>

</cftry>

--->