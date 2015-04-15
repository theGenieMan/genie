<!DOCTYPE HTML>

<!---

Module      : 404error.cfm

App         : GENIE

Purpose     : Page displayed if we get a 404 page not found error

Requires    : 

Author      : Nick Blackham

Date        : 14/04/2015

Revisions   : 

--->

<html>
<head>		
	<title>GENIE</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_Arial.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/jquery-ui-1.10.4.custom.css">
</head>

<body>

<cfsavecontent variable="dump404">
	<cfdump var="#cgi#" format="text">
</cfsavecontent>	
	
<div class="ui-widget-header-genie" align="center">
	GENIE - Page Cannot Be Found
</div>

<p>The page `<cfoutput>#SCRIPT_NAME#</cfoutput>` you are looking for cannot be found</p>

<p>GENIE was upgraded from V3.6.2 to V4 on Wednesday 15th April 2015 at 1000</p>

<p>It you have clicked a link in another application or somewhere on the intranet then it may be that this link needs to be reformatted to work with
GENIE V4. You should report where the link is that you are clicking on when receiving this error page to the ICT Service Desk via email (also if you can 
include a screenshot of the page with the link on this will help enormously). Many Thanks ICT.</p>

<cflog file="genie404" type="information" text="Script Name=#SCRIPT_NAME#, Path Translated=#PATH_TRANSLATED#, Referrer=#HTTP_REFERER#, User=#AUTH_USER#" />
<cflog file="genie404" type="information" text="Dump | #dump404#" />
	
</body>