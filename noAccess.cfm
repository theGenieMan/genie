<!doctype html>
<html>
<head>
	<title><cfoutput>GENIE - Access is Currently Disabled</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">				
</head>

<body>

<div class="ui-widget-header" align="center">
 <cfoutput>#Application.Form_Title# #Application.Version# #Application.ENV#</cfoutput>
</div>

<div align="center"><br><br>
 <img src="/images/noEntry.gif" alt="No Access To GENIE Sign">
</div>
<br>
<cfoutput>
<h1 align="center">Access to GENIE #Application.Version# #Application.ENV# is currently disabled<br><br>Please close all your GENIE windows</h1>
</cfoutput>

<cfif session.isGenieAdmin>
<p align="center"><b><a href="/index.cfm?startAccess=go">Reenable User Access</a></b></p>	
</cfif>	

</body>
</html>