
<cfcomponent name="hrService" output="false">

	<cffunction name="init" access="public" output="false" returntype="applications.cfc.hr_oo.hrService">
		<cfargument name="dsn" type="string" hint="datasource of where the data warehouse is" required="true" />
				
		<cfset variables.hrDAO = createObject('component','applications.cfc.hr_oo.hrDAO').init(dsn=arguments.dsn) />
		<cfset variables.hrGateway = createObject('component','applications.cfc.hr_oo.hrGateway').init(dsn=arguments.dsn) />
		
		<cfreturn this/>
	</cffunction>
  
	<cffunction name="getUserByCollar" access="public" output="false" returntype="applications.cfc.hr_oo.hrBean" hint="calls the DAO to get full user details, collar no needs to be passed in">
		<cfargument name="collar" type="String" required="true" default="" hint="collar no to get user details for" />
  
		<cfset var user = variables.hrDAO.read(ref=arguments.collar,refType='Collar') />
    
		<cfreturn user />
	</cffunction> 
  
	<cffunction name="getUserByUID" access="public" output="false" returntype="applications.cfc.hr_oo.hrBean" hint="calls the DAO to get full user details, user id needs to be passed in">
		<cfargument name="uid" type="String" required="true" default="" hint="collar no to get user details for" />

		<cfset var user = variables.hrDAO.read(ref=arguments.uid,refType='userID') />
	
		<cfreturn user />
	</cffunction>   
	
	<cffunction name="isMemberOf" access="public" output="false" returntype="boolean" hint="calls the gateway to see if user is a member of a given group">
		<cfargument name="groups" type="String" required="true" default="" hint="pipe seperated list of groups to check" />
		<cfargument name="uid" type="String" required="true" default="" hint="user id" />		
		<cfargument name="adServer" type="String" required="true" default="" hint="ip address of server that has the ldap groups on" />				

		<cfset var isMember = variables.hrGateway.isMemberOf(uid=arguments.uid,groups=arguments.groups,adServer=arguments.adServer) />
    
		<cfreturn isMember />
	</cffunction>  	

</cfcomponent>
