<cfquery name="qHRResults" datasource="#application.warehouseDSN#">
SELECT  FULL_NAME,EMAIL_ADDRESS,DIVISION,LOCATION
FROM    common_owner.HR_DETAILS_ALLIANCE
WHERE   LAST_NAME LIKE <cfqueryparam value="#UCase(url.searchValue)#" cfsqltype="cf_sql_varchar">
OR      SUBSTR(COLLAR,2,LENGTH(COLLAR)-1) = <cfqueryparam value="#url.searchValue#" cfsqltype="cf_sql_varchar">
ORDER BY LAST_NAME,OFFICIAL_FIRST_NAME, DIVISION
</cfquery>
<cfoutput>
<cfif qHRResults.recordCount GT 0>
	#qHRResults.recordCount# Results Match #url.searchValue#<br>
	<select id="hrResults" size="6" multiple>
		<cfloop query="qHRResults">
			<option value="#EMAIL_ADDRESS#">#FULL_NAME#</option>
		</cfloop>
	</select>
<cfelse>
	0 Results Match #url.searchValue#
</cfif> 	
</cfoutput>