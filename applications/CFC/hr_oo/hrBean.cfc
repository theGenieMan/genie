<cfcomponent displayname="hrBean" hint="object for a persons HR Record" output="false">
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="hrBean" output="false">
		<cfargument name="personID" type="numeric" required="false" default="0" />
		<cfargument name="duty" type="string" required="false" default="" />
		<cfargument name="fullName" type="string" required="false" default="" />
		<cfargument name="firstName" type="string" required="false" default="" />
		<cfargument name="lastName" type="string" required="false" default="" />
		<cfargument name="officialFirstName" type="string" required="false" default="" />
		<cfargument name="collar" type="string" required="false" default="" />
		<cfargument name="workPhone" type="string" required="false" default="" />
		<cfargument name="location" type="string" required="false" default="" />
		<cfargument name="division" type="string" required="false" default="" />
		<cfargument name="department" type="string" required="false" default="" />
		<cfargument name="alternativeDept" type="string" required="false" default="" />
		<cfargument name="userID" type="string" required="false" default="" />
		<cfargument name="pncUserID" type="string" required="false" default="" />
		<cfargument name="pncGroupID" type="string" required="false" default="" />
		<cfargument name="pncDateCreated" type="string" required="false" default="" />
		<cfargument name="pncDateRemoved" type="string" required="false" default="" />
		<cfargument name="pncDateReinstated" type="string" required="false" default="" />
		<cfargument name="pncDateLastUsed" type="string" required="false" default="" />
		<cfargument name="analysisCriteriaID" type="string" required="false" default="" />
		<cfargument name="voicemailID" type="string" required="false" default="" />
		<cfargument name="voicemailNo" type="string" required="false" default="" />
		<cfargument name="faxNo" type="string" required="false" default="" />
		<cfargument name="mobileNo" type="string" required="false" default="" />
		<cfargument name="pagerNo" type="string" required="false" default="" />
		<cfargument name="emailAddress" type="string" required="false" default="" />
		<cfargument name="title" type="string" required="false" default="" />
		<cfargument name="team" type="string" required="false" default="" />		
		<cfargument name="isValidRecord" type="boolean" required="false" default="false" /> 
		<cfargument name="command" type="string" required="false" default="" />   

		<!--- run setters --->
		<cfset setPersonID(arguments.personID) />
		<cfset setDuty(arguments.duty) />
		<cfset setFullName(arguments.fullName) />
		<cfset setFirstName(arguments.firstName) />
		<cfset setLastName(arguments.lastName) />
		<cfset setOfficialFirstName(arguments.officialFirstName) />
		<cfset setCollar(arguments.collar) />
		<cfset setWorkPhone(arguments.workPhone) />
		<cfset setLocation(arguments.location) />
		<cfset setDivision(arguments.division) />
		<cfset setDepartment(arguments.department) />
		<cfset setAlternativeDept(arguments.alternativeDept) />
		<cfset setUserID(arguments.userID) />
		<cfset setPncUserID(arguments.pncUserID) />
		<cfset setPncGroupID(arguments.pncGroupID) />
		<cfset setPncDateCreated(arguments.pncDateCreated) />
		<cfset setPncDateRemoved(arguments.pncDateRemoved) />
		<cfset setPncDateReinstated(arguments.pncDateReinstated) />
		<cfset setPncDateLastUsed(arguments.pncDateLastUsed) />
		<cfset setAnalysisCriteriaID(arguments.analysisCriteriaID) />
		<cfset setVoicemailID(arguments.voicemailID) />
		<cfset setVoicemailNo(arguments.voicemailNo) />
		<cfset setFaxNo(arguments.faxNo) />
		<cfset setMobileNo(arguments.mobileNo) />
		<cfset setPagerNo(arguments.pagerNo) />
		<cfset setEmailAddress(arguments.emailAddress) />
		<cfset setTitle(arguments.title) />
		<cfset setTeam(arguments.team) />
		<cfset setIsValidRecord(arguments.isValidRecord)>
		<cfset setCommand(arguments.command) />		

		<cfreturn this />
 	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setPersonID" access="public" returntype="void" output="false">
		<cfargument name="personID" type="numeric" required="true" />
		<cfset variables.instance.personID = trim(arguments.personID) />
	</cffunction>
	<cffunction name="getPersonID" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.personID />
	</cffunction>

	<cffunction name="setDuty" access="public" returntype="void" output="false">
		<cfargument name="duty" type="string" required="true" />
		<cfset variables.instance.duty = arguments.duty />
	</cffunction>
	<cffunction name="getDuty" access="public" returntype="string" output="false">
		<cfreturn variables.instance.duty />
	</cffunction>

	<cffunction name="setFullName" access="public" returntype="void" output="false">
		<cfargument name="fullName" type="string" required="true" />
		<cfset variables.instance.fullName = arguments.fullName />
	</cffunction>
	<cffunction name="getFullName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.fullName />
	</cffunction>

	<cffunction name="setFirstName" access="public" returntype="void" output="false">
		<cfargument name="firstName" type="string" required="true" />
		<cfset variables.instance.firstName = arguments.firstName />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.firstName />
	</cffunction>

	<cffunction name="setLastName" access="public" returntype="void" output="false">
		<cfargument name="lastName" type="string" required="true" />
		<cfset variables.instance.lastName = arguments.lastName />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.lastName />
	</cffunction>

	<cffunction name="setOfficialFirstName" access="public" returntype="void" output="false">
		<cfargument name="officialFirstName" type="string" required="true" />
		<cfset variables.instance.officialFirstName = arguments.officialFirstName />
	</cffunction>
	<cffunction name="getOfficialFirstName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.officialFirstName />
	</cffunction>

	<cffunction name="setCollar" access="public" returntype="void" output="false">
		<cfargument name="collar" type="string" required="true" />
    <!--- if a collar is passed then strip off the first character which is not
          required ie. C8560 only get 8560 --->
    <cfif Len(arguments.collar) gt 0>
		<cfset variables.instance.collar = Right(arguments.collar,Len(arguments.collar)-1) />
    </cfif>
	</cffunction>
	<cffunction name="getCollar" access="public" returntype="string" output="false">
		<cfreturn variables.instance.collar />
	</cffunction>

	<cffunction name="setWorkPhone" access="public" returntype="void" output="false">
		<cfargument name="workPhone" type="string" required="true" />
		<cfset variables.instance.workPhone = arguments.workPhone />
	</cffunction>
	<cffunction name="getWorkPhone" access="public" returntype="string" output="false">
		<cfreturn variables.instance.workPhone />
	</cffunction>

	<cffunction name="setLocation" access="public" returntype="void" output="false">
		<cfargument name="location" type="string" required="true" />
		<cfset variables.instance.location = arguments.location />
	</cffunction>
	<cffunction name="getLocation" access="public" returntype="string" output="false">
		<cfreturn variables.instance.location />
	</cffunction>

	<cffunction name="setDivision" access="public" returntype="void" output="false">
		<cfargument name="division" type="string" required="true" />
    <!--- if a div is passed only take the first character which should be 
          the divisional letter --->
    <cfif Len(arguments.division) GT 0>
		<cfset variables.instance.division = Left(arguments.division,1) />
    </cfif>
	</cffunction>
	<cffunction name="getDivision" access="public" returntype="string" output="false">
		<cfreturn variables.instance.division />
	</cffunction>

	<cffunction name="setDepartment" access="public" returntype="void" output="false">
		<cfargument name="department" type="string" required="true" />
		<cfset variables.instance.department = arguments.department />
	</cffunction>
	<cffunction name="getDepartment" access="public" returntype="string" output="false">
		<cfreturn variables.instance.department />
	</cffunction>

	<cffunction name="setAlternativeDept" access="public" returntype="void" output="false">
		<cfargument name="alternativeDept" type="string" required="true" />
		<cfset variables.instance.alternativeDept = arguments.alternativeDept />
	</cffunction>
	<cffunction name="getAlternativeDept" access="public" returntype="string" output="false">
		<cfreturn variables.instance.alternativeDept />
	</cffunction>

	<cffunction name="setUserID" access="public" returntype="void" output="false">
		<cfargument name="userID" type="string" required="true" />
		<cfset variables.instance.userID = arguments.userID />
	</cffunction>
	<cffunction name="getUserID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.userID />
	</cffunction>

	<cffunction name="setPncUserID" access="public" returntype="void" output="false">
		<cfargument name="pncUserID" type="string" required="true" />
		<cfset variables.instance.pncUserID = arguments.pncUserID />
	</cffunction>
	<cffunction name="getPncUserID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pncUserID />
	</cffunction>

	<cffunction name="setPncGroupID" access="public" returntype="void" output="false">
		<cfargument name="pncGroupID" type="string" required="true" />
		<cfset variables.instance.pncGroupID = arguments.pncGroupID />
	</cffunction>
	<cffunction name="getPncGroupID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pncGroupID />
	</cffunction>

	<cffunction name="setPncDateCreated" access="public" returntype="void" output="false">
		<cfargument name="pncDateCreated" type="string" required="true" />
		<cfset variables.instance.pncDateCreated = arguments.pncDateCreated />
	</cffunction>
	<cffunction name="getPncDateCreated" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pncDateCreated />
	</cffunction>

	<cffunction name="setPncDateRemoved" access="public" returntype="void" output="false">
		<cfargument name="pncDateRemoved" type="string" required="true" />
		<cfset variables.instance.pncDateRemoved = arguments.pncDateRemoved />
	</cffunction>
	<cffunction name="getPncDateRemoved" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pncDateRemoved />
	</cffunction>

	<cffunction name="setPncDateReinstated" access="public" returntype="void" output="false">
		<cfargument name="pncDateReinstated" type="string" required="true" />
		<cfset variables.instance.pncDateReinstated = arguments.pncDateReinstated />
	</cffunction>
	<cffunction name="getPncDateReinstated" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pncDateReinstated />
	</cffunction>

	<cffunction name="setPncDateLastUsed" access="public" returntype="void" output="false">
		<cfargument name="pncDateLastUsed" type="string" required="true" />
		<cfset variables.instance.pncDateLastUsed = arguments.pncDateLastUsed />
	</cffunction>
	<cffunction name="getPncDateLastUsed" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pncDateLastUsed />
	</cffunction>

	<cffunction name="setAnalysisCriteriaID" access="public" returntype="void" output="false">
		<cfargument name="analysisCriteriaID" type="string" required="true" />
		<cfset variables.instance.analysisCriteriaID = arguments.analysisCriteriaID />
	</cffunction>
	<cffunction name="getAnalysisCriteriaID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.analysisCriteriaID />
	</cffunction>

	<cffunction name="setVoicemailID" access="public" returntype="void" output="false">
		<cfargument name="voicemailID" type="string" required="true" />
		<cfset variables.instance.voicemailID = arguments.voicemailID />
	</cffunction>
	<cffunction name="getVoicemailID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.voicemailID />
	</cffunction>

	<cffunction name="setVoicemailNo" access="public" returntype="void" output="false">
		<cfargument name="voicemailNo" type="string" required="true" />
		<cfset variables.instance.voicemailNo = arguments.voicemailNo />
	</cffunction>
	<cffunction name="getVoicemailNo" access="public" returntype="string" output="false">
		<cfreturn variables.instance.voicemailNo />
	</cffunction>

	<cffunction name="setFaxNo" access="public" returntype="void" output="false">
		<cfargument name="faxNo" type="string" required="true" />
		<cfset variables.instance.faxNo = arguments.faxNo />
	</cffunction>
	<cffunction name="getFaxNo" access="public" returntype="string" output="false">
		<cfreturn variables.instance.faxNo />
	</cffunction>

	<cffunction name="setMobileNo" access="public" returntype="void" output="false">
		<cfargument name="mobileNo" type="string" required="true" />
		<cfset variables.instance.mobileNo = arguments.mobileNo />
	</cffunction>
	<cffunction name="getMobileNo" access="public" returntype="string" output="false">
		<cfreturn variables.instance.mobileNo />
	</cffunction>

	<cffunction name="setPagerNo" access="public" returntype="void" output="false">
		<cfargument name="pagerNo" type="string" required="true" />
		<cfset variables.instance.pagerNo = arguments.pagerNo />
	</cffunction>
	<cffunction name="getPagerNo" access="public" returntype="string" output="false">
		<cfreturn variables.instance.pagerNo />
	</cffunction>

	<cffunction name="setEmailAddress" access="public" returntype="void" output="false">
		<cfargument name="emailAddress" type="string" required="true" />
		<cfset variables.instance.emailAddress = arguments.emailAddress />
	</cffunction>
	<cffunction name="getEmailAddress" access="public" returntype="string" output="false">
		<cfreturn variables.instance.emailAddress />
	</cffunction>

	<cffunction name="setTitle" access="public" returntype="void" output="false">
		<cfargument name="title" type="string" required="true" />
		<cfset variables.instance.title = arguments.title />
	</cffunction>
	<cffunction name="getTitle" access="public" returntype="string" output="false">
		<cfreturn variables.instance.title />
	</cffunction>
	
	<cffunction name="setTeam" access="public" returntype="void" output="false">
		<cfargument name="team" type="string" required="true" />
		<cfset variables.instance.team = arguments.team />
	</cffunction>
	<cffunction name="getTeam" access="public" returntype="string" output="false">
		<cfreturn variables.instance.team />
	</cffunction>	
  
 	<cffunction name="setIsValidRecord" access="public" returntype="void" output="false">
		<cfargument name="isValidRecord" type="boolean" required="true" />
		<cfset variables.instance.isValidRecord = arguments.isValidRecord />
	</cffunction>
	<cffunction name="getIsValidRecord" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isValidRecord />
	</cffunction>
	
	<cffunction name="setCommand" access="public" returntype="void" output="false">
		<cfargument name="command" type="string" required="true" />
		<cfset variables.instance.command = arguments.command />
	</cffunction>
	<cffunction name="getCommand" access="public" returntype="string" output="false">
		<cfreturn variables.instance.command />
	</cffunction>

	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
	<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>