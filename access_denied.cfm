<!doctype html>
<html>
<head>
	<title><cfoutput>GENIE Access Denied</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_arial.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/jquery-ui-1.10.4.custom.css">	
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
<h1 align="center">User #session.user.getFullName()# (#session.user.getTrueUserId()#) is not authorised to use GENIE</h1>
</cfoutput>

<cflog file="genie" type="information" text="Access Denied: #AUTH_USER# #session.user.getFullname()# (#session.user.getTrueUserId()#) has attempted to access GENIE and is not authorised">
</body>
</html>