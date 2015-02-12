<cfsilent>
<cfquery name="qry_Sections" datasource="#Application.DSN#" dbtype="ODBC">
SELECT SECTION_CODE, SECTION_NAME
FROM   packages_owner.SECTION
WHERE  SECTION_DIV = '#url.thisDIV#'
OR     SECTION_DIV = 'O'
ORDER BY DECODE(SUBSTR(SECTION_CODE,0,1),'#url.thisDiv#',1,99),SECTION_DIV, SECTION_CODE
</cfquery>
</cfsilent>
<cfoutput><select name="frm_SelSection" #iif(not isDefined('url.dashboard'),de('class="mandatory"'),De(''))# id="frm_SelSection" #iif(isDefined('url.dashboard'),de('onChange="updateSector()"'),De(''))#>
 <option value="">-- Select Section--</option>
  <cfloop query="qry_Sections">
   	 <option value="#Section_Code#" <cfif url.currentSection IS Section_Code>selected</cfif>>#Section_Name#</option>
  </cfloop>
 </select>
</cfoutput> 	