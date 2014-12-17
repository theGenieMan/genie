<cfcomponent output="false">

	<cfif SERVER_NAME IS "genie.intranet.wmcpolice"
	   OR SERVER_NAME IS "genieuat.intranet.wmcpolice" 
	   OR SERVER_NAME IS "svr20312"
	   OR SERVER_NAME IS "svr20306"
	   OR SERVER_NAME IS "svr20424"
	   OR SERVER_NAME IS "svr20623"
	   OR SERVER_NAME IS "svr20624"	
	   OR SERVER_NAME IS "svr20031"	
	   OR SERVER_NAME IS "svr20290">
	   	<cfset variables.dsn='wmercia_jdbc'>  
	<cfelse>		  		
		<cfset variables.dsn='wmercia'>
	</cfif>
	
	<cfset variables.xmlHeader=''>
	<cfset variables.xmlFooter=''>
	<cfset variables.hrUser=''>
	<cfset variables.hrUsers=''>
	
	<cfsavecontent variable="variables.xmlHeader">
	<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	  <soap:Body>	
	</cfsavecontent>
	
	<cfsavecontent variable="variables.xmlFooter">
	  </soap:Body>
	</soap:Envelope>	
	</cfsavecontent>
	
	<cfsavecontent variable="variables.hrUser">	
	    <HRUser>		  
		  <personId>~personId~</personId>
		  <duty><![CDATA[~duty~]]></duty>
		  <fullName>~fullName~</fullName>
		  <firstName>~firstName~</firstName>
		  <lastName>~lastName~</lastName>
		  <officialFirstName>~officialFirstName~</officialFirstName>
		  <collar>~collar~</collar>
		  <workPhone><![CDATA[~workPhone~]]></workPhone>
		  <location><![CDATA[~location~]]></location>
		  <division><![CDATA[~division~]]></division>
		  <department><![CDATA[~department~]]></department>
		  <alternativeDept><![CDATA[~alternativeDept~]]></alternativeDept>
		  <userId>~userId~</userId>
		  <pncUserId>~pncUserId~</pncUserId>
		  <pncGroupId>~pncGroupId~</pncGroupId>
		  <pncDateCreated>~pncDateCreated~</pncDateCreated>
		  <pncDateRemoved>~pncDateRemoved~</pncDateRemoved>
		  <pncDateReinstated>~pncDateReinstated~</pncDateReinstated>
		  <pncDateLastUsed>~pncDateLastUsed~</pncDateLastUsed>
		  <analysisCriteriaID>~analysisCriteriaID~</analysisCriteriaID>
		  <voicemailID>~voicemailId~</voicemailID>
		  <voicemailNo>~voicemailNo~</voicemailNo>
		  <faxNo><![CDATA[~faxNo~]]></faxNo>
		  <mobileNo><![CDATA[~mobileNo~]]></mobileNo>
		  <pagerNo><![CDATA[~pagerNo~]]></pagerNo>
		  <emailAddress>~emailAddress~</emailAddress>
		  <title>~title~</title>		  
		  <isValidRecord>~isValidRecord~</isValidRecord>
		  <command><![CDATA[~command~]]></command>
		  <manager>~manager~</manager>		  
		  <forceCode>~forceCode~</forceCode>
		  <otherUserId>~otherUserId~</otherUserId>
		  <trueUserId>~trueUserId~</trueUserId>
		  <isSgtAndAbove>~isSgtAndAbove~</isSgtAndAbove>
		</HRUser>	  
	</cfsavecontent>

	<cfsavecontent variable="variables.hrUsers">
		<recordCount>~recordCount~</recordCount>	
	    <HRUsers>		  		  
		  ~HRUserList~
		</HRUsers>	  
	</cfsavecontent>
	
    <cffunction name="getUser" access="remote" returntype="xml" output="false" hint="gets a user based on user id supplied">
		<cfargument name="userId" type="string" hint="userId of user to get hr object for" required="true" />		
		<cfargument name="dsn" type="string" hint="userId of user to get hr object for" required="false" default="#variables.dsn#" />
		
		<cfset var hrService=CreateObject('component','hrService').init(dsn=arguments.DSN)>
		<cfset var user=hrService.getUserByUID(uid=arguments.userId)>
		
		<cfreturn formatXml(user)>
		
	</cffunction>	

	<cffunction name="getUserByCollar" access="remote" returntype="xml" output="false" hint="gets a user based on force code and collar supplied">
		<cfargument name="collar" type="string" hint="collar of user to get hr object for" required="true" />
		<cfargument name="forceCode" type="string" hint="force of user to get user details for" required="false" default="22" />
		<cfargument name="dsn" type="string" hint="userId of user to get hr object for" required="false" default="#variables.dsn#" />
		
		<cflog file="hrWS" text="getUserByCollar collar=#arguments.collar# forceCode=#arguments.forceCode#" type="information">
		
		<cfset var returnXml=Duplicate(variables.xmlHeader)>		
		<cfset var hrService=CreateObject('component','hrService').init(dsn=arguments.DSN)>
		<cfset var user=hrService.getUserByCollar(collar=arguments.collar,forceCode=arguments.forceCode)>
		
		<cfset returnXml &= formatXml(user)>
		<cfset returnXml &= Duplicate(variables.xmlFooter)>
		
		<cfreturn returnXml>
		
	</cffunction>	

	<cffunction name="quickSearch" access="remote" returntype="xml" output="false" hint="gets a list of users based some text, searches on wildcards firstname, lastname and exact collar">
		<cfargument name="searchText" type="string" hint="text to search on" required="true" />
		<cfargument name="maxResults" type="numeric" required="false" default="100" > 
		<cfargument name="dsn" type="string" hint="datasource to search" required="false" default="#variables.dsn#" />
		
		<cflog file="hrWS" text="quickSearch searchText=#arguments.searchText#" type="information">
		
		<cfset var hrService=CreateObject('component','hrService').init(dsn=arguments.DSN)>
		<cfset var users=hrService.quickSearch(searchText=arguments.searchText,maxResults=maxResults)>		
		<cfset var returnXml=Duplicate(variables.xmlHeader)>
		<cfset var userXmlList="">
		<cfset var iUser=1>
		
		<cfloop from="1" to="#arrayLen(users)#" index="iUser">
			<cfset userXmlList &= formatXml(users[iUser])>
		</cfloop>
		
		<cfset returnXml &= Replace(Duplicate(variables.hrUsers),'~recordCount~',arrayLen(users))>
		<cfset returnXml = Replace(returnXml,'~HRUserList~',userXmlList)>
		<cfset returnXml &= Duplicate(variables.xmlFooter)>
		
		<cflog file="hrWS" text="quickSearch returned=#returnXml#" type="information">
		
		<cfreturn returnXml>
		
	</cffunction>	
	
	<cffunction name="formatXml" access="private" returntype="xml" output="false" hint="returns an xml representation of a hr user object">
		<cfargument name="hrObj" required="true" type="hrBean" hint="hr object to create xml from">
		
		<cfset var userXml=Duplicate(variables.hrUser)> 
		
		<cfset userXml=Replace(userXml,'~personId~',arguments.hrObj.getPersonId())>
		<cfset userXml=Replace(userXml,'~duty~',arguments.hrObj.getDuty())>
		<cfset userXml=Replace(userXml,'~fullName~',arguments.hrObj.getFullName())>
		<cfset userXml=Replace(userXml,'~firstName~',arguments.hrObj.getFirstName())>
		<cfset userXml=Replace(userXml,'~lastName~',arguments.hrObj.getLastName())>
		<cfset userXml=Replace(userXml,'~officialFirstName~',arguments.hrObj.getFirstName())>
		<cfset userXml=Replace(userXml,'~collar~',arguments.hrObj.getCollar())>
		<cfset userXml=Replace(userXml,'~workPhone~',arguments.hrObj.getWorkPhone())>
		<cfset userXml=Replace(userXml,'~location~',arguments.hrObj.getLocation())>
		<cfset userXml=Replace(userXml,'~division~',arguments.hrObj.getDivision())>
		<cfset userXml=Replace(userXml,'~department~',arguments.hrObj.getDepartment())>
		<cfset userXml=Replace(userXml,'~alternativeDept~',arguments.hrObj.getAlternativeDept())>
		<cfset userXml=Replace(userXml,'~userId~',arguments.hrObj.getUserId())>
		<cfset userXml=Replace(userXml,'~pncUserId~',arguments.hrObj.getPncUserId())>
		<cfset userXml=Replace(userXml,'~pncGroupId~',arguments.hrObj.getPncGroupId())>
		<cfset userXml=Replace(userXml,'~pncDateCreated~',arguments.hrObj.getPncDateCreated())>
		<cfset userXml=Replace(userXml,'~pncDateRemoved~',arguments.hrObj.getPncDateRemoved())>
		<cfset userXml=Replace(userXml,'~pncDateReinstated~',arguments.hrObj.getPncDateReinstated())>
		<cfset userXml=Replace(userXml,'~pncDateLastUsed~',arguments.hrObj.getPncDateLastUsed())>
		<cfset userXml=Replace(userXml,'~analysisCriteriaID~',arguments.hrObj.getAnalysisCriteriaID())>
		<cfset userXml=Replace(userXml,'~voicemailId~',arguments.hrObj.getVoicemailId())>
		<cfset userXml=Replace(userXml,'~voicemailNo~',arguments.hrObj.getVoicemailNo())>
		<cfset userXml=Replace(userXml,'~faxNo~',arguments.hrObj.getFaxNo())>
		<cfset userXml=Replace(userXml,'~mobileNo~',arguments.hrObj.getMobileNo())>
		<cfset userXml=Replace(userXml,'~pagerNo~',arguments.hrObj.getPagerNo())>
		<cfset userXml=Replace(userXml,'~emailAddress~',arguments.hrObj.getEmailAddress())>
		<cfset userXml=Replace(userXml,'~title~',arguments.hrObj.getTitle())>		
		<cfset userXml=Replace(userXml,'~isValidRecord~',arguments.hrObj.getIsValidRecord())>
		<cfset userXml=Replace(userXml,'~command~',arguments.hrObj.getCommand())>
		<cfset userXml=Replace(userXml,'~manager~',arguments.hrObj.getManager())>
		<cfset userXml=Replace(userXml,'~isValidRecord~',arguments.hrObj.getIsValidRecord())>
		<cfset userXml=Replace(userXml,'~forceCode~',arguments.hrObj.getForceCode())>
		<cfset userXml=Replace(userXml,'~otherUserId~',arguments.hrObj.getOtherUserId())>
		<cfset userXml=Replace(userXml,'~trueUserId~',arguments.hrObj.getTrueUserId())>
		<cfset userXml=Replace(userXml,'~isSgtAndAbove~',arguments.hrObj.getIsSgtAndAbove())>
		
		<cfreturn userXml>
		
	</cffunction>

</cfcomponent>