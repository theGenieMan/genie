<!DOCTYPE HTML>
<html>
<head>
	<title>Person Enquiry - What am I searching?</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">	
</head>

<body>

<cfset headerTitle="GENIE NOMINAL ENQUIRY - What am I searching ?">	
<cfinclude template="/header.cfm">

<Br>
<div>
<strong>Important information about CRIMES and NSPIS Custody/Case Preparation nominals</strong>
<br><br>
In the event that a nominal is not tied between NSPIS Custody/NSPIS Case Preparation and CRIMES a temporary nominal reference is generated to identify the record. 
<br><br>
If you select one of these temporary nominal records all that you will be able to view for the nominal is the selected custody or case preparation data. Even if the nominal is known to CRIMES, unless the user has tied the record through the NSPIS applications the detail will not be visible. 
<br><br>

<strong>Systems available for search:</strong>
<Br><br>
CRIMES <Br>
NSPIS Case and Custody <br>
West Mercia Firearms Certificate Holders <br>
West Midlands Regional Data Warehouse  (Authorised users only)
<br><br>


<strong>Links available from result sets</strong>
<br><Br>
Data held on CRIMES for selected nominal (see above regarding temporary nominals)<br>
Data held on NSPIS Custody for selected nominal<br>
Summary of OIS incidents for CRIMES Crime records where nominal had a role<br>
Data held on NSPIS Case Preparation for selected nominal<br>
Offender Management System (OMS). Prisoner marker will be present for ALL current prisoners not just those being released shortly.  The marker will remain on the screen for up to 14 days after the nominal's release date. <br>
IOM and PPO Markers - Should a nominal have a warning marker on CRIMES of Integrated Offender Management or Priority and Prolific Offender this will now trigger an information box (originally triggered from JTRACK). <br>
Most recent photograph taken of nominal in a West Mercia Custody unit<br>
Summary data held on COMPACT for selected nominal<br>
Summary data held on CRS (Road Traffic Collisions) for selected nominal<br>
Authorised users can view forensic images on DAMS (Digital Asset Management System) related to crime records.<br>
Summary data held on West Mercia Firearms System for selected person<br>
STEP package data (Including Quick Step Task Allocation Packages - a red box will appear on a nominals record with a link to the Quick Step Package details.) <br>
Risk Management plan data<br>
ASBO/CRASBO information from the Anti Social Behaviour Collector System is included. When a nominal has been flagged with a record on Collector a marker will be displayed on the nominal record. <br>
Stop Searches - a tab has been added to the nominal details screen that shows stop searches that the nominal has been subject to.  (will only show Stop Searches recorded via the new paperless process)<br>
Links to West Midlands nominals, addresses, telephones and vehicles  (Authorised users only)
<br><br>
<b>NB. You will need to view the original database if more detailed information is required</b>
</div>

</body> 
</html>