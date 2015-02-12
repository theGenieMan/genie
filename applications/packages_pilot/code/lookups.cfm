<!--- <cftry> --->

<!---

Module      : lookups.cfm

App          : Packages

Purpose     : Does all lookup queries for packages

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfquery name="application.qry_Sections" datasource="#Application.DSN#" dbtype="ODBC">
SELECT SECTION_CODE, SECTION_NAME
FROM   packages_owner.SECTION
ORDER BY SECTION_DIV, SECTION_CODE
</cfquery>

<cfquery name="application.qry_Problems" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.Problems
Order By 1
</cfquery>

<cfquery name="application.qry_Causes" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.Causes
Order By 1
</cfquery>

<CFQUERY name="application.qry_Categories" datasource="#Application.DSN#" dbtype="ODBC">
SELECT CATEGORY_ID, CATEGORY_DESCRIPTION
FROM   packages_owner.CATEGORY
WHERE  (LOGICALLY_DELETED = 'N' OR LOGICALLY_DELETED IS NULL)
ORDER BY CATEGORY_DESCRIPTION
</CFQUERY>

<CFQUERY name="application.qry_Objectives" datasource="#Application.DSN#" dbtype="ODBC">
SELECT OBJECTIVE_CODE, OBJECTIVE
FROM   packages_owner.OBJECTIVES
ORDER BY OBJECTIVE_CODE
</CFQUERY>

<cfquery name="application.qry_Tactics" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.Tactics
Order By 1
</cfquery>

<cfquery name="application.qry_ResultsLookup" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.Results
Order By 1
</cfquery>

<cfset application.qry_ResultsLookupFTA=QueryNew('Ex_Code,How_Executed','Integer,varChar')>
<cfset queryAddRow(application.qry_ResultsLookupFTA,9)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',1,1)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Arrest and Bailed',1)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',2,2)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Arrest/Surrendered',2)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',3,3)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Paid Balance',3)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',4,4)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Return to Court Date',4)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',5,5)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Return to Court Trac',5)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',6,6)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Return to Court No T',6)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',7,7)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Warrant not Executed',7)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',8,8)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Recalled by Court',8)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'Ex_Code',99,9)>
<cfset querySetCell(application.qry_ResultsLookupFTA,'How_Executed','Withdrawn By CPS',9)>

<cfset application.qry_WarrantTypes=QueryNew('WRNT_CODE,WRNT_DESC','VarChar,varChar')>
<cfset queryAddRow(application.qry_WarrantTypes,23)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','A',1)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','FAIL TO SURRENDER AT COURT-COURT BAIL',1)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','B',2)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','FAIL TO SURRENDER AT COURT-POLICE BAIL',2)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','C',3)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','FAIL TO SURRENDER AT CROWN COURT-BENCH',3)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','D',4)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','FAIL TO APPEAR-ANSWER SUMMONS',4)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','E',5)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','WARRANT OF ARREST IN FIRST INSTANCE',5)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','F',6)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','NON PAYMENT OF FINE',6)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','G',7)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','NON PAYMENT OF MAINTENANCE',7)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','H',8)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','NON PAYMENT OF RATES/COMMUNITY CHARGE',8)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','J',9)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','NON PAYMENT OF LEGAL AID CONTRIBUTIONS',9)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','K',10)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','BREACH OF PROBATION ORDER',10)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','L',11)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','BREACH OF COMMUNITY SERVICE ORDER',11)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','M',12)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','BREACH OF COMBINATION ORDER',12)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','N',13)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','COMMITMENT PRISON NON PAYMENT OF FINE',13)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','P',14)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','COMMITMENT PRISON NON PAYMENT MAINTENANCE',14)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','Q',15)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','COMMITMENT PRISON NON PAYMENT RATES ETC.',15)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','R',16)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','WARRANT FOR ARREST OF WITNESS',16)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','S',17)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','FAIL TO APPEAR-OTHERWISE THAN ON BAIL',17)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','T',18)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','BREACH OF AUTOMATIC CONDITIONAL RELEASE LICENCE',18)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','U',19)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','BREACH OF COURT ORDER',19)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','V',20)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','WARRANT OF COMMITMENT ON REMAND BEFORE CONVICTION',20)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','W',21)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','BREACH OF CURFEW ORDER',21)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','X',22)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','OTHER - ENTER DETAILS IN OFFENCE FIELD',22)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_CODE','Y',23)>
<cfset querySetCell(application.qry_WarrantTypes,'WRNT_DESC','EUROPEAN ARREST WARRANT',23)>

<cfquery name="application.qry_CrimeType" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.Crime_Types
Order By 1
</cfquery>

<cfquery name="application.qry_RiskLevel" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.Risk_Levels
</cfquery>

<cfquery name="application.qry_Division" datasource="#Application.DSN#" dbtype="ODBC">
Select * From packages_owner.policing_area
order by 1
</cfquery>

<cfset application.lis_Targets="7,14,21,28">

<!--- Error Trapping  
<cfcatch type="any">
 <cfset str_Subject="#Request.App.Form_Title# - Error">
 <cfset ErrorScreen="SearchForm.cfm"> 
 <cfinclude template="cfcatch_include.cfm">
</cfcatch>
</cftry> --->