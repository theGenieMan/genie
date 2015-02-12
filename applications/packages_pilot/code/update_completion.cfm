<!---

Module      : update_completion.cfm

App          : Packages

Purpose     : Allows completion of package by intel users

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->
<cfset Function_CFCs=CreateObject("component","functions")>
<cfinclude template="lookups.cfm">

<cfif isDefined("frm_HidAction")>

 <!-- validate dates for each nominal --->

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

  <cfif Len(frm_SelEvalComp) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select whether the Evalution Form has been completed","|")>	
 </cfif>

  <cfif Len(frm_TxtOutcome) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"Please enter an outcome","|")>	
 </cfif>

 <cfif frm_SelResult IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a result for the package","|")>	
 </cfif>

 
   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->

     <cfset s_Return=Function_CFCs.Complete_Package(Form)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Message>
			</cfif>			
	
   </cfif>


<cfelse>
 <cfset frm_SelEvalComp="">
 <cfset frm_TxtEvalCompDate="">
 <cfset frm_TxtOutcome="">
 <cfset frm_SelResult="">
</cfif>



<cfset qry_Package=Function_CFCS.Get_Package_Details(Package_ID)>


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
	 <input type="submit" name="frm_Submit" value="Back To #qry_Package.Division_Entering#/#Package_ID# Details">	
</form>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
<br>
 </cfif>

<fieldset>
 <legend>Package Summary  #qry_Package.Division_Entering#/#Package_ID#</legend>
 <cfloop query="qry_Package">
 <table width="95%" align="center">
  <tr>
   <td width="25%"><strong>Package</strong></td>
   <td>#Division_Entering#/#Package_ID#</td>
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
 <legend>Package Completion #qry_Package.Division_Entering#/#qry_Package.Package_ID#</legend>

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
	<td width="25%" valign="top"><label for="frm_TxtOutcome">Outcome</label> *</td>
	 <td>
       <textarea name="frm_TxtOutcome" rows="5" cols="60" class="mandatory">#frm_TxtOutCome#</textarea>
	 </td>
   </tr>
   <tr>
	<td><label for="frm_SelEvalComp">Evaluation Form Complete?</label> *</td>
	 <td>
	  <select name="frm_SelEvalComp" id="frm_SelEvalComp" class="mandatory">
	   <option value="">-- Select --</option>
	   <option value="Y" <cfif frm_SelEvalComp IS "Y">selected</cfif>>Yes</option>
	   <option value="N" <cfif frm_SelEvalComp IS "N">selected</cfif>>No</option>	   
	  </select>
	 </td>
   </tr>
   <tr>
	<td><label for="frm_TxtEvalCompDate">Evaluation Sent/Filed Date</label></td>
	 <td>
       <input type="text" name="frm_TxtEvalCompDate" id="frm_TxtEvalCompDate" value="#frm_TxtEvalCompDate#" size="12"> (dd/mm/yyyy)
	 </td>
   </tr>
   <tr>
	<td><label for="frm_SelResult">Result</label></td>
	 <td>
       <select name="frm_SelResult" id="frm_SelResult" class="mandatory">
		<cfloop query="qry_ResultsLookup">
		 <option value="#RESULT_ID#" <cfif RESULT_ID IS frm_SelResult>selected</cfif>>#RESULT_DESCRIPTION#</option>
		</cfloop>
	  </select>
	 </td>
   </tr>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="update">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 	
	 <input type="submit" name="frm_Submit" value="Update Package">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

</body>
</html>
</cfoutput>	