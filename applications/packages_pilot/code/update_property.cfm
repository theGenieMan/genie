<!---

Module      : update_property.cfm

App          : Packages

Purpose     : Allows update of property on an existing package.

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <cfif frm_HidAction is "Add">

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

  <cfif Len(frm_SelPropType) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Property Type","|")>	
 </cfif>

  <cfif Len(frm_TxtDesc) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a description for the property","|")>	
 </cfif>

  <cfif Len(frm_TxtValue) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a value for the property","|")>	
 <cfelse>
  <cfif not isNumeric(frm_TxtValue)>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"Value must be a number","|")>		
  </cfif>
 </cfif>

 
   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->

     <cfset s_Return=application.stepPackageDAO.Add_Package_Property(Form)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
			    <cfset s_ShowForm="YES">
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			     <cfset s_Message=s_Return.Ref>
				 <cfset frm_SelPropType="">
				 <cfset frm_TxtDesc="">
				 <cfset frm_TxtValue="">
				 <cfset frm_TxtRef="">		   
			</cfif>			
	
   </cfif>
 </cfif>

 <cfif frm_HidAction is "Delete">
	
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some property to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->        
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Property(frm_ChkDel,Package_ID)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>	
	
 <cfset frm_SelPropType="">
 <cfset frm_TxtDesc="">
 <cfset frm_TxtValue="">
 <cfset frm_TxtRef="">	
	
 </cfif>

<cfelse>
 <cfset frm_SelPropType="">
 <cfset frm_TxtDesc="">
 <cfset frm_TxtValue="">
 <cfset frm_TxtRef="">
</cfif>

<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset qry_PropList=application.stepReadDAO.Get_Package_Property(Package_ID)>

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
 <legend>Add Property For Package #qry_Package.Package_URN#</legend>

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
	<td width="15%"><label for="frm_SelPropType">Property Type</label> *</td>
	 <td>
	  <select name="frm_SelPropType" id="frm_SelActionType" class="mandatory">
	   <option value="">-- Select --</option>
	   <cfloop list="#Application.lis_PropTypes#" index="s_Prop" delimiters=",">
	    <option value="#s_Prop#"  <cfif s_Prop IS frm_SelPropType>selected</cfif>>#s_Prop#</option>
	   </cfloop>
	  </select>
	 </td>
   </tr>
   <tr>
	 <td valign="top"><label for="frm_TxtAction">Description</label> *</td>
	 <td><textarea name="frm_TxtDesc" rows="2" cols="60" class="mandatory">#frm_TxtDesc#</textarea></td>
   </tr>
   <tr>
	 <td valign="top"><label for="frm_TxtAction">Value</label> *</td>
	 <td><input type="text" name="frm_TxtValue" size="5" value="#frm_TxtValue#" class="mandatory"></td>
   </tr>
   <tr>
	 <td valign="top"><label for="frm_TxtRef">Property Ref</label> *</td>
	 <td><input type="text" name="frm_TxtRef" size="15" value="#frm_TxtRef#"></td>
   </tr>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="Add">
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">		 	 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">			
	 <input type="submit" name="frm_Submit" value="Add Property">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>	
 <legend>Property Added To Package</legend>
 <br>
 <cfif qry_PropList.RecordCount IS 0>
  <b>No Property has been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="15%">Type</td>
	 <td class="table_title" width="50%">Description</td>	 
	 <td class="table_title" width="5%">Value</td>
	 <td class="table_title" width="25%">Property Ref</td>	 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_PropList">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#PROPERTY_TYPE#</strong></td>
	 <td>#PROPERTY_DESC#</td>	 
	 <td>#PROPERTY_VALUE#</td>	 	 
	 <td>#PROPERTY_REF#</td>	 	 
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#PROPERTY_ID#">
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
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		
	 <input type="submit" name="frm_Submit" value="Remove Property From Package">	
	</td>
   </tr>
 </table> 
 </cfif> 
</fieldset>
</form>

</body>
</html>
</cfoutput>	