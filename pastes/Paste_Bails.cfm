<!---

Module      : Paste_Bails.cfm

App         : Nominal Photo Searching

Purpose     : Delivers all Details for a bail in pastable to OIS format

Requires    : 

Author      : Nick Blackham

Date        : 28/11/2006

Revisions   : 

--->

<cfquery name="qry_BAILS" DATASOURCE="#Application.WarehouseDSN#">	
SELECT BAIL_TYPE AS BAIL_DESC, SUBSTR(STATUS,0,1) AS BAIL_ANSWERED, CUSTODY_REF,
       TO_CHAR(DATE_SET,'DD MON YYYY DY') AS DATE_SET, BAILED_FROM AS ISSUER,
	   BAILED_TO AS RECEIVER, TO_CHAR(BAILED_TO_DATE,'DD MON YYYY DY') AS DATE_ACTION,
	   BAIL_OFFICER AS BAIL_OFF, CANCELLATION_REASON
FROM   browser_owner.BAIL_SEARCH b
WHERE  b.bail_ref='#bailRef#'
</cfquery>		

<cfquery name="qry_BAILOFF" DATASOURCE="#Application.WarehouseDSN#">			
SELECT *
FROM   browser_owner.BAIL_DETAILS
WHERE  bail_ref='#bailRef#'
</cfquery>

<cfset str_Offence="">
<cfloop query="qry_BAILOFF">
 <cfset str_Offence=ListAppend(str_Offence,OFFENCE_DETAIL,'|')>
</cfloop>

<cfquery name="qry_BAILCONDS" DATASOURCE="#Application.WarehouseDSN#">			
SELECT *
FROM   browser_owner.BAIL_CONDITIONS
WHERE  bail_ref='#bailRef#'
</cfquery>

<cfset str_Conditions="">
<cfloop query="qry_BAILCONDS">
 <cfset str_Conditions=ListAppend(str_Conditions,CONDITION,'|')>
</cfloop>

