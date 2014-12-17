<!---

Module      : lookup_queries.cfm

App          : GENIE

Purpose     : Runs all queries that are requried for our pop list boxes. These are then stored in Application variables
                  as they do not change very often. Stops long queries running very often.

Requires     : 

Author       : Nick Blackham

Date          : 31/01/2008

Revisions     : 

--->
<cfsetting requesttimeout="99999999999">

<cfquery name="Application.qry_Manu" datasource="#Application.LookupDSN#">
SELECT PROP_CODE1 AS MNF_CODE, DESCRIPTION
FROM	 BROWSER_OWNER.PROP_LOOKUP
WHERE PROP_TYPE = 'MNF'
ORDER BY TO_NUMBER(PROP_CODE1)
</cfquery>

<cfquery name="Application.qry_Model" datasource="#Application.LookupDSN#">
SELECT 	MOD.PROP_CODE2 AS MOD_CODE, NVL(MOD.DESCRIPTION,' ') AS DESCRIPTION,
		    MOD.PROP_CODE1 AS MNF_CODE, MAN.DESCRIPTION AS MAN_DESC
FROM    BROWSER_OWNER.PROP_LOOKUP MAN, BROWSER_OWNER.PROP_LOOKUP MOD
WHERE   MAN.PROP_TYPE = 'MNF'
AND		MOD.PROP_TYPE = 'MOD'
AND		MAN.PROP_CODE1 = MOD.PROP_CODE1
</cfquery>

<cfquery name="Application.qry_PropCat" datasource="#Application.LookupDSN#">
SELECT PROP_CODE1 AS PRPC_CODE, DESCRIPTION
FROM   BROWSER_OWNER.PROP_LOOKUP
WHERE  PROP_TYPE = 'PRP_CAT'	
ORDER BY 1
</cfquery>

<cfquery name="Application.qry_SubCats" datasource="#Application.LookupDSN#">
SELECT   SUB.PROP_CODE1 AS PRPC_CODE, SUB.PROP_CODE2 AS PSC_CODE, 
		 SUB.DESCRIPTION AS SUB_DESC, CAT.DESCRIPTION AS CAT_DESC
FROM    BROWSER_OWNER.PROP_LOOKUP CAT, BROWSER_OWNER.PROP_LOOKUP SUB
WHERE   CAT.PROP_TYPE = 'PRP_CAT'
AND		SUB.PROP_TYPE = 'PRP_SUB'
AND		CAT.PROP_CODE1 = SUB.PROP_CODE1
ORDER BY SUB.DESCRIPTION
</cfquery>

<cfquery name="Application.qry_PropType" datasource="#Application.LookupDSN#">
SELECT DESCRIPTION
FROM   BROWSER_OWNER.ORG_LOOKUP
WHERE  ORG_TYPE = 'ZPT'
ORDER BY 1
</cfquery> 

<cfquery name="Application.qry_Station" datasource="#Application.LookupDSN#">
SELECT ORG_CODE,DESCRIPTION AS ORG_NAME
FROM   BROWSER_OWNER.ORG_LOOKUP
WHERE  ORG_TYPE = 'STN'
ORDER BY 1
</cfquery>

<cfquery name="Application.qry_Force" datasource="#Application.LookupDSN#">
	SELECT ORG_CODE,DESCRIPTION AS ORG_NAME
	FROM   BROWSER_OWNER.ORG_LOOKUP
	WHERE  ORG_TYPE = 'FRC'
	ORDER BY 1 
</cfquery>

<cfquery name="Application.qry_PhoneType" datasource="#Application.LookupDSN#">
	SELECT DESCRIPTION
	FROM   BROWSER_OWNER.ORG_LOOKUP
	WHERE  ORG_TYPE = 'TELT'
	ORDER BY 1 
</cfquery>

<cfquery name="Application.qry_PhoneAirtime" datasource="#Application.LookupDSN#">
		SELECT DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'AIRT'
		ORDER BY 1  
</cfquery>  

<cfquery name="Application.qry_Beats" datasource="#Application.LookupDSN#">  
	SELECT ORG_CODE,DESCRIPTION AS ORG_NAME
	FROM   BROWSER_OWNER.ORG_LOOKUP
	WHERE  ORG_TYPE = 'BTS'
	ORDER BY 1  
</cfquery>


