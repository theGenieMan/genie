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
		SELECT OFF_CODE1 AS HOMC_CODE, DESCRIPTION
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

<cfset application.qry_Sex=QueryNew("rv_low_value,rv_meaning","varchar,varchar")>
<cfset newRow = QueryAddRow(application.qry_Sex,3)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_low_value","M",1)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_meaning","Male",1)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_low_value","F",2)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_meaning","Female",2)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_low_value","U",3)>
<cfset temp = QuerySetCell(application.qry_Sex, "rv_meaning","Unknown",3)>

<cfset Application.Lookup_Queries="YES">