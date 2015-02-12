<!---

Module      : createReport.cfm

App         : Packages - Report

Purpose     : Creates the report based upon data selected in selectAxis.cfm and selectParameters.cfm
              these details are saved in session.reportValues

Requires    : 

Author      : Nick Blackham

Date        : 27/11/2008

Revisions   : 

--->

<cfset lisAxis="Package Category,Crime Type,Section,Objective">
<cfset lisAxisTableNames="CATEGORY_DESCRIPTION,DESCRIPTION,SECTION_NAME,PROBLEM_DESCRIPTION">
<cfset lisAxisTableCols="CAT_CATEGORY_ID,p.CRIME_TYPE_ID,SEC_SECTION_ID,PROB_PROBLEM_ID">
<cfset params="">

<cfprocessingdirective suppresswhitespace="true">

<cfoutput>

<cfquery name="qReport" datasource="#Application.DSN#">
SELECT #Replace(session.reportValues.xAxis,"p.","","ALL")#, #Replace(session.reportValues.yAxis,"p.","","ALL")#,#Replace(session.reportValues.xAxisId,"p.","","ALL")#, #Replace(session.reportValues.yAxisId,"p.","","ALL")#, SUM(CREATED) AS CREATED, SUM(OUTSTANDING) AS OUTSTANDING, SUM(OVERDUE) AS OVERDUE, SUM(COMPLETED) AS COMPLETED
FROM
(
SELECT #session.reportValues.xAxis#, #session.reportValues.yAxis#, #session.reportValues.xAxisId#, #session.reportValues.yAxisId#,COUNT(*) AS CREATED,0 AS OUTSTANDING,0 AS OVERDUE,0 AS COMPLETED 
FROM packages_owner.PACKAGES p, packages_owner.CATEGORY c, packages_owner.CRIME_TYPES ct, packages_owner.PROBLEMS pr, packages_owner.SECTION s
WHERE p.CAT_CATEGORY_ID=C.CATEGORY_ID
AND   p.CRIME_TYPE_ID=ct.CRIME_TYPE_ID
AND   p.PROB_PROBLEM_ID=pr.PROBLEM_ID
AND   p.SEC_SECTION_ID=s.SECTION_CODE
AND PACKAGE_URN IS NOT NULL
AND (DIVISION_ENTERING ='#session.reportValues.division#' OR SEC_SECTION_ID='H#session.reportValues.division#' OR SUBSTR(SEC_SECTION_ID,0,1)='#session.reportValues.division#')
AND DATE_GENERATED BETWEEN TO_DATE('#session.reportValues.dateFrom# 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('#session.reportValues.dateTo# 23:59:59','DD/MM/YYYY HH24:MI:SS')
<cfloop collection="#session.reportValues#" item="field">
  <cfif Left(field,2) IS "P_">
    <cfset valVar="#StructFindKey(session.reportValues,field,"one")#">
     AND  p.#Replace(field,"P_","")# IN (#valVar[1].value#)
     <cfset params=ListAppend(params,Replace(field,"P_","")&"="&valVar[1].value,"&")>
  </cfif>
</cfloop>
GROUP BY #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#
UNION
SELECT #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#, 0,COUNT(*),0,0 
FROM packages_owner.PACKAGES p, packages_owner.CATEGORY c, packages_owner.CRIME_TYPES ct, packages_owner.PROBLEMS pr, packages_owner.SECTION s
WHERE p.CAT_CATEGORY_ID=C.CATEGORY_ID
AND   p.CRIME_TYPE_ID=ct.CRIME_TYPE_ID
AND   p.PROB_PROBLEM_ID=pr.PROBLEM_ID
AND   p.SEC_SECTION_ID=s.SECTION_CODE
AND (DIVISION_ENTERING='#session.reportValues.division#' OR SEC_SECTION_ID='H#session.reportValues.division#' OR SUBSTR(SEC_SECTION_ID,0,1)='#session.reportValues.division#')
AND PACKAGE_URN IS NOT NULL
AND TRUNC(SYSDATE) <= TRUNC(RETURN_DATE)
AND COMPLETED IS NULL
<cfloop collection="#session.reportValues#" item="field">
  <cfif Left(field,2) IS "P_">
    <cfset valVar="#StructFindKey(session.reportValues,field,"one")#">
     AND  p.#Replace(field,"P_","")# IN (#valVar[1].value#)
  </cfif>
</cfloop>
GROUP BY #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#
UNION
SELECT #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#, 0,0,COUNT(*),0 
FROM packages_owner.PACKAGES p, packages_owner.CATEGORY c, packages_owner.CRIME_TYPES ct, packages_owner.PROBLEMS pr, packages_owner.SECTION s
WHERE p.CAT_CATEGORY_ID=C.CATEGORY_ID
AND   p.CRIME_TYPE_ID=ct.CRIME_TYPE_ID
AND   p.PROB_PROBLEM_ID=pr.PROBLEM_ID
AND   p.SEC_SECTION_ID=s.SECTION_CODE
AND (DIVISION_ENTERING='#session.reportValues.division#' OR SEC_SECTION_ID='H#session.reportValues.division#' OR SUBSTR(SEC_SECTION_ID,0,1)='#session.reportValues.division#')
AND PACKAGE_URN IS NOT NULL
AND TRUNC(SYSDATE) > TRUNC(RETURN_DATE)
AND COMPLETED IS NULL
<cfloop collection="#session.reportValues#" item="field">
  <cfif Left(field,2) IS "P_">
    <cfset valVar="#StructFindKey(session.reportValues,field,"one")#">
     AND  p.#Replace(field,"P_","")# IN (#valVar[1].value#)
  </cfif>
</cfloop>
GROUP BY #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#
UNION
SELECT #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#, 0,0,0,COUNT(*) 
FROM packages_owner.PACKAGES p, packages_owner.CATEGORY c, packages_owner.CRIME_TYPES ct, packages_owner.PROBLEMS pr, packages_owner.SECTION s
WHERE p.CAT_CATEGORY_ID=C.CATEGORY_ID
AND   p.CRIME_TYPE_ID=ct.CRIME_TYPE_ID
AND   p.PROB_PROBLEM_ID=pr.PROBLEM_ID
AND   p.SEC_SECTION_ID=s.SECTION_CODE
AND (DIVISION_ENTERING='#session.reportValues.division#' OR SEC_SECTION_ID='H#session.reportValues.division#' OR SUBSTR(SEC_SECTION_ID,0,1)='#session.reportValues.division#')
AND PACKAGE_URN IS NOT NULL
AND RECEIVED_DATE BETWEEN TO_DATE('#session.reportValues.dateFrom# 00:00:00','DD/MM/YYYY HH24:MI:SS') AND TO_DATE('#session.reportValues.dateTo# 23:59:59','DD/MM/YYYY HH24:MI:SS')
AND COMPLETED IS NOT NULL
<cfloop collection="#session.reportValues#" item="field">
  <cfif Left(field,2) IS "P_">
    <cfset valVar="#StructFindKey(session.reportValues,field,"one")#">
     AND  p.#Replace(field,"P_","")# IN (#valVar[1].value#)
  </cfif>
</cfloop>
GROUP BY #session.reportValues.xAxis#, #session.reportValues.yAxis#,#session.reportValues.xAxisId#, #session.reportValues.yAxisId#
)
GROUP BY #Replace(session.reportValues.xAxis,"p.","","ALL")#, #Replace(session.reportValues.yAxis,"p.","","ALL")#,#Replace(session.reportValues.xAxisId,"p.","","ALL")#, #Replace(session.reportValues.yAxisId,"p.","","ALL")#
ORDER BY #Replace(session.reportValues.xAxis,"p.","","ALL")#, #Replace(session.reportValues.yAxis,"p.","","ALL")#,#Replace(session.reportValues.xAxisId,"p.","","ALL")#, #Replace(session.reportValues.yAxisId,"p.","","ALL")#
</cfquery>

<cfquery name="qXAxis" dbtype="query">
SELECT DISTINCT #Replace(session.reportValues.xAxis,"p.","","ALL")#, #Replace(session.reportValues.xAxisId,"p.","","ALL")#
FROM qReport
</cfquery>

<cfquery name="qYAxis" dbtype="query">
SELECT DISTINCT #Replace(session.reportValues.yAxis,"p.","","ALL")#, #Replace(session.reportValues.yAxisId,"p.","","ALL")#
FROM qReport
</cfquery>

</cfoutput>

</cfprocessingdirective>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
 <cfinclude template="header.cfm">  

  <p align="center"><b>CR</b> - Created. <b>OU</b> - Outstanding. <b>OD</b> - Overdue. <b>TO</b> - Total Outstanding. <b>CP</b> - Completed.</p> 
	<table width="80%" align="center" cellpadding="1" cellspacing="0" border="1">
	   
	  <tr>
	    <td></td>
	   <cfset xCount=1>
	   <cfloop query="qXAxis">
	    <td colspan="5" align="center"><b>#Evaluate(session.reportValues.xAxis)#</b></td>
	    <cfif xCount LT qXAxis.recordCount>
	     <td bgcolor="##004040">&nbsp;</td>
	    </cfif>
	    <cfset xCount=xCount+1>
	   </cfloop>
	  </tr>
	
	  <tr>
	   <td></td>
	   <cfset xCount=1>
	   <cfloop query="qXAxis">  
	    <td align="center">CR</td>
	    <td align="center">OU</td>
	    <td align="center">OD</td>
	    <td align="center">TO</td>
	    <td align="center">CP</td>
	    <cfif xCount LT qXAxis.recordCount>
	    <td bgcolor="##004040">&nbsp</td>
	    </cfif>
	    <cfset xCount=xCount+1>
	   </cfloop>
	  </tr>
	  
	  <tr>
	   <td colspan="11"></td>
	  </tr>
	 
    <cfset i=1>
	  <cfloop query="qYAxis"> 
	   <cfset theY=Evaluate(Replace(session.reportValues.yAxis,"p.","","ALL"))>
	   <cfset theYid=Evaluate(Replace(session.reportValues.yAxisId,"p.","","ALL"))>        
	  <tr class="row_colour#i mod 2#">
	   <td><b>#Evaluate(session.reportValues.yAxis)#</b></td>
	   <cfset xCount=1>
	   <cfloop query="qXAxis">
	     <cfset theX=Evaluate(Replace(session.reportValues.xAxis,"p.","","ALL"))>
	     <cfset theXid=Evaluate(Replace(session.reportValues.xAxisId,"p.","","ALL"))>            
	     <cfquery name="qResult" dbtype="query">
	      SELECT CREATED, OUTSTANDING, OVERDUE, COMPLETED, (OUTSTANDING+OVERDUE) AS TOTAL_OUT
	      FROM qReport
	      WHERE #session.reportValues.yAxis#='#theY#'
	      AND #session.reportValues.xAxis#='#theX#'
	     </cfquery>
	     <cfif qResult.recordCount GT 0>
	     <cfloop query="qResult">
	     <td align="center">
         <cfif CREATED GT 0>     
           <cfset xString=session.reportValues.xAxisId&"="&theXid>
           <cfset yString=session.reportValues.yAxisId&"="&theYid>           
           <a href="stRepShowPackages.cfm?#session.URLToken#&#xString#&#yString#&#params#&dateFrom=#session.reportValues.dateFrom#&dateTo=#session.reportValues.dateTo#&division=#session.reportValues.division#&type=CREATED" target="_blank">
           #CREATED#
           </a>
         <cfelse>
           #CREATED#
         </cfif> 
       </td>
	     <td align="center">
         <cfif OUTSTANDING GT 0>     
           <cfset xString=session.reportValues.xAxisId&"="&theXid>
           <cfset yString=session.reportValues.yAxisId&"="&theYid>           
           <a href="stRepShowPackages.cfm?#session.URLToken#&#xString#&#yString#&#params#&division=#session.reportValues.division#&type=OUTSTANDING" target="_blank">
           #OUTSTANDING#
           </a>
         <cfelse>
           #OUTSTANDING#
         </cfif> 
       </td>
 	     <td align="center">
         <cfif OVERDUE GT 0>     
           <cfset xString=session.reportValues.xAxisId&"="&theXid>
           <cfset yString=session.reportValues.yAxisId&"="&theYid>           
           <a href="stRepShowPackages.cfm?#session.URLToken#&#xString#&#yString#&#params#&division=#session.reportValues.division#&type=OVERDUE" target="_blank">
           #OVERDUE#
           </a>
         <cfelse>
           #OVERDUE#
         </cfif> 
       </td>
	   <td align="center">
	    #TOTAL_OUT#
	   </td>
 	     <td align="center">
         <cfif COMPLETED GT 0>     
           <cfset xString=session.reportValues.xAxisId&"="&theXid>
           <cfset yString=session.reportValues.yAxisId&"="&theYid>           
           <a href="stRepShowPackages.cfm?#session.URLToken#&#xString#&#yString#&#params#&division=#session.reportValues.division#&type=COMPLETED" target="_blank">
           #COMPLETED#
           </a>
         <cfelse>
           #COMPLETED#
         </cfif> 
       </td>
	     </cfloop>
	     <cfelse>
	     <td align="center">0</td>
	     <td align="center">0</td>
	     <td align="center">0</td>     
	     <td align="center">0</td>    
	     <td align="center">0</td>    	      
	     </cfif>
	     <cfif xCount LT qXAxis.recordCount>
	      <td bgcolor="##004040">&nbsp;</td>
	     </cfif>
	     <cfset xCount=xCount+1>
	   </cfloop>
	  </tr>
    <cfset i=i+1>
	  </cfloop>
	  
	 </table>
    
 </body>
 </html>
 </cfoutput>