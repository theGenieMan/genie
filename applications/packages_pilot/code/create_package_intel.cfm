<!--- <cftry> --->

<!---

Module      : create_package_intel.cfm

App          : Packages

Purpose     : Package Creation Screen Stage Intel. Addition of Intelligence logs

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
	
	 <cfif Len(frm_TxtIntelRef) IS 0>
  	    <cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter an intelligence log number","|")>	
	 <cfelse>
	    <!--- check is valid format crime no --->
		      <!--- check crime no exists --->
		      <cfset s_IntelExists=application.stepPackageDAO.Is_Valid_IntelLog(frm_TxtIntelRef)>
		      <cfif s_IntelExists.valid IS "NO">
			      <cfset str_Valid="NO">
		        <cfset lis_Errors=ListAppend(lis_Errors,"Intelligence Log #frm_TxtIntelRef# does no exist.","|")>		      
			    </cfif>
     </cfif>
    	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the package and then move the user on to stage 2, giving the created
		       package id --->

       
        <cfset Form.intelDesc=s_IntelExists.intelInfo.INDICATOR&" "&s_IntelExists.intelInfo.SOURCE&" Level:"&s_IntelExists.intelInfo.SECURITY_ACCESS_LEVEL&" From:"&DateFormat(s_IntelExists.intelInfo.DATE_START,"DD/MM/YYYY")&" To:"&DateFormat(s_IntelExists.intelInfo.DATE_END,"DD/MM/YYYY")>

		<cfset s_Return=application.stepPackageDAO.Add_Package_Intel(Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>			
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
			 <cfset frm_TxtIntelRef="">
			 <cfset frm_TxtLocardRef="">
			 <cfset frm_TxtOffLoc="">
		</cfif>		
		--->
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some intelligence to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Intel(frm_ChkDel,Package_ID)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>

 <cfset frm_TxtIntelRef="">
 </cfif>

<cfelse>
 <cfset frm_TxtIntelRef="">
</cfif>

<cfset qry_IntelList=application.stepReadDAO.Get_Package_Intel(Package_ID)>

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
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 3 - Intelligence Logs</div>

If you have no intelligence logs to add to the packge then click `Save & Continue To Stage 4`. If you have intelligence logs to add
then enter their FULL REFERENCE (eg. 123456) one by one and when all have been added click `Save & Continue To Stage 4 `.
<br>


<div align="center">
<form action="create_package_stage3.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubStage3" value="Save & Continue To Stage 4">
</form>
</div>
<cfelse>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Intelligence Logs</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>
</cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form">

<fieldset>
 <legend>Intelligence Log Information</legend>
<cfif isDefined("lis_Errors") and isDefined("frm_HidAction")>
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

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
 </cfif>
 <br>
 <table width="98%" align="center">
  <tr>
	 <td width="17%"><label for="frm_TxtIntelRef">Intelligence Log Ref</label> *</td>
	 <td>
		 <input type="text" name="frm_TxtIntelRef" id="frm_TxtIntelRef" value="#frm_TxtIntelRef#" size="15" class="mandatory"> (eg. 1233456) 
		 	  <input type="button" name="frm_BtnGENIE" value="Open GENIE Intel Search" onClick="fullscreen('#Application.GENIE_INTEL_Search#','GENIE_Intel')">
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
	 <input type="submit" name="frm_Submit" value="Add Intelligence To Package">
	</div>
</fieldset>
<!--- package information section, two columns of inputs. Problem, Section, Cause & Tactics are mandatory --->
<fieldset>
</form>	

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
 <legend>Intelligence Logs Added To Package</legend>
 <br>
 <cfif qry_IntelList.RecordCount IS 0>
  <b>No Intelligence Logs have been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="25%">Intellignece Log Ref</td>
	 <td class="table_title" width="75%">Description</td>	 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_IntelList">
   <tr class="row_colour#i mod 2#">
	 <td>#INTEL_LOG_REF#</td>
	 <td>#INTEL_DESC#</td>    
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#INTEL_ID#">
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
	 <input type="submit" name="frm_Submit" value="Remove Intelligence From Package">	
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