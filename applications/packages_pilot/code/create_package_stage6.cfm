<!--- <cftry> --->

<!---

Module      : create_package_stage3.cfm

App          : Packages

Purpose     : Package Creation Screen Stage 6. Addition of CC Users

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>
	
 <cfif frm_HidAction IS "Add">
	 <!--- check required fields are completed and any dates entered are valid --->
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif Len(frm_TxtCollar) IS 0 AND Len(frm_SelEmail) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a collar no of the person / generic email to be cc'd on the package","|")>	
	 </cfif>
	 
	 <cfif Len(frm_TxtCollar) GT 0 AND Len(frm_TxtName) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter the name of the person to be cc'd on the package","|")>	
	 </cfif>	 
	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the cc user to the package  --->
		
		<cfif Len(frm_SelEmail) GT 0>
		 <cfset form.frm_TxtCollar="Generic">
		 <cfset form.frm_TxtUID="Generic">		 
		 <cfset form.frm_TxtName="Generic ("&frm_SelEmail&")">
		</cfif>
		
		<cfset s_Return=application.stepPackageDAO.Add_Package_CC(Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<cfset s_Message="*** ERROR ***<br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		   <cfset frm_TxtCollar="">		   
		   <cfset frm_TxtName="">
       <cfset frm_TxtNotes=""> 
	<cfset frm_SelEmail="">
		</cfif>		
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some people to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		<cfset s_Return=application.stepPackageDAO.Delete_Package_CC(frm_ChkDel)>
		
		    <cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
			</cfif>		

		
		 <cfset frm_TxtCollar="">
		 <cfset frm_TxtName="">
     <cfset frm_TxtNotes="">
		 <cfset frm_SelEmail="">
	 </cfif>

 </cfif>

<cfelse>
 <cfset frm_TxtCollar="">
 <cfset frm_TxtName="">
 <cfset frm_TxtNotes="">
 <cfset frm_SelEmail="">
</cfif>

<cfset qry_CCList=application.stepReadDAO.Get_Package_CC(Package_ID)>
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
			$('#ccOfficer').hrQuickSearch(
				{
					returnUserId: 'frm_TxtUID',
					returnFullName: 'frm_TxtName',
					returnCollarNo: 'frm_TxtCollar',
					returnRank: 'frm_TxtRank',
					returnEmail: 'frm_TxtEmail',
					searchBox: 'allocateSearch',
					searchBoxClass: 'mandatory',
					searchBoxName: 'allocateNameSearch',
					initialValue: $('#ccOfficer').attr('initialValue')
				}
			);
				
		})
    </script>	
</head>

<body>
<cfoutput>	
<a name="top"></a>
<cfinclude template="header.cfm">

<cfif not isDefined("isEdit")>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 7 - CC Users</div>

You can CC people / Generic Emails into a package. They will receive the email making them aware that the package exists and will have access
to view the package from their STEP screen.<br>
Enter the collar number of the person to CC or the email address and click add. You can CC mutiple people / email addresses on a package.<Br>
If you do not wish to CC anyone into the package then just click complete package.
<br><Br>
All fields in yellow and marked with an `*` are mandatory

<div align="center">
<form action="complete_package.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
 <input type="hidden" name="frm_HidAssBy" value="#session.user.getUserId()#">
 <input type="hidden" name="frm_HidAssByName" value="#session.user.getFullName()#">	
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubComp" value="Complete Package">
</form>
</div>

<cfelse>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit CC</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">
 	 <input type="hidden" name="Package_URN" value="#Package_URN#">
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>
</cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form">

<fieldset>
 <legend>Add CC Person</legend>
<cfif isDefined("lis_Errors") and isDefined("frm_HidAction")>
<cfif frm_HidAction IS "add">
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
</cfif>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
 </cfif>

 <table width="98%" align="center">
  <tr>
	 <td width="25%" valign="top"><label>Enter CC User</label> *</td>
	 <td>
	 <div id="ccOfficer" initialValue="#frm_TxtCollar#"></div>
	 </td>
  </tr>

	  
   <tr>
	<td colspan="2"><span style="font-size:120%; font-weight:bold">OR</span></td>
	 
   </tr>	  

	  <tr>
		 <td  valign="top"><label for="frm_SelEmail">Generic Email</label> *</td>
		 <td>
	  <select name="frm_SelEmail" id="frm_SelEmail">
	   <option value="">-- Select --</option>
	   <cfloop query="qry_Email">
	    <option value="#EMAIL_ADDRESS#" <cfif frm_SelEmail IS EMAIL_ADDRESS>selected</cfif>>#DESCRIPTION#</option>
	   </cfloop>
	  </select>
			 
		 </td>
	  </tr>  	  
	  <tr>
		 <td  valign="top"><label for="frm_TxtNotes">Notes</label></td>
		 <td>
 		   <textarea name="frm_TxtNotes" rows="4" cols="60">#frm_TxtNotes#</textarea>
		 </td>
	  </tr>  	  
 </table>
	<div align="center" style="padding-top:5px;">
	 <input type="hidden" name="frm_HidAction" value="add">
	 <input type="hidden" name="frm_HidAddedBy" value="#session.user.getUserId()#">
	 <input type="hidden" name="frm_HidAddedByName" value="#session.user.getFullName()#">	
     <input type="hidden" name="Package_ID" value="#Package_ID#">
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">			
	 <input type="hidden" name="Package_URN" value="#Package_URN#">
	 </cfif>	 		 	 
	 <input type="submit" name="frm_Submit" value="Add CC To Package">
	</div>
</fieldset>
</form>
<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Persons CC'd' To Package</legend>
 <br>
<cfif qry_CCList.RecordCount IS 0>
<b>Nobody is CC'd into this package</td>
<cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="98%">Person</td>
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_CCList">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#CC_USERNAME#</strong></td>
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#CC_ID#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="5" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
		 <input type="hidden" name="Package_URN" value="#Package_URN#">	
	 </cfif>	 	
	 <input type="submit" name="frm_Submit" value="Remove CC From Package">	
	</td>
   </tr>
 </table>  
</cfif>
</fieldset>
</form>

</cfoutput>
</body>
</html>