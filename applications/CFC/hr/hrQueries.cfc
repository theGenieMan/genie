<cfcomponent displayname="HR Queries" hint="CFC With HR Database Queries In">
  <cffunction name="getEmployeeName" displayname="Get Employee Name" hint="Pass UserID, DSN, UID, PWD">
	 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#arguments.DSN#" username="#arguments.UID#" password="#arguments.PWD#">
			select ppf.title,
			       ppf.last_name,
				     ppf.first_name,
				     ppf.suffix,
				     ppf.email_address
			from   per_people_f ppf,
			       per_assignments_f paf,
				     per_person_analyses ppa,
				     per_analysis_criteria pac
			where  pac.segment7='#UCase(arguments.UserID)#'
			and    paf.person_id = ppf.person_id
			and    paf.person_id = ppa.person_id
			and    ppa.analysis_criteria_id = pac.analysis_criteria_id
			and    SYSDATE BETWEEN paf.effective_start_date AND NVL(PAF.EFFECTIVE_END_DATE,SYSDATE+1)
			and    sysdate between ppf.effective_start_date and ppf.effective_end_date
			and    paf.assignment_type='E'
			and    assignment_status_type_id <> -5
			and    pac.id_flex_num = 50141
    </cfquery>

		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_PersonText="NONE">
		<cfelse>
		 <cfset str_Rank=qry_PersonDetails.Title>
		 <cfset str_Badge=qry_PersonDetails.Suffix>
		 <cfset str_Name=qry_PersonDetails.first_name&" "&qry_PersonDetails.last_name>
 		 <cfset str_PersonText=str_Rank&" "&str_Badge&" "&str_Name>
		</cfif>
	
    <cfreturn str_PersonText>
	
		<cfcatch type="Any">
		 <cfset str_PersonText="">
     <cfreturn str_PersonText>		 
		</cfcatch>
		
		</cftry>
  </cffunction>
<cffunction name="getEmployeeBadge" displayname="Get Employee Name" hint="Pass UserID, DSN, UID, PWD">
   <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#arguments.DSN#" username="#arguments.UID#" password="#arguments.PWD#">
			select ppf.title,
			       ppf.last_name,
				     ppf.first_name,
				     ppf.suffix,
				     ppf.email_address
			from   per_people_f ppf,
			       per_assignments_f paf,
				     per_person_analyses ppa,
				     per_analysis_criteria pac
			where  pac.segment7='#UCase(arguments.UserID)#'
			and    paf.person_id = ppf.person_id
			and    paf.person_id = ppa.person_id
			and    ppa.analysis_criteria_id = pac.analysis_criteria_id
			and    SYSDATE BETWEEN paf.effective_start_date AND NVL(PAF.EFFECTIVE_END_DATE,SYSDATE+1)
			and    sysdate between ppf.effective_start_date and ppf.effective_end_date
			and    paf.assignment_type='E'
			and    assignment_status_type_id <> -5
			and    pac.id_flex_num = 50141
    </cfquery>

		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Badge="">
		<cfelse>
		 <cfset str_Badge=qry_PersonDetails.Suffix>
		</cfif>	
    <cfreturn str_Badge>
		
		<cfcatch type="Any">
		 <cfset str_PersonText="">
     <cfreturn str_PersonText>		 
		</cfcatch>
		
		</cftry>
  </cffunction>
<cffunction name="getEmployeeRank" displayname="Get Employee Name" hint="Pass UserID, DSN, UID, PWD">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#arguments.DSN#" username="#arguments.UID#" password="#arguments.PWD#">
			select ppf.title,
			       ppf.last_name,
				     ppf.first_name,
				     ppf.suffix,
				     ppf.email_address
			from   per_people_f ppf,
			       per_assignments_f paf,
				     per_person_analyses ppa,
				     per_analysis_criteria pac
			where  pac.segment7='#UCase(arguments.UserID)#'
			and    paf.person_id = ppf.person_id
			and    paf.person_id = ppa.person_id
			and    ppa.analysis_criteria_id = pac.analysis_criteria_id
			and    SYSDATE BETWEEN paf.effective_start_date AND NVL(PAF.EFFECTIVE_END_DATE,SYSDATE+1)
			and    sysdate between ppf.effective_start_date and ppf.effective_end_date
			and    paf.assignment_type='E'
			and    assignment_status_type_id <> -5
			and    pac.id_flex_num = 50141
    </cfquery>

		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Rank="NONE">
		<cfelse>
		 <cfset str_Rank=qry_PersonDetails.Title>
		</cfif>
	
    <cfreturn str_Rank>
		<cfcatch type="Any">
		 <cfset str_PersonText="">
     <cfreturn str_PersonText>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>	
