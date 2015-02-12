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

 <cfif frm_hidAction is "search">

   		<cfldap action="QUERY" 
		name="ldapEmails" 
		attributes="displayName,mail"
				start="CN=Microsoft Exchange System Objects,DC=westmerpolice01,DC=local"
				filter="(mail=*#LCase(frm_TxtSearch)#*)"
				server="10.1.230.216"
				username="westmerpolice01\cold_fusion"
				password="a11a1re"> 

 </cfif>

 <!-- validate dates for each nominal --->
 <cfif frm_HidAction IS "Add">
 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

  <cfif Len(frm_TxtEmail) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter an email address","|")>	
 </cfif>

  <cfif Len(frm_TxtDesc) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a description","|")>	
 </cfif>

  <cfset Form.frm_TxtEmail=frm_TxtEmail>
  <cfset Form.frm_TxtDesc=frm_TxtDesc>
 
   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->

     <cfset s_Return=application.stepPackageDAO.Add_Generic_Email(Form)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
			   <cfset frm_TxtEmail="">			   
			   <cfset frm_TxtDesc="">			
			   <cfset frm_TxtSearch="">   			   
			</cfif>			
	
   </cfif>
 </cfif>

 <cfif frm_HidAction IS "delete">
	
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some emails to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->        
		<cfset s_Return=application.stepPackageDAO.Delete_Generic_Emails(frm_ChkDel)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>	
	
	 <cfset frm_TxtEmail="">
	 <cfset frm_TxtDesc="">
	 <cfset frm_TxtSearch="">
	
 </cfif>

<cfelse>
 <cfset frm_TxtEmail="">
 <cfset frm_TxtDesc="">
 <cfset frm_TxtSearch="">
</cfif>

<cfset qry_Emails=application.stepReadDAO.Get_Generic_Emails()>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
<cfinclude template="header.cfm">

 <cfif isDefined("s_Message")>
  <div class="error_title">
    #s_Message#
  </div>
<br>
 </cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>	
 <legend>Search For Email Address</legend>
 <table width="98%" align="center">
   <tr>
	<td width="15%"><label for="frm_TxtSearch">Search Text</label> *</td>
	 <td>
		 <input type="text" name="frm_TxtSearch" id="frm_TxtSeach" value="#frm_TxtSearch#" size="20" class="mandatory">
	 </td>
   </tr> 
   <tr>
    <td colspan="2" align="right">
	 <input type="hidden" name="frm_HidAction" value="search">
	 <input type="submit" name="frm_Submit" value="Search">	
	</td>
 </table>
 <cfif isDefined("ldapEmails")>
  <hr>
  <strong>Available Email Addresses</strong>
  <br>
  <br>
  <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="40%">Email</td>
	 <td class="table_title" width="40%">Description</td>
	 <td class="table_title" width="20%"></td>
  </tr>
  <cfset i=1>
  <cfloop query="ldapEmails">
  <tr class="row_colour#i mod 2#">
	 <td>#mail#</td>
	 <td>#displayName#</td>
	 <td><a href="#SCRIPT_NAME#?#Session.urlToken#&frm_HidAction=Add&frm_TxtEmail=#mail#&frm_TxtDesc=#displayName#&frm_HidEmailType=P&frm_HidAddUser=#session.user.getUserId()#&frm_HidAddUser=#session.user.getFullName()#">Add Permanent</a> | 
	     <a href="#SCRIPT_NAME#?#Session.urlToken#&frm_HidAction=Add&frm_TxtEmail=#mail#&frm_TxtDesc=#displayName#&frm_HidEmailType=T&frm_HidAddUser=#session.user.getUserId()#&frm_HidAddUser=#session.user.getFullName()#">Add Temporary</a>
  </tr>
  <cfset i=i+1>
  </cfloop>
  </table>
 </cfif>


</fieldset>
</form>


<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>	
 <legend>Existing Generic Emails</legend>
 <br>
 <cfif qry_Emails.RecordCount IS 0>
  <b>No Emails Exist</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="25%">Email</td>
	 <td class="table_title" width="35%">Description</td>	 
	 <td class="table_title" width="20%">Added By</td>
	 <td class="table_title" width="10%">Date Added</td>	 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_Emails">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#EMAIL_ADDRESS#</strong></td>
	 <td>#DESCRIPTION#</td>	 
	 <td>#ADDED_BY_NAME#</td>	 	 
	 <td>#DateFormat(DATE_ADDED,"DD/MM/YYYY")#</td>	 	 
	 <td>	   
	   <input type="checkbox" name="frm_ChkDel" value="#EMAIL_ID#">
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
	 <input type="submit" name="frm_Submit" value="Remove Emails">	
	</td>
   </tr>
 </table> 
 </cfif> 
</fieldset>
</form>

</body>
</html>
</cfoutput>	