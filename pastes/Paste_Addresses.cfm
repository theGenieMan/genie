
<!---

Module      : Paste_Addresses.cfm

App         : GENIE

Purpose     : Delivers all Addresses for a nominal in pastable to OIS format

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

<CFQUERY NAME = "qry_AddrDetails" DATASOURCE="#Application.WarehouseDSN#">
SELECT DECODE(PART_ID,'','',PART_ID||', ')||
	   DECODE(BUILDING_NAME,'','',BUILDING_NAME||', ')||
	   DECODE(BUILDING_NUMBER,'','',BUILDING_NUMBER||', ')||
	   DECODE(STREET_1,'','',STREET_1||', ')||
	   DECODE(LOCALITY,'','',LOCALITY||', ') AS LINE1,
	   DECODE(TOWN,'','',TOWN||', ')||
	   DECODE(COUNTY,'','',COUNTY||' ')||
	   DECODE(addr.POST_CODE,'','',addr.POST_CODE) AS LINE2,
	   addr.*, nom.TYPE, TO_CHAR(nom.RECORDED,'DD/MM/YYYY') AS DATE_REC
FROM   browser_owner.GE_ADDRESSES addr, browser_owner.GE_ADD_NOMINALS nom
WHERE  nom.POST_CODE=addr.POST_CODE
AND    addr.PREMISE_KEY=nom.PREMISE_KEY
AND    nom.NOMINAL_REF='#nominalRef#' 
ORDER BY RECORDED DESC
</cfquery>

<cfset i_Page=1>
<cfset arr_Lines=ArrayNew(1)>

<cfset arr_Lines[1]="West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Nominal Addresses. Page #i_Page#"&chr(13)&chr(10)>
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
<cfset arr_Lines[6]="++-- Nominal Addresses -------------------------------------------------------++"&chr(13)&chr(10)>

<cfset i_Line="7">
<cfset i_Addr=1>
<cfloop query="qry_AddrDetails">

 <cfset arr_Lines[i_Line]=" | Relevance  ">

 <cfif Len(TYPE) GT 62>
  <cfset str_AddrText=Left(TYPE,62)>
 <cfelse>
  <cfset str_AddrText=TYPE>
	<cfset i_Spaces=62-Len(TYPE)>
	<cfloop index="z" from="1" to="#i_Spaces#" step="1">
	<cfset str_AddrText=str_AddrText&chr(32)>
	</cfloop>	 
 </cfif> 
 <cfset str_AddrText=str_AddrText&"  |"&chr(13)&chr(10)>
 <cfset arr_lines[i_Line]=arr_lines[i_Line]&str_AddrText>

 <cfset i_Line=i_Line+1>
 <cfset arr_Lines[i_Line]=" | Address    ">
 <cfif Len(LINE1) GT 62>
  <cfset str_AddrText=Left(LINE1,62)>
 <cfelse>
  <cfset str_AddrText=LINE1>
	<cfset i_Spaces=62-Len(LINE1)>
	<cfloop index="z" from="1" to="#i_Spaces#" step="1">
	<cfset str_AddrText=str_AddrText&chr(32)>
	</cfloop>	 
 </cfif> 
 <cfset str_AddrText=str_AddrText&"  |"&chr(13)&chr(10)>
 <cfset arr_lines[i_Line]=arr_lines[i_Line]&str_AddrText>

 <cfset i_Line=i_Line+1>
 <cfset arr_Lines[i_Line]=" |            ">
 <cfif Len(LINE2) GT 62>
  <cfset str_AddrText=Left(LINE2,62)>
 <cfelse>
  <cfset str_AddrText=LINE2>
	<cfset i_Spaces=62-Len(LINE2)>
	<cfloop index="z" from="1" to="#i_Spaces#" step="1">
	<cfset str_AddrText=str_AddrText&chr(32)>
	</cfloop>	 
 </cfif> 
 <cfset str_AddrText=str_AddrText&"  |"&chr(13)&chr(10)>
 <cfset arr_lines[i_Line]=arr_lines[i_Line]&str_AddrText>

 <cfset i_Line=i_Line+1>
 <cfset arr_Lines[i_Line]=" | Recorded   ">
 <cfif Len(DATE_REC) GT 62>
  <cfset str_AddrText=Left(DATE_REC,62)>
 <cfelse>
  <cfset str_AddrText=DATE_REC>
	<cfset i_Spaces=62-Len(DATE_REC)>
	<cfloop index="z" from="1" to="#i_Spaces#" step="1">
	<cfset str_AddrText=str_AddrText&chr(32)>
	</cfloop>	 
 </cfif> 
 <cfset str_AddrText=str_AddrText&"  |"&chr(13)&chr(10)>
 <cfset arr_lines[i_Line]=arr_lines[i_Line]&str_AddrText>

<!---
 <cfset arr_Lines[9]=" | Code Type Offence No      Offence Title                        Committed   | "&chr(13)&chr(10)>
--->
<!---
 <cfset arr_lines[i_Line]=str_NominalText>
--->
 <Cfset i_Line=i_Line+1>
 <cfset arr_Lines[i_Line]=" |                                                                            | "&chr(13)&chr(10)>
<Cfset i_Line=i_Line+1>

 <cfif i_Addr MOD 3 IS 0 or i_Addr IS qry_AddrDetails.RecordCount>
   <cfset arr_Lines[i_line]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>
   <cfset str_Text=ArrayToList(arr_Lines,"~")>
   <cfoutput>
   <pre>#Trim(Replace(str_Text,"~","","ALL"))#</pre>
   </cfoutput>
    <cfset i_Page=i_page+1>
	<cfset arr_Lines=ArrayNew(1)>
	
	<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
	<cfset arr_Lines[2]="Nominal Addresses. Page #i_Page#"&chr(13)&chr(10)>
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
	<cfset arr_Lines[6]="++-- Nominal Addresses -------------------------------------------------------++"&chr(13)&chr(10)>
	
	<cfset i_Line="7">
  
 </cfif>
 <cfset i_Addr=i_Addr+1>
</cfloop>

