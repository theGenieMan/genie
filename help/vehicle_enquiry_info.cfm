<!DOCTYPE HTML>
<html>
<head>
	<title>Vehicle Enquiry - What am I searching?</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">			
</head>


<body>
	
<cfset headerTitle="GENIE VEHICLE ENQUIRY - What am I searching ?">	
<cfinclude template="/header.cfm">	

<div style="clear:both">
<br>

<strong>Systems available for search:</strong>
<br><br>
Vehicle Details recorded in CRIMES Intelligence log <br>
Vehicle Details recorded as CRIMES Property <br>
Vehicle Details associated with a defendant on NSPIS Case Prep <br>
Vehicle Details associated with a known nominal on CRIMES from the CRS (Road Traffic Collision) system<br>
West Midlands Regional Data Warehouse  (Authorised users only)<br>


</div>

</body> 
</html>