<cfquery name="qry_NomDetails" datasource="#Application.WarehouseDSN#">
 SELECT NS.NOMINAL_REF||' '||
    	  REPLACE(REPLACE(LTRIM(
				RTRIM(ND.TITLE)||' '||
        RTRIM(NS.SURNAME_1)||DECODE(NS.SURNAME_2,NULL,'','-'||NS.SURNAME_2)||', '||
        RTRIM(INITCAP(FORENAME_1))||' '||
        RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ') Name,
				SEX,TO_CHAR(DATE_OF_BIRTH,'DD MON YYYY') AS DOB
 FROM   browser_owner.NOMINAL_SEARCH NS, browser_owner.NOMINAL_DETAILS nd
 WHERE  NS.NOMINAL_REF=ND.NOMINAL_REF(+)
 AND    ns.nominal_ref='#nominalRef#'				
</cfquery>

<cfset arr_Lines=ArrayNew(1)>

<cfoutput query="qry_Bails" maxrows="1">

<cfset arr_Lines[1]="+-- Nominals ------------------------------------------------------------+"&chr(13)&chr(10)>
<cfset arr_Lines[2]="| Nom Ref ">
       
			<cfset str_NomText=qry_NomDetails.Name>
			<cfif Len(str_NomText) GT 40>
			<cfset str_NomText=Left(str_NomText,40)> 
			<cfelse>
			<cfset i_Spaces=40-Len(qry_NomDetails.Name)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NomText=str_NomText&chr(32)>
			</cfloop>
			</cfif>

<cfset arr_Lines[2]=arr_Lines[2]&str_NomText&" Sex "&qry_NomDetails.Sex&" DOB "&qry_NomDetails.DOB&" |"&chr(13)&chr(10)>
<cfset arr_Lines[4]="++--- Bails ------------------------------------------------------------++"&chr(13)&chr(10)>
<cfset arr_Lines[5]=" | Bail Type ">

			<cfset str_BailText=BAIL_DESC>
			<cfset i_Spaces=35-Len(BAIL_DESC)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			
			<cfif LEN(BAIL_ANSWERED) GT 0>
			<cfset str_BailText=str_BailText&" Cancel/Answered Bail "&BAIL_ANSWERED&" |"&chr(13)&chr(10)>
			<cfelse>
			<cfset str_BailText=str_BailText&" Cancel/Answered Bail   | "&chr(13)&chr(10)>
			</cfif>			
			
<cfset arr_Lines[5]=arr_Lines[5]&str_BailText>

<cfset arr_Lines[6]=" | Custody Ref ">

			<cfset str_BailText=CUSTODY_REF>
			<cfset i_Spaces=56-Len(CUSTODY_REF)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			
<cfset arr_Lines[6]=arr_Lines[6]&str_BailText&" | "&chr(13)&chr(10)>			
<cfset arr_Lines[7]=" |                                                                      | "&chr(13)&chr(10)>

<cfset arr_Lines[8]=" | Bail By  Date             "&DATE_SET&"                            | "&chr(13)&chr(10)>


<cfset arr_Lines[9]=" |          Organisation     ">

			<cfset str_BailText=ISSUER>
			<cfif Len(str_BailText) GT 42>
			<cfset str_BailText=Left(str_BailText,42)> 
			<cfelse>
			<cfset i_Spaces=42-Len(str_BailText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			</cfif>
			
<cfset arr_Lines[9]=arr_Lines[9]&str_BailText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[10]=" |                                                                      |"&chr(13)&chr(10)>

<cfset arr_Lines[11]=" | Bail To  Date             "&DATE_ACTION&"                            | "&chr(13)&chr(10)>


<cfset arr_Lines[12]=" |          Organisation     ">

			<cfset str_BailText=RECEIVER>
			<cfif Len(str_BailText) GT 42>
			<cfset str_BailText=Left(str_BailText,42)> 
			<cfelse>
			<cfset i_Spaces=42-Len(str_BailText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			</cfif>
			
<cfset arr_Lines[12]=arr_Lines[12]&str_BailText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[13]=" |                                                                      | "&chr(13)&chr(10)>
<cfset arr_Lines[14]=" | Bail in connection with   ">

			<cfset str_BailText=Replace(str_Offence,"|",". ","ALL")>
			<cfif Len(str_BailText) GT 42>
			<cfset str_BailText=Left(str_BailText,42)> 
			<cfelse>
			<cfset i_Spaces=42-Len(str_BailText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			</cfif>

<cfset arr_Lines[14]=arr_Lines[14]&str_BailText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[15]=" |                                                                      | "&chr(13)&chr(10)>
<cfset arr_Lines[16]=" | Bailing Officer           ">

			<cfset str_BailText=BAIL_OFF>
			<cfset i_Spaces=42-Len(BAIL_OFF)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>

<cfset arr_Lines[16]=arr_Lines[16]&str_BailText&" | "&chr(13)&chr(10)>

<cfset arr_Lines[17]=" | Reason for Cancellation   ">

			<cfset str_BailText=CANCELLATION_REASON>
			<cfif Len(str_BailText) GT 42>
			<cfset str_BailText=Left(str_BailText,42)> 
			<cfelse>
			<cfset i_Spaces=42-Len(str_BailText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			</cfif>


<cfset arr_Lines[17]=arr_Lines[17]&str_BailText&" | "&chr(13)&chr(10)>
	
<cfset arr_Lines[18]=" ++--Applied Bail Conditions ------------------------------------------++ "&chr(13)&chr(10)>	
			
<cfif Len(str_Conditions) GT 0>
 <cfset str_Conditions=Replace(str_Conditions,"|",". ","ALL")>
 <!--- bail conditions max 5 lines, 66 characters a line --->
  
 <!--- how many lines have we got ? --->
 <cfset i_Lines=Int(Len(str_Conditions)/66)>

 <cfset i_ModLines=Len(str_Conditions) MOD 66>
 <cfif i_ModLines GT 0>
	<cfset i_Lines=i_Lines+1>
 </cfif>
 
 <cfif i_Lines GT 5>
  <cfset i_Lines=5>
 </cfif>

 <cfset lis_Lines="">
 <cfset i_Start=1>
 <cfloop index="z" from="1" to="#i_Lines#" step="1">
   <cfset i_End=z*66>
   <cfif i_End GT Len(str_Conditions)>
	 <cfset i_End=Len(str_Conditions)+1>
   </cfif>
   <cfset s_Line=Mid(str_Conditions,i_Start,i_End-i_Start)>
   <cfset lis_Lines=ListAppend(lis_Lines,s_Line,"|")>
   <cfset i_Start=z*66>
 </cfloop>
 
 <cfset i=19>

 <cfloop index="str_Line" delimiters="|" list="#lis_Lines#">

			<cfset str_BailText=str_Line>
			<cfif Len(str_BailText) GT 66>
			<cfset str_BailText=Left(str_BailText,66)> 
			<cfelse>
			<cfset i_Spaces=66-Len(str_BailText)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_BailText=str_BailText&chr(32)>
			</cfloop>
			</cfif>
			
  <cfset arr_Lines[i]="  | "&str_BailText&" |  "&chr(13)&chr(10)>			

  <cfset i=i+1>
 </cfloop>
 <cfset arr_Lines[i]="  +--------------------------------------------------------------------+  "&chr(13)&chr(10)>
<cfelse>			
			
<cfset arr_Lines[19]="  | None                                                               |  "&chr(13)&chr(10)>
<cfset arr_Lines[20]="  +--------------------------------------------------------------------+  "&chr(13)&chr(10)>

</cfif>

</cfoutput>

<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>#Replace(str_Text,"~","","ALL")#</pre>
</cfoutput>