<!--- <cftry> --->

<!---

Module      : excel_export.cfm

App          : Packages

Purpose     : Exports the users division entire list of packages as a CSV file

Requires    : 

Author      : Nick Blackham

Date        :  19/03/2008

Revisions   : 

--->
<cfsetting requesttimeout="99999">
<!--- get all the packages for that division --->

<cfquery name="qry_Packages" datasource="#Application.DSN#">
	   SELECT p.*,sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION, pct.DESCRIPTION AS CRIME_TYPE,
	         (SELECT ASSIGNED_TO_NAME 
	          FROM packages_owner.PACKAGE_ASSIGNMENTS pa
	          WHERE ASSIGNMENT_ID=(SELECT MAX(ASSIGNMENT_ID)
	                               FROM packages_owner.PACKAGE_ASSIGNMENTS pa1
	                               WHERE pa1.PACKAGE_ID=p.PACKAGE_ID)
	         ) AS ASSIGNED_TO_NAME, CRIME_REF, LOCARD_REF, OIS_REF
	   FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,
	            packages_owner.PROBLEMS po, packages_owner.CRIME_TYPES pct, packages_owner.PACKAGE_REFERENCES pr
	   WHERE (1=1)
	   AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
	   AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
	   AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
	   AND p.CRIME_TYPE_ID=pct.CRIME_TYPE_ID   
	   AND p.PACKAGE_ID=pr.PACKAGE_ID(+)	   
	   AND p.CAT_CATEGORY_ID IN ('6','23','24','26','31')	   
	   AND DATE_GENERATED BETWEEN TO_DATE('01-MAY-2000 00:00:00','DD-MON-YYYY HH24:MI:SS') AND SYSDATE
	   AND (COMPLETED IS NULL OR COMPLETED <> 'Y')     
	   AND PACKAGE_URN IS NOT NULL
	   ORDER BY DATE_GENERATED
</cfquery>

<!---   
AND DIVISION_ENTERING=<cfqueryparam value="#Session.LoggedInUserDiv#" cfsqltype="cf_sql_varchar"> 
 --->

<!--- setup the csv columnds --->
<cfset lisFile="PACKAGE URN,PACKAGE TYPE,CATEGORY,CRIME TYPE,SECTION,PROBLEM_OUTLINE,NOTES,DATE GENERATED,TARGET RETURN DATE,ACTUAL RETURN DATE,COMPLETED,ARRESTS,NIRS,ENCOUNTERS,EVALUATION FORM COMPLETED,DATE EVALUATION FORM COMPLETED,ASSIGNED_TO,CRIME,LOCARD,OIS">



<cfloop query="qry_Packages">
  
           <cfset sLink=URLDecode("http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=STEP&ref=")&PACKAGE_URN>
		 <cfset str_Link="""=HYPERLINK(""""#sLink#"""",""""#PACKAGE_URN#"""")"""> 
  
   <cfset sLine="">
   <cfset sLine=ListAppend(sLine,str_Link,",")>
   <cfset sLine=ListAppend(sLine,PROBLEM_DESCRIPTION,",")>
   <cfset sLine=ListAppend(sLine,CATEGORY_DESCRIPTION,",")>
   <cfset sLine=ListAppend(sLine,CRIME_TYPE,",")>
   <cfset sLine=ListAppend(sLine,SECTION_NAME,",")>
   <cfset sLine=ListAppend(sLine,Replace(Replace(Replace(PROBLEM_OUTLINE,",","","ALL"),chr(10),"","ALL"),chr(13),"","ALL"),",")>
   <cfset sLine=ListAppend(sLine,Replace(Replace(Replace(NOTES,",","","ALL"),chr(10),"","ALL"),chr(13),"","ALL"),",")>            
   <cfset sLine=ListAppend(sLine,DateFormat(DATE_GENERATED,"DD/MM/YYYY"),",")>
   <cfset sLine=ListAppend(sLine,DateFormat(RETURN_DATE,"DD/MM/YYYY"),",")>
   <cfset sLine=ListAppend(sLine,DateFormat(RECEIVED_DATE,"DD/MM/YYYY"),",")>
   <cfset sLine=ListAppend(sLine,COMPLETED,",")>
   <cfset sLine=ListAppend(sLine,ARRESTS_MADE,",")>
   <cfset sLine=ListAppend(sLine,NIRS_SUB,",")>
   <cfset sLine=ListAppend(sLine,ENCOUNTERS,",")>
   <cfset sLine=ListAppend(sLine,EVAL_COMP,",")>
   <cfset sLine=ListAppend(sLine,DateFormat(EVAL_COMP_DATE,"DD/MM/YYYY"),",")>
   <cfset sLine=ListAppend(sLine,ASSIGNED_TO_NAME,",")>
   <cfset sLine=ListAppend(sLine,CRIME_REF,",")>
   <cfset sLine=ListAppend(sLine,LOCARD_REF,",")>
   <cfset sLine=ListAppend(sLine,OIS_REF,",")>

   <cfset lisFile=ListAppend(lisFile,sLine,chr(13)&chr(10))>

</cfloop>

<!--- create the file --->
<cfset sFileName=HTTP_SMUSER&DateFormat(now(),"YYYYMMDD")&TimeFormat(now(),"HHmmss")&".csv">
<cffile action="write" addnewline="false" file="#Application.TempDir##sFileName#" output="#lisFile#">

<!--- get the users email address --->
<cfset hrService=CreateObject("component","applications.cfc.hr_oo.hrService").init(dsn=Application.WarehouseDSN)>
<cfset user=hrService.getUserByUID(uid=HTTP_SMUSER)>


<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
 <script>
  function updateTargDate()
  {
   var s_Targ = form.frm_SelTargPeriod.value;
   var s_Data = s_Targ.split("|");   
   form.frm_TxtTargDate.value=s_Data[1];
  }
	function fullscreen(url,winname) {
	  w = screen.availWidth-10;
	  h = screen.availHeight-50;
	  features = "width="+w+",height="+h;
	  features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
	
	  window.open(url, winname , features);
	}
 </script>
</head>

<body>

<a name="top"></a>
<cfinclude template="header.cfm">
<br><br>

<cfif user.getIsValidRecord()>

	<!--- email the file --->
	<cfmail to="#user.getEmailAddress()#" subject="STEP Extract" from="packages@westmercia.pnn.police.uk">
	 <cfmailparam disposition="attachment" file="#Application.TempDir##sFileName#">
	  CSV Extract from STEP Attached.
	
	 This is an automated email please do not reply.
	</cfmail>
		
		
	<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">
	 CSV File (Can be opened in XL) has been emailed to : 	 #user.getEmailAddress()#
	</div>

<cfelse>
	
   <div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">
	 User Id #http_smuser# has not been recognised
	</div>
	
</cfif>	
	
</body>
</html>
</cfoutput>