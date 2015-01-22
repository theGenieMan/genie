
<!---

Module      : Paste_Warnings.cfm

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

<CFQUERY NAME = "qry_NominalWarnings" DATASOURCE="#Application.WarehouseDSN#">
 select wsc_code, wsc_desc as description, ws_note, TO_CHAR(date_marked,'DD/MM/YYYY') AS DATE_MARKED_F
 from browser_owner.ge_warnings w
 where nominal_ref='#nominalRef#'
 order by date_marked desc
</CFQUERY>

<cfset i_Pages=qry_NominalWarnings.RecordCount/3>
<cfif qry_NominalWarnings.RecordCount MOD 3 GT 0>
 <cfset i_Pages=i_Pages+1>
</cfif>

<cfloop index="i_ThisPage" from="1" to="#i_Pages#">

<cfset arr_Lines=ArrayNew(1)>

<cfset arr_Lines[1]="Warwickshire Police and West Mercia Police - GENIE"&chr(13)&chr(10)>
<cfset arr_Lines[2]="Nominal Warnings"&chr(13)&chr(10)>
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
<cfset arr_Lines[7]="++-- Warning Signals ---------------------------------------------------------++"&chr(13)&chr(10)>

<cfset i_Line="8">

<cfif i_ThisPage IS 1>
 <cfset i_Start=1>
 <cfif qry_NominalWarnings.RecordCount LT 3>
  <cfset i_End=qry_NominalWarnings.RecordCount>
 <cfelse>
  <cfset i_End=3>
 </cfif>
<cfelse>
 <cfset i_Start=i_End+1>
 <cfif qry_NominalWarnings.RecordCount LT i_Start+2>
  <cfset i_End=qry_NominalWarnings.RecordCount>
 <cfelse>
 <cfset i_End=i_Start+2>
 </cfif>
</cfif>

<cfloop query="qry_NominalWarnings" startrow="#i_Start#" endrow="#i_End#">
                       
<cfset arr_Lines[i_Line]=" | Signal Code ">
    
		<cfset str_NominalText="">
    <cfset str_NominalText=str_NominalText&WSC_CODE&" ">
		
		<cfif Len(DESCRIPTION) GT 52>
		 <cfset str_NominalText=str_NominalText&Left(DESCRIPTION,52)>
		<cfelse>
		 <cfset str_NominalText=str_NominalText&DESCRIPTION>
			<cfset i_Spaces=52-Len(DESCRIPTION)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 
		</cfif>
  
    <cfset str_NominalText=str_NominalText&"        |"&chr(13)&chr(10)>
  
    <cfset arr_lines[i_Line]=arr_Lines[i_Line]&str_NominalText>
		
		<cfset i_Line=i_Line+1>
		<cfoutput>
		<cfset arr_Lines[i_Line]=" | Notes       ">
		<cfif Len(WS_NOTE) GT 60>
		 <cfset str_stop="NO">
		 <cfset str_Note=WS_NOTE>
		 
		 <cfset i_NoteLines=0>
		 <cfloop condition="str_stop IS 'NO'">
		  <cfset i_NoteLines=i_NoteLines+1>
		  <cfif Len(str_Note) GT 60>
			<cfset str_NominalText="">
 		    <cfset i_Space=FindNoCase(" ",WS_NOTE,50)>
	        <cfif i_Space IS 0>
 		    <cfset i_Space=FindNoCase(" ",WS_NOTE,40)>	        
	        </cfif>
	        <cfif i_Space IS 0>
 		    <cfset i_Space=FindNoCase(" ",WS_NOTE,30)>	        
	        </cfif>
	        <cfif i_Space IS 0>
 		    <cfset i_Space=FindNoCase(" ",WS_NOTE,20)>	        
	        </cfif>	      	
        	<cfif i_Space IS 0>
 		    <cfset i_Space=FindNoCase(" ",WS_NOTE,10)>	        
	        </cfif>		                
		    <cfset str_Text=Trim(Left(str_Note,i_Space))>
		    <cfif i_Space LT Len(str_Note)>
			<cfset str_Note=Trim(Right(str_Note,Len(str_Note)-(i_Space)))>
			 </cfif>
			<cfset str_NominalText=str_NominalText&str_Text>
            <cfset i_Spaces=60-Len(str_Text)>
			
			 <cfloop index="z" from="1" to="#i_Spaces#" step="1">
			  <cfset str_NominalText=str_NominalText&chr(32)>
			 </cfloop>	 	
			 
			 <cfset arr_lines[i_Line]=arr_Lines[i_Line]&str_NominalText&"   |"&chr(13)&chr(10)>				
			 <cfif i_NoteLines LT 2>
			 <cfset i_Line=i_Line+1> 
			 <cfset arr_lines[i_Line]=" |             ">
			 </cfif>
		 <cfelse>
			 <cfset arr_lines[i_Line]=" |             ">
			 <cfset str_NominalText=str_Note>
             <cfset i_Spaces=60-Len(str_NOTE)>
			
			 <cfloop index="z" from="1" to="#i_Spaces#" step="1">
			  <cfset str_NominalText=str_NominalText&chr(32)>
			 </cfloop>	 	
			 
			 <cfset arr_lines[i_Line]=arr_Lines[i_Line]&str_NominalText&"   |"&chr(13)&chr(10)>	
			 <cfset i_Line=i_line+1>			 
			 <cfset str_Stop="YES">
		 </cfif>
			<cfif i_NoteLines GTE 2>
			  <cfset str_Stop="YES">
			</cfif>
		 </cfloop>
		<cfelse>
		  <!--- <cfset i_Line=i_Line+1> --->
			<cfset str_NominalText=WS_NOTE>
      <cfset i_Spaces=60-Len(WS_NOTE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset str_NominalText=str_NominalText&chr(32)>
			</cfloop>	 	
			<cfset arr_lines[i_Line]=arr_Lines[i_Line]&str_NominalText&"   |"&chr(13)&chr(10)>	
			<cfset i_Line=i_line+1>	
		</cfif>
		</cfoutput>
	<cfset i_Line=i_Line+1>
    
	<cfset arr_Lines[i_Line]=" | Date Marked "&DATE_MARKED_F&"                                                     |"&chr(13)&chr(10)>
	<cfset i_Line=i_Line+1>	
    
    <cfset arr_Lines[i_Line]=" |                                                                            | "&chr(13)&chr(10)>	
	<cfset i_Line=i_Line+1>
</cfloop>
<!---



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
</cfloop> ---->
	<cfset i_Line=i_Line+1>	
<cfset arr_Lines[i_line]=" +----------------------------------------------------------------------------+ "&chr(13)&chr(10)>
	<cfset i_Line=i_Line+1>	
<cfset arr_Lines[i_line]=" END PAGE #i_ThisPage# "&chr(13)&chr(10)>


<cfset str_Text=ArrayToList(arr_Lines,"~")>

<cfoutput>
<pre>
#Replace(str_Text,"~","","ALL")#
</pre>
</cfoutput>

</cfloop>