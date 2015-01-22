<!---

Module      : Paste_Nominal_Details.cfm

App         : GENIE

Purpose     : Delivers all Details for a nominal in pastable to OIS format

Requires    : 

Author      : Nick Blackham

Date        : 24/11/2014

Revisions   : 

--->

<CFQUERY NAME = "qry_NominalDetails" DATASOURCE="#Application.WarehouseDSN#">
 SELECT ns.*, nd.*,
        TRUNC(FLOOR(months_between(trunc(sysdate), trunc(NVL(date_of_birth , sysdate))))/12) as AGE
 FROM   browser_owner.NOMINAL_SEARCH NS, browser_owner.NOMINAL_DETAILS ND
 WHERE  NS.NOMINAL_REF='#nominalRef#'
 AND    ns.NOMINAL_REF=nd.NOMINAL_REF
</cfquery>

<!--- get the latest home address --->
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
AND    nom.LATEST_FLAG='Y'
</cfquery>

<cfset arr_Lines=ArrayNew(1)>

<cfoutput query="qry_NominalDetails">

<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Full Nominal Details"&chr(13)&chr(10)>
<cfset arr_Lines[3]="+-- Nominals-------------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[4]="| Ref         ">
       
			<cfset str_NominalText=nominalRef>
			<cfset i_Spaces=19-Len(nominalRef)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[4]=arr_Lines[4]&str_NominalText&" CRO ">

			<cfset str_NominalText=CRO>
			<cfset i_Spaces=41-Len(CRO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[4]=arr_Lines[4]&str_NominalText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[5]="| Title       ">

      <cfset str_NominalText=TITLE>
			<cfset i_Spaces=65-Len(TITLE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 

<cfset arr_Lines[5]=arr_Lines[5]&str_NominalText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[6]="| Surname(s)  ">

    <cfset str_NominalText="">
    <cfif Len(SURNAME_1) GT 32>
		 <cfset str_NominalText=str_NominalText&Left(SURNAME_1,32)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&SURNAME_1>
			<cfset i_Spaces=32-Len(SURNAME_1)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>
		
    <cfif Len(SURNAME_2) GT 32>
		 <cfset str_NominalText=str_NominalText&Left(SURNAME_2,32)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&SURNAME_2>
			<cfset i_Spaces=32-Len(SURNAME_2)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>		
		

<cfset arr_Lines[6]=arr_Lines[6]&str_NominalText&" |"&chr(13)&chr(10)>

<cfset arr_Lines[7]="| Forename(s) ">

    <cfset str_NominalText="">
    <cfif Len(FORENAME_1) GT 32>
		 <cfset str_NominalText=str_NominalText&Left(FORENAME_1,32)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&FORENAME_1>
			<cfset i_Spaces=32-Len(FORENAME_1)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>
		
    <cfif Len(FORENAME_2) GT 32>
		 <cfset str_NominalText=str_NominalText&Left(FORENAME_2,32)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&FORENAME_2>
			<cfset i_Spaces=32-Len(FORENAME_2)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>		
		

<cfset arr_Lines[7]=arr_Lines[7]&str_NominalText&" |"&chr(13)&chr(10)>

<cfset arr_Lines[8]="| PNC ID      ">
      
			<cfset str_NominalText=PNCID_NO>
			<cfset i_Spaces=65-Len(PNCID_NO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 

<cfset arr_Lines[8]=arr_Lines[8]&str_NominalText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[9]="| Maiden      ">
    <cfset str_NominalText="">
    <cfif Len(MAIDEN_NAME) GT 19>
		 <cfset str_NominalText=str_NominalText&Left(MAIDEN_NAME,19)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&MAIDEN_NAME>
			<cfset i_Spaces=19-Len(MAIDEN_NAME)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>		

<cfset arr_Lines[9]=arr_Lines[9]&str_NominalText&" Nickname ">
    <cfset str_NominalText="">
    <cfif Len(FAMILIAR_NAME) GT 19>
		 <cfset str_NominalText=str_NominalText&Left(FAMILIAR_NAME,19)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&FAMILIAR_NAME>
			<cfset i_Spaces=19-Len(FAMILIAR_NAME)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>		

<cfset arr_Lines[9]=arr_Lines[9]&str_NominalText&" DOB "&DateFormat(DATE_OF_BIRTH,"DD/MM/YYYY")&"  |"&chr(13)&chr(10)>

<cfset arr_Lines[10]="| Age         ">

			<cfset str_NominalText=AGE>
			<cfset i_Spaces=19-Len(AGE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	

<cfset arr_Lines[10]=arr_Lines[10]&str_NominalText&" SEX "&SEX&"   Ethnic App ">

    <cfset str_NominalText="">
    <cfif Len(ETHNICITY_16) GT 25>
		 <cfset str_NominalText=str_NominalText&Left(ETHNICITY_16,25)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&ETHNICITY_16>
			<cfset i_Spaces=25-Len(ETHNICITY_16)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>		
			
<cfset arr_Lines[10]=arr_Lines[10]&str_NominalText&" |"&chr(13)&chr(10)>			

<cfset arr_Lines[11]="| Birthplace  ">

			<cfset str_NominalText=PLACE_OF_BIRTH>
			<cfset i_Spaces=64-Len(PLACE_OF_BIRTH)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	
			
<cfset arr_Lines[11]=arr_Lines[11]&str_NominalText&" |"&chr(13)&chr(10)>	

<cfset arr_Lines[12]="| Height      ">

  <cfif Len(Height_CMS) GT 0 AND Len(HEIGHT_INS) GT 0>
   <cfset str_Height=Int(HEIGHT_INS/12)&" Ft "&Int(HEIGHT_INS MOD 12)&" In / "&(HEIGHT_CMS/100)&"m">
  <cfelseif Len(HEIGHT_CMS) GT 0 AND Len(HEIGHT_INS) IS 0>
   <cfset str_Height=(HEIGHT_CMS/100)&"m">
  <cfelseif Len(HEIGHT_CMS) IS 0 AND Len(HEIGHT_INS) GT 0>
   <cfset str_Height=Int(HEIGHT_INS/12)&" Ft "&Int(HEIGHT_INS MOD 12)&" In">
  <cfelse>
	 <cfset str_Height="">
	</cfif>
			<cfset str_NominalText=str_Height>
			<cfset i_Spaces=27-Len(str_Height)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	
			
<cfset arr_Lines[12]=arr_Lines[12]&str_NominalText&" Weight ">
 
  <cfif Len(Weight_LBS) GT 0>
	 <cfset iStone=Int(Weight_LBS/14)>
	 <cfset iPounds=Weight_LBS MOD 14>
   <cfset str_Weight=iStone&" St "&iPounds&" Lbs / "&WEIGHT_KGS&" Kg">
	<cfelse>
	 <cfset str_Weight="">
	</cfif>
		
			<cfset str_NominalText=str_Weight>
			<cfset i_Spaces=29-Len(str_Weight)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>			
	
	<cfset arr_Lines[12]=arr_Lines[12]&str_NominalText&" |"&chr(13)&chr(10)>	
</cfoutput>	
<cfset arr_Lines[13]="+------------------------------------------------------------------------------+"&chr(13)&chr(10)>	
<cfset arr_Lines[14]="++-- Most Recent Home Address ------------------------------------------------++"&chr(13)&chr(10)>	
<cfset arr_Lines[15]=" |                                                                            | "&chr(13)&chr(10)>	

<cfif qry_AddrDetails.recordCount IS 0>
 <cfset LINE1="">
 <cfset LINE2="">
 <cfset DATE_REC="">
<cfelse>
 <cfset LINE1=qry_AddrDetails.LINE1>
 <cfset LINE2=qry_AddrDetails.LINE2>
 <cfset DATE_REC=qry_AddrDetails.DATE_REC>
</cfif>

<cfoutput>

 <cfset arr_Lines[16]=" | Address    ">
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
 <cfset arr_lines[16]=arr_lines[16]&str_AddrText>

 <cfset arr_Lines[17]=" |            ">
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
 <cfset arr_lines[17]=arr_lines[17]&str_AddrText>

 <cfset arr_Lines[18]=" | Recorded   ">
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
 <cfset arr_lines[18]=arr_lines[18]&str_AddrText>

</cfoutput>

<cfset arr_Lines[19]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>	
	
<!---
<cfset arr_Lines[5]=arr_Lines[5]&str_NominalText&"Sex "&qry_NominalDetails.SEX&" DOB "&qry_NominalDetails.DOB&"    |">
<cfset arr_Lines[6]="|                                                                              |">
<cfset arr_Lines[7]="++-- Crime Roles -------------------------------------------------------------++">
<cfset arr_Lines[8]=" | Role Proc                                                      Date        | ">
<cfset arr_Lines[9]=" | Code Type Offence No      Offence Title                        Committed   | ">

<cfset i_Line="10">
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
		<cfset str_NominalText=str_NominalText&chr(32)&DATE_COMM&chr(32)&" | ">		
 <cfset arr_lines[i_Line]=str_NominalText>
 <Cfset i_Line=i_Line+1>
</cfloop>

<cfset arr_Lines[i_line]=" +----------------------------------------------------------------------------+ ">
--->

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","","ALL")#</pre>
</cfoutput>