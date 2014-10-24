<html>
<head>
	<title><cfoutput>GENIE Access Denied</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>

<div class="header">
 <cfoutput>#Application.Form_Title# #Application.Version# #Application.ENV#</cfoutput>
</div>

<div align="center"><br><br>
 <img src="noEntry.gif" alt="No Access To GENIE Sign">
</div>
<br>
<cfoutput>
<h1 align="center">User #session.user.getFullName()# (#session.user.getTrueUserId()#) is not authorised to use GENIE</h1>
</cfoutput>

<cflog file="genie" type="information" text="Access Denied: #AUTH_USER# #session.user.getFullname()# (#session.user.getTrueUserId()#) has attempted to access GENIE and is not authorised">

