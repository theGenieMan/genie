<!--- <cftry> --->

<!---

Module      : complete_package.cfm

App          : Packages

Purpose     : Package Completion. Calls a CFC to update the package assignments table and send an email to the
                  person who had been assigned the package.

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfset s_Return=application.stepPackageDAO.Send_Initial_Assignment(Package_ID)>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
<a name="top"></a>
<cfinclude template="header.cfm">

<h3 align="center">Package #s_Return.Package_URN# has been successfully created</h3>

<h4 align="center">#s_Return.Message#</h4>

<p align="center"><a href="view_package.cfm?#session.URLToken#&Package_ID=#s_Return.Package_ID#&Package_URN=#s_Return.Package_URN#">View Package #s_Return.Package_URN#</a></p>

<p align="center"><a href="index.cfm?#session.URLToken#">Back To Packages Homepage</a> | <a href="create_package_stage1.cfm?#session.URLToken#">Complete Another Package</a></p>

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