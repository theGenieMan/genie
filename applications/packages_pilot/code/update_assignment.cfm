<!---

Module      : update_assignment.cfm

App          : Packages

Purpose     : Allosw update of assignments on an existing package.

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <cfset s_ValuePresent="NO">

 <cfif Len(frm_SelSendGeneric) GT 0>
	<cfset s_ValuePresent="YES">
	<cfset frm_TxtAssRank="GENERIC">
	<cfset sUserId="GENERIC">
	<cfset frm_TxtAssName="GENERIC">
	<cfset frm_TxtAssEmail=frm_SelSendGeneric> 
 </cfif>
 <cfif Len(frm_TxtAssUserId) GT 0>
	<cfif s_ValuePresent IS "YES">	
	   <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Please select from only one of the Generic or Person","|")>
	<cfelse>
	   <cfset sUserId=frm_TxtAssUserId>
	</cfif> 	 
 </cfif>
 
 

 <cfif Len(frm_TxtAssNotes) GT 240>
	 <cfset str_Valid="NO">
	 <cfset lis_Errors=ListAppend(lis_Errors,"The notes text that you have entered is too long. Only 240 Characters are available. You have entered #Len(frm_TxtAssNotes)# characters. Please enter long notes in the Package Updates section under type of `Note`.","|")>
	  <cfset s_ShowForm="YES">
 </cfif>

   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->

     <cfset s_Return=application.stepPackageDAO.Update_Package_Assignment(Package_ID,
	                                                                      sUserId,
	                                                                      frm_TxtAssRank,
	                                                                      session.user.getUserId(),
	                                                                      session.user.getFullName(),
	                                                                      frm_TxtAssNotes,
	                                                                      frm_TxtAssName,
	                                                                      frm_TxtAssEmail)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Message>
			   <cfset frm_SelSendGeneric="">
 			   <cfset frm_TxtAssNotes="">
 			   <cfset frm_TxtAssUserId="">
			</cfif>			
	
   </cfif>


<cfelse>
 <cfset frm_SelSendGeneric="">
 <cfset frm_TxtAssNotes="">
 <cfset frm_TxtAssUserId="">
</cfif>

<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset qry_AssignList=application.stepReadDAO.Get_Package_Assignments(Package_ID)>
<cfset qry_Email=application.stepReadDAO.Get_Generic_Emails()>

<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/ui/css/base/jquery-ui.css">  
    <script type="text/javascript" src="/jQuery/jQuery.js"></script>		
	<script type="text/javascript" src="/jquery-ui-1.9.1.custom/js/jquery-ui-1.9.1.custom.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript">         
		$(document).ready(function() {
			$.support.cors = true;
			$('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});		
			
			// jQuery to create the hr for the allocated officer
			$('#assignOfficer').hrQuickSearch(
				{
					returnUserId: 'frm_TxtAssUserId',
					returnFullName: 'frm_TxtAssName',
					returnCollarNo: 'frm_TxtAssCollar',
					returnRank: 'frm_TxtAssRank',
					returnEmail: 'frm_TxtAssEmail',
					searchBox: 'assignSearch',
					searchBoxClass: 'mandatory',
					searchBoxName: 'asssignNameSearch',
					initialValue: $('#assignOfficer').attr('initialValue')
				}
			);
				
		})
    </script>	
</head>

<body>
<cfoutput>	
<cfinclude template="header.cfm">

<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">
 	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 	 
	 <input type="submit" name="frm_Submit" value="Back To #Package_URN# Details">	
</form>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
<br>
 </cfif>

<div align="center">
 <b>Current Allocation : </b> <cfloop query="qry_AssignList" startrow="1" endrow="1">
                                    #ASSIGNED_TO_NAME# (#DateFormat(ASSIGNED_DATE,"DD/MM/YYYY")#)
								   </cfloop>
</div>


<fieldset>
 <legend>Package Summary  #qry_Package.Package_URN#</legend>
 <cfloop query="qry_Package">
 <table width="95%" align="center">
  <tr>
   <td width="15%"><strong>Package</strong></td>
   <td>#Package_URN#</td>
  </tr>
  <tr>
   <td width="15%"><strong>Outline</strong></td>
   <td>#PROBLEM_OUTLINE#</td>
  </tr>
 </table>
 </cfloop>
</fieldset>


<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="ass_form">
<fieldset>
 <legend>Change Assignment For Package #qry_Package.Package_URN#</legend>

	<cfif isDefined("lis_Errors")>
	 <cfif ListLen(lis_Errors,"|") GT 0>
	<br>
	  <div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		#Replace(lis_Errors,"|","<br>","ALL")#
		</div>
	 </cfif>
	</cfif> 
 	<br>
  
   <table width="98%" align="center">   
  <tr>
   <td width="20%"><label for="frm_SelSendGeneric">GENERIC</label></td>
   <td><label>PERSON</label></td>	      
  </tr>
  <tr>
   <td valign="top">
        <cfdiv bind="url:generic_off.cfm?ItemName=frm_SelSendGeneric&currentItem=#frm_SelSendGeneric#" ID="generic" />    
   </td>
   <td valign="top">
   		<div id="assignOfficer" initialValue="#frm_TxtAssUserId#"></div>
   </td>
   </tr> 
   <tr>
	 <td colspan="2">
		<label for="frm_TxtAssNotes">Notes</label> : <input type="text" name="frm_TxtAssNotes" value="#frm_TxtAssNotes#" size="80">
	 </td>
   </tr>
   <tr>
    <td colspan="2" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
     <input type="hidden" name="Package_ID" value="#Package_ID#">
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 	 
	 <input type="hidden" name="Assign_By" value="#session.user.getUserId()#">
	 <input type="hidden" name="Assign_By_Name" value="#session.user.getFullName()#">	 
	 <input type="submit" name="frm_Submit" value="Update Assignment">	
	</td>
   </tr>
 </table> 

</fieldset>
</form>
</cfoutput>	
</body>
</html>
