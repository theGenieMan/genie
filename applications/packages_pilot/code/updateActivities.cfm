<!--- <cftry> --->
<!---

Module      : updateActivities.cfm

App         : STEP Packages

Purpose     : Shows user a screen to be able to update package activities

Requires    : packageId of the package being worked on and a seq no for the activity set 

Author      : Nick Blackham

Date        : 10/10/2012

Revisions   : 

--->

<!--- get the packages details --->
<cfset package=Application.stepService.getPackageDetail(packageId=packageId)>

<!--- has the user asked for the form to be processed? --->
<cfif isDefined("hidAction")>	
	<!--- yes, process the form --->	
	
	<!--- send the form off to the service for processing --->
	<cfset processResult=application.stepService.updateActivities(packageId=packageId,Form=Form,userId=userId,seqNo=seqNo)>	
		
	<!--- if the result of the processing comes back as valid then display the success message to the
	      user --->
	      
	<cfif processResult.valid>		
		  <cfset sMessage="Activities have been successfully updated">
	</cfif>
	
	<cfset packageActivities=Application.stepService.getPackageActivities(packageId=packageId,seqNo=seqNo)>
	
	<!--- if it's not valid then we display the form again with errors and allow the user
	      to resubmit --->
		
    <!--- end of form processing --->		
			
</cfif>	

    <!--- get the activities for this packages and seq no --->
    <cfset packageActivities=Application.stepService.getPackageActivities(packageId=packageId,seqNo=seqNo)>
		

	<!--- setup the activity variables for the form --->
	<cfloop query="packageActivities">
		<cfset "frm_SelActivity#ACTIVITY_ID#"=ACTIVITY_COMPLETE>
		<cfset "frm_TxtActivity#ACTIVITY_ID#"=ACTIVITY_NOTES>
		<cfset "frm_TxtActivityDate#ACTIVITY_ID#"=DateFormat(ACTIVITY_DATE,"DD/MM/YYYY")>
		<cfset "frm_HidActivityDesc#ACTIVITY_ID#"=ACTIVITY_DESC>
	</cfloop>	

<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="step.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/ui/css/smoothness/jquery-ui-1.8.23.custom.css">	
	
	<script type="text/javascript" src="/jQuery/jQuery.js"></script>
	<script type="text/javascript" src="/jQuery/ui/js/jquery-ui-1.8.23.custom.min.js"></script>
	<script type="text/javascript">         
		$(document).ready(function() {  		               
            $('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'});
            });         
	</script>
</head>

<cfoutput>
<body>

<a name="top"></a>
<cfinclude template="header.cfm">

<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#PackageID#">	
     <input type="hidden" name="Package_URN" value="#package.Package_URN#">	 		  
	 <input type="submit" name="frm_Submit" value="Back To #Package.Package_URN# Details">	
</form>


    <cfif isDefined('sMessage')>
		<div class="error_title">
			#sMessage#
		</div>
	</cfif>

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
	  	
		<cfform action="#SCRIPT_NAME#?#session.URLToken#" method="post">
		
		<fieldset>
		 <legend>#package.PACKAGE_URN# - #package.RISK_LEVEL# Risk - #IIf(seqNO IS 1, DE('PRE SUBMISSION ACTIVITIES'), DE('REVIEW'))# Activities #activityDate#</legend>	
			<table width="98%" align="center">
				<tr>
					<td width="55%" class="table_title">Activity / Check</td>
					<td width="5%" class="table_title">Done?</td>
					<td width="10%" class="table_title">Date</td>
					<td width="30%" class="table_title">Notes</td>
				</tr>
				<cfset i=1>
				<cfloop query="packageActivities">
				<tr class="row_colour#i mod 2#">
					<td valign="top">
					  #Evaluate("frm_HidActivityDesc#ACTIVITY_ID#")#
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
						<cfinput type="hidden" name="frm_HidActivityDesc#ACTIVITY_ID#" value="#Evaluate("frm_HidActivityDesc"&ACTIVITY_ID)#">
					</td>
				</tr>
				<cfset i++>
				</cfloop>
			</table>
		</fieldset>
        <br>
		
		<input type="hidden" name="packageId" value="#packageId#">			
		<input type="hidden" name="seqNo" value="#seqNo#">
		<input type="hidden" name="activityDate" value="#activityDate#">							        
		<input type="hidden" name="categoryId" value="#package.Cat_Category_Id#">
		<input type="hidden" name="userId" value="#session.user.getUserId()#">
		<input type="hidden" name="hidAction" value="">
		<input type="submit" name="frm_SubPackage" value="Update Activities">
		
	   </cfform>
    </div>
   </div>

</body>
</html>

</cfoutput>

<!---

 <cfcactch>
 </cfcatch>

</cftry>

--->
