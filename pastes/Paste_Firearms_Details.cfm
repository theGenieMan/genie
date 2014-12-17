<!---

Module      : Paste_Firearms_Details.cfm

App         : Nominal Photo Searching

Purpose     : Delivers all Firearms details based on Person ID 

Requires    : 

Author      : Nick Blackham

Date        : 14/06/2007

Revisions   : 

--->

<cfquery name="qry_NominalDetails" datasource="#Application.WarehouseDSN#">
SELECT p.*
FROM   browser_owner.NFLMS_PERSON p
WHERE  PERSON_URN='#PERSON_URN#'
</cfquery>

<cfquery name="qry_AddressDetails" datasource="#Application.WarehouseDSN#">
SELECT   DECODE(LINE_1,'','',LINE_1||', ')||
				DECODE(LINE_2,'','',LINE_2||', ')||
				DECODE(LINE_3,'','',LINE_3) AS ADDR1,
				DECODE(LINE_4,'','',LINE_4||', ')||
				DECODE(LINE_5,'','',LINE_5||', ')||
				DECODE(POSTCODE,'','',POSTCODE) ADDR2,a.*
FROM   browser_owner.NFLMS_ADDRESS a
WHERE  PERSON_URN='#PERSON_URN#'
</cfquery>

<cfset arr_Lines=ArrayNew(1)>

<cfoutput query="qry_NominalDetails">

<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="NFLMS Firearms Nominal Details"&chr(13)&chr(10)>
<cfset arr_Lines[3]="+-- Nominals-------------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[4]="| Ref         ">
       
			<cfset str_NominalText=PERSON_URN>
			<cfset i_Spaces=19-Len(PERSON_URN)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[4]=arr_Lines[4]&str_NominalText&" PNC ID ">

			<cfset str_NominalText=PNCID>
			<cfset i_Spaces=38-Len(PNCID)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[4]=arr_Lines[4]&str_NominalText&"|"&chr(13)&chr(10)>

    <cfset str_NominalText="">
    <cfif Len(FORENAMES) GT 32>
		 <cfset str_NominalText=str_NominalText&Left(FORENAMES,32)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&FORENAMES>
			<cfset i_Spaces=32-Len(FORENAMES)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>
		
    <cfif Len(SURNAME) GT 32>
		 <cfset str_NominalText=str_NominalText&Left(SURNAME,32)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&SURNAME>
			<cfset i_Spaces=32-Len(SURNAME)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>		

<cfset arr_Lines[5]="| Name        "&str_NominalText&" |"&chr(13)&chr(10)>

<cfset arr_Lines[6]="| DOB         ">

      <cfset str_NominalText=DateFormat(DOB,"DD/MM/YYYY")>
			<cfset i_Spaces=65-Len(DateFormat(DOB,"DD/MM/YYYY"))>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 

<cfset arr_Lines[6]=arr_Lines[6]&str_NominalText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[7]="| Height      ">

<cfset str_NominalText=HEIGHT>
			<cfset i_Spaces=64-Len(HEIGHT)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	   
		

<cfset arr_Lines[7]=arr_Lines[7]&str_NominalText&" |"&chr(13)&chr(10)>

</cfoutput>

<cfoutput query="qry_AddressDetails">

<cfset arr_Lines[8]="+------------------------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[9]="++--Address Details ----------------------------------------------------------++"&chr(13)&chr(10)>
<cfset arr_Lines[10]=" | Address                                                                    | "&chr(13)&chr(10)>

<cfset arr_Lines[11]=" | ">

			<cfset str_NominalText=ADDR1>
         <cfif Len(str_NominalText) GT 75>
		 <cfset str_NominalText=str_NominalText&Left(str_NominalText,75)>
		<cfelse>
			<cfset i_Spaces=75-Len(ADDR1)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[11]=arr_Lines[11]&str_NominalText&"| "&chr(13)&chr(10)>

<cfset arr_Lines[12]=" | ">

			<cfset str_NominalText=ADDR2>
         <cfif Len(str_NominalText) GT 75>
		 <cfset str_NominalText=str_NominalText&Left(str_NominalText,75)>
		<cfelse>
			<cfset i_Spaces=75-Len(ADDR2)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[12]=arr_Lines[12]&str_NominalText&"| "&chr(13)&chr(10)>

<cfset arr_Lines[13]=" |                                                                            | "&chr(13)&chr(10)>

