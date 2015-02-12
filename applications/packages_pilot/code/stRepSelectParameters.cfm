<!---

Module      : selectParameters.cfm

App         : Packages - Report

Purpose     : Allows the user to select what parameters they want to narrow down the report too.
              X & Y axis values may not be selected

Requires    : 

Author      : Nick Blackham

Date        : 27/11/2008

Revisions   : 

--->

<cfset lisAxis="Package Category,Crime Type,Section,Objective">
<cfset lisAxisTableNames="CATEGORY_DESCRIPTION,DESCRIPTION,SECTION_NAME,PROBLEM_DESCRIPTION">
<cfset lisAxisTableCols="CAT_CATEGORY_ID,p.CRIME_TYPE_ID,SEC_SECTION_ID,PROB_PROBLEM_ID">

<cfif isDefined("frm_HidAction")>

 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <cfif Len(frm_TxtDateFrom) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a date from","|")>	
 <cfelse>   
   <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateTo)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid target date to dd/mm/yyyy","|")>	 
 	 </cfif>  
 </cfif>

 <cfif Len(frm_TxtDateTo) IS 0>
  	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a date to","|")>
 <cfelse>
   <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateFrom)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid target date from dd/mm/yyyy","|")>	 
 	 </cfif> 
 </cfif>
 
 
 <cfif str_Valid IS "YES">
   <cfset session.reportValues.dateFrom=frm_TxtdateFrom>
   <cfset session.reportValues.dateTo=frm_TxtdateTo>
   
   <cfloop list="#fieldNames#" index="field" delimiters=",">
    <cfoutput>#field#</cfoutput>
    <cfif field is NOT "frm_Sub" and field is NOT "frm_hidAction"
      and field is NOT "frm_TxtDateFrom" and field is NOT "frm_TxtDateTo"
      and field is NOT "fieldNames">
        
    <cfset StructInsert(session.reportValues,"P_"&field,Evaluate(field),true)>
    </cfif>
   </cfloop>
   
   <cflocation url="stRepCreateReport.cfm" addtoken="true">
   
 </cfif>

<cfelse>

 <cfset frm_TxtDateFrom="01/"&DateFormat(now(),"MM")&"/"&DateFormat(now(),"YYYY")>
 <cfset frm_TxtDateTo=DateFormat(now(),"DD/MM/YYYY")>

</cfif>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
 <cfinclude template="header.cfm">
 
 <h3 align="center">Report Stage 2 - Select Criteria</h3>

 <form action="#ListLast(SCRIPT_NAME,"/")#?#session.URLToken#" method="post">
 
 <table width="90%" align="center">
  <tr>
   <td width="20%"><label for="frm_TxtDateFrom">Dates</label></td>
   <td>
    <b>From</b>: 
    <input type="text" name="frm_TxtDateFrom" size="12" value="#frm_TxtDateFrom#" class="mandatory"> 
    <b>To</b>: 
    <input type="text" name="frm_TxtDateTo" size="12" value="#frm_TxtDateTo#" class="mandatory">     
   </td>
  </tr>
    
  <cfset i=1>
  <cfloop list="#lisAxisTableNames#" index="axisValue" delimiters=",">
   <cfif axisValue IS NOT session.reportValues.xAxis AND axisValue IS NOT session.reportValues.yAxis>
        
	     <cfswitch expression="#axisValue#">
		     <cfcase value="CATEGORY_DESCRIPTION">
		       <cfset qLookup="application.qry_Categories">
           <cfset id="CATEGORY_ID">
           <cfset desc="CATEGORY_DESCRIPTION">
           <cfset queryID="CAT_CATEGORY_ID">
		     </cfcase>
		     <cfcase value="DESCRIPTION">
		       <cfset qLookup="application.qry_CrimeType">
           <cfset id="CRIME_TYPE_ID">
           <cfset desc="DESCRIPTION">
           <cfset queryID="CRIME_TYPE_ID">                             
		     </cfcase>     
		     <cfcase value="SECTION_NAME">
		       <cfset qLookup="application.qry_Sections">
           <cfset id="SECTION_CODE">
           <cfset desc="SECTION_NAME">                  
           <cfset queryID="SEC_SECTION_ID">           
		     </cfcase>
		     <cfcase value="PROBLEM_DESCRIPTION">
		       <cfset qLookup="application.qry_Problems">
           <cfset id="PROBLEM_ID">
           <cfset desc="PROBLEM_DESCRIPTION">                  
           <cfset queryID="PROB_PROBLEM_ID">           
		     </cfcase>   
	     </cfswitch>        
        
		  <tr>
		   <td valign="top"><label for="#queryID#">#ListGetAt(lisAxis,i,",")#</label></td>
		   <td>
		    <select name="#queryId#" id="#queryId#" multiple size="4"> 
         <cfloop query="#qLookup#">
           <option value="#Evaluate(id)#">#Evaluate(desc)#</option>
         </cfloop>
		    </select>
		   </td>
		  </tr>
   </cfif>
  <cfset i=i+1>
  </cfloop>
  
 </table>
 
 <div align="right">
  <input type="hidden" name="frm_HidAction" value="run">
  <input type="submit" name="frm_Sub" value="Create Report --->">
 </div>
 
 </form>
 
</body>
</html>
</cfoutput>