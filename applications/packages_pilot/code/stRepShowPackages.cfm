<!---

Module      : stRepShowPackages.cfm

App         : Packages - Report

Purpose     : Shows list of packages created from the options select in the stRep report

Requires    : 

Author      : Nick Blackham

Date        : 27/11/2008

Revisions   : 

--->


<cfquery name="qry_Package" datasource="#Application.DSN#" dbtype="ODBC">
SELECT DISTINCT p.PACKAGE_ID, PROBLEM_OUTLINE, DATE_GENERATED, RETURN_DATE ,
                COMPLETED, RECEIVED_DATE, DIVISION_ENTERING,
                sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION ,
                p.OTHER_REFERENCE, p.PACKAGE_URN          
FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,packages_owner.PROBLEMS po
WHERE (1=1)
AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
AND p.PACKAGE_URN IS NOT NULL
AND (DIVISION_ENTERING='#url.division#' OR SEC_SECTION_ID='H#url.division#')
<cfloop collection="#url#" item="param">
 <cfif param IS NOT "CFID" and param IS NOT "CFTOKEN" and param IS NOT "JSESSIONID"
   AND param is NOT "dateFrom" and param is NOT "dateTo" and param IS NOT "type" and param is NOT "division">
   <cfset valVar="#StructFindKey(url,param,"one")#">  
   <cfif listLen(valVar[1].value,",") IS 1>
   AND #param# = '#valVar[1].value#'
   <cfelse>
   AND #param# IN (#valVar[1].value#)
   </cfif>
 </cfif>
</cfloop>
<cfif url.TYPE IS "CREATED">
AND DATE_GENERATED BETWEEN TO_DATE('#url.dateFrom# 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('#url.dateTo# 23:59:59','DD/MM/YYYY HH24:MI:SS')
</cfif>
<cfif url.TYPE IS "COMPLETED">
AND DATE_RECEIVED BETWEEN TO_DATE('#url.dateFrom# 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('#url.dateTo# 23:59:59','DD/MM/YYYY HH24:MI:SS')
AND COMPLETED IS NOT NULL
</cfif>
<cfif url.TYPE IS "OUTSTANDING">
AND TRUNC(SYSDATE) <= TRUNC(RETURN_DATE)
AND COMPLETED IS NULL
</cfif>
<cfif url.TYPE IS "OVERDUE">
AND TRUNC(SYSDATE) > TRUNC(RETURN_DATE)
AND COMPLETED IS NULL
</cfif>
</cfquery>

<!---
<cfoutput>
<cfprocessingdirective suppresswhitespace="true">
<pre>
SELECT DISTINCT p.PACKAGE_ID, PROBLEM_OUTLINE, DATE_GENERATED, RETURN_DATE ,
                COMPLETED, RECEIVED_DATE, DIVISION_ENTERING,
                sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION ,
                p.OTHER_REFERENCE, p.PACKAGE_URN          
FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,packages_owner.PROBLEMS po
WHERE (1=1)
AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
AND p.PACKAGE_URN IS NOT NULL
AND (DIVISION_ENTERING='#url.division#' OR SEC_SECTION_ID='H#url.division#')
<cfloop collection="#url#" item="param">
 <cfif param IS NOT "CFID" and param IS NOT "CFTOKEN" and param IS NOT "JSESSIONID"
   AND param is NOT "dateFrom" and param is NOT "dateTo" and param IS NOT "type" and param is NOT "division">
   <cfset valVar="#StructFindKey(url,param,"one")#">  
   <cfif listLen(valVar[1].value,",") IS 1>
   AND #param# = '#valVar[1].value#'
   <cfelse>
   AND #param# IN (#valVar[1].value#)
   </cfif>
 </cfif>
</cfloop>
<cfif url.TYPE IS "CREATED">
AND DATE_GENERATED BETWEEN TO_DATE('#url.dateFrom# 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('#url.dateTo# 23:59:59','DD/MM/YYYY HH24:MI:SS')
</cfif>
<cfif url.TYPE IS "COMPLETED">
AND DATE_RECEIVED BETWEEN TO_DATE('#url.dateFrom# 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('#url.dateTo# 23:59:59','DD/MM/YYYY HH24:MI:SS')
AND COMPLETED IS NOT NULL
</cfif>
<cfif url.TYPE IS "OUTSTANDING">
AND TRUNC(SYSDATE) <= TRUNC(RETURN_DATE)
AND COMPLETED IS NULL
</cfif>
<cfif url.TYPE IS "OVERDUE">
AND TRUNC(SYSDATE) > TRUNC(RETURN_DATE)
AND COMPLETED IS NULL
</cfif>
</pre>
</cfprocessingdirective>
</cfoutput>
--->

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
 <cfinclude template="header.cfm">
  <br>
 <table width="98%" align="center">
  <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
  </tr>
 <cfset i=1>
 <cfloop query="qry_Package">
  <tr class="row_colour#i mod 2#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
    </td>
		<td valign="top">#Left(PROBLEM_OUTLINE,75)# ...</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td> 
  </tr>
  <cfset i=i+1>
 </cfloop>
 </table>

</body>
</html>
</cfoutput>