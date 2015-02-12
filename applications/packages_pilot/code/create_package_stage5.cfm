<!--- <cftry> --->

<!---

Module      : create_package_stage6.cfm

App          : Packages

Purpose     : Package Creation Screen Stage 6. Addition of Attachments

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
	
	 <cfif Len(frm_TxtDesc) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a description","|")>	
	 </cfif>
	 
	 <cfif Len(frm_FilFile) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a file","|")>	
	 </cfif>	 
	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the package and then move the user on to stage 2, giving the created
		       package id --->
		
		<cfset s_Return=application.stepPackageDAO.Add_Package_Attachment(Form,frm_FilFile)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<cfset s_Message="*** ERROR ***<br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		   <cfset frm_TxtDesc="">		   
		   <cfset frm_FilFile="">
		</cfif>		
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some attachments to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">

		<cfset s_Return=application.stepPackageDAO.Delete_Package_Attachment(frm_ChkDel,Package_ID)>
		
		    <cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
			</cfif>		

		
		 <cfset frm_TxtDesc="">
		 <cfset frm_FilFile="">
		
	 </cfif>

 </cfif>

<cfelse>
 <cfset frm_TxtDesc="">
 <cfset frm_FilFile="">
</cfif>

<cfset qry_AttachList=application.stepReadDAO.Get_Package_Attachments(Package_ID)>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
<a name="top"></a>
<cfinclude template="header.cfm">

<cfif not isDefined("isEdit")>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 6 - Attachments</div>

If you have no attachments to add to the packge then click `Continue To Stage 7`. If you have attachment to add
then enter their description and filename one by one and when all have been added click `Continue To Stage 7`.
<br><Br>
All fields in yellow and marked with an `*` are mandatory


<div align="center">
<form action="create_package_stage6.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubComp" value="Save & Continue To Stage 7">
</form>
</div>

<cfelse>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Attachments</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">
 	 <input type="hidden" name="Package_URN" value="#Package_URN#">
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>
</cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form" enctype="multipart/form-data">

<fieldset>
 <legend>Add Attachment Information</legend>
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
	 <td width="25%"><label for="frm_TxtDesc">Description</label> *</td>
	 <td>
	  <input type="text" name="frm_TxtDesc" value="#frm_TxtDesc#" size="50" class="mandatory">
  </tr>
  <tr>
	 <td width="25%"><label for="frm_FilFile">File</label> *</td>
	 <td>
	  <input type="file" name="frm_FilFile"  size="25" class="mandatory"> 
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
	 <input type="submit" name="frm_Submit" value="Add Attachment To Package">
	</div>
</fieldset>
</form>
<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Attachments Added To Package</legend>
 <br>
<cfif qry_AttachList.RecordCount IS 0>
<b>No Attachments have been added to this package</b>
<cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="48%">Description</td>
	 <td class="table_title" width="48%">File</td>	 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_AttachList">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#ATTACHMENT_DESC#</strong></td>
	 <td>#ATTACHMENT_FILENAME#</td>	 
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#Attachment_ID#|#ATTACHMENT_FILENAME#">
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
	 <input type="submit" name="frm_Submit" value="Remove Attachment From Package">	
	</td>
   </tr>
 </table>  
</cfif>
</fieldset>
</form>

</body>
</html>
</cfoutput>

<!--- Error Trapping  
<cfcatch type="any">
 <cfset str_Subject="#Request.App.Form_Title# - Error">
 <cfset ErrorScreen="SearchForm.cfm"> 
 <cfinclude template="cfcatch_include.cfm">
</cfcatch>
</cftry> --->