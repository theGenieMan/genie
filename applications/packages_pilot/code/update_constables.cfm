<!---

Module      : update_constables.cfm

App          : Packages

Purpose     : Allows update of constables who are allowed to return a package without it going back through the 
                  chain of command

Requires    : 

Author      : Nick Blackham

Date        : 19/03/2008

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

     <cfset s_Return=application.stepPackageDAO.Add_Package_Constable(Form)>
	
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
        
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Constable(frm_ChkDel)>
		
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

<cfset qry_Users=application.stepReadDAO.Get_Package_Constables()>

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
			$('#constableSearch').hrQuickSearch(
				{
					returnUserId: 'frm_TxtUserId',
					returnFullName: 'frm_TxtName',
					returnCollarNo: 'frm_TxtCollar',
					returnRank: 'frm_TxtSendRank',
					searchBox: 'conSearch',
					scrollToResults: false,
					searchBoxName: 'conNameSearch',
					initialValue: $('#constableSearch').attr('initialValue')
				}
			);
				
		})
    </script>					
</head>

<body>
<cfoutput>
<cfinclude template="header.cfm">

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
<br>
 </cfif>

<br>To add a constable who is allowed to send a package back without going through a Sgt or Insp enter their user Id below<br>

<fieldset>
 <legend>Add A Constable</legend>
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
	<td width="15%" valign="top"><label for="frm_TxtUserID">User ID</label> *</td>
	 <td>
		 <div id="constableSearch" initialValue="#frm_TxtUserId#"></div>
	 </td>
   </tr>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="add">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">	
	 <input type="submit" name="frm_Submit" value="Add User">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

<br><br>Below is a list of constables who have access to return a package without going through a Sgt or Insp<br>
<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>	
 <legend>Existing Constables</legend>
 <br>
 <cfif qry_Users.RecordCount IS 0>
  <b>No Users Exist</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="15%">User ID</td>
	 <td class="table_title" width="50%">Name</td>	 
	 <td class="table_title" width="20%">Added By</td>
	 <td class="table_title" width="15%">Date Added</td>	 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_Users">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#PC_USERID#</strong></td>
	 <td>#PC_USERNAME#</td>	 
	 <td>#ADDED_BY#</td>	 	 
	 <td>#DateFormat(DATE_ADDED,"DD/MM/YYYY")#</td>	 	 
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#PC_USERID#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="Delete">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">	
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
