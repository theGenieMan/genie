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
        <cfargument name="REASON_CODE" type="string" required="yes">	
        <cfargument name="REQUEST_FOR" type="string" required="yes">			
        <cfargument name="AUDIT_DETAIL" type="string" required="yes">	
        
		<cfset var str_AuditString="">
		<cfset var str_AuditFile="">
	    <cfset var computerHostname=ListGetAt(CreateObject("java", "java.net.InetAddress").getLocalHost(),1,"/")>
	    <cfset var startDbQuery="">
	    <cfset var endDbQuery="">
	    <cfset var dbQueryTime="">
	    <cfset var qAuditResult="">

        <!---
		<cfset str_AuditString=""""&arguments.USER_ID&""","""&arguments.Session_ID&""","&DateFormat(now(),"DD/MM/YYYY")&" "&TimeFormat(now(),"HH:mm:ss")&","""&REASON_CODE&""","""&REQUEST_FOR&""","""&AUDIT_DETAIL&""","""&Replace(arguments.Screen,"""","","ALL")&""","""&Replace(arguments.Search_Params,"""","","ALL")&""","""&Replace(arguments.Screen_Details,"""","","ALL")&""","&arguments.Num_Results>
		
		<cfif ListLen(str_AuditString,",") IS NOT 10>
		  <cfmail to="nick.blackham@westmercia.pnn.police.uk" subject="duff genie audit [NOT PROTECTIVELY MARKED]" from="genie@westmercia.pnn.police.uk">
		   #now()#
		   
		   #str_AuditString#
		  </cfmail>
		</cfif>
		
		<cfset str_AuditFile=DateFormat(now(),"yyyymmdd")&"_sessions.txt">
	
		<cflock type="exclusive" timeout="5">
			<cffile action="append" addnewline="yes" file="#arguments.AuditDir#\#str_AuditFile#" output="#Trim(StripCR(str_AuditString))#">
		</cflock>
		--->
		
	    <cfset startDbQuery=getTickCount()>
	    
	     <cftransaction>
  	       <cfquery name="qAuditInsert" datasource="#arguments.dsn#" result="qAuditResult">
	        INSERT INTO browser_owner.AUDIT_DATA
	        (
	          SESSION_ID,
	          REQUEST_TIMESTAMP,
	          USER_ID,
	          REASON,
	          REASON_TEXT,
	          REQUEST_FOR,
	          USER_ACTION,
	          FIELDS,
	          DETAILS,
	          NUMBER_OF_RESULTS,
	          SERVER
	        )
	        VALUES
	        (
	          <cfqueryparam value="#arguments.session_Id#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
	          <cfqueryparam value="#arguments.user_Id#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#arguments.reason_code#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#arguments.audit_detail#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#arguments.request_for#" cfsqltype="cf_sql_varchar">,	          
	          <cfqueryparam value="#arguments.screen#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#Replace(arguments.search_params,chr(34),'','ALL')#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#arguments.screen_details#" cfsqltype="cf_sql_varchar">,
	          <cfqueryparam value="#arguments.num_results#" cfsqltype="cf_sql_numeric">,
	          <cfqueryparam value="#computerHostname#" cfsqltype="cf_sql_varchar">        	          	          	          	          	          	          	          
	        )
	       </cfquery> 
	     </cftransaction>
	     
	    <cfset endDbQuery=getTickCount()>
        <cfset dbQueryTime=endDbQuery-startDbQuery>
		
		<cfif dbQueryTime GTE 1000>
		  <cfmail to="nick.blackham@westmercia.pnn.police.uk" subject="GENIE Audit Taking 1000ms + [NOT PROTECTIVELY MARKED]" from="genie@westmercia.pnn.police.uk" type="html">
		   #now()#
		   <br><br>
		   Execution Time=#qAuditResult.ExecutionTime#<br>
		   #qAuditResult.sql#
		   <br><br>
		  </cfmail>		
		</cfif>		

  </cffunction>	

  <cffunction name="isNominalTarget" access="public" displayname="See if nominal is a target" hint="Nominal_Ref, CRIMES DSN, Return Target Code">

	<cfargument name="DSN" type="string" required="yes">
	<cfargument name="NOMINAL_REF" type="string" required="yes">     
	<cfargument name="sTimespan" type="Any" required="yes">	
      <!--- function queries crimes to see if a nominal is a target 
	      returns 0 - Not a target
	              1 - Covert Target
	              2 - Overt Target
	              3 - Proactive Target                               --->	
    <!---  <cftry> --->
	<cfset i_TargCode=0>
	
	<!--- query source for target info --->
	<cfquery name="qry_Targets" DATASOURCE="#DSN#" cachedWithin="#sTimespan#">			
	SELECT TARGET_INTEREST_TYPE, TARGET_REF,
	       REASON||'. '||TO_CHAR(START_DATE,'DD/MM/YYYY')||' To '||TO_CHAR(END_DATE,'DD/MM/YYYY') AS TARG_TEXT
	FROM   browser_owner.TARGET_MARKERS
	WHERE  NOMINAL_REF='#NOMINAL_REF#'
	AND    TARGET_INTEREST_TYPE <> 1
	AND    end_date >= sysdate
	</cfquery>
  
	<cfif qry_Targets.RecordCount GT 0>
     <cfif qry_Targets.TARGET_INTEREST_TYPE IS 1>
	  <cfset i_TargCode=qry_Targets.TARGET_INTEREST_TYPE&"|None|"&qry_Targets.TARGET_REF>
	 <cfelseif qry_Targets.TARGET_INTEREST_TYPE IS 2>
	 <cfset i_TargCode=qry_Targets.TARGET_INTEREST_TYPE&"|"&qry_Targets.TARG_TEXT&"|"&qry_Targets.TARGET_REF>
	 <cfelseif qry_Targets.TARGET_INTEREST_TYPE IS 3>
	 <cfset i_TargCode=qry_Targets.TARGET_INTEREST_TYPE&"|Enquiry to HQ Ops Room Insp. Quoting Ref "&qry_Targets.TARGET_REF&"|"&qry_Targets.TARGET_REF>
	 </cfif>
	</cfif>
	
	<cfreturn i_TargCode>
	
    <!--->
	<cfcatch type="Any">
	 <cfset i_TargCode="Function Error">
     <cfreturn i_TargCode>		 
	</cfcatch>	
   </cftry>--->
  </cffunction>	
	
  <cffunction name="auditTarget" access="public" displayname="See if nominal is a target" hint="Nominal_Ref, CRIMES DSN, Audit Text">

	<cfargument name="DSN" type="string" required="yes">
	<cfargument name="NOMINAL_REF" type="string" required="yes">     
	<cfargument name="AUDIT_TEXT" type="string" required="yes">     	
	<cfargument name="AUDIT_USER" type="string" required="yes">   	
    <cfargument name="TARGET_REF" type="string" required="yes">   		
	<cfargument name="TRANSACTION_DATE" type="date" required="yes">
	
	<!---<cftry>--->
	<cfset AUDIT_REF="99999998">
	<cfquery name="ins_TargetAudit" DATASOURCE="#DSN#">	
	 INSERT INTO TEMP_TARGET_MESS
	 (AUDIT_LOG_REF,TEMP_TARGET_REF,TEMP_NOMINAL_REF,TEMP_TRANSACTION_DATE,
	  TEMP_USER_ID,TEMP_MESSAGE)
	 VALUES
	 (#AUDIT_REF#,#TARGET_REF#,'#NOMINAL_REF#',#TRANSACTION_DATE#,
	  '#UCase(AUDIT_USER)#','#AUDIT_TEXT#')
	</cfquery>
	
	
	<cfreturn "YES">
	
	<!---
	<cfcatch type="Any">
     <cfreturn "NO">		 
	</cfcatch>	
   </cftry>--->
  </cffunction>	
		
	
</cfcomponent>
