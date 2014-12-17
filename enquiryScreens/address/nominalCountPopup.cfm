<cflog file="ncp" type="information" text="#now()#" > 

<cfquery name="qNCData" datasource="#application.warehouseDSN#">
SELECT distinct GAN.NOMINAL_REF, 
       REPLACE(REPLACE(LTRIM(
                                      RTRIM(ND.TITLE)||' '||
                                                    RTRIM(NS.SURNAME_1)||DECODE(NS.SURNAME_2,NULL,'','-'||NS.SURNAME_2)||', '||
                                                    RTRIM(INITCAP(FORENAME_1))||' '||
                                                    RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ')
                                                        || DECODE(FAMILIAR_NAME,'','', ' (Nick ' || FAMILIAR_NAME || ')')
                                                            || DECODE(MAIDEN_NAME,NULL,'',' (Nee ' || MAIDEN_NAME || ')') AS FULL_NAME
FROM browser_owner.ge_add_nominals gan, browser_owner.ge_addresses gadd, browser_owner.nominal_search ns, browser_owner.nominal_details nd
where (GAN.POST_CODE=gadd.POST_CODE AND GAN.PREMISE_KEY=gadd.PREMISE_KEY)
AND gadd.POST_CODE='#postcode#'
AND gadd.PREMISE_KEY='#premisekey#'
and gan.NOMINAL_REF=ns.NOMINAL_REF
and gan.NOMINAL_REF=nd.NOMINAL_REF
</cfquery>	

<cfoutput>
<table class="dataTable genieData">
 <thead>
 	<tr>
 		<th class="table_title">Ref</th>
		<th class="table_title">Name</th>
 	</tr>
 </thead>	
 <tbody>
 	<cfset i=1>
	<cfloop query="qNCData" startrow="1" endrow="10">
	<tr class="row_colour#i mod 2#">
		<td>#NOMINAL_REF#</td>
		<td><b>#FULL_NAME#</b></td>
	</tr>
	<cfset i++>
	</cfloop>
 </tbody>
</table>
</cfoutput>