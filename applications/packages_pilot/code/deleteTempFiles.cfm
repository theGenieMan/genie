<cfdirectory action="list" recurse="true" directory="\\svr20200\stepassets" name="myDir" filter="~*">

<!---
<cfdump var="#myDir#">
--->

<cfoutput>
<h3>STEP Temp File Deletion running #now()#</h3>

<p><b>#myDir.recordCount# files will be deleted</b></p>

<cfsetting requesttimeout="99999999">

<cfset i=1>

<cfloop query="myDir">

   <cffile action="delete" file="#Directory#\#Name#">
   Deleted #Directory#\#Name#<br>

 <cfset i=i+1>
</cfloop>

<cfdirectory action="list" recurse="true" directory="\\svr20200\stepassets" name="myDir">

<cfloop query="myDir">

   <!---
   <cffile action="delete" file="#Directory#\#Name#">--->
   <cfif TYPE IS "File" AND FindNoCase(".",NAME) IS 0>
	 <cfif Len(NAME) IS 8 and Right(NAME,2) IS "00">
	   <cffile action="delete" file="#Directory#\#Name#">
       Deleted #Directory#\#Name#<br>
	 </cfif>
   </cfif>

 <cfset i=i+1>
</cfloop>

<h3>STEP Temp File Deletion finished #now()#</h3>
</cfoutput>