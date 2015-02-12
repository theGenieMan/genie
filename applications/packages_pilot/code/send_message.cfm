<!---

Module      : send_message.cfm

pp          : Packages

Purpose     : Allows admin user to send messages to people associated with the package
              This is then sent via email and logged in the package updates table.

Requires    : 

Author      : Nick Blackham

Date        : 30/10/2008

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <!-- validate dates for each nominal --->

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

  <cfif Len(frm_SelMessageType) IS 0>
	  <cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Message Type","|")>	
  </cfif>

  <cfif Len(frm_TxtMessage) IS 0>
  	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a Message","|")>	
  </cfif>
 
  <cfif not isDefined("frm_SelEmail")>
  	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some people to be sent the message","|")>	
    <cfset frm_ChkEmail="">
  </cfif>

 
   <cfif str_Valid IS "YES">   
   
   <!--- only do update if the fields have been completed properly --->

     <cfset s_Return=application.stepPackageDAO.Send_Message(Form)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
  			 <cfset frm_SelMessageType="">
			   <cfset frm_TxtMessage="">		
         <cfset frm_ChkEmail="">	   
			</cfif>			
	
   </cfif>


<cfelse>
 <cfset frm_SelMessageType="">
 <cfset frm_TxtMessage="">
 <cfset frm_SelEmail="">
</cfif>

<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset qry_Assignees=application.stepReadDAO.Get_Package_Assignments(Package_ID)>
<cfset qCC=application.stepReadDAO.Get_Package_CC(Package_ID)>
<cfset qGeneric=application.stepReadDAO.Get_Generic_Emails()>

<!---
<cfdump var="#qry_Assignees#">
--->

<cfquery name="qAssignees" dbtype="query">
SELECT DISTINCT ASSIGNED_TO_NAME, ASSIGNED_EMAIL, ASSIGNED_TO
FROM qry_Assignees
WHERE ASSIGNED_EMAIL IS NOT NULL
</cfquery>

<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<script type="text/javascript" src="/jQuery/jQuery.js"></script>
	<script>
		function fullscreen(url,winname) {
		  w = screen.availWidth-10;
		  h = screen.availHeight-50;
		  features = "width="+w+",height="+h;
		  features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		
		  window.open(url, winname , features);
		}
	</script>
	<script>
		$(document).ready(function() {
			
			// set the recipients list width
			$('#frm_SelEmail').width($('#selPackageUsers').width());
			
			/* turn of ajax caching */
			$.ajaxSetup ({
			    // Disable caching of AJAX responses
			    cache: false
			});				
			
			// ajax call for a person search
			$('#btnHRSearch').click(
			  function(){
			  	var sSearchFor=$('#txtHRSearch').val();				
				$('#searchResults').load('hrResults.cfm?searchValue='+encodeURI(sSearchFor));
			}); // end of btnHRSearch click
			
			$('#selPackageUsers').dblclick(
			  function() {
			  	var sValue=$(this).val().toString();
				var sText=$(this).find("option:selected").text();				
				
				$("#frm_SelEmail").append("<option value='"+sValue+"'>"+sText+"</option>");
				
			  }); // end of selPackageUsers double click
			  
			$('#searchResults').live("dblclick",
			  function() {
			  	var sValue=$(this).find("option:selected").val();
				var sText=$(this).find("option:selected").text();				
												
				$("#frm_SelEmail").append("<option value='"+sValue+"'>"+sText+"</option>");
				
			  }); // end of selPackageUsers double click	
			
			// frm_SelEmail double click, remove an entry on double click  
			$('#frm_SelEmail').dblclick(
			  function() {
			  	
			  	 $('#frm_SelEmail option:selected').remove();
				
			  }); // end of frm_SelEmail double click			  

            // form submit click, when form is submitted select all options in the
			// recipients list so they go through to the Form variable
			$('#frm_Submit').click(
			  function() {
			  
			     $('#frm_SelEmail').find("option").attr("selected", true);	
				 	  	 				
			  }); // end of form submit click				  			 
			  		  
		});
	</script>
</head>

<cfoutput>
<body>
<cfinclude template="header.cfm">

<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	
     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		  
	 <input type="submit" name="frm_Submit" value="Back To #qry_Package.Package_URN# Details">	
</form>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;" class="error_title">
    #s_Message#
  </div>
