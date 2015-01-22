
<!---

Module      : Paste_Offences.cfm

App         : Nominal Photo Searching

Purpose     : Delivers all Roles for a nominal in pastable to OIS format

Requires    : 

Author      : Nick Blackham

Date        : 13/04/2004

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

<!--- Get all crimes that the Nominal has been involved in 
<CFQUERY NAME = "qry_WarrantDetails" DATASOURCE="#Application.WarehouseDSN#">
Select w.*,
       o.org_name as court,
	   o1.org_name as police,
	   date_executed,rv_meaning,
	   nvl(offence,'&nbsp;') as offence,warrant_executed,
		 crc.description as warrant_type,
	   RANK||' '||BADGE_NUMBER||' '||SURNAME_1||' '||SURNAME_2 AS Exec_By,
	   cu.ORG_CODE_CUST
From   Warrants w, Organisations o, Organisations o1, Crimes_Ref_codes cc, crimes_reference_codes crc,
       Badge_Assignments ba, nominals n, custodies cu
Where  w.warrant_ref='#warrantRef#'
And    (o.Org_Type=org_type_court And o.Org_Code=org_code_court)
And    (o1.Org_Type=org_type_police And o1.Org_Code=org_code_police)
And    (Rv_Domain(+)='METHOD_EX_WARNT' AND Rv_Low_Value(+)=how_warrant_executed)
And    (w.Assignment_ref=ba.Assignment_ref(+) and ba.nominal_ref=n.nominal_ref(+))
And    (w.wt_type=crc.crc_code AND crc.CRD_DOMAIN='WRNT')
And    (w.custody_ref=cu.custody_ref(+))
Order By Date_Issued DESC
</cfquery>--->

<CFQUERY NAME = "qry_WarrantDetails" DATASOURCE="#Application.WarehouseDSN#">
Select w.*, court_name as court, org_code_police as police
From   browser_owner.Warrants w
Where  w.warrant_ref='#warrantRef#'
Order By Date_Issued DESC
</cfquery>

<cfset arr_Lines=ArrayNew(1)>

<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Warrant Details"&chr(13)&chr(10)>
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
<cfset arr_Lines[7]="++-- Warrants ---------------------------------------------------------------++"&chr(13)&chr(10)>

<cfoutput query="qry_WarrantDetails" maxrows="1">
	