<cffunction name="getEmployeeSurname" displayname="Get Employee Name" hint="Pass UserID, DSN, UID, PWD">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#arguments.DSN#" username="#arguments.UID#" password="#arguments.PWD#">
			select ppf.title,
			       ppf.last_name,
				     ppf.first_name,
				     ppf.suffix,
				     ppf.email_address
			from   per_people_f ppf,
			       per_assignments_f paf,
				     per_person_analyses ppa,
				     per_analysis_criteria pac
			where  pac.segment7='#UCase(arguments.UserID)#'
			and    paf.person_id = ppf.person_id
			and    paf.person_id = ppa.person_id
			and    ppa.analysis_criteria_id = pac.analysis_criteria_id
			and    SYSDATE BETWEEN paf.effective_start_date AND NVL(PAF.EFFECTIVE_END_DATE,SYSDATE+1)
			and    sysdate between ppf.effective_start_date and ppf.effective_end_date
			and    paf.assignment_type='E'
			and    assignment_status_type_id <> -5
			and    pac.id_flex_num = 50141
    </cfquery>

		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Surname="NONE">
		<cfelse>
		 <cfset str_Surname=qry_PersonDetails.last_name>
		</cfif>
	
    <cfreturn str_Surname>
		
		<cfcatch type="Any">
		 <cfset str_PersonText="">
     <cfreturn str_PersonText>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>	
<cffunction name="getOfficerDetailsFromCollar" displayname="Get Employee Name" hint="Pass Collar, DSN">
<cfargument name="str_Collar" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select FULL_NAME
			From   common_owner.HR_DETAILS
			Where  substr(collar,2,4)='#str_Collar#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Fullname="Unknown">
		<cfelse>
		 <cfset str_Fullname=qry_PersonDetails.FULL_NAME>
		</cfif>
	
    <cfreturn str_Fullname>
		
		<cfcatch type="Any">
		 <cfset str_Fullname="Error Please Overtype">
     <cfreturn str_Fullname>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
<cffunction name="getOfficerDetailsFromUID" displayname="Get Employee Name" hint="Pass UID, DSN">
<cfargument name="str_UID" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select FULL_NAME
			From   common_owner.HR_DETAILS
			Where  user_id='#Ucase(str_UID)#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Fullname="Unknown">
		<cfelse>
		 <cfset str_Fullname=qry_PersonDetails.FULL_NAME>
		</cfif>
	
    <cfreturn str_Fullname>
		
		<cfcatch type="Any">
		 <cfset str_Fullname="Error Please Overtype">
     <cfreturn str_Fullname>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
<cffunction name="getOfficerEmailFromUID" displayname="Get Employee Name" hint="Pass UID, DSN">
<cfargument name="str_UID" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select EMAIL_ADDRESS
			From   common_owner.HR_DETAILS
			Where  User_ID ='#Ucase(str_UID)#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Email="Unknown">
		<cfelse>
		 <cfset str_Email=qry_PersonDetails.EMAIL_ADDRESS>
		</cfif>
	
    <cfreturn str_Email>
		
		<cfcatch type="Any">
		 <cfset str_Email="Function Error">
     <cfreturn str_Email>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
<cffunction name="getOfficerEmailFromCollar" displayname="Get Employee Name" hint="Pass Collar, DSN">
<cfargument name="str_Collar" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select EMAIL_ADDRESS
			From   common_owner.HR_DETAILS
			Where  substr(collar,2,4)='#str_Collar#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Email="Unknown">
		<cfelse>
		 <cfset str_Email=qry_PersonDetails.EMAIL_ADDRESS>
		</cfif>
	
    <cfreturn str_Email>
		
		<cfcatch type="Any">
		 <cfset str_Email="Function Error">
     <cfreturn str_Email>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>			
<cffunction name="getOfficerPhoneFromUID" displayname="Get Employee Name" hint="Pass UID, DSN">
<cfargument name="str_UID" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select WORK_PHONE
			From   common_owner.HR_DETAILS
			Where  User_ID ='#Ucase(str_UID)#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Phone="Unknown">
		<cfelse>
		 <cfset str_Phone=qry_PersonDetails.WORK_PHONE>
		</cfif>
	
    <cfreturn str_Phone>
		
		<cfcatch type="Any">
		 <cfset str_Phone="Function Error">
     <cfreturn str_Phone>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>				

