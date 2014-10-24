<cfcomponent>
	<cffunction name="checkDate" access="public" returntype="string">
		<cfargument name="str_Date" type="string" required="true">
		  <cfset var locale=SetLocale("English (UK)")>
		  <cfset var str_Valid="YES">
		  
          <cfif Len(str_Date) IS 0>
            <cfset str_Valid="NO">
		  <cfelse>
	         <cfif ListLen(str_Date,"/") IS NOT 3>
 			  <cfset str_Valid="NO">
			 <cfelse>
                <cfif Len(str_Date) IS NOT 10>	 
				 <cfset str_Valid="NO">
				<cfelse>
		           <cfif LSisDate(str_Date) IS "NO">
				     <cfset str_Valid="NO">
 		           </cfif>
		        </cfif>
 	         </cfif>
	      </cfif>
		  <cfreturn str_Valid>
	</cffunction>

	<cffunction name="checkTime" access="public" returntype="string">
		<cfargument name="str_Time" type="string" required="true">
		<cfset var locale=SetLocale("English (UK)")>	
		<cfset var str_Valid="YES">
		
		<cfif Len(str_Time) IS NOT 5>
		  <cfset str_Valid="NO">
		<cfelse>
		  <cfif ListLen(str_Time,":") IS NOT 2>
			 <cfset str_Valid="NO">
			<cfelse>
			 <cfset str_hour=ListGetAt(str_Time,1,":")>
			 <cfset str_mins=ListGetAt(str_Time,2,":")>
			 
			 <cfif not isNumeric(str_Hour)>
			  <cfset str_Valid="NO">
			 <cfelse>
			   <cfset str_hour=Int(str_hour)>
			   <cfif not isNumeric(str_mins)>
				  <cfset str_Valid="NO">
				 <cfelse>
				  <cfset str_mins=Int(str_mins)>
					<cfif str_hour LT 0 OR str_hour GT 23>
				    <cfset str_Valid="NO">					
					<cfelse>
					  <cfif str_mins LT 0 OR str_mins GT 59>
						 <cfset str_Valid="NO">
						</cfif>
					</cfif>
				 </cfif>
			 </cfif>
			 
			</cfif>
		</cfif>
		
		<cfreturn str_Valid>
		
	</cffunction>

</cfcomponent>