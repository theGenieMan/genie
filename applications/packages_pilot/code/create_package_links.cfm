<!--- <cftry> --->

<!---

Module      : create_package_links.cfm

App          : Packages

Purpose     : Package Creation Screen Stage Links. Addition of Links between packages

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
	
	 <cfset frm_TxtLinkRef=UCase(frm_TxtLinkRef)>
	
	 <cfif Len(frm_TxtLinkRef) IS 0>
  	    <cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a URN of the package you want to link to","|")>	
	 <cfelse>
	    <!--- check is valid format crime no --->
		      <!--- check crime no exists --->
		      <cfset s_LinkExists=application.stepPackageDAO.Is_Valid_URN(frm_TxtLinkRef)>
		      <cfif s_LinkExists IS "NO">
			      <cfset str_Valid="NO">
		        <cfset lis_Errors=ListAppend(lis_Errors,"Package URN #frm_TxtLinkRef# does no exist.","|")>		      
			    </cfif>
     </cfif>
    	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the package and then move the user on to stage 2, giving the created
		       package id --->
        
		<cfset s_Return=application.stepPackageDAO.Add_Package_Link(Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>			
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
			 <cfset frm_TxtLinkRef="">
		</cfif>		
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some linked packages to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->        
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Link(frm_ChkDel,Package_ID)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>

 <cfset frm_TxtLinkRef="">
 </cfif>

<cfelse>
 <cfset frm_TxtLinkRef="">
</cfif>

<cfset qry_LinkList=application.stepReadDAO.Get_Package_Links(Package_URN)>

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
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 8 - Links</div>

If you have no linked to add to the packge then click `Complete Package`. If you have links to add
then enter their FULL REFERENCE (eg. H/00001/09) one by one and when all have been added click `Complete Package `.
<br>

<div align="center">
<form action="complete_package.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubComp" value="Complete Package">
</form>
</div>

<cfelse>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Linked Packages</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>
</cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form">

<fieldset>
<legend>Linked STEP Package Information</legend>

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
	 <td width="17%"><label for="frm_TxtLinkRef">Package To Link URN</label> *</td>
	 <td>
		 <input type="text" name="frm_TxtLinkRef" id="frm_TxtLinkRef" value="#frm_TxtLinkRef#" size="15" class="mandatory"> (eg. H/00001/09) 
   </td>
  </tr>
 </table>
	<div style="padding-top:5px;">
	 <input type="hidden" name="frm_HidAction" value="add">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">			 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 		
	 </cfif>	 
	 <input type="submit" name="frm_Submit" value="Add Link To Package">
	</div>
</fieldset>
<!--- package information section, two columns of inputs. Problem, Section, Cause & Tactics are mandatory --->
<fieldset>
</form>	

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
 <legend>Linked STEP Packages</legend>
 <br>
 <cfif qry_LinkList.RecordCount IS 0>
  <b>No Linked Logs have been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="98%">Package URN</td>
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_LinkList">
   <tr class="row_colour#i mod 2#">
	 <td>#LINK_URN#</td>
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#PACKAGE_URN#|#LINK_URN#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">			 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
		 <input type="hidden" name="Package_URN" value="#Package_URN#">		 	
	 </cfif>	 
	 <input type="submit" name="frm_Submit" value="Remove Link From Package">	
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