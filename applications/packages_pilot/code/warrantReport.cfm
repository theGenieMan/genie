<cfif SERVER_NAME IS "schedule1.intranet.wmcpolice">
	<cfset toEmail="warrants.cjsd@westmercia.pnn.police.uk">
<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
    <cfset toEmail="nick.blackham@westmercia.pnn.police.uk">
<cfelse>
    <cfabort>
</cfif>

<!--- get the open step package warrants --->
<cfquery name="qSTEPS" datasource="STEP">
SELECT p.PACKAGE_ID, p.PACKAGE_URN, N.NOMINAL_REF, N.NAME, P.CRIMES_WARRANT_REF
FROM packages_owner.PACKAGES p, packages_owner.PACKAGE_NOMINALS n
WHERE p.PACKAGE_URN IS NOT NULL
AND N.PACKAGE_ID=P.PACKAGE_ID
AND CAT_CATEGORY_ID=32
AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)    	
</cfquery>	

<cfoutput>
<cfsavecontent variable="headerHtml">
<html>
	<head>
		<title>FTA Warrant STEP Package Report</title>
		<style>
			body {font-family:Arial; font-size:12pt}
			th {text-align:left}
		</style>
	</head>		
</cfsavecontent>		
<cfsavecontent variable="stepOpenWarrantClosed">	
<h2 align="center">OPEN STEP PACKAGES WHERE WARRANT ON CRIMES HAS BEEN CLOSED</h2>

<table width="90%" border="1" align="center">
	<tr>
		<th width="12%">STEP Ref</th>
		<th width="8%">Warrant Ref</th>
		<th width="30%">Person</th>
		<th>Date Executed / Method</th>		
	</tr>

<cfloop query="qSTEPS">
	
	<cfquery name="qWarrants" datasource="wmercia">
		SELECT *
		FROM   browser_owner.WARRANTS
		WHERE  WARRANT_REF=<cfqueryparam value="#CRIMES_WARRANT_REF#" cfsqltype="cf_sql_numeric">
		AND    DATE_EXECUTED IS NOT NULL
	</cfquery>
    <cfif qWarrants.recordCount GT 0>
    <tr>
    	<td><a href="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=STEP&ref=#PACKAGE_URN#" target="_blank"><b>#PACKAGE_URN#</b></a></td>
		<td><b>#CRIMES_WARRANT_REF#</b></td>
		<td><a href="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=nominal&ref=#NOMINAL_REF#" target="_blank"><b>#NAME#</b> (#NOMINAL_REF#)</a></td>
		<td>#DateFormat(qWarrants.DATE_EXECUTED,"DDD DD-MMM-YYYY")# / #qWarrants.EXECUTION_METHOD#</td>		
    </tr>
	</cfif>	
</cfloop>
</table>	
</cfsavecontent>
</cfoutput>

<!--- get the closed step package warrants --->
<cfquery name="qSTEPS" datasource="STEP">
SELECT p.PACKAGE_ID, p.PACKAGE_URN, N.NOMINAL_REF, N.NAME, P.CRIMES_WARRANT_REF, 
      (SELECT 'Closed By '||UPDATE_BY_NAME||' on '||TO_CHAR(UPDATE_DATE,'DY DD-MON-YYYY HH24:MI')
       FROM packages_owner.PACKAGE_STATUS ps
       WHERE ps.PACKAGE_ID=p.PACKAGE_ID
       AND   ps.PACK_STATUS_ID = (SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS ps1
       							  WHERE ps1.PACKAGE_ID=p.PACKAGE_ID
       							  AND   ps1.STATUS='COMPLETE')
      ) AS PACK_COMPLETE_BY
FROM packages_owner.PACKAGES p, packages_owner.PACKAGE_NOMINALS n
WHERE p.PACKAGE_URN IS NOT NULL
AND N.PACKAGE_ID=P.PACKAGE_ID
AND CAT_CATEGORY_ID=32
AND (COMPLETED = 'Y')    	
</cfquery>	

<cfoutput>
<cfsavecontent variable="stepClosedWarrantOpen">	
<h2 align="center">CLOSED STEP PACKAGES WHERE WARRANT ON CRIMES IS STILL OPEN</h2>

<table width="90%" border="1" align="center">
	<tr>
		<th width="12%">STEP Ref</th>
		<th width="8%">Warrant Ref</th>
		<th width="30%">Person</th>
		<th>STEP Closed By</th>
	</tr>

<cfloop query="qSTEPS">
	
	<cfquery name="qWarrants" datasource="wmercia">
		SELECT *
		FROM   browser_owner.WARRANTS
		WHERE  WARRANT_REF=<cfqueryparam value="#CRIMES_WARRANT_REF#" cfsqltype="cf_sql_numeric">
		AND    DATE_EXECUTED IS NULL
	</cfquery>
    <cfif qWarrants.recordCount GT 0>
    <tr>
    	<td><a href="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=STEP&ref=#PACKAGE_URN#" target="_blank"><b>#PACKAGE_URN#</b></a></td>
		<td><b>#CRIMES_WARRANT_REF#</b></td>
		<td><a href="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=nominal&ref=#NOMINAL_REF#" target="_blank"><b>#NAME#</b> (#NOMINAL_REF#)</a></td>
		<td>#PACK_COMPLETE_BY#</td>		
    </tr>
	</cfif>	
</cfloop>
</table>	
</cfsavecontent>



<cfsavecontent variable="reportEmailHtml">
#headerHtml#
<body>	
<h3 align="center">RESTRICTED</h3>
#stepOpenWarrantClosed#
#stepClosedWarrantOpen#
<h3 align="center">RESTRICTED</h3>
</body>
</html>	
</cfsavecontent>	

<cfmail to="#toEmail#" bcc="nick.blackham@westmercia.pnn.police.uk" from="step@westmercia.pnn.police.uk" subject="STEP Warrants Report [RESTRICTED]" type="html">
	#reportEmailHtml#
</cfmail>	

#reportEmailHtml#

</cfoutput>