<!---

Module      : interestMarkers.cfm

App         : GENIE

Purpose     : Stub that shows Interest Markers for a Crime.

Requires    : CRIME_REF

Author      : Nick Blackham

Date        : 24/04/2015

Revisions   : 

--->

<cfquery name="qIMS" datasource="#application.warehouseDSN#">
SELECT *
FROM   browser_owner.OFFENCE_MARKERS
WHERE  CRIME_REF=<cfqueryparam value="#CRIME_REF#" cfsqltype="cf_sql_numeric" />	
</cfquery>	

<cfoutput>
	<div class="genieTooltipHeader_IM">
		#CRIME_NO# - INTEREST MARKERS
	</div>
	<div class="genieTooltipHolder_IM">
		#Replace(ValueList(qIMS.DESCRIPTION,"|"),"|","<br>","ALL")#		
	</div>
</cfoutput>