<cfquery name="Application.qry_Division" datasource="#Application.LookupDSN#">  
	SELECT ORG_CODE,DESCRIPTION AS ORG_NAME
	FROM   BROWSER_OWNER.ORG_LOOKUP
	WHERE  ORG_TYPE = 'INT'
	ORDER BY 1  
</cfquery>

<cfquery name="Application.qry_WMCRecordedAS" datasource="#Application.LookupDSN#">  
	SELECT OFF_CODE1 AS WMC_OFFENCE_CODE, DESCRIPTION AS SHORT_OFFENCE_TITLE
	FROM   BROWSER_OWNER.OFFENCE_LOOKUP
	WHERE  OFF_TYPE = 'WMC'
	ORDER BY 1  
</cfquery>

<cfquery name="Application.qry_HOMC" datasource="#Application.LookupDSN#">  
		SELECT TO_CHAR(OFF_CODE1) AS HOMC_CODE, DESCRIPTION
		FROM   BROWSER_OWNER.OFFENCE_LOOKUP
		WHERE  OFF_TYPE = 'HOMC'
		ORDER BY 1  
</cfquery>

<cfquery name="Application.qry_HOOC" datasource="#Application.LookupDSN#">
	SELECT OFF_CODE1 AS HOMC_CODE, OFF_CODE2 AS HOOC_CODE, DESCRIPTION
	FROM   BROWSER_OWNER.OFFENCE_LOOKUP
	WHERE  OFF_TYPE = 'HOOC'
	ORDER BY 1,2  
</cfquery>

<cfquery name="Application.qry_ACPO" datasource="#Application.LookupDSN#">
	SELECT TO_NUMBER(OFF_CODE1) AS ACPO_CATEGORY, DESCRIPTION
	FROM   BROWSER_OWNER.OFFENCE_LOOKUP
	WHERE  OFF_TYPE = 'ACPO_CAT'
	ORDER BY TO_NUMBER(OFF_CODE1) 
</cfquery>

<cfquery name="Application.qry_ACPOSub" datasource="#Application.LookupDSN#">  
	SELECT TO_NUMBER(OFF_CODE1) AS ACPO_CATEGORY, TO_NUMBER(OFF_CODE2) AS ACPO_SUB_CATEGORY,DESCRIPTION
	FROM   BROWSER_OWNER.OFFENCE_LOOKUP
	WHERE  OFF_TYPE = 'ACPO_SUB'
	ORDER BY TO_NUMBER(OFF_CODE2), OFF_CODE1  
</cfquery>

<cfquery name="Application.qry_ACPOOffence" datasource="#Application.LookupDSN#">  
		SELECT TO_NUMBER(OFF_CODE1) AS ACPO_CATEGORY, TO_NUMBER(OFF_CODE2) AS ACPO_SUB_CATEGORY,
			   OFF_CODE3 AS OFFENCE_CODE, DESCRIPTION
		FROM   BROWSER_OWNER.OFFENCE_LOOKUP
		WHERE  OFF_TYPE = 'ACPO_OFF'
		ORDER BY OFF_CODE3, OFF_CODE1, OFF_CODE2  
</cfquery>

<cfquery name="Application.qry_Ind" datasource="#Application.LookupDSN#">
	SELECT DESCRIPTION
	FROM   BROWSER_OWNER.ORG_LOOKUP
	WHERE  ORG_TYPE = 'LIND'  
</cfquery>  

<cfquery name="Application.qry_Src" datasource="#Application.LookupDSN#">
		SELECT DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'LSOR'
		ORDER BY 1
</cfquery>  

<cfquery name="Application.qry_SrcLoc" datasource="#Application.LookupDSN#">
		SELECT DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'LLOC'
		ORDER BY 1
</cfquery>  

<cfquery name="Application.qry_SrcDoc" datasource="#Application.LookupDSN#">
		SELECT ORG_CODE AS DOCUMENT_CODE, DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'LDOC'
		ORDER BY 1
</cfquery>  

<cfquery name="Application.qry_PropUsage" datasource="#Application.LookupDSN#">
		SELECT DISTINCT USAGE
		FROM   BROWSER_OWNER.GE_PROPERTY_USAGE
		ORDER BY 1
</cfquery>  

<cfquery name="Application.qry_Lind" datasource="#Application.LookupDSN#">
		SELECT DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'LIND'
		ORDER BY 1
</cfquery>  


<cfquery name="Application.qry_Access" datasource="#Application.LookupDSN#">
		SELECT ORG_CODE AS CRC_CODE, DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'LIAL'
		ORDER BY 1
