<cfcomponent>
	<cffunction name="Pad_Collar" access="public" returntype="string">
	<cfargument name="str_CollarNumber" type="string" required="true">
	 <cfif Len(str_CollarNumber) GT 0>
		<cfif Len(str_CollarNumber) IS "1">
		 <cfset str_Collar="000"&str_CollarNumber>
		</cfif>
		<cfif Len(str_CollarNumber) IS "2">
		 <cfset str_Collar="00"&str_CollarNumber>
		</cfif>
		<cfif Len(str_CollarNumber) IS "3">
		 <cfset str_Collar="0"&str_CollarNumber>
		</cfif>    
		<cfif Len(str_CollarNumber) GTE 4> 
		 <cfset str_Collar=str_CollarNumber>
		</cfif>
	 <cfelse>
	  <cfset str_Collar="">
   </cfif>
	 <cfreturn str_Collar>
	</cffunction>
	<cffunction name="Pad_Serial" access="public" returntype="string">
	<cfargument name="str_Serial" type="string" required="true">
   <cfset i_Loop=5-Len(str_Serial)>
	 <cfset str_RetSerial=str_Serial>
	 <cfloop index="i" from="1" to="#i_Loop#" step="1">
	  <cfset str_RetSerial="0"&str_RetSerial>
	 </cfloop>
	 <cfreturn str_RetSerial>
	</cffunction>		
</cfcomponent>