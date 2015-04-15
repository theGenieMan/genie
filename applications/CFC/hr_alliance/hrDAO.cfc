<cfcomponent displayname="hrDAO"
	output="false"
	hint="Data Access Object for persons hr record">
  
<cffunction name="init" access="public" output="false" returntype="hrDAO" hint="constructor">
     <cfargument name="DSN" type="string" required="true" hint="datasource" />
	 <cfargument name="adServer" type="string" required="false" hint="address of AD Server" default="10.1.230.216" />
     <cfset variables.DSN = arguments.DSN />
	 <cfset variables.adServer = arguments.adServer>
     <cfreturn this />
</cffunction>

<cffunction name="read" access="public" output="true" returntype="hrBean" hint="based on a an unique ref and it's type get a hr record">
     <cfargument name="ref" type="string" required="true" hint="ref to read in" />
     <cfargument name="refType" type="string" required="true" hint="what type is the ref userId,collar,pncID,personID are possible values" />
	 <cfargument name="forceCode" type="string" required="false" hint="force code of user to lookup only required if refType is collar. Default 22 West Mercia" default="22" >     

     <!--- setup a new hr object --->
     <cfset var hrRecord=CreateObject("component","hrBean").init()>
	 <cfset var userQuery="">
	  	  
	 <cfif refType IS "userId">
	  <cfset hrRecord.setUserId(ref)>
	 <cfelseif refType IS "collar">
	  <cfset hrRecord.setCollar(ref)>
	 </cfif>
 
     <cfset lisValidRefTypes="UserID,Collar,PncID,PersonID">
     
     <!--- check the passed in refType is in the allowable list above,
           if it is then continue to run the query. If not an empty
           bean is return with isValidRecord set to false (default value) --->
 
     <cfif ListFindNoCase(lisValidRefTypes,refType,",") GT 0>
     
	     <cfquery name="qHR" datasource="#variables.DSN#" result="qHRRes">
		 		  Select *
				  From common_owner.HR_DETAILS_ALLIANCE
			 	  Where 
		        <cfswitch expression="#refType#">
		         <cfcase value="userID">
		           (     USER_ID       =  <cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_varchar">
				     OR  OTHER_USER_ID =  <cfqueryparam value="#UCase(ref)#" cfsqltype="cf_sql_varchar">
				   ) 
		         </cfcase>
		         <cfcase value="collar">
		          TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(UCase(ref))#" cfsqltype="cf_sql_number">
		          AND FORCE_CODE=<cfqueryparam value="#arguments.forceCode#" cfsqltype="cf_sql_varchar">
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
						<cfset hrRecord.setCommand(qHR.COMMAND) />
						<cfset hrRecord.setManager(qHR.MANAGER) />
						<cfset hrRecord.setForceCode(qHR.FORCE_CODE) />
						<cfset hrRecord.setOtherUserId(qHR.OTHER_USER_ID) />
						<cfset hrRecord.setTrueUserId(qHR.TRUE_USER_ID) />
            			<cfset hrRecord.setIsValidRecord(true)>		
            		<cfelse>
						<!--- no HR warehouse record so try Active Directory, if we have a userId type search --->
						
						<cfif refType IS "userId">
							<cfldap action="QUERY" name="userQuery"
							attributes="displayName"	start="DC=westmerpolice01,DC=local"
							scope="SUBTREE" maxrows="1"
							filter="samaccountname=#ref#"
							server="#variables.adServer#"
							username="westmerpolice01\cold_fusion"
							password="a11a1re" />		
						    	
							<cfif userQuery.recordCount GT 0>
								<cfset hrRecord.setFullName(userQuery.displayName) />
								<cfset hrRecord.setForceCode('XX')>
								<cfset hrRecord.setUserId(ref)>
								<cfset hrRecord.setCollar('999999')>
								<cfset hrRecord.setDuty('TEMPORARY USER NOT ON HR')>
								<cfset hrRecord.setIsValidRecord(true)>		
							</cfif>
							
						</cfif>													
					</cfif>  
				
	     </cfif> 
	      
	     <cfreturn hrRecord />
	</cffunction>
	
