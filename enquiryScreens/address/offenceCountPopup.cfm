<cfquery name="qOffData" datasource="#application.warehouseDSN#">
	SELECT ORG_CODE||'/'||SERIAL_NO||'/'||DECODE(LENGTH(YEAR),1, '0' || YEAR, YEAR) AS CRIME_NO,
           DECODE(O.LAST_COMMITTED,'', TO_CHAR(O.FIRST_COMMITTED,'DD/MM/YYYY HH24:MI'),
           TO_CHAR(O.FIRST_COMMITTED,'DD/MM/YYYY HH24:MI') || ' and ' ||    TO_CHAR(O.LAST_COMMITTED,'DD/MM/YYYY HH24:MI')) Committed,	       
		   REC_TITLE, INCIDENT_NO,
           O.CRIME_REF, TO_CHAR(O.CREATED_DATE,'YYYY') AS REC_YEAR,
		   TO_CHAR(O.CREATED_DATE,'MM') AS REC_MON, TO_CHAR(O.CREATED_DATE,'DD') AS REC_DAY		   
	FROM   browser_owner.OFFENCE_SEARCH o
	WHERE  PREMISE_KEY='#premiseKey#'
	AND    POST_CODE='#postcode#'
	ORDER BY FIRST_COMMITTED DESC
</cfquery>	

<cfoutput>
<table width="400" class="dataTable genieData">
 <thead>
 	<tr>
 		<th class="table_title">Crime No</th>
		<th class="table_title">Details</th>
 	</tr>
 </thead>	
 <tbody>
 	<cfset i=1>
	<cfloop query="qOffData" startrow="1" endrow="10">
	<tr class="row_colour#i mod 2#">
		<td valign="top"><b>#CRIME_NO#</b></td>
		<td>#REC_TITLE#<br>#COMMITTED#</td>
	</tr>
	<cfset i++>
	</cfloop>
 </tbody>
</table>
</cfoutput>