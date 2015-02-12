<!--- <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> --->
<!--- <cftry> --->

<!---

Module      : index.cfm

App         : Packages

Purpose     : Home/Dashboard page for the packages application

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->
 
<!--- see if user is an Intel User so gets the dashboard view, if user is just an INSP, SGT or CON they just
see their outstand Packages with an option to view all their packages --->


<cfoutput>
<cfif isDefined("url.AppRefresh")>
 <cfset onApplicationStart()>
 <cfset onSessionStart()>
</cfif>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="step.css">	
</head>

<body>
<a name="top"></a>
<cfinclude template="header.cfm">
<br>

  <cfinclude template="user_view.cfm">
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

