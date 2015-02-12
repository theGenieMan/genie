<!--- <cftry> --->

<!---

Module      : systemOutage.cfm

App         : Packages

Purpose     : adds a system outage or takes it off
              if outage=ON then required vars are outageFile the file that should be displayed and 
              outageExclusions which is a csv list of users who whould be excluded
              if outage=OFF then the exclusions are removed

Requires    : 

Author      : Nick Blackham

Date        : 07/11/12

Revisions   : 

--->

<!--- only process if the outage is set --->
<cfif isDefined('outage')>
	
	<cfif outage IS "ON">
		<cfset application.systemOutageFile=outageFile>
		<cfset application.systemOutageExclusions=outageExclusions>
	</cfif>
	
	<cfif outage IS "OFF">
		<cfset application.systemOutageFile="">
		<cfset application.systemOutageExclusions="">		
	</cfif>
	
	<cfdump var="#application#">
	
</cfif>	