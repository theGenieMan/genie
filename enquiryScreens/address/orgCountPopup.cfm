<cfquery name="qOrgData" datasource="#application.warehouseDSN#">
	SELECT   ORG_CODE,ORG_TYPE,NAME, TO_CHAR(RECORDED,'DD/MM/YYYY') AS DATE_REC
	FROM     browser_owner.GE_ADD_ORG a_org
	WHERE    a_org.PREMISE_KEY='#premiseKey#'
	AND      a_org.POST_CODE='#postcode#'
	ORDER BY a_org.RECORDED DESC, NAME	
</cfquery>	

<cfoutput>
<table width="400" class="dataTable genieData">
 <thead>
 	<tr>
 		<th class="table_title">Organisation</th>
		<th class="table_title">Rec</th>
 	</tr>
 </thead>	
 <tbody>
 	<cfset i=1>
	<cfloop query="qOrgData" startrow="1" endrow="10">
	<tr class="row_colour#i mod 2#">
		<td valign="top"><b>#NAME#</b></td>
		<td>#DATE_REC#</td>
	</tr>
	<cfset i++>
	</cfloop>
 </tbody>
</table>
</cfoutput>