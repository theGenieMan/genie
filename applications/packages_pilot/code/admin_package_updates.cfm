<!---

Module      : packages_updates.cfm

App          : Packages

Purpose     : Shows an admin user all package updates between two given (2 days by default) dates

Requires    : 

Author      : Nick Blackham

Date        :  11/01/2008

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <!-- validate dates for each nominal --->

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <cfif Len(frm_TxtStartDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtStartDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid start date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

 <cfif Len(frm_TxtEndDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtEndDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid end date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>


<cfelse>
 <cfset frm_TxtStartDate=DateFormat(DateAdd("d","-1",now()),"DD/MM/YYYY")>
 <cfset frm_TxtEndDate=DateFormat(now(),"DD/MM/YYYY")>
 <cfset frm_TxtDiv=Session.LoggedInUserDiv>
 <cfset str_Valid="YES">
</cfif>

<cfif str_Valid IS "YES">
<cfset qry_Actions=application.stepReadDAO.Get_Package_Admin_Updates(frm_TxtStartDate,frm_TxtEndDate,frm_TxtDiv)>

<cfquery name="qry_OrdActions" dbtype="query">
SELECT *
FROM qry_Actions
ORDER BY DateAdded DESC
</cfquery>
</cfif>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
<cfinclude template="header.cfm">

<fieldset>
  <legend>Recent Package Updates - Enter Date Range</legend>
  <form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">

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
	   	<td width="15%"><label for="frm_TxtDiv">Division</label></td>
	    <td>
           <input type="text" name="frm_TxtDiv" id="frm_TxtDiv" value="#frm_TxtDiv#" size="2"> (leave blank for all)
		</td>
		<td width="15%"><label for="frm_TxtStartDate">Start Date</label> *</td>
		 <td>
           <input type="text" name="frm_TxtStartDate" id="frm_TxtStartDate" value="#frm_TxtStartDate#" size="12"> (dd/mm/yyyy)
		 </td>
		 <td valign="top"><label for="frm_TxtEndDate">End Date</label> *</td>
		 <td>
		  <input type="text" name="frm_TxtEndDate" id="frm_TxtEndDate" value="#frm_TxtEndDate#" size="12"> (dd/mm/yyyy)
		</td>
	   </tr>
	   <tr>
	    <td colspan="6" align="right">
		 <input type="hidden" name="frm_HidAction" value="update">
		 <input type="submit" name="frm_Submit" value="Refresh List">	
		</td>
	   </tr>
	 </table> 

  </form>
</fieldset>

<cfif isDefined("qry_Actions")>

 <fieldset>
   <legend>Updates #frm_TxtStartDate# - #frm_TxtEndDate#</legend>
 
   <table width="98%" align="center">
     <tr>
	   <td class="table_title" width="5%">Package</td>	
	   <td class="table_title" width="8%">Category</td>	
	   <td class="table_title" width="8%">Date</td>
	   <td class="table_title" width="10%">Type</td>	   
	   <td class="table_title" width="20%">By</td>
	   <td class="table_title">Update</td>	   	   
 	 </tr>
    <cfset i=1>
    <cfloop query="qry_OrdActions">
	  <tr class="row_colour#i mod 2#">
	    <td valign="top"><strong><a href="/index_email.cfm?page_address=#URLEncodedFormat("#Application.HomeURL#/code/view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#")#" target="_blank">#PACKAGE_URN#</a></strong></td>
		<td valign="top">#CATEGORY#</td>
	    <td valign="top">#DateFormat(DateAdded,"DD/MM/YYYY")#<br>#TimeFormat(DateAdded,"HH:mm")#</td>
	    <td valign="top">#Type#</td>
	    <td valign="top">#By#</td>
	    <td valign="top">#Details#</td>
	  </tr>
	  <cfset i=i+1>
	</cfloop>
   </table>
   
 </fieldset>

</cfif>

</body>
</html>
</cfoutput>	