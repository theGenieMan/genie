<cfcomponent>
	<cffunction name="updateSession" access="remote" output="false" returntype="void">
		<cfargument name="requestFor" type="string" required="true" hint="update of request for field">
		<cfargument name="reasonCode" type="string" required="true" hint="update of request code field">
		<cfargument name="reasonText" type="string" required="true" hint="update of reason text field">
	 	
	 	<cflog file="genie" type="information" text="updateSession called #session.urlToken#" >
		 
		<cfsavecontent variable="sessionDetails">
		<cfdump var="#session#" format="text" > 
		</cfsavecontent>
		
		<cflog file="genie" type="information" text="updateSession #sessionDetails#" >
		 
		<cfif isDefined('session.lastDPAUpdate')>
		<cflog file="genie" type="information" text="updateSession before = #session.lastDPAUpdate#,#session.audit_code#,#session.audit_for#,#session.audit_details#">
		</cfif> 
	 	
	 	<cfset session.lastDPAUpdate=now()>		
		<cfset session.audit_code=arguments.reasoncode>
		<cfset session.audit_for=arguments.requestFor>
		<cfset session.audit_details=arguments.reasonText>
			 
		<cflog file="genie" type="information" text="updateSession after = #session.lastDPAUpdate#,#session.audit_code#,#session.audit_for#,#session.audit_details#">	
		 
	</cffunction>
	
	<cffunction name="updateUserSettings" access="remote" output="false" returntype="string">
		<cfargument name="font" type="string" required="true" hint="user settings update font">
		<cfargument name="stylesheet" type="string" required="true" hint="user settings update stylesheet">
		<cfargument name="openNewWindow" type="string" required="true" hint="uset settings update openNewWindow">
	 	
	 	<cfset application.genieUserService.updateUserSettings(userId=arguments.userId,
															   userName=arguments.userName,
															   font=arguments.font,
															   stylesheet=arguments.stylesheet,
                                                               openNewWindow=arguments.openNewWindow)>
	 	
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
	 
</cfcomponent>