<cffunction name="getOfficerFullDetailsFromUID" displayname="Get Employee Name" hint="Pass UID, DSN">
<cfargument name="str_UID" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
  <!--- <cftry> --->
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#" result="q_PD">
			select FULL_NAME,NVL(COLLAR,' ') AS COLLAR,NVL(WORK_PHONE,' ') AS WORK_PHONE,NVL(LOCATION,' ') AS LOCATION,NVL(DIVISION,' ') AS DIVISION,NVL(DEPARTMENT,' ') AS DEPARTMENT,NVL(DUTY,' ') AS DUTY,NVL(EMAIL_ADDRESS,' ') AS EMAIL_ADDRESS,FIRST_NAME,LAST_NAME,TITLE,USER_ID
			From   common_owner.HR_DETAILS
			Where  User_ID ='#Ucase(str_UID)#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Details="Unknown">
		<cfelse>
		 <cfset str_Details=qry_PersonDetails.FULL_NAME&"|"&qry_PersonDetails.COLLAR&"|"&qry_PersonDetails.WORK_PHONE&"|"&qry_PersonDetails.LOCATION&"|"&qry_PersonDetails.DIVISION&"|"&qry_PersonDetails.DEPARTMENT&"|"&qry_PersonDetails.DUTY&"|"&qry_PersonDetails.EMAIL_ADDRESS&"|"&qry_PersonDetails.LAST_NAME&"|"&qry_PersonDetails.FIRST_NAME&"|"&qry_PersonDetails.TITLE&"|"&qry_PersonDetails.USER_ID&"|"&q_PD.ExecutionTime>
		</cfif>
	
    <cfreturn str_Details>
<!---
		<cfcatch type="Any">
		 <cfset str_Details="Function Error">
     <cfreturn str_Details>		 
		</cfcatch>
		
		</cftry>		--->
  </cffunction>	
<cffunction name="getOfficerFullDetailsFromLDAP" displayname="Get Employee Name" hint="Pass UID, DSN">
<cfargument name="str_UID" type="string" required="true">
  <cftry> 

		<cfldap action="QUERY" 
		name="results_id" 
		attributes="givenName,sn,l,title,department,telephoneNumber,mail,sAMAccountName"
				start="DC=westmerpolice01,DC=local"
				filter="(&(sAMAccountName=#str_UID#))"
				server="128.1.150.254"
				username="westmerpolice01\cold_fusion"
				password="a11a1re"> 
				
		<cfif results_id.RecordCount GT 0>
		 <cfloop query="results_id" startrow="1" endrow="1">
		 <cfif Len(title) IS 0>
			<cfset stitle="999999">
		 <cfelse>
		    <cfset stitle=title>
		 </cfif>
		 <Cfset str_Details=stitle&"|"&givenName&" "&sn&" "&title&"|"&Left(department,1)&"|"&mail>
		 </cfloop>
		<cfelse>
		 <cfset str_Details="Unknown">
		</cfif>
	
    <cfreturn str_Details>

		<cfcatch type="Any">
		 <cfset str_Details="Function Error">
     <cfreturn str_Details>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
<cffunction name="getOfficerFullDetailsFromCollar" displayname="Get Employee Name" hint="Pass Collar, DSN">
<cfargument name="str_Collar" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
  <cftry> 
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select FULL_NAME,NVL(COLLAR,' ') AS COLLAR,NVL(WORK_PHONE,' ') AS WORK_PHONE,NVL(LOCATION,' ') AS LOCATION,NVL(DIVISION,' ') AS DIVISION,NVL(DEPARTMENT,' ') AS DEPARTMENT,NVL(DUTY,' ') AS DUTY,NVL(EMAIL_ADDRESS,' ') AS EMAIL_ADDRESS,FIRST_NAME,LAST_NAME,TITLE,USER_ID
			From   common_owner.HR_DETAILS
			Where  substr(collar,2,4)='#str_Collar#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Details="Unknown">
		<cfelse>
		 <cfset str_Details=qry_PersonDetails.FULL_NAME&"|"&qry_PersonDetails.COLLAR&"|"&qry_PersonDetails.WORK_PHONE&"|"&qry_PersonDetails.LOCATION&"|"&qry_PersonDetails.DIVISION&"|"&qry_PersonDetails.DEPARTMENT&"|"&qry_PersonDetails.DUTY&"|"&qry_PersonDetails.EMAIL_ADDRESS&"|"&qry_PersonDetails.LAST_NAME&"|"&qry_PersonDetails.FIRST_NAME&"|"&qry_PersonDetails.TITLE&"|"&qry_PersonDetails.USER_ID>
		</cfif>
	
    <cfreturn str_Details>

		<cfcatch type="Any">
		 <cfset str_Details="Function Error">
     <cfreturn str_Details>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
