<!--- get all packages --->
<cfquery name="qry_Packages" datasource="#Application.DSN#">
SELECT PACKAGE_ID, DIVISION_ENTERING,DATE_GENERATED
FROM packages_owner.packages
WHERE PACKAGE_URN IS NULL
</cfquery>

<!--- loop round and based on year added and division create a serial no and urn --->
<cfloop query="qry_Packages">
 
  <cfset sYear=DateFormat(DATE_GENERATED,"YY")>

  <!--- get the biggest serial no based on year and division --->
  <cfquery name="qry_Serial" datasource="#Application.DSN#">
   SELECT MAX(SERIAL_NO) AS THIS_SERIAL
   FROM packages_owner.PACKAGES
   WHERE TO_CHAR(DATE_GENERATED,'YY')=<cfqueryparam value="#sYear#" cfsqltype="cf_sql_varchar">
   AND DIVISION_ENTERING=<cfqueryparam value="#DIVISION_ENTERING#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif Len(qry_Serial.THIS_SERIAL) IS 0>
   <cfset iSerial=1>
  <cfelse>
   <cfset iSerial=qry_Serial.THIS_SERIAL+1>
  </cfif>

  <cfset sSerial=iSerial>
  <!--- pad the serial no with 0's to make it 5 chars --->
  <cfloop from="1" to="#5-Len(iSerial)#" index="i">
	<cfset sSerial="0"&sSerial>
  </cfloop>

  <cfset sURN=DIVISION_ENTERING&"/"&sSerial&"/"&sYear>

  <!--- update the table with Serial, Year and URN --->
  <cfquery name="upd_Serial" datasource="#Application.DSN#">
   UPDATE packages_owner.packages
   SET		SERIAL_NO=<cfqueryparam value="#iSerial#" cfsqltype="cf_sql_integer">,
                PACKAGE_YEAR=<cfqueryparam value="#sYear#" cfsqltype="cf_sql_varchar">,
                PACKAGE_URN=<cfqueryparam value="#sURN#" cfsqltype="cf_sql_varchar">
   WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfoutput>Package ID #PACKAGE_ID# Has been given URN #sURN# <Br><br></cfoutput>

</cfloop>