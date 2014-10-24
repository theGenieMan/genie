<cfcomponent displayname="hrGateway"
	output="false"
	hint="Gateway Object for hr person reocrd">

 <cffunction name="init" access="public" output="false" returntype="hrGateway" hint="constructor">
     <cfargument name="DSN" type="string" required="true" hint="HR Table DSN" />
     
     <cfset variables.DSN = arguments.DSN />
     <cfreturn this />
 </cffunction>

 <cffunction name="isValidCollar" access="public" output="true" returntype="boolean" hint="based on a an collar no, returns true if collar no exists, false otherwise">
     <cfargument name="collar" type="string" required="true" hint="collar no to check" />
     
	     <cfquery name="qHR" datasource="#variables.DSN#">
		 		  Select *
				  From common_owner.HR_DETAILS
			 	  Where TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(collar)#" cfsqltype="cf_sql_numeric">
			 </cfquery>
			
					<cfif qHR.RecordCount GT 0>
            <cfreturn true>
          <cfelse>
            <cfreturn false>
					</cfif>  

	</cffunction>

 <cffunction name="isMemberOf" displayname="isMemberOf" hint="given a user id and a list of groups returns true or false dependant on if the user is in one of the AD groups">
	<cfargument name="groups" type="string" required="true">	
	<cfargument name="UID" type="string" required="true">
	<cfargument name="adServer" type="string" required="true">

	<cfset var sReturn=false> 
	<cfset var results_id="">
	<cfset var group="">
	<cfset var s_GroupText="">
	
    <cftry>
    
		<cfldap action="QUERY" 
		name="results_id" 
		attributes="MemberOf"
				start="DC=westmerpolice01,DC=local"
				filter="(&(sAMAccountName=#UID#))"
				server="#adServer#"
				username="westmerpolice01\cold_fusion"
				password="a11a1re"
			    separator="|"> 
				
		<cfif results_id.RecordCount GT 0>
		 <cfloop query="results_id" startrow="1" endrow="1">
		 
		  <cfloop index="group" list="#MEMBEROF#" delimiters="|">
		  <cfset s_GroupText=ListGetAt(group,1,",")>
		  <cfset s_GroupText=ReplaceNoCase(s_GroupText,"cn=","","ALL")>		    
		  
		   <cfif ListFindNoCase(groups,s_GroupText,",") GT 0>
			 <cfset sReturn=true>
			 <cfbreak>
		   </cfif>
		 </cfloop>
		 
		 </cfloop>
		<cfelse>
		 <cfset sReturn=false>
		</cfif>
	
    <cfreturn sReturn>
    
	<cfcatch type="Any">
     <cfreturn false>		 
	</cfcatch>
	
   </cftry> 
  </cffunction>	

</cfcomponent>