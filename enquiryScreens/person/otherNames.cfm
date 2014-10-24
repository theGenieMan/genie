<!---

Module      : otherNames.cfm

App         : GENIE

Purpose     : Displays the Aliases for a nominal, this is only a fragment of code and is intended
              to be loaded into a jQuery dialog or popup

Requires    : 

Author      : Nick Blackham

Date        : 09/07/2014

Revisions   : 

--->


<!--- get all the primary nominal refs associated with this nominal. 
      in the case of a primary being passed through then no results 
	  will be returned, this is why the nominal ref passed in is
	  added to the list if it's a primary --->
	  
<cfset lis_NomRefAlias="">	  
<cfset lis_NomRefs="">
<!---

<cfif NAME_TYPE IS "P">
 <!--- primary name type only 1 nom ref to get aliases for --->
 <cfset lis_NomRefAlias=ListAppend(lis_NomRefAlias,"'"&NOM_REF&"'",",")>
<cfelse> --->
 <CFQUERY NAME = "qry_PrimaryNomRefs" DATASOURCE="#Application.WarehouseDSN#">
    SELECT nd.NOMINAL_REF AS NOMINAL_REF	
	FROM   browser_owner.Nominal_Links nl, browser_owner.Nominal_Details nd
	WHERE  ((nl.NOMINAL_REF_2='#NOM_REF#' AND nl.NOMINAL_REF_1=nd.NOMINAL_REF) OR (nl.NOMINAL_REF_1='#NOM_REF#' AND nl.NOMINAL_REF_2=nd.NOMINAL_REF))
	AND    (nl.NOMINAL_REF_1=nd.NOMINAL_REF OR nl.NOMINAL_REF_2=nd.NOMINAL_REF)
 </CFQUERY>


 <cfloop query="qry_PrimaryNomRefs">
  <cfset lis_NomRefAlias=ListAppend(lis_NomRefAlias,"'"&NOMINAL_REF&"'",",")>
 </cfloop>
<!---
</cfif> --->

<cfif ListLen(lis_NomRefAlias,",") GT 0>
	
<CFQUERY NAME = "qry_NomAlias" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">	
SELECT NOMINAL_REF_2
FROM   browser_owner.NOMINAL_LINKS
WHERE  NOMINAL_REF_1 IN (#PreserveSingleQuotes(lis_NomRefAlias)#)
</cfquery>

<cfloop query="qry_NomAlias">
 <cfset lis_NomRefs=ListAppend(lis_NomRefs,"'"&NOMINAL_REF_2&"'",",")>
</cfloop>

<CFQUERY NAME = "qry_NomAlias" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">	
SELECT NOMINAL_REF_1
FROM   browser_owner.NOMINAL_LINKS
WHERE  NOMINAL_REF_2 IN (#PreserveSingleQuotes(lis_NomRefAlias)#)
</cfquery>

<cfloop query="qry_NomAlias">
 <cfset lis_NomRefs=ListAppend(lis_NomRefs,"'"&NOMINAL_REF_1&"'",",")>
</cfloop>
	
<cfif ListLen(lis_NomRefs,",") GT 0>	
<!--- get the address details again --->
 <CFQUERY NAME = "qry_OtherNames" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
	select ns.NOMINAL_REF AS NOMINAL_REF,
    	   REPLACE(REPLACE(LTRIM(
				 RTRIM(ND.TITLE)||' '||
         RTRIM(NS.SURNAME_1)||DECODE(NS.SURNAME_2,NULL,'','-'||NS.SURNAME_2)||', '||
         RTRIM(INITCAP(FORENAME_1))||' '||
         RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ')
		     || DECODE(FAMILIAR_NAME,'','', ' (Nick ' || FAMILIAR_NAME || ')')
				 || DECODE(MAIDEN_NAME,NULL,'',' (Nee ' || MAIDEN_NAME || ')') Name,
		     SEX,
				 TO_CHAR(DATE_OF_BIRTH,'DD/MM/YYYY') AS DOB,
				 NAME_TYPE,
				 ETHNICITY_16 AS EA_APP,
				 PLACE_OF_BIRTH,
				 POST_TOWN, FORENAME_1, SURNAME_1
	FROM   browser_owner.Nominal_Search ns, browser_owner.Nominal_Details nd
	WHERE  (ns.NOMINAL_REF IN (#PreserveSingleQuotes(lis_NomRefs)#) OR ns.NOMINAL_REF IN (#PreserveSingleQuotes(lis_NomRefAlias)#))
	AND    ns.NOMINAL_REF=nd.NOMINAL_REF
	ORDER BY DECODE(NAME_TYPE,'P',0,1), SURNAME_1, SURNAME_2, FORENAME_1, FORENAME_2
 </cfquery>
</cfif>
</cfif>

<cfoutput>
<div class="content">

 <h3 align="center">#NAME# - #NOM_REF#</h3>

  <cfif ListLen(lis_NomRefs) GT 0>
  <cfif qry_OtherNames.RecordCount GT 0>
  <table width="100%" class='genieData'>
  	<thead>
	 <tr>
		<th>Nominal Ref</th>
		<th>Name</th>
		<th>Sex</th>	
		<th>DOB</th>
		<th>NT</th>	
		<th>Birth Place</th>	
		<th>Post Town</th>						
	 </tr>
	</thead>
	 <cfset i=1>
	<tbody>
	 <cfloop query="qry_OtherNames">	 	 
      <tr class="row_colour#i mod 2#">
		<cfif NAME_TYPE IS "P">
		<td valign="top">				
		<b><a href='#NOMINAL_REF#' class='genieNominal'>#NOMINAL_REF#</a></b>		
		<td valign="top">
		<b><a href='#NOMINAL_REF#' class='genieNominal'>#NAME#</a></b>
		</td>
		<cfelse>
		<td valign="top">#NOMINAL_REF#</td>
		<td valign="top">#NAME#</td>
		</cfif>	
		<td valign="top">#SEX#</td>
		<td valign="top">#DOB#</td>
		<td valign="top">#NAME_TYPE#</td>		
		<td valign="top">#PLACE_OF_BIRTH#</td>		
		<td valign="top">#POST_TOWN#</td>																	
	  </tr>	
	 <cfset i=i+1>
	 </cfloop>
	 </tbody>
	</table>
 <cfelse>
 <h3 align="center">Other Names Not Available</h3>
 </cfif>
 <cfelse>
 <h3 align="center">Other Names Not Available</h3>
 </cfif>
</cfoutput>

</div>