</cfquery>  

<cfquery name="Application.qWarnings" datasource="#Application.LookupDSN#">
		SELECT DISTINCT WSC_CODE, WSC_DESC
		FROM   BROWSER_OWNER.GE_WARNINGS		
		ORDER BY WSC_DESC
</cfquery>	

<cfquery name="Application.qSNTs" datasource="#Application.LookupDSN#">
		SELECT DISTINCT SNT_CODE, SNT_NAME
		FROM   BROWSER_OWNER.SNT_LOOKUP		
		ORDER BY SNT_CODE
</cfquery>	

<cfquery name="Application.qry_CustodyStation" datasource="#Application.LookupDSN#">
SELECT STATION_CODE AS ORG_CODE,STATION_DESC AS ORG_NAME
FROM   BROWSER_OWNER.CUSTODY_STATIONS
WHERE  LOGICALLY_DELETED = 'N'
ORDER BY 1
</cfquery>

<cfquery name="Application.qCrimeOutcomes" datasource="#Application.LookupDSN#">
		SELECT ORG_CODE AS OUTCOME_CODE, DESCRIPTION
		FROM   BROWSER_OWNER.ORG_LOOKUP
		WHERE  ORG_TYPE = 'COUT'
		ORDER BY 1
</cfquery>	

<cfset application.qry_Sex=QueryNew("rv_low_value,rv_meaning","varchar,varchar")>
<cfset newRow = QueryAddRow(application.qry_Sex,3)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_low_value","M",1)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_meaning","Male",1)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_low_value","F",2)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_meaning","Female",2)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_low_value","U",3)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_meaning","Unknown",3)>

<cfset application.qry_Ethnic=QueryNew("ea_code,description","integer,varchar")>
<cfset newRow = QueryAddRow(application.qry_Ethnic,7)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",0,1)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","UNKNOWN",1)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",1,2)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","WHITE EUROPEAN",2)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",2,3)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","DARK EUROPEAN",3)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",3,4)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","AFRO-CARIBBEAN",4)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",4,5)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","ASIAN",5)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",5,6)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","ORIENTAL",6)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "ea_code",6,7)>
<cfset temp = QuerySetCell(application.qry_Ethnic, "description","ARAB",7)>

<cfset application.qry_NoCrimeReason=QueryNew("ncr_code,description","varchar,varchar")>
<cfset newRow = QueryAddRow(application.qry_NoCrimeReason,11)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",1,1)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","IF THE CRIME, AS ALLEGED, CONSISTUTES PART OF A CRIME ALREADY RECORDED",1)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",2,2)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","** OLD CODE ** COUNTING RULES - OTHER",2)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",3,3)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","** OLD CODE ** NOT HO REPORTABLE OFFENCE",3)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",4,4)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","ONCE RECORDED ADDITIONAL VERIFABLE INFORMATION TO DETERMINE CRIME NOT COMMITTED",4)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",5,5)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","IF THE REPORTED INCIDENT WAS RECORDED AS A CRIME IN ERROR",5)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",6,6)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","DUPLICATED OFFENCE",6)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",7,7)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","CRIME COMMITTED OUTSIDE JURISDICTION OF POLICE FORCE IN WHICH IT WAS RECORDED",7)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",8,8)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","RECORDED BY OTHER AGENCY - NOT POLICE",8)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",9,9)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","CRIMES RESTRICTION / PROCESS ERROR",9)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",'A',10)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","53C AND 53D OFFENCES WHERE OFFENDER DEALT WITH BY CRIMINAL COURT ABROAD",10)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "ncr_code",999,11)>
<cfset temp = QuerySetCell(application.qry_NoCrimeReason, "description","ALL NO CRIME REASONS",11)>


<cfset application.qry_HowReported=QueryNew("rv_low_value,rv_meaning","integer,varchar")>
<cfset newRow = QueryAddRow(application.qry_HowReported,10)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",1,1)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","OTHER TELEPHONE",1)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",2,2)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","'999' CALL",2)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",3,3)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","REPORTED AT POLICE STATION",3)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",4,4)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","REPORTED TO POLICE PATROL",4)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",5,5)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","ALARM",5)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",6,6)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","ON ADMISSION",6)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",7,7)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","BY CORRESPONDENCE",7)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",8,8)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","FOUND BY POLICE",8)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",9,9)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","OBSERVATION",9)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_low_value",10,10)>
<cfset temp = QuerySetCell(application.qry_HowReported, "rv_meaning","OTHER",10)>

