<!---

Module      : update_actions.cfm

App          : Packages

Purpose     : Allows update of actions on an existing package.

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <!-- validate dates for each nominal --->

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

  <cfif Len(frm_SelActionType) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select an Update Type","|")>	
 </cfif>

  <cfif Len(frm_TxtAction) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter some Update Text","|")>	
 </cfif>

 
   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->

     <cfset s_Return=application.stepPackageDAO.Update_Package_Actions(Form)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
  			   <cfset frm_SelActionType="">
			   <cfset frm_TxtAction="">			   
			</cfif>			
	
   </cfif>


<cfelse>
 <cfset frm_SelActionType="">
 <cfset frm_TxtAction="">
</cfif>

<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
<script>
	function fullscreen(url,winname) {
	  w = screen.availWidth-10;
	  h = screen.availHeight-50;
	  features = "width="+w+",height="+h;
	  features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
	
	  window.open(url, winname , features);
	}
</script>
</head>

<body>
<cfinclude template="header.cfm">

<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	
     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		  
	 <input type="submit" name="frm_Submit" value="Back To #qry_Package.Package_URN# Details">	
</form>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
<br>
 </cfif>

<div class="error_title">
 Any significant updates MUST also be added to the main Crime Report on CRIMES.
 <br><br>
 If your update / message requires further action by your supervisor or Intelligence Unit, please ensure that you complete the 'Package Allocation' section, allocating the package to the appropriate individual.  Thank you.
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

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Add Update For Package #qry_Package.Package_URN#</legend>

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
	<td width="15%"><label for="frm_SelActionType">Update Type</label> *</td>
	 <td>
	  <select name="frm_SelActionType" id="frm_SelActionType" class="mandatory">
	   <option value="">-- Select --</option>
	   <cfloop list="#Application.lis_ActionTypes#" index="s_Action" delimiters=",">
	    <option value="#s_Action#"  <cfif s_Action IS frm_SelActionType>selected</cfif>>#s_Action#</option>
	   </cfloop>
	  </select>
	 </td>
   </tr>
   <tr>
	 <td valign="top"><label for="frm_TxtAction">Text</label> *</td>
	 <td><textarea name="frm_TxtAction" rows="4" cols="60" class="mandatory">#frm_TxtAction#</textarea></td>
   </tr>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="update">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">		 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 	
     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		
	 <input type="submit" name="frm_Submit" value="Add Update">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

</body>
</html>
</cfoutput>	