<!--- <cftry> --->

<!---

Module      : creationSuccess.cfm

App         : Packages

Purpose     : Page displayed to a user when they have successfully created a page from the quick
              GENIE link way of doing things. Not the full package creation screen
Requires    : 

Author      : Nick Blackham

Date        : 26/09/2012

Revisions   : 

--->

<!---
<cfset Function_CFCs=CreateObject("component","functions")>
--->
<cfset qry_Package=application.stepReadDAO.Get_Package_Details(URN)>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
<a name="top"></a>
<cfinclude template="header.cfm">

<h3 align="center">Package #URN# has been successfully created</h3>

<cfif qry_Package.CAT_CATEGORY_ID IS 27>
  <div align="center">
	<div style="padding:10px; background-color:##FF0000; color:##FFF; font-size:140%; font-weight:bold; font-family:courier new;">
		**********************************************************************************<br>
		A Step Package has been created for the Nominal – The Sergeant you have allocate it to will authorise the Package.<br>
	   (Once authorised Sergeant will allocate to Inspector for Sign off who then will allocate to PNSB for update onto PNC)<br>
		*Now Ensure the File/Case Papers have been placed in the PNC Wanted Cabinet on your TPU, as per Force Policy*	
		**********************************************************************************<br>
	</div>
  </div>
</cfif>

<p align="center"><a href="view_package.cfm?Package_ID=#URN#&#session.URLToken#">View Package #URN#</a></p>

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