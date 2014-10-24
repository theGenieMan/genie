<cfcomponent displayname="GE_Queries" hint="CFC For General Enquiry">
  <cffunction name="ge_audit" access="public" displayname="Add Row To Audit Logs" hint="DSN,User_ID,Session_ID,Screen,Search_Params,Screen_Details,Num_Results">
		<cfargument name="DSN" type="string" required="yes">
		<cfargument name="USER_ID" type="string" required="yes">		
		<cfargument name="SESSION_ID" type="string" required="yes">
		<cfargument name="SCREEN" type="string" required="yes">
		<cfargument name="SEARCH_PARAMS" type="string" required="yes">
		<cfargument name="SCREEN_DETAILS" type="string" required="yes">
		<cfargument name="NUM_RESULTS" type="numeric" required="yes">		
    <cfargument name="AUDITDIR" type="string" required="yes">		

		<cfset str_AuditString=arguments.USER_ID&","&arguments.Session_ID&","&DateFormat(now(),"DD/MM/YYYY")&" "&TimeFormat(now(),"HH:mm:ss")&","&arguments.Screen&","&arguments.Search_Params&","&arguments.Screen_Details&","&arguments.Num_Results>
		<cfset str_AuditFile=DateFormat(now(),"yyyymmdd")&"_sessions.txt">
		
		<cffile action="append" addnewline="yes" file="#arguments.AuditDir#\#str_AuditFile#" output="#str_AuditString#">

  </cffunction>		
</cfcomponent>