<cffunction name="getOfficerCollarFromUID" displayname="Get Officer Collar from UID" hint="Pass UID, DSN">
<cfargument name="str_UID" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select SUBSTR(COLLAR,2,4) AS COLLAR
			From   common_owner.HR_DETAILS
			Where  USER_ID='#Ucase(str_UID)#'
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_Collar="Unknown">
		<cfelse>
		 <cfset str_Collar=qry_PersonDetails.COLLAR>
		</cfif>
	
    <cfreturn str_Collar>
		
		<cfcatch type="Any">
		 <cfset str_Collar="Function Error">
     <cfreturn str_Collar>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>				
	
	<cffunction name="getOfficerUIDFromCollar" displayname="Get Officer Collar from UID" hint="Pass UID, DSN">
<cfargument name="str_Collar" type="string" required="true">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select USER_ID
			From   common_owner.HR_DETAILS
			Where  TO_NUMBER(SUBSTR(COLLAR,2,4))=#Int(str_Collar)#
    </cfquery>
		<cfif qry_PersonDetails.RecordCount IS 0>
		 <cfset str_UID="Unknown">
		<cfelse>
		 <cfset str_UID=qry_PersonDetails.USER_ID>
		</cfif>
	
    <cfreturn str_UID>
		
		<cfcatch type="Any">
		 <cfset str_UID="Function Error">
     <cfreturn str_UID>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
			
<cffunction name="getAllOfficers" displayname="Get All Officers" hint="Pass UID, DSN">
<cfargument name="str_DSN" type="string" required="true">
 <cftry>
	  <cfquery name="qry_PersonDetails" datasource="#Str_DSN#">
			select COLLAR||'|'||LAST_NAME||'|'||FIRST_NAME||'|'||FULL_NAME||'|'||NVL(SUBSTR(DIVISION,0,1),' ')||'|'||USER_ID||'|'||NVL(EMAIL_ADDRESS,' ') AS Details
			From   common_owner.HR_DETAILS
			Where  SUBSTR(COLLAR,0,1)='P'
			ORDER  BY LAST_NAME,FIRST_NAME
    </cfquery>
		<cfset lis_Officers="">
		<cfloop query="qry_PersonDetails">
		 <cfset lis_Officers=ListAppend(lis_Officers,Details,"~")>
		</cfloop>
	
    <cfreturn lis_Officers>
		
		<cfcatch type="Any">
		 <cfset lis_Officers="Function Error">
     <cfreturn lis_Officers>		 
		</cfcatch>
		
		</cftry>		
  </cffunction>		
<cffunction name="isMemberOf" displayname="isMemberOf" hint="Pass groups, UID">
<cfargument name="s_Groups" type="string" required="true" hint="groups to check in for user">	
<cfargument name="s_UID" type="string" required="true" hint="userId to check if in groups">
  <!--- <cftry>  --->

    <cfset s_Return="NO">   

		<cfldap action="QUERY" 
		name="results_id" 
		attributes="MemberOf"
				start="DC=westmerpolice01,DC=local"
				filter="(&(sAMAccountName=#s_UID#))"
				server="128.1.150.254"
				username="westmerpolice01\cold_fusion"
				password="a11a1re"
			    separator="|"> 
				
		<cfif results_id.RecordCount GT 0>
		 <cfloop query="results_id" startrow="1" endrow="1">
		 
		  <cfloop index="s_Group" list="#memberOf#" delimiters="|">
		  <cfset s_GroupText=ListGetAt(s_Group,1,",")>
		  <cfset s_GroupText=ReplaceNoCase(s_GroupText,"cn=","","ALL")>
		   <cfif ListFindNoCase(s_Groups,s_GroupText,",") GT 0>
			 <cfset s_Return="YES">
			 <cfbreak>
		   </cfif>
		 </cfloop>
		 
		 </cfloop>
		<cfelse>
		 <cfset s_Return="Unknown">
		</cfif>
	
    <cfreturn s_Return>

 <!---
	<cfcatch type="Any">
	 <cfset s_Return="Function Error">
     <cfreturn s_Return>		 
	</cfcatch>
		
		</cftry>		 --->
  </cffunction>	

</cfcomponent>