<cfset application.qry_CUC=QueryNew("cuc_code,description","integer,varchar")>
<cfset newRow = QueryAddRow(application.qry_CUC,14)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",1,1)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","CHARGE",1)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",2,2)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","SUMMONS",2)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",3,3)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","TIC",3)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",5,4)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","CAUTION",4)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",6,5)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","INFORMAL WARNING",5)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",7,6)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","OTHER (NFA)",6)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",8,7)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","OTHER (POST SENTENCE NFA)",7)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",9,8)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","REPRIMAND",8)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",10,9)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","WARNING",9)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",11,10)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","WARNING 1ST OFFENCE S.65(4)",10)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",12,11)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","2 ND WARNING",11)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",13,12)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","PENALTY NOTICE",12)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",14,13)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","CANNABIS WARNING",13)>
<cfset temp = QuerySetCell(application.qry_CUC, "cuc_code",15,14)>
<cfset temp = QuerySetCell(application.qry_CUC, "description","COMMUNITY RESOLUTION",14)>

<cfset application.qry_Detected=QueryNew("rv_low_value,rv_meaning","integer,varchar")>
<cfset newRow = QueryAddRow(application.qry_Detected,4)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_low_value",1,1)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_meaning","Detected",1)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_low_value",2,2)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_meaning","Undetected",2)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_low_value",3,3)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_meaning","Undetected filed on screening",3)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_low_value",4,4)>
<cfset temp = QuerySetCell(application.qry_Detected, "rv_meaning","Undetected filed undetected",4)>

<cfset application.qry_Validation=QueryNew("rv_low_value,rv_meaning","varchar,varchar")>
<cfset newRow = QueryAddRow(application.qry_Validation,4)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_low_value","0",1)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_meaning","0",1)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_low_value","1",2)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_meaning","1",2)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_low_value","2",3)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_meaning","2",3)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_low_value","3",4)>
<cfset temp = QuerySetCell(application.qry_Validation, "rv_meaning","3",4)>

<cfset application.qry_MOPI=QueryNew("rv_low_value,rv_meaning","varchar,varchar")>
<cfset newRow = QueryAddRow(application.qry_MOPI,5)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_low_value","1",1)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_meaning","1",1)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_low_value","2",2)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_meaning","2",2)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_low_value","3",3)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_meaning","3",3)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_low_value","4",4)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_meaning","4",4)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_low_value","U",5)>
<cfset temp = QuerySetCell(application.qry_MOPI, "rv_meaning","U",5)>

<cfif application.ENV IS NOT "TRAIN">
	<cfquery name="application.bailCustodySuites" datasource="#application.warehouseDSN#">
        SELECT DISTINCT REPLACE(REPLACE(REPLACE(BAILED_TO, ', WEST MERCIA CONSTABULARY',''),'NUNEATON AND BEDWORTH DISTRICT SECTOR, WARWICKSHIRE POLICE','NUNEATON'),'SOUTHERN AREA, WARWICKSHIRE POLICE','LEAMINGTON SPA') AS CUSTODY_SUITE
        FROM browser_owner.BAIL_SEARCH BS
        WHERE bail_type = 'POLICE'
        AND (BAILED_TO LIKE '%WEST MERCIA%' OR BAILED_TO LIKE '%WARWICKSHIRE%')
        AND trunc(BS.BAILED_TO_DATE)>=trunc(sysdate)
        ORDER BY REPLACE(REPLACE(REPLACE(BAILED_TO, ', WEST MERCIA CONSTABULARY',''),'NUNEATON AND BEDWORTH DISTRICT SECTOR, WARWICKSHIRE POLICE','NUNEATON'),'SOUTHERN AREA, WARWICKSHIRE POLICE','LEAMINGTON SPA')
	</cfquery>
<cfelse>
	<cfset application.bailCustodySuites=QueryNew("CUSTODY_SUITE","varchar")>
	<cfset newRow = QueryAddRow(application.bailCustodySuites,7)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","HEREFORD",1)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","KIDDERMINSTER",2)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","LEAMINGTON SPA",3)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","MALINSGATE",4)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","NUNEATON",5)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","SHREWSBURY",6)>
	<cfset temp = QuerySetCell(application.bailCustodySuites, "CUSTODY_SUITE","WORCESTER",7)>	
</cfif>	

<cfset Application.Lookup_Queries="YES">