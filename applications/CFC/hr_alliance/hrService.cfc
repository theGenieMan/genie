
<cfcomponent name="hrService" output="false">

	<cffunction name="init" access="public" output="false" returntype="hrService">
		<cfargument name="dsn" type="string" hint="datasource of where the data warehouse is" required="true" />
				
		<cfset variables.hrDAO = createObject('component','hrDAO').init(dsn=arguments.dsn) />
		<cfset variables.hrGateway = createObject('component','hrGateway').init(dsn=arguments.dsn) />
		
		<cfreturn this/>
	</cffunction>
  
	<cffunction name="getUserByCollar" access="public" output="false" returntype="hrBean" hint="calls the DAO to get full user details, collar no needs to be passed in">
		<cfargument name="collar" type="String" required="true" hint="collar no to get user details for" />
  	    <cfargument name="forceCode" type="string" required="false" default="22" hint="force code to lookup from default 22 west mercia." > 

		<cfset var user = variables.hrDAO.read(ref=arguments.collar,refType='Collar',forceCode=arguments.forceCode) />
    
		<cfreturn user />
	</cffunction> 
  
	<cffunction name="getUserByUID" access="public" output="false" returntype="hrBean" hint="calls the DAO to get full user details, user id needs to be passed in">
		<cfargument name="uid" type="String" required="true" default="" hint="collar no to get user details for" />

		<cfset var fUser = formatUserid(arguments.uid)>
		<cfset var fUid = fUser.userId>
		<cfset var adUid = fUser.adUserId> 
		<cfset var user = '' />
		
		<cfset user = variables.hrDAO.read(ref=fUid,refType='userID') />
		
		<cfif user.getIsValidRecord()>
			 <cfset user.setAdUserId(adUid)>
		</cfif>
	
		<cfreturn user />
	</cffunction>   
	
	<cffunction name="isMemberOf" access="public" output="false" returntype="boolean" hint="calls the gateway to see if user is a member of a given group">
		<cfargument name="uid" type="String" required="true" default="" hint="user id" />
		<cfargument name="groups" type="String" required="true" default="" hint="pipe seperated list of groups to check" />
		<cfargument name="adServer" type="String" required="true" default="" hint="ip address of server that has the ldap groups on" />				

		<cfset var isMember = variables.hrGateway.isMemberOf(uid=arguments.uid,groups=arguments.groups,adServer=arguments.adServer) />
    
		<cfreturn isMember />
	</cffunction>  	
	
	<cffunction name="formatUserid" access="public" output="false" returntype="struct" hint="returns a struct of the pure west mercia or warwickshire user id from a strong containing them, eg westmerpolice01\n_bla003 returns n_bla003 or wmp\23001234ag returns 23001234 AND which force it has come from eg 22 (west mercia) and 23 (warwickshire)">
		<cfargument name="uid" type="String" required="true" hint="user id to format" />
		
		<cfset var aFormattedUser="">
		<cfset var sUID="">
		<cfset var returnStruct=structNew()>
		
		<!--- first up remove everything after the \ --->
		<cfset aFormattedUser=REMatch('([^\\]+)$',arguments.uid)>
		
		<!--- if we get a matches then take the first element of the returned array, 
			  otherwise there was no \ so just take the user id  --->
		<cfif arrayLen(aFormattedUser) GT 0>
			<cfset sUID=aFormattedUser[1]>
		<cfelse>
			<cfset sUID=arguments.UID>
		</cfif>	
		
		<!--- see if the user id starts with 23 (ie Warks)
		      if so make sure that any characters are stripped from the end
		      as sometimes warks user id's look like 23001234ag rather than just 23001234 --->
		      
		<cfset aFormattedUser=REMatch('^(23[0-9]+)',sUID)>
		
		<!--- if we get a match then just take the returned match
		      otherwise it's a West Mercia User id --->
		
		<cfif arrayLen(aFormattedUser) GT 0>
			<cfset returnStruct.adUserId=sUid>
			<cfset sUid=aFormattedUser[1]>			
			<cfset returnStruct.userId=ReReplaceNoCase(sUid,"[^0-9]","","ALL")>
			<cfset returnStruct.force=23>
		<cfelse>
			<cfset returnStruct.adUserId=sUid>
			<cfset returnStruct.userId=sUid>
			<cfset returnStruct.force=22>
		</cfif>      
			
		<cfreturn returnStruct>	
	
	</cffunction>

	<cffunction name="quickSearch" access="public" output="false" returntype="hrBean[]" hint="returns an array of HRBeans matching the quicksearch text">
		<cfargument name="searchText" type="String" required="true" hint="text to search on" />
		<cfargument name="maxResults" type="numeric" required="false" default="100" hint="max no results"> 
		<cfset var users=variables.hrDAO.quickSearch(searchText=arguments.searchText,maxResults=arguments.maxResults)>
					
		<cfreturn users>	
	
	</cffunction>

</cfcomponent>
