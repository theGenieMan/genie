
<!---

Module      : Paste_Vehicles.cfm

App         : GENIE

Purpose     : Delivers all Vehicles for a nominal in pastable to OIS format

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

<CFQUERY NAME = "qry_VehicleDetails" DATASOURCE="#Application.WarehouseDSN#">
SELECT VRM, MANUFACTURER, MODEL, PRIMARY_COL, TO_CHAR(START_DATE,'DD-MON-YYYY') AS START_DATE
FROM   browser_owner.VEHICLE_SEARCH vs, browser_owner.VEHICLE_USAGES vu
WHERE vs.veh_ref=vu.veh_ref(+)
AND VU.NOMINAL_REF='#nominalRef#'
ORDER BY vu.START_DATE DESC
</CFQUERY>				

<cfset i_Pages=qry_VehicleDetails.RecordCount/15>
<cfif qry_VehicleDetails.RecordCount MOD 15 GT 0>
 <cfset i_Pages=i_Pages+1>
</cfif>

<cfloop index="i_ThisPage" from="1" to="#i_Pages#">
	
<cfset arr_Lines=ArrayNew(1)>
	
<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Nominal Vehicles"&chr(13)&chr(10)>
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
<cfset arr_Lines[7]="++-- Vehicles ----------------------------------------------------------------++"&chr(13)&chr(10)>
<cfset arr_Lines[8]=" | VRM      Make           Model                  Colour        Date          | "&chr(13)&chr(10)>

<cfset i_Line="9">
<cfset i_Veh=1>

<cfif i_ThisPage IS 1>
 <cfset i_Start=1>
 <cfif qry_VehicleDetails.RecordCount LT 15>
  <cfset i_End=qry_VehicleDetails.RecordCount>
 <cfelse>
  <cfset i_End=15>
 </cfif>
<cfelse>
 <cfset i_Start=i_End+1>
 <cfif qry_VehicleDetails.RecordCount LT i_Start+14>
  <cfset i_End=qry_VehicleDetails.RecordCount>
 <cfelse>
 <cfset i_End=i_Start+14>
 </cfif>
</cfif>


<cfloop query="qry_VehicleDetails" startrow="#i_Start#" endrow="#i_End#">

    <cfset str_NominalText=" | "&VRM&" ">
		<cfif Len(VRM) LT 8>
          <cfset i_Spaces=8-Len(VRM)>
		  <cfloop index="z" from="1" to="#i_Spaces#" step="1">
		    <cfset str_NominalText=str_NominalText&chr(32)>
		  </cfloop>		
		</cfif>
		
		<cfif Len(MANUFACTURER) GT 14>
		  <cfset str_NominalText=str_NominalText&Left(MANUFACTURER,14)>
		<cfelse>
		  <cfset str_NominalText=str_NominalText&MANUFACTURER>
		  <cfset i_Spaces=14-Len(MANUFACTURER)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			 <cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop> 	
		</cfif>
		<cfset str_NominalText=str_NominalText&chr(32)>
		<cfif Len(MODEL) GT 22>
		  <cfset str_NominalText=str_NominalText&Left(MODEL,22)>
		<cfelse>
		  <cfset str_NominalText=str_NominalText&MODEL>
		  <cfset i_Spaces=22-Len(MODEL)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			 <cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop> 	
		</cfif>
		<cfset str_NominalText=str_NominalText&chr(32)>
		<cfif Len(PRIMARY_COL) GT 13>
		  <cfset str_NominalText=str_NominalText&Left(PRIMARY_COL,13)>
		<cfelse>
		  <cfset str_NominalText=str_NominalText&PRIMARY_COL>
		  <cfset i_Spaces=13-Len(PRIMARY_COL)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			 <cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop> 	
		</cfif>
		
		<cfset str_NominalText=str_NominalText&chr(32)&START_DATE&chr(32)&"  | "&chr(13)&chr(10)>
		    		
 <cfset arr_lines[i_Line]=str_NominalText>
 <Cfset i_Line=i_Line+1>
 <cfset i_Veh=i_Veh+1>
 <cfif i_Veh IS 15>
  <cfbreak>
 </cfif>
</cfloop>

<cfset arr_Lines[i_line]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>
<cfset i_Line=i_Line+1>	
<cfset arr_Lines[i_line]=" END PAGE #i_ThisPage# "&chr(13)&chr(10)>

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","<br>","ALL")#</pre>
</cfoutput>

</cfloop>

