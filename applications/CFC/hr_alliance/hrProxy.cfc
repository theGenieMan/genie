<cfcomponent output="false">

	<cfset variables.dsn='wmercia'>
	
    <cffunction name="getUser" access="remote" returntype="Any" output="false" hint="gets a user based on user id supplied">
		<cfargument name="userId" type="string" hint="userId of user to get hr object for" required="true" />		
		<cfargument name="dsn" type="string" hint="userId of user to get hr object for" required="false" default="#variables.dsn#" />
		<cfargument name="returnJSON" type="boolean" required="false" default="true" hint="return in JSON format? default true" />
		
		<cfset var hrService=CreateObject('component','hrService').init(dsn=arguments.DSN)>
		<cfset var user=hrService.getUserByUID(uid=arguments.userId)>
		
		<cfset var userStruct=structNew()>
		<cfset var userStruct.isValidUser=user.getIsValidRecord()>
		<cfset var userStruct.fullName=user.getFullName()>
		<cfset var userStruct.email=user.getEmailAddress()>
		<cfset var userStruct.workPhone=user.getWorkPhone()>
		<cfset var userStruct.uid=user.getUserId()>
		<cfset var userStruct.otherUserId=user.getOtherUserId()>
				
		<cfif arguments.returnJSON>
		  <cfreturn serializeJSON(userStruct)>
		<cfelse>
		  <cfreturn user>
		</cfif>
		
	</cffunction>	

	<cffunction name="getUserByCollar" access="remote" returntype="Any" output="false" hint="gets a user based on force code and collar supplied">
		<cfargument name="collar" type="string" hint="collar of user to get hr object for" required="true" />
		<cfargument name="forceCode" type="string" hint="force of user to get user details for" required="false" default="22" />
		<cfargument name="dsn" type="string" hint="userId of user to get hr object for" required="false" default="#variables.dsn#" />
		<cfargument name="returnJSON" type="boolean" required="false" default="true" hint="return in JSON format? default true" />
		
		<cflog file="hrWS" text="getUserByCollar collar=#arguments.collar# forceCode=#arguments.forceCode#" type="information">
		
		<cfset var hrService=CreateObject('component','hrService').init(dsn=arguments.DSN)>
		<cfset var user=hrService.getUserByCollar(collar=arguments.collar,forceCode=arguments.forceCode)>
		
		<cfset var userStruct=structNew()>
		<cfset var userStruct.isValidUser=user.getIsValidRecord()>
		<cfset var userStruct.fullName=user.getFullName()>
		<cfset var userStruct.email=user.getEmailAddress()>
		<cfset var userStruct.workPhone=user.getWorkPhone()>
		<cfset var userStruct.uid=user.getUserId()>
		<cfset var userStruct.otherUserId=user.getOtherUserId()>
				
		<cfif arguments.returnJSON>
		  <cfreturn serializeJSON(userStruct)>
		<cfelse>
		  <cfreturn user>
		</cfif>
		
	</cffunction>	

</cfcomponent>