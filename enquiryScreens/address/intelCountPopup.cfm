<cfquery name="qIntData" datasource="#application.warehouseDSN#">
  SELECT int.*
  FROM   browser_owner.INTELL_SEARCH int, browser_owner.INTELL_ADDS addr
  WHERE  addr.LOG_REF=int.LOG_REF
  AND    addr.POST_CODE='#postcode#'
  AND    addr.PREMISE_KEY='#premiseKey#'
  ORDER BY DATE_START DESC
</cfquery>	

<cfset str_Message="">
<cfloop query="qIntData">
 <cfif SECURITY_ACCESS_LEVEL LT Session.LoggedInUserLogAccess>
  <cfset str_Message="OTHER LOGS ARE RECORDED FOR WHICH YOU DO NOT HAVE ACCESS">
 </cfif>
</cfloop>

<cfoutput>
<div class="error_title">#str_Message#</div>
<table width="500" class="dataTable genieData">
 <thead>
 	<tr>
 		<th class="table_title">Log No</th>
		<th class="table_title">SAL</th>
		<th class="table_title">Indicator</th>
		<th class="table_title">Date</th>
 	</tr>
 </thead>	
 <tbody>
 	<cfset i=0>
	<cfloop query="qIntData" startrow="1" endrow="10">
	<cfif SECURITY_ACCESS_LEVEL GTE Session.LoggedInUserLogAccess>
	 <cfif i GT 0 AND i MOD 20 IS 0><cfbreak></cfif>		
	<tr class="row_colour#i mod 2#">
		<td valign="top">#LOG_REF#</td>
		<td valign="top">#SECURITY_ACCESS_LEVEL#</td>
		<td valign="top">#INDICATOR#</td>
		<td valign="top">#DateFormat(DATE_CREATED,"DD/MM/YYYY")#</td>
	</tr>
	<cfset i++>
	</cfif>
	
	</cfloop>
 </tbody>
</table>
</cfoutput>