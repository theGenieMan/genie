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
<cfif isDefined("url.AppScopeRefresh")>
 <cfset onApplicationStart()>
</cfif>
<cfif isDefined("url.SesScopeRefresh")>
 <cfset onSessionStart()>
</cfif>

<cfif isDefined("hidAction")>
 	<cfif hidAction IS "updateDefaultArea">	  
	   <cfset session.defaultDiv=defaultPolicingArea>
	   <cfset application.stepUserDAO.updateUserDefaultArea(userId=session.user.getUserId(),userName=session.user.getFullName(),areaId=defaultPolicingArea)>
	</cfif>	
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

<cfif session.user.getUserId() IS "n_bla003">
	<a href="index.cfm?appRefresh=yes">RESET APP/SESSION</a> | <a href="index.cfm?appScopeRefresh=yes">RESET APP</a> | <a href="index.cfm?sesScopeRefresh=yes">RESET SESSION</a>
</cfif>

<br style="clear:all;">
<form action="index.cfm?#session.urlToken#" method="post">
<b>Your Default Policing Area: </b>
 <select name="defaultPolicingArea">	     		     
  <cfloop query="Application.qry_Division">
   	 <option value="#areaId#" <cfif session.Div IS areaId>selected</cfif>>#areaName#</option> *
  </cfloop>
 </select>
 <input type="hidden" name="hidAction" value="updateDefaultArea">
 <input type="submit" name="btnSubmit" value="Update Area">
</form>
	
<cfif session.IsIntelUser IS "YES" AND not isDefined("forceUser")>
 <cfif isDefined('session.ftaWarrantUser')>
  <cfif session.ftaWarrantUser IS "YES">
  	<cfinclude template="ftaWarrantDashboard.cfm">
  <cfelse>
  	<cfinclude template="dashboard.cfm">
  </cfif>
 <cfelse>
  <cfinclude template="dashboard.cfm">
 </cfif>
<cfelse>
  <cfinclude template="user_view.cfm">
</cfif>

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

