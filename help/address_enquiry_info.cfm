<!DOCTYPE HTML>
<html>
<head>
	<title>Address Enquiry - What am I searching?</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">	
</head>

<body>
	
<cfset headerTitle="GENIE ADDRESS ENQUIRY - What am I searching ?">	
<cfinclude template="/header.cfm">
<div>
<br>
<b>Systems available for search:</b>
<br><br>
Address Details from CRIMES<br>
Address Details from NSPIS Case Preparation<br>
Address Details from NSPIS Custody<br>
Address details from West Mercia Firearms Certificate Holders records<br>
West Midlands Regional Data Warehouse  (Authorised users only)<br><br>
<b>
Important information about Address Enquiry hits 
<br><br>
GENIE will only return hits where information has been linked to that address. If no results are returned the address may be valid but no information has been linked to it. 
</b>

</div>

</body> 
</html>