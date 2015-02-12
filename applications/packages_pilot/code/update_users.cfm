<!---

Module      : update_users.cfm

App          : Packages

Purpose     : Allows update of users allowed on admin for packages db

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->
<cfif isDefined("frm_HidAction")>

 <!-- validate dates for each nominal --->
 <cfif frm_HidAction IS "Add">
 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

  <cfif Len(frm_TxtUserID) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a user id","|")>	
 </cfif>

   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->
     <cfif not isDefined("Form.frm_ChkSuper")>
	 	 <cfset Form.frm_ChkSuper='N'>
	 </cfif>
	 <cfif not isDefined("Form.frm_ChkPNC")>
	 	 <cfset Form.frm_ChkPNC='N'>
	 </cfif>
	 <cfif not isDefined("Form.frm_ChkFTAWarrant")>
	 	 <cfset Form.frm_ChkFTAWarrant='N'>
	 </cfif>	 
     <cfset s_Return=application.stepUserDAO.Add_Package_User(Form)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
			   <cfset frm_TxtUserID="">			   
			</cfif>			
	
   </cfif>
 </cfif>

 <cfif frm_HidAction IS "delete">
	
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some users to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->
        
		<cfset s_Return=application.stepUserDAO.Delete_Package_User(frm_ChkDel)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>	
	
	 <cfset frm_TxtUserID="">
	
 </cfif>

<cfelse>
 <cfset frm_TxtUserID="">
</cfif>

<cfset qry_Users=application.stepUserDAO.Get_Package_Users()>

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
			$('#adminOfficer').hrQuickSearch(
				{
					returnUserId: 'frm_TxtUserId',
					returnFullName: 'frm_TxtUserName',
					returnCollarNo: 'frm_TxtUserCollar',
					returnRank: 'frm_TxtUserRank',
					searchBox: 'adminSearch',
					searchBoxClass: 'mandatory',
					searchBoxName: 'adminNameSearch',
					returnUserIdType: 'trueUID',
					initialValue: $('#adminOfficer').attr('initialValue')
				}
			);
				
		})
    </script>	
    	
</head>

<body>
<cfoutput>
<cfinclude template="header.cfm">

 <cfif isDefined("s_Message")>
  <div class="error_title">
    #s_Message#
  </div>
<br>
 </cfif>


<fieldset>
 <legend>Add A Packages User</legend>
  <form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">

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
	<td width="15%"><label for="frm_TxtUserID">User ID</label> *</td>
	 <td>
	 	<div id="adminOfficer" initialValue="#frm_TxtUserId#"></div>
	 </td>
   </tr>
   <tr>
	<td width="15%"><label for="frm_ChkSuper">Super User?</label> *</td>
	 <td>
		 <input type="checkbox" name="frm_ChkSuper" id="frm_ChkSuper" value="Y">
	 </td>
   </tr>   
   <tr>
	<td width="15%"><label for="frm_ChkPNC">PNC Wanted User?</label> *</td>
	 <td>
		 <input type="checkbox" name="frm_ChkPNC" id="frm_ChkPNC" value="Y">
	 </td>
   </tr>
   <tr>
	<td width="15%"><label for="frm_ChkFTAWarrant">FTA Warrant User?</label> *</td>
	 <td>
		 <input type="checkbox" name="frm_ChkFTAWarrant" id="frm_ChkFTAWarrant" value="Y">
	 </td>
   </tr>           
   <tr>
    <td colspan="4" align="right">
     <input type="hidden" name="frm_HidAddedBy" value="#session.user.getUserId()#">
	 <input type="hidden" name="frm_HidAction" value="add">
	 <input type="submit" name="frm_Submit" value="Add User">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>	
 <legend>Existing Users</legend>
 <br>
 <cfif qry_Users.RecordCount IS 0>
  <b>No Users Exist</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="15%">User ID</td>
	 <td class="table_title" width="37%">Name</td>	 
	 <td class="table_title" width="10%">Added By</td>	
	 <td class="table_title" width="8%">Super?</td>
	 <td class="table_title" width="8%">PNC Wanted?</td>
	 <td class="table_title" width="8%">FTA Wrnt?</td>
	 <td class="table_title" width="15%">Date Added</td>		 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_Users">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#USER_ID#</strong></td>
	 <td>#NAME#</td>	 
	 <td>#ADDED_BY#</td>	 	 
	 <td>#SUPER_USER#</td>
	 <td>#PNC_WANTED_USER#</td>
	 <td>#FTA_WARRANT_USER#</td>
	 <td>#DateFormat(CREATED_DATE,"DD/MM/YYYY")#</td>		  	 
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#USER_ID#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="Delete">
	 <input type="submit" name="frm_Submit" value="Remove Users">	
	</td>
   </tr>
 </table> 
 </cfif> 
</fieldset>
</form>
</cfoutput>	
</body>
</html>