<cffunction name="quickSearch" access="public" output="true" returntype="hrBean[]" hint="based on searchText returns an array of matching users max 50">
	<cfargument name="searchText" type="string" required="true" hint="text to search on" />
	<cfargument name="maxResults" type="numeric" required="false" default="100" hint="max no of results" />
	
	<cfset var qSearch="">
	<cfset var thisUser="">
	<cfset var arrUsers=ArrayNew(1)>
	<cfset var tempHRRecord="">
	
	<!--- do the query based on the last name, first name being wildcarded on the search text, or if search text is number assume
	      that it's a collar no and try and match on that.
	      the results are ordered on exact matches first --->
	<cfquery name="qSearch" datasource="#variables.DSN#">
	SELECT *
	FROM (
 		SELECT USER_ID,FIRST_NAME, LAST_NAME, FULL_NAME,
		       CASE  <cfif isNumeric(arguments.searchText)>
		       		 WHEN TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(UCase(arguments.searchText))#" cfsqltype="cf_sql_number"> THEN 1	 
		       		 </cfif>
		       		 WHEN LAST_NAME=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> THEN 2
		       		 WHEN UPPER(FIRST_NAME)=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> THEN 3
		             WHEN LAST_NAME LIKE <cfqueryparam value="#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 4		             
		             WHEN UPPER(FIRST_NAME) LIKE <cfqueryparam value="#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 5
		             WHEN LAST_NAME LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 6
		             WHEN UPPER(FIRST_NAME) LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 7
		       END AS SORTING_ORDER
		FROM   common_owner.hr_details_alliance
		WHERE  LAST_NAME LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">	or UPPER(FIRST_NAME) LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">
		OR     USER_ID=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> 
		OR     OTHER_USER_ID=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar">
		OR     TRUE_USER_ID=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar">
       <cfif isNumeric(arguments.searchText)>
	   OR TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(UCase(arguments.searchText))#" cfsqltype="cf_sql_number">	   
	   </cfif>
		ORDER BY SORTING_ORDER, LAST_NAME, FIRST_NAME
	    )
	 WHERE rownum < #maxResults#
	</cfquery>	
	
	<!--- if the search string matches a 900 user id AND we get no results from the HR Table search then try AD --->
	<cfif qSearch.recordCount IS 0 AND (ArrayLen(REMatch('[a-z]_[a-z]{3}9[0-9][0-9]',arguments.searchText)) OR ArrayLen(REMatch('2300[0-9][0-9][0-9][0-9]',arguments.searchText)) GT 0)>
		<cfset tempHRRecord=read(ref=searchText,refType='userId')>
		<cfif tempHRRecord.getIsValidRecord()>
			<cfset arrayAppend(arrUsers,tempHRRecord)>
	    </cfif>
	<cfelse>
	
		<cfloop query="qSearch">
			<cfset arrayAppend(arrUsers,read(ref=USER_ID,refType='userId'))>
		</cfloop>
	
	</cfif>
	
	<cfreturn arrUsers>
		
</cffunction>		

<cffunction name="quickSearch_290813" access="public" output="true" returntype="hrBean[]" hint="based on searchText returns an array of matching users max 50">
	<cfargument name="searchText" type="string" required="true" hint="text to search on" />
	<cfargument name="maxResults" type="numeric" required="false" default="100" hint="max no of results" />
	
	<cfset var qSearch="">
	<cfset var thisUser="">
	<cfset var arrUsers=ArrayNew(1)>
	
	<!--- do the query based on the last name, first name being wildcarded on the search text, or if search text is number assume
	      that it's a collar no and try and match on that.
	      the results are ordered on exact matches first --->
	<cfquery name="qSearch" datasource="#variables.DSN#">
	SELECT *
	FROM (
 		SELECT USER_ID,FIRST_NAME, LAST_NAME, FULL_NAME,
		       CASE  <cfif isNumeric(arguments.searchText)>
		       		 WHEN TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(UCase(arguments.searchText))#" cfsqltype="cf_sql_number"> THEN 1	 
		       		 </cfif>
		       		 WHEN LAST_NAME=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> THEN 2
		       		 WHEN UPPER(FIRST_NAME)=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> THEN 3
		             WHEN LAST_NAME LIKE <cfqueryparam value="#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 4		             
		             WHEN UPPER(FIRST_NAME) LIKE <cfqueryparam value="#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 5
		             WHEN LAST_NAME LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 6
		             WHEN UPPER(FIRST_NAME) LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> THEN 7
		       END AS SORTING_ORDER
		FROM   common_owner.hr_details_alliance
		WHERE  LAST_NAME LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">	or UPPER(FIRST_NAME) LIKE <cfqueryparam value="%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">
		OR     USER_ID=<cfqueryparam value="#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> 
       <cfif isNumeric(arguments.searchText)>
	   OR TO_NUMBER(SUBSTR(COLLAR,2,LENGTH(COLLAR)-1))=<cfqueryparam value="#Int(UCase(arguments.searchText))#" cfsqltype="cf_sql_number">	   
	   </cfif>
		ORDER BY SORTING_ORDER, LAST_NAME, FIRST_NAME
	    )
	 WHERE rownum < #maxResults#
	</cfquery>	
	
	<cfloop query="qSearch">
		<cfset arrayAppend(arrUsers,read(ref=USER_ID,refType='userId'))>
	</cfloop>
	
	<cfreturn arrUsers>
		
</cffunction>	
	
</cfcomponent>  