<br>
 </cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Send Message For Package #qry_Package.Package_URN#</legend>

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
     <td width="15%" valign="top"><label for="frm_SelPeopleToEmail">Send Message To</label> *<br>
	 <div style="padding:5px;">
	 <br>Double click on a person in the pre populated to add them to the recipients list.
	 <br><br>
	 To search for a person not in the pre populated list enter a surname or collar no in the search
	 box and click 'Search'. A list of matches will then appear, double click a match to add them
	 to the recipients list.	 
	 </div>
	 </td>
	 <td valign="top">		 
	     <table width="600">
	     	<tr>
	     		<td><b>Select From</b></td>
				<td>&nbsp;</td>
				<td><b>Recipients List</b></td>
			</tr>
			<tr>
				<td valign="top">
			 <cfset l_UsersDisp="">
			 <select id="selPackageUsers" name="selPackageUsers" size="10" multiple>
			   
			   <!--- people assigned the package first --->
			   <option value="ignore">----- People who have been assigned this package ---</option>
			   <cfloop query="qAssignees">
				 <cfif ASSIGNED_TO_NAME IS NOT "Unknown">
				  <cfset l_UsersDisp=ListAppend(UCase(l_UsersDisp),ASSIGNED_TO,",")>
			 	
				    <cfif ListContains(frm_SelEmail,ASSIGNED_EMAIL,",") GT 0>
				     <cfset sSel="checked">
				    <cfelse>
				     <cfset sSel="">
				    </cfif>
				    
					<option value="#ASSIGNED_EMAIL#" #sSel#>#ASSIGNED_TO_NAME#</option>	
				
				 </cfif>
				</cfloop>
			
			   <option value="ignore"></option>
				
			   <!--- people cc'd the package first --->
			   <option value="ignore">----- People who have been cc'd on this package ---</option>
			
				<cfloop query="qCC">
				 <cfif CC_USERNAME IS NOT "Unknown" AND CC_USERID IS NOT "Generic">
				  <cfif ListContains(l_UsersDisp,UCase(CC_USERID),",") IS 0>	  
				    <cfif ListContains(frm_SelEmail,CC_EMAIL,",") GT 0>
				     <cfset sSel="checked">
				    <cfelse>
				     <cfset sSel="">
				    </cfif>
				    <option value="#CC_EMAIL#" #sSel#>#CC_USERNAME#</option>	   
				  </cfif>
				 </cfif>
				 </cfloop> 
				 
			   <option value="ignore"></option>
				
			   <!--- people cc'd the package first --->
			   <option value="ignore">----- Generic Emails ---</option>
			
				<cfloop query="qGeneric">
				  <cfif SEND_MESSAGE IS "Y">	
				    <cfif ListContains(frm_SelEmail,EMAIL_ADDRESS,",") GT 0>
				     <cfset sSel="checked">
				    <cfelse>
				     <cfset sSel="">
				    </cfif>
				    <option value="#EMAIL_ADDRESS#" #sSel#>#DESCRIPTION#</option>
				  </cfif>	   			  
				 </cfloop> 			 
				
			 </select>
	         <br>
		 	 <b>Search For</b>: <input type="text" id="txtHRSearch" size="18" value=""><input type="button" id="btnHRSearch" value="Search">
			<div id="searchResults"></div>
	 </td>
	 <td>&nbsp;</td>
	 <td>
	 	<select id="frm_SelEmail" name="frm_SelEmail" multiple size="20" class="mandatory">
	 		
	 	</select>		
	 </td>
	</tr>
	</table>
   </td>
  </tr>
  
 <br>

	<td width="15%"><label for="frm_SelMessageType">Message Type</label> *</td>
	 <td>
	  <select name="frm_SelMessageType" id="frm_SelMessageType" class="mandatory">
	   <option value="">-- Select --</option>
	   <cfloop list="#Application.lis_MessageTypes#" index="s_Action" delimiters=",">
	    <option value="#s_Action#"  <cfif s_Action IS frm_SelMessageType>selected</cfif>>#s_Action#</option>
	   </cfloop>
	  </select>
	 </td>
   </tr>
   <tr>
	 <td valign="top"><label for="frm_TxtMessage">Message</label> *</td>
	 <td><textarea name="frm_TxtMessage" rows="12" cols="80" class="mandatory">#frm_TxtMessage#</textarea></td>
   </tr>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="update">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">		 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 	
     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		
	 <input type="submit" name="frm_Submit" id="frm_Submit" value="Send Message">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

</body>
</cfoutput>	
</html>
