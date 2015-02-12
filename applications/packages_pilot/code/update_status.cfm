<!---

Module      : update_status.cfm

App          : Packages

Purpose     : Allosw update of status on an existing package.

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

  <cfif Len(frm_SelStatus) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Status","|")>	
	<cfset s_ShowForm="YES">
 <cfelse>
   <cfif frm_SelStatus IS "RETURN TO ORIGINATOR - ENQUIRIES COMPLETED" AND Outcome_Length IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"A RESULT / OUTCOME MUST BE ENTERED ON THE PACKAGE BEFORE IT CAN BE RETURNED","|")>		
	<cfset s_ShowForm="YES">
	</cfif>
 </cfif>

 
   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->    

     <cfset s_Return=application.stepPackageDAO.Update_Package_Status(Package_ID,frm_SelStatus, frm_HidAddUser, frm_HidAddUserName)>

			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Message>
			   <!---
			   <cfif isDefined("s_Return.Redirect_Complete")>
				   <cflocation url="update_completion.cfm?Package_ID=#Package_ID#" addtoken="true">
			   </cfif>
			   --->
			</cfif>			
	
   </cfif>


<cfelse>
 <cfset frm_SelStatus="">
<cfset s_ShowForm="YES">
</cfif>

<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset qry_StatusList=application.stepReadDAO.Get_Package_Status(Package_ID)>

<cfif session.IsIntelUser IS "YES">
 <cfif (qry_PACKAGE.CAT_CATEGORY_ID IS "15" OR qry_PACKAGE.CAT_CATEGORY_ID IS "24")
   AND qry_Package.DIVISION_ENTERING IS NOT session.loggedInUserDiv>
  <cfset lis_Status="COMPLETE,COMPLETE - RETURN TO CRIMESTOPPERS,COMPLETE - RETURN TO PRISON RECALL,OUTSTANDING/REVIEW,RETURN TO ORIGINATOR - ENQUIRIES COMPLETED,RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC,RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED">
 <cfelse>
  <cfif qry_Package.CAT_CATEGORY_ID IS NOT 27
	  	 OR (qry_Package.CAT_CATEGORY_ID IS 27 AND session.pncWantedUser IS "YES")>	 	 
    <cfset lis_Status="COMPLETE,COMPLETE - RETURN TO CRIMESTOPPERS,COMPLETE - RETURN TO PRISON RECALL,OUTSTANDING/REVIEW,RETURN TO ORIGINATOR - ENQUIRIES COMPLETED,RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC,RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED">
  <cfelse>
  	<cfset lis_Status="COMPLETE - RETURN TO CRIMESTOPPERS,COMPLETE - RETURN TO PRISON RECALL,OUTSTANDING/REVIEW,RETURN TO ORIGINATOR - ENQUIRIES COMPLETED,RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC,RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED">  
  </cfif> 
 </cfif>
 
 
 
<cfelse>
 <cfset lis_Status="RETURN TO ORIGINATOR - ENQUIRIES COMPLETED,RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC,RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED">
</cfif>

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

<div align="center">
 <b>Current Status : </b> <cfloop query="qry_StatusList" startrow="1" endrow="1">
                                    #STATUS# (#DateFormat(UPDATE_DATE,"DD/MM/YYYY")#)
								   </cfloop>
</div>


<fieldset>
 <legend>Package Summary  #qry_Package.Package_URN#</legend>
 <cfloop query="qry_Package">
 <table width="95%" align="center">
  <tr>
   <td width="15%"><strong>Package</strong></td>
   <td>#qry_Package.Package_URN#</td>
  </tr>
  <tr>
   <td width="15%"><strong>Outline</strong></td>
   <td>#PROBLEM_OUTLINE#</td>
  </tr>
 </table>
 </cfloop>
</fieldset>

<cfif isDefined("s_ShowForm")>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Change Status For Package #qry_Package.Package_URN#</legend>

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
	<td width="15%"><label for="frm_SelStatus">Set Status To</label></td>
	 <td>
	  <select name="frm_SelStatus" id="frm_SelStatus">
	   <option value="">-- Select --</option>
	   <cfloop list="#lis_Status#" index="s_Status" delimiters=",">
	    <option value="#s_Status#"  <cfif s_Status IS frm_SelStatus>selected</cfif>>#s_Status#</option>
	   </cfloop>
	  </select>
	 </td>
   </tr>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="update">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">	
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 	
     <input type="hidden" name="Package_URN" value="#Package_URN#">	 	
     <input type="hidden" name="Outcome_Length" value="#len(qry_Package.Outcome)#">	 	
	 <input type="submit" name="frm_Submit" value="Update Status">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>
</cfif>

</body>
</html>
</cfoutput>	