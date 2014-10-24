<!--- just resets the user session, used by AJAX calls to do the biz! --->
<cflog file="genie" type="information" text="sessionRestart.cfm has been called" />
<cfset onSessionStart()>
<cflog file="genie" type="information" text="sessionRestart.cfm has run" />