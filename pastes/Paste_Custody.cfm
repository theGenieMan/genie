<!---

Module      : Paste_Custody.cfm

App         : Nominal Photo Searching

Purpose     : Delivers all Details for a custody in pastable to OIS format

Requires    : 

Author      : Nick Blackham

Date        : 13/04/2004

Revisions   : 

--->

<CFQUERY NAME="qry_CustodyDetails" DATASOURCE="#Application.WarehouseDSN#">
 SELECT CS.*, CD.*, CR.*
 FROM   browser_owner.CUSTODY_SEARCH CS, browser_owner.CUSTODY_DETAIL CD, browser_owner.CUSTODY_REASONS CR
 WHERE  CS.CUSTODY_REF='#custodyRef#'
 AND    CS.CUSTODY_REF=CD.CUSTODY_REF
 AND    CS.CUSTODY_REF=CR.CUSTODY_REF
</cfquery>

<cfset arr_Lines=ArrayNew(1)>

<cfoutput query="qry_CustodyDetails" maxrows="1">

<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Custody Enquiry"&chr(13)&chr(10)>
<cfset arr_Lines[3]="+-- Custody Record ------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[4]="| Custody No ">
       
			<cfset str_CustText=Trim(CUSTODY_REF)>
			<cfset i_Spaces=15-Len(str_CustText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>

<cfset arr_Lines[4]=arr_Lines[4]&str_CustText>

			<cfset str_CustText=NOMINAL_REF>
			<cfset i_Spaces=9-Len(NOMINAL_REF)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[4]=arr_Lines[4]&str_CustText>

    <cfset str_CustText="">
    <cfif Len(NAME) GT 42>
		 <cfset str_CustText=str_CustText&Left(NAME,42)>
		<cfelse>
		 <cfset str_CustText=str_CustText&NAME>
			<cfset i_Spaces=42-Len(NAME)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>	

<cfset arr_Lines[4]=arr_Lines[4]&str_CustText&"|"&chr(13)&chr(10)>


<cfset arr_Lines[5]="| Station    ">

      <cfset str_CustText=STATION>
			<cfset i_Spaces=66-Len(STATION)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 

<cfset arr_Lines[5]=arr_Lines[5]&str_CustText&"|"&chr(13)&chr(10)>

<cfset arr_Lines[6]="| Sex        ">

      <cfset str_CustText=SEX>
			<cfset i_Spaces=3-Len(SEX)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 

<cfset arr_Lines[6]=arr_Lines[6]&str_CustText>			

			<cfset str_CustText="      DOB "&DateFormat(DOB,"DD/MM/YYYY")&" ">
			
<cfset arr_Lines[6]=arr_Lines[6]&str_CustText>				
			
			<cfset str_CustText="     Ethnic App "&ETHNIC_APP>
			<cfset i_Spaces=26-Len(ETHNIC_APP)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>			
			
<cfset arr_Lines[6]=arr_Lines[6]&str_CustText&"|"&chr(13)&chr(10)>		

<cfset arr_Lines[7]="| Home Address           ">

      <cfset str_CustText="">
			<cfset i_Spaces=54-Len("")>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 	
			
<cfset arr_Lines[7]=arr_Lines[7]&str_CustText&"|"&chr(13)&chr(10)>					

<cfset arr_Lines[8]="| Home Tel               ">

      <cfset str_CustText="">
			<cfset i_Spaces=17-Len("")>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 	
			
<cfset arr_Lines[8]=arr_Lines[8]&str_CustText>		

      <cfset str_CustText="Business Tel ">
			<cfset i_Spaces=24-Len("")>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 	
			
<cfset arr_Lines[8]=arr_Lines[8]&str_CustText&"|"&chr(13)&chr(10)>		

<cfset arr_Lines[9]="| Reason For Arrest   ">

<cfset str_CustText="">
    <cfif Len(ARREST_REASON_TEXT) GT 57>
		 <cfset str_CustText=str_CustText&Left(ARREST_REASON_TEXT,57)>
		<cfelse>
		 <cfset str_CustText=str_CustText&ARREST_REASON_TEXT>
			<cfset i_Spaces=57-Len(ARREST_REASON_TEXT)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[9]=arr_Lines[9]&str_CustText&"|"&chr(13)&chr(10)>				 	

<cfset arr_Lines[10]="| Place Of Arrest     ">

<cfset str_CustText="">
    <cfif Len(PLACE_OF_ARREST) GT 57>
		 <cfset str_CustText=str_CustText&Left(PLACE_OF_ARREST,57)>
		<cfelse>
		 <cfset str_CustText=str_CustText&PLACE_OF_ARREST>
			<cfset i_Spaces=57-Len(PLACE_OF_ARREST)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[10]=arr_Lines[10]&str_CustText&"|"&chr(13)&chr(10)>			

<cfset arr_Lines[11]="| Date/Time Of Arrest ">

<cfset str_CustText="">
 <cfset str_ArrTime=TimeFormat(Arrest_Time,"HH:MM")&" "&UCase(DateFormat(Arrest_Time,"DD/MM/YYYY DDD"))>
    <cfif Len(str_ArrTime) GT 57>
		 <cfset str_CustText=str_CustText&Left(str_ArrTime,57)>
		<cfelse>
		 <cfset str_CustText=str_CustText&str_ArrTime>
			<cfset i_Spaces=57-Len(str_ArrTime)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[11]=arr_Lines[11]&str_CustText&"|"&chr(13)&chr(10)>		

<cfset arr_Lines[12]="| Arr Force/Off/Stn   ">

<cfset str_CustText="">
    <cfif Len(AO_FORCE) GT 6>
		 <cfset str_CustText=str_CustText&Left(AO_FORCE,6)>
		<cfelse>
		 <cfset str_CustText=str_CustText&AO_FORCE>
			<cfset i_Spaces=6-Len(AO_FORCE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[12]=arr_Lines[12]&str_CustText>			

<cfset str_CustText="Badge No ">
<cfset str_AO=AO_BADGE&" "&AO_NAME>
    <cfif Len(str_AO) GT 25>
		 <cfset str_CustText=str_CustText&Left(str_AO,25)>
		<cfelse>
		 <cfset str_CustText=str_CustText&str_AO>
			<cfset i_Spaces=25-Len(str_AO)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[12]=arr_Lines[12]&str_CustText>					

<cfset str_CustText="Stn ">

    <cfif Len(AO_STATION) GT 13>
		 <cfset str_CustText=str_CustText&Left(AO_STATION,13)>
		<cfelse>
		 <cfset str_CustText=str_CustText&AO_STATION>
			<cfset i_Spaces=13-Len(AO_STATION)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[12]=arr_Lines[12]&str_CustText&"|"&chr(13)&chr(10)>	

<cfset arr_Lines[13]="| OIC Force/Off/Stn   ">

<cfset str_CustText="">
    <cfif Len(OIC_FORCE) GT 6>
		 <cfset str_CustText=str_CustText&Left(OIC_FORCE,6)>
		<cfelse>
		 <cfset str_CustText=str_CustText&OIC_FORCE>
			<cfset i_Spaces=6-Len(OIC_FORCE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[13]=arr_Lines[13]&str_CustText>			

<cfset str_CustText="Badge No ">
<cfset str_OIC=OIC_BADGE&" "&OIC_NAME>
    <cfif Len(str_OIC) GT 25>
		 <cfset str_CustText=str_CustText&Left(str_OIC,25)>
		<cfelse>
		 <cfset str_CustText=str_CustText&str_OIC>
			<cfset i_Spaces=25-Len(str_OIC)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[13]=arr_Lines[13]&str_CustText>					

<cfset str_CustText="Stn ">

    <cfif Len(OIC_STATION) GT 13>
		 <cfset str_CustText=str_CustText&Left(OIC_STATION,13)>
		<cfelse>
		 <cfset str_CustText=str_CustText&OIC_STATION>
			<cfset i_Spaces=13-Len(OIC_STATION)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[13]=arr_Lines[13]&str_CustText&"|"&chr(13)&chr(10)>	

<cfset arr_Lines[14]="| Original Cust No     ">

<cfset str_CustText="">
    <cfif Len(ORIG_CUSTODY) GT 19>
		 <cfset str_CustText=str_CustText&Left(ORIG_CUSTODY,19)>
		<cfelse>
		 <cfset str_CustText=str_CustText&ORIG_CUSTODY>
			<cfset i_Spaces=19-Len(ORIG_CUSTODY)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[14]=arr_Lines[14]&str_CustText>	

<cfset str_CustText="Time/Date Dept  ">
 <cfset str_DepTime=TimeFormat(DEPARTURE_TIME,"HH:MM")&" "&UCase(DateFormat(DEPARTURE_TIME,"DD/MM/YYYY DDD"))>
    <cfif Len(str_DepTime) GT 21>
		 <cfset str_CustText=str_CustText&Left(str_DepTime,21)>
		<cfelse>
		 <cfset str_CustText=str_CustText&str_DepTime>
			<cfset i_Spaces=21-Len(str_DepTime)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>

<cfset arr_Lines[14]=arr_Lines[14]&str_CustText&"|"&chr(13)&chr(10)>	

<cfset arr_Lines[15]="| Departure Reason    ">

<CFQUERY NAME="qry_CustodyDepReason" DATASOURCE="#Application.WarehouseDSN#">
 SELECT CD.*
 FROM   browser_owner.CUSTODY_DEPARTURES CD
 WHERE  CD.CUSTODY_REF='#custodyRef#'
</cfquery>

<cfif qry_CustodyDepReason.RecordCount GT 0>
 <cfset str_DepRes=qry_CustodyDepReason.REASON_FOR_DEPARTURE>
<cfelse>
 <cfset str_DepRes="">
</cfif>

<cfset str_CustText="">
    <cfif Len(str_DepRes) GT 57>
		 <cfset str_CustText=str_CustText&Left(str_DepRes,57)>
		<cfelse>
		 <cfset str_CustText=str_CustText&str_DepRes>
			<cfset i_Spaces=57-Len(str_DepRes)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[15]=arr_Lines[15]&str_CustText&"|"&chr(13)&chr(10)>			

<cfset arr_Lines[16]="| Canc/Answer Bail    ">

<cfset str_CustText="">
    <cfif Len(BAIL_ANSWERED) GT 3>
		 <cfset str_CustText=str_CustText&Left(BAIL_ANSWERED,3)>
		<cfelse>
		 <cfset str_CustText=str_CustText&BAIL_ANSWERED>
			<cfset i_Spaces=4-Len(BAIL_ANSWERED)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>		
		
<cfset arr_Lines[16]=arr_Lines[16]&str_CustText>			
		
<cfset str_CustText="Cancel Reason ">
    <cfif Len(BAIL_CANC_REASON) GT 38>
		 <cfset str_CustText=str_CustText&Left(BAIL_CANC_REASON,38)>
		<cfelse>
		 <cfset str_CustText=str_CustText&BAIL_CANC_REASON>
			<cfset i_Spaces=38-Len(BAIL_CANC_REASON)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_CustText=str_CustText&chr(32)>
			</cfloop>	 
		</cfif>				
		
<cfset arr_Lines[16]=arr_Lines[16]&str_CustText&" |"&chr(13)&chr(10)>			

<cfset arr_Lines[17]="+------------------------------------------------------------------------------+"&chr(13)&chr(10)>

</cfoutput>

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","","ALL")#</pre>
</cfoutput>