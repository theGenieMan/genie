
<!---

Module      : Paste_Offences.cfm

App         : GENIE

Purpose     : Delivers all Roles for a nominal in pastable to OIS format

Requires    : 

Author      : Nick Blackham

Date        : 24/11/2014

Revisions   : 

--->

<CFQUERY NAME = "qry_NominalDetails" DATASOURCE="#Application.WarehouseDSN#">
 SELECT REPLACE(REPLACE(LTRIM(
				RTRIM(ND.TITLE)||' '||
        RTRIM(NS.SURNAME_1)||DECODE(NS.SURNAME_2,NULL,'','-'||NS.SURNAME_2)||', '||
        RTRIM(INITCAP(FORENAME_1))||' '||
        RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ') Name,
		    SEX,
				TO_CHAR(DATE_OF_BIRTH,'DD/MM/YYYY') AS DOB
 FROM   browser_owner.NOMINAL_SEARCH NS, browser_owner.NOMINAL_DETAILS ND
 WHERE  NS.NOMINAL_REF='#nominalRef#'
 AND    ns.NOMINAL_REF=nd.NOMINAL_REF
</cfquery>

<CFQUERY NAME = "qry_CrimeDetails" DATASOURCE="#Application.WarehouseDSN#">
select nr.role as ROLE_CODE, nr.process as proc_type,
       o.ORG_CODE || '/' || o.SERIAL_NO ||'/' || DECODE(LENGTH(o.YEAR),1, '0' || o.YEAR, o.YEAR) CRIME_NO,
       o.INCIDENT_NO, O.REC_TITLE AS SHORT_OFFENCE_TITLE , TO_CHAR(O.FIRST_COMMITTED,'DD/MM/YYYY') AS DATE_COMM
from browser_owner.offence_search o, browser_owner.nominal_roles nr
where nr.nominal_ref=<cfqueryparam value="#nominalRef#" cfsqltype="cf_sql_varchar">
and NR.CRIME_REF=O.CRIME_REF
order by first_committed desc
</cfquery>

<!--- Get all crimes that the Nominal has been involved in 
<CFQUERY NAME = "qry_CrimeDetails" DATASOURCE="#Application.WarehouseDSN#">
select   rt.ROLE_CODE, SUBSTR(cuc.DESCRIPTION,0,4) AS PROC_TYPE,
         C.ORG_DSP_CODE || '/' || C.SERIAL_NO ||'/' || DECODE(LENGTH(C.YEAR),1, '0' || C.YEAR, C.YEAR) CRIME_NO,
	       c.INCIDENT_NO, o.SHORT_OFFENCE_TITLE, TO_CHAR(c.DATE_FIRST_COMMITED,'DD/MM/YYYY') AS DATE_COMM
from     role_in_crimes ric, crimes c, offences o, role_types rt, cleared_up_codes cuc
where    ric.ROLE_TYPE_REF=rt.ROLE_TYPE_REF
and      ric.CRIME_REF=c.CRIME_REF
and      c.OFFENCE_REF_REPORTED=o.OFFENCE_REF
and      ric.CUC_CODE=cuc.CUC_CODE(+)
and      ric.NOMINAL_REF='#nominalRef#'
ORDER BY DATE_FIRST_COMMITED DESC
</cfquery>--->

<cfset arr_Lines=ArrayNew(1)>

<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Crime Role Enquiry"&chr(13)&chr(10)>
<cfset arr_Lines[3]="+-- Nominals-------------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[4]="| Nominal Ref ">
       
			<cfset str_NominalText=nominalRef>
			<cfset i_Spaces=65-Len(nominalRef)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[4]=arr_Lines[4]&str_NominalText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[5]="| Name        ">

    
    <cfif Len(qry_NominalDetails.NAME) GT 41>
		 <cfset str_NominalText=Left(qry_NominalDetails.NAME,41)>
		<cfelse>
		 <cfset str_NominalText=qry_NominalDetails.NAME>
			<cfset i_Spaces=41-Len(qry_NominalDetails.NAME)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif> 

<cfset arr_Lines[5]=arr_Lines[5]&str_NominalText&"Sex "&qry_NominalDetails.SEX&" DOB "&qry_NominalDetails.DOB&"    |"&chr(13)&chr(10)>
<cfset arr_Lines[6]="|                                                                              |"&chr(13)&chr(10)>
<cfset arr_Lines[7]="++-- Crime Roles -------------------------------------------------------------++"&chr(13)&chr(10)>
<cfset arr_Lines[8]=" | Role Proc                                                      Date        | "&chr(13)&chr(10)>
<cfset arr_Lines[9]=" | Code Type Offence No      Offence Title                        Committed   | "&chr(13)&chr(10)>

<cfset i_Line="10">
<cfset i_Off=1>
<cfloop query="qry_CrimeDetails">

    <cfset str_NominalText=" | "&ROLE_CODE&" ">
		<cfif Len(PROC_TYPE) LT 4>
    <cfset i_Spaces=4-Len(PROC_TYPE)>
		<cfloop index="z" from="1" to="#i_Spaces#" step="1">
		<cfset str_NominalText=str_NominalText&chr(32)>
		</cfloop>		
		</cfif>
		<cfset str_NominalText=str_NominalText&PROC_TYPE&" "&CRIME_NO>
		<cfset i_Spaces=16-Len(CRIME_NO)>
		<cfloop index="z" from="1" to="#i_Spaces#" step="1">
		<cfset str_NominalText=str_NominalText&chr(32)>
		</cfloop>
    <cfif Len(SHORT_OFFENCE_TITLE) GT 36>
		 <cfset str_NominalText=str_NominalText&Left(SHORT_OFFENCE_TITLE,36)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&SHORT_OFFENCE_TITLE>
			<cfset i_Spaces=36-Len(SHORT_OFFENCE_TITLE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>
		<cfset str_NominalText=str_NominalText&chr(32)&DATE_COMM&chr(32)&" | "&chr(13)&chr(10)>		
 <cfset arr_lines[i_Line]=str_NominalText>
 <Cfset i_Line=i_Line+1>
 <cfset i_Off=i_Off+1>
 <cfif i_Off IS 15>
  <cfbreak>
 </cfif>
</cfloop>

<cfset arr_Lines[i_line]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>


<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","<br>","ALL")#</pre>
</cfoutput>