<cfset arr_Lines[8]=" | WMC Warrant No   ">

			<cfset str_WarText=WARRANT_REF>
			<cfset i_Spaces=22-Len(WARRANT_REF)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			<cfset arr_Lines[8]=arr_Lines[8]&str_WarText&"  Court Warrant No ">
			<cfset str_WarText=WARRANT_REFERENCE>
			<cfset i_Spaces=15-Len(WARRANT_REFERENCE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>			

<cfset arr_Lines[8]=arr_Lines[8]&str_WarText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[9]=" | Warrant Location ">

			<cfset arr_Lines[9]=arr_Lines[9]&str_WarText&"  ">
			<cfset str_WarText=POLICE>
			<cfset i_Spaces=39-Len(POLICE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[9]=arr_Lines[9]&str_WarText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[10]=" | Court of Origin  ">

			
			<cfset str_WarText=COURT>
            
			<cfset i_Spaces=56-Len(COURT)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
           	</cfloop>
			
<cfset arr_Lines[10]=arr_Lines[10]&str_WarText&" | "&chr(13)&chr(10)>

<!--->
<cfset arr_Lines[11]=" | Office of Origin ">

			<cfset str_WarText=OFFICE_OF_ORIGIN>
			<cfset i_Spaces=56-Len(OFFICE_OF_ORIGIN)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[11]=arr_Lines[11]&str_WarText&" | "&chr(13)&chr(10)>
--->
<cfset arr_Lines[11]="">

<cfset arr_Lines[12]=" | Offence          ">

			<cfset str_WarText=OFFENCE>
			<cfset i_Spaces=56-Len(OFFENCE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[12]=arr_Lines[12]&str_WarText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[13]=" | Type of Warrant  ">

			<cfset str_WarText=WARRANT_TYPE>
			<cfset i_Spaces=56-Len(WARRANT_TYPE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[13]=arr_Lines[13]&str_WarText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[14]=" | Date Issued      ">

			<cfset str_WarText=DateFormat(DATE_ISSUED,"DD MMM YYYY")>
			<cfset i_Spaces=12-Len(DateFormat(DATE_ISSUED,"DD MMM YYYY"))>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>

			<cfset arr_Lines[14]=arr_Lines[14]&str_WarText&"  With Bail ">
			<cfset str_WarText=BAIL>
			<cfset i_Spaces=32-Len(BAIL)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
            <!---
			<cfset arr_Lines[14]=arr_Lines[14]&str_WarText&"  Amount Outstanding  ">
			<cfset str_WarText=CASH_AMOUNT>
			<cfset i_Spaces=8-Len(CASH_AMOUNT)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			--->
			
<cfset arr_Lines[14]=arr_Lines[14]&str_WarText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[15]=" |                                                                           | "&chr(13)&chr(10)>

<cfset arr_Lines[16]=" | Status           ">

			<cfset str_WarText=EXECUTION_METHOD>
			<cfset i_Spaces=41-Len(EXECUTION_METHOD)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>

			<cfset arr_Lines[16]=arr_Lines[16]&str_WarText&"  Executed ">
            <cfif Len(DATE_EXECUTED) GT 0>
			<cfset str_WarText="Y">
            <cfelse>
			<cfset str_WarText="N">            
            </cfif>
			<cfset i_Spaces=3-Len(str_WarText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[16]=arr_Lines[16]&str_WarText&"  | "&chr(13)&chr(10)>

<!---
<cfset arr_Lines[17]=" | Sent To          ">

			<cfset str_WarText=SENT_TO>
			<cfset i_Spaces=37-Len(SENT_TO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>

			<cfset arr_Lines[17]=arr_Lines[17]&str_WarText&"  Date ">
			<cfset str_WarText=DateFormat(SENT_TO_DATE,"DD MMM YYYY")>
			<cfset i_Spaces=12-Len(DateFormat(SENT_TO_DATE,"DD MMM YYYY"))>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[17]=arr_Lines[17]&str_WarText&" | "&chr(13)&chr(10)>
--->
<cfset arr_lines[17]="">

<!---
<cfset arr_Lines[18]=" | Executed By      ">

			<cfset str_WarText=EXEC_BY>
			<cfset i_Spaces=56-Len(EXEC_BY)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[18]=arr_Lines[18]&str_WarText&" | "&chr(13)&chr(10)>
--->
<cfset arr_Lines[18]="">

<cfset arr_Lines[19]=" | Date Executed    ">

			<cfset str_WarText=DateFormat(DATE_EXECUTED,"DD MMM YYYY")>
			<cfset i_Spaces=56-Len(DateFormat(DATE_EXECUTED,"DD MMM YYYY"))>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>

<!---
			<cfset arr_Lines[19]=arr_Lines[19]&str_WarText&"  Receipt Number ">
			<cfset str_WarText=RECEIPT_NO>
			<cfset i_Spaces=12-Len(RECEIPT_NO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
            --->
			
<cfset arr_Lines[19]=arr_Lines[19]&str_WarText&" | "&chr(13)&chr(10)>

<!---
<cfset arr_Lines[20]=" | Custody Number   ">

			<cfset str_WarText=CUSTODY_REF>
			<cfset i_Spaces=15-Len(CUSTODY_REF)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>

			<cfset arr_Lines[20]=arr_Lines[20]&str_WarText&"  Station ">
			<cfset str_WarText=ORG_CODE_CUST>
			<cfset i_Spaces=31-Len(ORG_CODE_CUST)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[20]=arr_Lines[20]&str_WarText&" | "&chr(13)&chr(10)>
--->
<cfset arr_LInes[20]="">

<cfset arr_Lines[21]=" | Notepad          ">
            <cfset nPad=TRIM(NOTEPAD)>
            <cfif Len(nPAD) GT 55>
		    <cfset str_WarText=Left(nPAD,55)>
			<Cfelse>
			<cfset str_WarText=nPAD>
			</cfif>
			<cfset i_Spaces=56-Len(str_WarText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_WarText=str_WarText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[21]=arr_Lines[21]&str_WarText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[22]=" +---------------------------------------------------------------------------+ "&chr(13)&chr(10)>

</cfoutput>

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","","ALL")#</pre>
</cfoutput>