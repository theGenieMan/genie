<cfcomponent displayname="hrDAO"
	output="false"
	hint="Data Access Object for persons hr record">
  
<cffunction name="init" access="public" output="false" returntype="hrDAO" hint="constructor">
     <cfargument name="DSN" type="string" required="true" hint="datasource" />
     <cfset variables.DSN = arguments.DSN />
     <cfreturn this />
</cffunction>

<cffunction name="read" access="public" output="true" returntype="applications.cfc.hr_oo.hrBean" hint="based on a an unique ref and it's type get a hr record">
     <cfargument name="ref" type="string" required="true" hint="ref to read in" />
     <cfargument name="refType" type="string" required="true" hint="what type is the ref userId,collar,pncID,personID are possible values" />     

     <!--- setup a new hr object --->
     <cfset hrRecord=CreateObject("component","applications.cfc.hr_oo.hrBean").init()>
 
     <cfset lisValidRefTypes="UserID,Collar,PncID,PersonID">
     
     <!--- check the passed in refType is in the allowable list above,
           if it is then continue to run the query. If not an empty
           bean is return with isValidRecord set to false (default value) --->
 
     <cfif ListFindNoCase(lisValidRefTypes,refType,",") GT 0>
     
	     <cfquery name="qHR" datasource="#variables.DSN#">
		 		  Select *
				  From common_owner.HR_DETAILS
			 	  Where 
		        <cfswitch expression="#refType#">
		         <cfcase value="userID">
		          USER_ID=<cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_varchar">
		         </cfcase>
		         <cfcase value="collar">
				  <cfif isNumeric(ref)>
				  TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(ref)#" cfsqltype="cf_sql_integer">
				  <cfelseif not isNumeric(Left(ref,1))>
				  COLLAR=<cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_varchar">	  
				  <cfelse>
		          SUBSTR(COLLAR,2,LENGTH(COLLAR)-1)=<cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_varchar">
				  </cfif>
		         </cfcase>
		         <cfcase value="pncID">
		          PNC_USER_ID=<cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_varchar">
		         </cfcase>
		         <cfcase value="personID">
		          PERSON_ID=<cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_numeric">
		         </cfcase>                                                            
		        </cfswitch>
			   </cfquery>
			
					<cfif qHR.RecordCount GT 0>
						<cfset hrRecord.setPersonID(qHR.PERSON_ID) />
						<cfset hrRecord.setDuty(qHR.DUTY) />
						<cfset hrRecord.setFullName(qHR.FULL_NAME) />
						<cfset hrRecord.setFirstName(qHR.FIRST_NAME) />
						<cfset hrRecord.setLastName(qHR.LAST_NAME) />
						<cfset hrRecord.setOfficialFirstName(qHR.OFFICIAL_FIRST_NAME) />
						<cfset hrRecord.setCollar(qHR.COLLAR) />
						<cfset hrRecord.setWorkPhone(qHR.WORK_PHONE) />
						<cfset hrRecord.setLocation(qHR.LOCATION) />
						<cfset hrRecord.setDivision(qHR.DIVISION) />
						<cfset hrRecord.setDepartment(qHR.DEPARTMENT) />
						<cfset hrRecord.setAlternativeDept(qHR.ALTERNATIVE_DEPT) />
						<cfset hrRecord.setUserID(lcase(qHR.USER_ID)) />
						<cfset hrRecord.setPncUserID(qHR.PNC_USER_ID) />
						<cfset hrRecord.setPncGroupID(qHR.PNC_GROUP_ID) />
						<cfset hrRecord.setPncDateCreated(qHR.PNC_DATECREATED) />
						<cfset hrRecord.setPncDateRemoved(qHR.PNC_DATEREMOVED) />
						<cfset hrRecord.setPncDateReinstated(qHR.PNC_DATEREINSTATED) />
						<cfset hrRecord.setPncDateLastUsed(qHR.PNC_DATELASTUSED) />
						<cfset hrRecord.setAnalysisCriteriaID(qHR.ANALYSIS_CRITERIA_ID) />
						<cfset hrRecord.setVoicemailID(qHR.VOICEMAIL_ID) />
						<cfset hrRecord.setVoicemailNo(qHR.VOICEMAIL_NO) />
						<cfset hrRecord.setFaxNo(qHR.FAX_NO) />
						<cfset hrRecord.setMobileNo(qHR.MOBILE_NO) />
						<cfset hrRecord.setPagerNo(qHR.PAGER_NO) />
						<cfset hrRecord.setEmailAddress(qHR.EMAIL_ADDRESS) />
						<cfset hrRecord.setTitle(qHR.TITLE) />
						<cfset hrRecord.setTeam(qHR.TEAM) />	
						<cfset hrRecord.setCommand(qHR.COMMAND) />						
            <cfset hrRecord.setIsValidRecord(true)>																	
					</cfif>  
				
	     </cfif> 
	      
	     <cfreturn hrRecord />
	</cffunction>
	
	</cfcomponent>  