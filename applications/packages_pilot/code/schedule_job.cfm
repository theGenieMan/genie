<!---

Module      : schedule_job.cfm

App          : Packages

Purpose     : Sched job that runs on a dialy basis, does emails to users to due and overdue jobs and tidies up attachments

Requires    : 

Author      : Nick Blackham

Date        : 16/10/2007

Revisions   : 11/10/2012
              To use new table columns rather than checking HR for what peoples email addresses and names
              are, speeds up the job and stops any problems with people who have left the organisation.

--->

<cfset hrService=CreateObject("component","applications.cfc.hr_alliance.hrService").init(dsn=application.warehouseDSN)>

<!--- email overdue jobs --->
	  <cfquery name="qry_OverduePackage" datasource="#Application.DSN#" dbtype="ODBC">
	   SELECT p.PACKAGE_ID, RECORD_CREATED_BY, DIVISION_ENTERING, PROBLEM_OUTLINE, RETURN_DATE, PACKAGE_URN
	   FROM packages_owner.PACKAGES p
	   WHERE RECEIVED_DATE IS NULL
	   AND RETURN_DATE=TRUNC(SYSDATE-1)
	   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
	   AND PACKAGE_URN IS NOT NULL
	  </cfquery>
	  
	  <cfdump var="#qry_OverduePackage#">
	  
	  <!--- loop round the packages now overdue and email the current assignee that they are overdue.
	         bcc the package creator --->
	  
	  <cfset s_log="Emailing Overdue Jobs"&chr(10)>
	  <cfset s_log=s_log&"---------------------------------------------------------------------------------------------------------------------------------"&chr(10)>
	  <cfset s_log=s_log&"#qry_OverduePackage.RecordCount# Overdue packages"&chr(10)&chr(10)>
	  
	  <cfloop query="qry_OverduePackage">
	    <cfquery name="qry_Assigned" datasource="#Application.DSN#" dbtype="ODBC">
	      SELECT ASSIGNED_TO,ASSIGNED_TO_NAME,ASSIGNED_EMAIL 
	      FROM packages_owner.PACKAGE_ASSIGNMENTS
	      WHERE  ASSIGNMENT_ID=(SELECT MAX(ASSIGNMENT_ID)
	                                        FROM packages_owner.PACKAGE_ASSIGNMENTS
	                                        WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">)
	    </cfquery>
          
      <cfquery name="qry_CCd"  datasource="#Application.DSN#">
       SELECT CC_USERID, CC_USERNAME, CC_EMAIL, PACKAGE_ID
       FROM packages_owner.PACKAGE_CC
       WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">
      </cfquery>
      
       <cfif qry_Assigned.recordCount GT 0>
	      <cfset s_AssName=qry_Assigned.ASSIGNED_TO_NAME>
	      <cfset s_AssEmail=qry_Assigned.ASSIGNED_EMAIL>	      
	      
	      <cfset s_CreatorDets=hrService.getUserByUId(RECORD_CREATED_BY)>
	      
	      <cfif s_CreatorDets.getIsValidRecord()>
		       <cfset s_CreatorEmail=s_CreatorDets.getEmailAddress()>
		  </cfif>
	      
	        <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-family:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>#s_AssName#</strong></p>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"  <p>You have been assigned package #PACKAGE_URN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p><strong>This package is now overdue, the target return date was #DateFormat(Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>Outline</strong> : #PROBLEM_OUTLINE#</p>"&chr(10)>	   	   	   		   
		   <cfset s_Email=s_Email&"  <p><a href=""#Application.View_Link##Package_ID#"">Click Here For Full Details of Package #PACKAGE_URN#</a></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
		   
		  <!--- send the email  --->
		  <cfif isDefined("s_CreatorEmail")>
		  <cfmail to="#s_AssEmail#" bcc="#s_CreatorEmail#" from="packages@westmercia.pnn.police.uk" subject="OVERDUE Package #PACKAGE_URN#" type="html">
		   #s_Email#
		  </cfmail>		   
		  <cfelse>
		  <cfmail to="#s_AssEmail#"  from="packages@westmercia.pnn.police.uk" subject="OVERDUE Package #PACKAGE_URN#" type="html">
		   #s_Email#
		  </cfmail>		   		  
		  </cfif>
		  
		  <cfset s_Log=s_log&"Emailing overdue message to #s_AssEmail# for package #PACKAGE_URN#"&chr(10)>
		  
	   </cfif>
	   <cfset thisURN=PACKAGE_URN>
	   <cfset thisOutline=PROBLEM_OUTLINE>
	   <cfset thisReturnDate=RETURN_DATE>
	   
	   <cfif qry_CCd.recordCount GT 0> 
	    <cfloop query="qry_CCd">
	      <!--- it's ok to send the email --->
	      <cfset s_CCName=CC_USERNAME>
	      <cfset s_CCEmail=CC_EMAIL>	 
           
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-family:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>#s_CCName#</strong></p>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"  <p>You have been cc'd on' package #thisURN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p><strong>This package is now overdue, the target return date was #DateFormat(thisReturnDate,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>Outline</strong> : #thisOutline#</p>"&chr(10)>	   	   	   		   
		   <cfset s_Email=s_Email&"  <p><a href=""#Application.View_Link##Package_ID#"">Click Here For Full Details of Package #thisURN#</a></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	     <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>           
                                            
          <cfmail to="#s_CCEmail#"  from="packages@westmercia.pnn.police.uk" subject="OVERDUE Package #thisURN#" type="html">
		   #s_Email#
		  </cfmail>		  		  	   		            
		  
		  <cfset s_Log=s_log&"Emailing overdue message to #s_CCEmail# for package #thisURN# as CC'd"&chr(10)>
		      
		</cfloop>      
      </cfif>		  	  
	    
	  </cfloop>

	  <cfset s_log=s_log&"---------------------------------------------------------------------------------------------------------------------------------"&chr(10)>
	  
<!--- email jobs now a multiple of 7 days overdue --->	  
<cfquery name="qry_Overdue7Package" datasource="#Application.DSN#" dbtype="ODBC">
	   SELECT FLOOR(SYSDATE-RETURN_DATE) as diff,p.PACKAGE_ID, RECORD_CREATED_BY, DIVISION_ENTERING, PROBLEM_OUTLINE, RETURN_DATE, PACKAGE_URN
	   FROM packages_owner.PACKAGES p
	   WHERE RECEIVED_DATE IS NULL
	   AND TRUNC(RETURN_DATE) < TRUNC(SYSDATE)
	   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
	   AND PACKAGE_URN IS NOT NULL
	  </cfquery>
	  
	  <!--- loop round the packages now overdue and email the current assignee that they are overdue.
	         bcc the package creator --->
	  
	  <cfset s_log=s_log&chr(10)&chr(10)&"Emailing Multiple of 7 Days Overdue Jobs"&chr(10)>
	  <cfset s_log=s_log&"---------------------------------------------------------------------------------------------------------------------------------"&chr(10)>
	  <cfset s_log=s_log&"#qry_Overdue7Package.RecordCount# Overdue packages"&chr(10)&chr(10)>
	  
	  <cfloop query="qry_Overdue7Package">
	  <cfif DIFF GT 0>
	   <cfif DIFF MOD 7 IS 0>
	    <cfquery name="qry_Assigned" datasource="#Application.DSN#" dbtype="ODBC">
	      SELECT ASSIGNED_TO,ASSIGNED_TO_NAME,ASSIGNED_EMAIL
	      FROM packages_owner.PACKAGE_ASSIGNMENTS
	      WHERE  ASSIGNMENT_ID=(SELECT MAX(ASSIGNMENT_ID)
	                                        FROM packages_owner.PACKAGE_ASSIGNMENTS
	                                        WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">)
	    </cfquery>
	    
	    <!--- the the users full name and email --->
	    <cfif qry_Assigned.recordCount GT 0>
	      <!--- it's ok to send the email --->
	      <cfset s_AssName=qry_Assigned.ASSIGNED_TO_NAME>
	      <cfset s_AssEmail=qry_Assigned.ASSIGNED_EMAIL>	      
	      
	      <cfset s_CreatorDets=hrService.getUserByUId(RECORD_CREATED_BY)>
	      
	      <cfif s_CreatorDets.getIsValidRecord()>
		       <cfset s_7CreatorEmail=s_CreatorDets.getEmailAddress()>
		  </cfif>
	      
	        <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-family:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>#s_AssName#</strong></p>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"  <p>You have been assigned packge #PACKAGE_URN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p><strong>This package is now #DIFF# days overdue, the target return date was #DateFormat(Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>Outline</strong> : #PROBLEM_OUTLINE#</p>"&chr(10)>	   	   	   		   
		   <cfset s_Email=s_Email&"  <p><a href=""#Application.View_Link##Package_ID#"">Click Here For Full Details of Package #PACKAGE_URN#</a></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
		   
		  <!--- send the email --->
		  <cfif isDefined("s_7CreatorEmail")>
		  <cfmail to="#s_AssEmail#" bcc="#s_7CreatorEmail#" from="packages@westmercia.pnn.police.uk" subject="OVERDUE Package #PACKAGE_URN#" type="html">
		   #s_Email#
		  </cfmail>		   
		  <cfelse>
		  <cfmail to="#s_AssEmail#"  from="packages@westmercia.pnn.police.uk" subject="OVERDUE Package #PACKAGE_URN#" type="html">
		   #s_Email#
		  </cfmail>		   		  
		  </cfif>		  
		  
		  <cfset s_Log=s_log&"Emailing overdue message to #s_AssEmail# for package #PACKAGE_URN#"&chr(10)>
	      	   
	    </cfif>
	    </cfif>
	   </cfif>
	  </cfloop>

	  <cfset s_log=s_log&"---------------------------------------------------------------------------------------------------------------------------------"&chr(10)>
	  	  

<!--- email jobs due in next 3 days --->

	  <cfquery name="qry_DueIn3Package" datasource="#Application.DSN#" dbtype="ODBC">
	   SELECT p.PACKAGE_ID, RECORD_CREATED_BY, DIVISION_ENTERING, PROBLEM_OUTLINE, RETURN_DATE, PACKAGE_URN
	   FROM packages_owner.PACKAGES p
	   WHERE RECEIVED_DATE IS NULL
	   AND RETURN_DATE=TRUNC(SYSDATE+3)
       AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
	   AND PACKAGE_URN IS NOT NULL
	  </cfquery>
	  
	  <!--- loop round the packages now overdue and email the current assignee that they are overdue.
	         bcc the package creator --->
	  
	  <cfset s_log=s_log&chr(10)&chr(10)&"Emailing Jobs Due In 3 Days Time"&chr(10)>
	  <cfset s_log=s_log&"---------------------------------------------------------------------------------------------------------------------------------"&chr(10)>
	  <cfset s_log=s_log&"#qry_DueIn3Package.RecordCount# packages due in 3 days"&chr(10)&chr(10)>
	  
	  <cfloop query="qry_DueIn3Package">
	    <cfquery name="qry_Assigned" datasource="#Application.DSN#" dbtype="ODBC">
	      SELECT ASSIGNED_TO,ASSIGNED_TO_NAME,ASSIGNED_EMAIL
	      FROM packages_owner.PACKAGE_ASSIGNMENTS
	      WHERE  ASSIGNMENT_ID=(SELECT MAX(ASSIGNMENT_ID)
	                                        FROM packages_owner.PACKAGE_ASSIGNMENTS
	                                        WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">)
	    </cfquery>
	    
	    <cfif qry_Assigned.RecordCount GT 0>
	      <!--- it's ok to send the email --->
	      <cfset s_AssName=qry_Assigned.ASSIGNED_TO_NAME>
	      <cfset s_AssEmail=qry_Assigned.ASSIGNED_EMAIL>	      
	      
	        <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-family:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>#s_AssName#</strong></p>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"  <p>You have been assigned packge #PACKAGE_URN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p><strong>This package is due on #DateFormat(Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>Outline</strong> : #PROBLEM_OUTLINE#</p>"&chr(10)>	   	   	   		   
		   <cfset s_Email=s_Email&"  <p><a href=""#Application.View_Link##Package_ID#"">Click Here For Full Details of Package #PACKAGE_URN#</a></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
		   
		  <!--- send the email --->

		  <cfmail to="#s_AssEmail#" from="packages@westmercia.pnn.police.uk" subject="Package #PACKAGE_URN# is due on #DateFormat(Return_Date,'DD/MM/YYYY')#" type="html">
		   #s_Email#
		  </cfmail>	
		  
		  <cfset s_Log=s_log&"Emailing due in 3 days message to #s_AssEmail# for package #PACKAGE_URN#"&chr(10)>
	      	   
	    </cfif>
	    
	  </cfloop>

	  <cfset s_log=s_log&"---------------------------------------------------------------------------------------------------------------------------------"&chr(10)>

<cffile action="write" file="#Application.HomeDir#/#DateFormat(now(),"YYYYMMDD")##TimeFormat(now(),"HHmmss")#_schedlog.txt" output="#s_Log#">