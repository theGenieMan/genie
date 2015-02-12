<!--- <cftry> --->

<!---

Module      : create_package_stage3.cfm

App          : Packages

Purpose     : Package Creation Screen Stage 3. Addition of Nominals

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
	
	 <cfif Len(frm_TxtNomRef) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a nominal reference no","|")>	
	 </cfif>
	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the package and then move the user on to stage 2, giving the created
		       package id --->
		
		<cfset s_Return=application.stepPackageDAO.Add_Package_Nominal(Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>			
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		   <cfset frm_TxtNomRef="">
		</cfif>		
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some nominals to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->        
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Nominal(frm_ChkDel,Package_ID,Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>

  <cfset frm_TxtNomRef="">
 </cfif>

<cfelse>
 <cfset frm_TxtNomRef="">
</cfif>

<cfset qry_NominalList=application.stepReadDAO.Get_Package_Nominals(Package_ID)>

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
<a name="top"></a>
<cfinclude template="header.cfm">

<cfif not isDefined("isEdit")>

<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 4 - Nominal Details</div>

If you have no nominals to add to the packge then click `Save & Continue To Stage 5`. If you have nominals to add
then enter their nominal references one by one and when all have been added click `Save & Continue To Stage 5 `.
<br>
<div class="error_title">
If you do not have a nominal reference number, please contact your local intelligence office to have a nominal created.
</div>
<bR>
All fields in yellow and marked with an `*` are mandatory


<div align="center">
<form action="create_package_stage4.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubStage3" value="Save & Continue To Stage 5">
</form>
</div>

<cfelse>

<br>
<div class="error_title">
If you do not have a nominal reference number, please contact your local intelligence office to have a nominal created.
</div>
<bR>
All fields in yellow and marked with an `*` are mandatory

<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Nominals</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	      <input type="hidden" name="Package_URN" value="#Package_URN#">	 	
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>

</cfif>


<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form">

<fieldset>
 <legend>Add Nominal Information</legend>
<cfif isDefined("lis_Errors") and isDefined("frm_HidAction")>
<cfif frm_HidAction IS "add">
 <cfif ListLen(lis_Errors,"|") GT 0>
<br><br>
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
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;" class="error_title">
    #StripCR(Trim(s_Message))#
  </div>
 </cfif>

 <table width="98%" align="center">
  <tr>
	 <td width="25%"><label for="frm_TxtNomRef">Nominal Reference</label> *</td>
	 <td>
	  <input type="text" name="frm_TxtNomRef" value="#frm_TxtNomRef#" size="12"> (e.g. 123456A)
	  &nbsp;&nbsp;
	  <input type="button" name="frm_BtnGENIE" value="Open GENIE Person Search" onClick="fullscreen('#Application.GENIE_PERSON_Search#','GENIE_Person')">
	 </td>
  </tr>
 </table>
	<div style="padding-top:5px;">
	 <input type="hidden" name="frm_HidAction" value="add">
	 <input type="hidden" name="frm_HidAddedBy" value="#session.user.getUserId()#">
	 <input type="hidden" name="frm_HidAddedByName" value="#session.user.getFullName()#">	 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
	     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		
	 </cfif>
	 <input type="submit" name="frm_Submit" value="Add Nominal To Package">
	</div>
</fieldset>
<!--- package information section, two columns of inputs. Problem, Section, Cause & Tactics are mandatory --->
<fieldset>
</form>	

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
 <legend>Nominals Added To Package</legend>
 <br>
 <cfif qry_NominalList.RecordCount IS 0>
  <b>No Nominals have been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="10%">Nominal Ref</td>
	 <td class="table_title" width="10%">Date Of Birth</td>	 
	 <td class="table_title" width="78%">Name</td>
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_NominalList">
   <tr class="row_colour#i mod 2#">
	 <td>#NOMINAL_REF#</td>
	 <td>#DateFormat(DATE_OF_BIRTH,"DD/MM/YYYY")#</td>	 
	 <td><strong>#NAME#</strong></td>	 	 
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#Nominal_ID#|#nominal_ref#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
	<input type="hidden" name="Division_Entering" value="#Division_Entering#">		
	     <input type="hidden" name="Package_URN" value="#Package_URN#">	 	
	 </cfif>	
	 <input type="submit" name="frm_Submit" value="Remove Nominal From Package">	
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