<cfset arr_Lines[14]=" | Home Tel      ">
       
        	<cfset s_TELNO=Replace(Replace(Replace(TEL_NO,"(","","ALL"),")","","ALL")," ","","ALL")>
			<cfset str_NominalText=s_TELNO>
			<cfset i_Spaces=19-Len(s_TELNO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[14]=arr_Lines[14]&str_NominalText&" Mobile Tel ">

			<cfset str_NominalText=qry_NominalDetails.MOBILE_TEL>
			<cfset i_Spaces=30-Len(qry_NominalDetails.MOBILE_TEL)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[14]=arr_Lines[14]&str_NominalText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[15]=" |                                                                            | "&chr(13)&chr(10)>

<cfset arr_Lines[16]=" | Security Type ">

		<cfset str_NominalText=SECURITY_TYPE>
         <cfif Len(str_NominalText) GT 61>
		 <cfset str_NominalText=str_NominalText&Left(str_NominalText,61)>
		<cfelse>
			<cfset i_Spaces=61-Len(SECURITY_TYPE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[16]=arr_Lines[16]&str_NominalText&"| "&chr(13)&chr(10)>

<cfset arr_Lines[17]=" | Location      ">

		<cfset str_NominalText=SECURITY_LOCATION>
         <cfif Len(str_NominalText) GT 61>
		 <cfset str_NominalText=str_NominalText&Left(str_NominalText,61)>
		<cfelse>
			<cfset i_Spaces=61-Len(SECURITY_LOCATION)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[17]=arr_Lines[17]&str_NominalText&"| "&chr(13)&chr(10)>
<cfset arr_Lines[18]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>	
<cfset arr_Lines[19]=" END PAGE 1 "&chr(13)&chr(10)>	

</cfoutput>

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","<br>","ALL")#</pre>
</cfoutput>

<!--- now do certificates --->

<cfquery name="qry_NominalCertif" datasource="#Application.WarehouseDSN#">
SELECT nc.*
FROM   browser_owner.NFLMS_CERTIFICATE nc
WHERE  PERSON_URN='#PERSON_URN#'
</cfquery>

<cfset i_Page=2>
<cfloop query="qry_NominalCertif">

<cfset arr_Lines=ArrayNew(1)>
<cfset arr_Lines[1]="West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="NFLMS Firearms Certificate Details"&chr(13)&chr(10)>
<cfset arr_Lines[3]="+-- Nominals-------------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[4]="| ">

    <cfset str_NominalText=qry_NominalDetails.PERSON_URN&", "&qry_NominalDetails.FORENAMES&" "&qry_NominalDetails.SURNAME>
    <cfif Len(str_NominalText) GT 76>
		 <cfset str_NominalText=str_NominalText&Left(str_NominalText,76)>
		<cfelse>
			<cfset i_Spaces=76-Len(str_NominalText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[4]=arr_Lines[4]&str_NominalText&" |"&chr(13)&chr(10)>

<cfset arr_Lines[5]="++--Certificate Details ------------------------------------------------------++"&chr(13)&chr(10)>
<cfset arr_Lines[6]=" | Certif No  ">

			<cfset str_NominalText=CERT_NO>
			<cfset i_Spaces=63-Len(CERT_NO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[6]=arr_Lines[6]&str_NominalText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[7]=" | Type       ">

	<cfset i_FindDesc=ListFind(Application.NFLMS_CertCode,CERT_TYPE,",")>
	<cfif i_FindDesc IS 0>
	 <cfset s_CertDesc=CERT_TYPE>
	<cfelse>
	 <cfset s_CertDesc=ListGetAt(Application.NFLMS_CertDesc,i_FindDesc,",")>
	</cfif>	

			<cfset str_NominalText=s_CERTDesc>
			<cfset i_Spaces=63-Len(s_CertDesc)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[7]=arr_Lines[7]&str_NominalText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[8]=" | Status     ">

	<cfset i_FindDesc=ListFind(Application.NFLMS_StatusCode,CERT_STATUS,",")>
	<cfif i_FindDesc IS 0>
	 <cfset s_StatusDesc=CERT_STATUS>
	<cfelse>
	 <cfset s_StatusDesc=ListGetAt(Application.NFLMS_StatusDesc,i_FindDesc,",")>
	</cfif>

			<cfset str_NominalText=s_StatusDesc>
			<cfset i_Spaces=63-Len(s_StatusDesc)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[8]=arr_Lines[8]&str_NominalText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[9]=" | Valid From ">
       
			<cfset str_NominalText=DateFormat(VALID_FROM,"dd/mm/yyyy")>
			<cfset i_Spaces=19-Len(DateFormat(VALID_FROM,"dd/mm/yyyy"))>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[9]=arr_Lines[9]&str_NominalText&" Valid To ">

			<cfset str_NominalText=DateFormat(VALID_TO,"dd/mm/yyyy")>
			<cfset i_Spaces=34-Len(DateFormat(VALID_TO,"dd/mm/yyyy"))>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>

<cfset arr_Lines[9]=arr_Lines[9]&str_NominalText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[10]=" |                                                                            | "&chr(13)&chr(10)>

<cfset arr_Lines[11]=" | Weapons                                                                    | "&chr(13)&chr(10)>

	<cfquery name="qry_CertifWeapons" datasource="#Application.WarehouseDSN#">
	SELECT nw.*
	FROM   browser_owner.NFLMS_WEAPON nw
	WHERE  CERT_NO='#CERT_NO#'
	</cfquery>
	
<cfset i_Line=12>	
<cfloop query="qry_CertifWeapons">	
 <cfset arr_Lines[i_line]=" | ">
 <cfset s_LineText="#MANUFACTURER# #WEAPON_TYPE# #WEAPON_ACTION# #CALIBRE# (Serial No : #Serial_NO#)">	
 <cfset str_NominalText=s_lineText>
 <cfif Len(s_lineText) GT 74>
 <cfset s_NominalText=Left(s_LineText,74)> 
 <cfelse>
 <cfset i_Spaces=74-Len(s_lineText)>
 <cfloop index="z" from="1" to="#i_Spaces#" step="1">
 <cfset str_NominalText=str_NominalText&chr(32)>
 </cfloop>
 </cfif>

 <cfset arr_Lines[i_line]=arr_Lines[i_line]&str_NominalText&" | "&chr(13)&chr(10)>

 <cfset i_Line=i_Line+1>
</cfloop>	

<cfset arr_Lines[i_Line]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>	
<cfset arr_Lines[i_Line+1]=" END PAGE #i_Page# "&chr(13)&chr(10)>	

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","<br>","ALL")#</pre>
</cfoutput>
<cfset i_Page-i_Page+1>
</cfloop>
