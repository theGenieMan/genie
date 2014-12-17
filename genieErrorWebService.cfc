<cfcomponent>
	<cffunction name="logError" access="remote" output="false" returntype="string" returnformat="plain">
		<cfset var errorData=deserializeJSON(toString(getHttpRequestData().content))>       
	 	<cfset var errorUrn=application.genieErrorService.logError(errorData)>
		 
		<cfreturn errorUrn>	
		 
	</cffunction>		
	
	<cffunction name="getErrorList" access="remote" returntype="xml" output="false" hint="gets an xml list of genie errors">
  	  <cfargument name="errorUrn" type="string" required="true" hint="urn of the error">
	  <cfargument name="errorYear" type="string" required="true" hint="error year">	    	  	  
	  <cfargument name="dateFrom" type="string" required="true" hint="error from date dd/mm/yyyy">
	  <cfargument name="dateTo" type="string" required="true" hint="erro to date dd/mm/yyyy">
	  <cfargument name="errorBy" type="string" required="true" hint="person who generated the error">
	  <cfargument name="status" type="string" required="true" hint="error status">  	 
	  
	  <cfset var errorXml=application.genieErrorService.getErrorList(errorUrn,errorYear,dateFrom,dateTo,errorBy,status)>	
		 
	  <cfreturn errorXml>	
		 
	</cffunction>	
	
		
</cfcomponent>