<cfcomponent>
	<cffunction name="updateSession" access="remote" output="false" returntype="void">
		<cfargument name="requestFor" type="string" required="true" hint="update of request for field">
		<cfargument name="reasonCode" type="string" required="true" hint="update of request code field">
		<cfargument name="reasonText" type="string" required="true" hint="update of reason text field">
		<cfargument name="ethnicCode" type="string" required="false" default="" hint="update of ethnicity code">
		<cfargument name="requestForCollar" type="string" required="false" default="" hint="update of collar of person requesting">
		<cfargument name="requestForForce" type="string" required="false" default="" hint="update of Force of person requesting">
	 	
	 	<cflog file="genie" type="information" text="updateSession called #session.urlToken#" >
		 
		<cfsavecontent variable="sessionDetails">
		<cfdump var="#session#" format="text" > 
		</cfsavecontent>
		
		<cflog file="genie" type="information" text="updateSession #sessionDetails#" >
		 
		<cfif isDefined('session.lastDPAUpdate')>
		<cflog file="genie" type="information" text="updateSession before = #session.lastDPAUpdate#,#session.audit_code#,#session.audit_for#,#session.audit_details#,#session.ethnic_code#,#session.audit_for_collar#,#session.audit_for_force#">
		</cfif> 
	 	
	 	<cfset session.lastDPAUpdate=now()>		
		<cfset session.audit_code=arguments.reasoncode>
		<cfset session.audit_for=arguments.requestFor>
		<cfset session.audit_details=arguments.reasonText>
		<cfset session.ethnic_code=arguments.ethnicCode>
		<cfset session.audit_for_collar=arguments.requestForCollar>
		<cfset session.audit_for_force=arguments.requestForForce>
			 
		<cflog file="genie" type="information" text="updateSession after = #session.lastDPAUpdate#,#session.audit_code#,#session.audit_for#,#session.audit_details#,#session.ethnic_code#,#session.audit_for_collar#,#session.audit_for_force#">	
		 
	</cffunction>
	
	<cffunction name="updateUserSettings" access="remote" output="false" returntype="string">
		<cfargument name="font" type="string" required="true" hint="user settings update font">
		<cfargument name="stylesheet" type="string" required="true" hint="user settings update stylesheet">
		<cfargument name="peType" type="string" required="true" hint="uset settings update person search type">
		<cfargument name="fontSize" type="string" required="true" hint="user settings update font size">
		<cfargument name="collapse" type="string" required="true" hint="should search sections be collapse on search">
		<cfargument name="userId" type="string" required="true" hint="user settings userid to update">
		<cfargument name="userName" type="string" required="true" hint="user settings user name to update">		
	 	
	 	<cfset application.genieUserService.updateUserSettings(userId=arguments.userId,
															   userName=arguments.userName,
															   font=arguments.font,
															   stylesheet=arguments.stylesheet,
                                                               peType=arguments.peType,
															   collapse=arguments.collapse,
															   fontSize=arguments.fontSize)>
	 	
	 	<cfreturn true>	
		 
	</cffunction> 

	<cffunction name="getAppVar" access="remote" output="false" returntype="string" returnformat="plain">
		<cfargument name="varName" type="string" required="true" hint="name of app variable to get">		
	 	
	 	<cfset var returnVar = application.genieVarService.getAppVar(varName=arguments.varName)>
	 	
	 	<cfreturn returnVar>	
		 
	</cffunction> 

	<cffunction name="resetSession" access="remote" output="false" returntype="string">
	 	
	 	<cflog file="genie" type="information" text="Web service resetSession has been called" />
	 	<cfset application.genieUserService.resetSession()>
		<cflog file="genie" type="information" text="Web service resetSession has ended" />
	 	
	 	<cfreturn true>	
		 
	</cffunction> 
	
	<cffunction name="doGenieAudit" access="remote" returntype="void" output="false" hint="calls the genie service with audit data">
    	<cfargument type="string" name="userId" required="true" hint="userId to audit for">
    	<cfargument type="string" name="sessionId" required="false" default="#createUUID()#" hint="sessionId to audit for">    	
    	<cfargument type="string" name="reason" required="true" hint="reason code for request">    	
    	<cfargument type="string" name="reasonText" required="true" hint="reason text for request">
    	<cfargument type="string" name="requestFor" required="true" hint="requestor userid to audit for">    	    	    	    	 	    	    	    	
    	<cfargument type="string" name="fullName" required="true" hint="requestor fullname to audit for">    	    	    	    	
    	<cfargument type="string" name="action" required="true" hint="audit action for">    	    	    	    	    	    	    	
    	<cfargument type="string" name="fields" required="false" default='""' hint="sessionId to audit for">    	    	    	    	    	
    	<cfargument type="string" name="details" required="false" default='""' hint="sessionId to audit for">    	    	  
    	<cfargument type="string" name="numberOfResults" required="false" default="0" hint="sessionId to audit for">
		<cfargument type="string" name="department" required="false" default="" hint="department the person works in">
		<cfargument type="string" name="ethnicCode" required="false" default="" hint="ethnic code of driver being checked">
		<cfargument type="string" name="requestCollar" required="false" default="" hint="collar of person requesting">
		<cfargument type="string" name="requestForce" required="false" default="" hint="for of person requesting">	
	
		<cfset application.genieService.doGenieAudit( userId=arguments.userId,
													  sessionId=arguments.sessionId,
													  reason=arguments.reason,
                                                      reasonText=arguments.reasonText,
                                                      requestFor=arguments.requestFor,
                                                      fullName=arguments.fullName,
                                                      action=arguments.action,
                                                      fields=arguments.fields,
                                                      details=arguments.details,
                                                      numberOfResults=arguments.numberOfResults,
                                                      department=arguments.department,
                                                      ethnicCode=arguments.ethnicCode,
                                                      requestCollar=arguments.requestCollar,
                                                      requestForce=arguments.requestForce)>
	
	</cffunction>
	 
</cfcomponent>