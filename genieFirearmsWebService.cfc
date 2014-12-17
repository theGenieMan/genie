
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.nominalClass="genieFirearmsNominal">

<cfsavecontent variable="variables.firearmsTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="37%">Person</th>
		<th width="13%">Certificate No</th>
		<th width="12%">Serial No</th>		
		<th width="38%">Weapon</th>		
	 </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.firearmsTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.firearmsTableRow">
    <tr>
		<td valign="top" class="fullName"><a href="%personRef%" class="%nominalClass%">%fullName%</a></td>
		<td valign="top">%CERTIFICATE%</td>		
		<td valign="top">%SERIAL%</td>		
		<td valign="top">%WEAPON%</td>				  						  				
    </tr>	
</cfsavecontent>

  <cffunction name="validateFirearmsEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a Firearms enquiry">
	 <cfset var fArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var fItem="">
	 <cfset var fDataFound=false>	
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#fArgs#" item="fItem">
	 	 <cfif Len(StructFind(fArgs,fItem)) GT 0>
		   <cfset fDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not fDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>				
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doFirearmsEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do firearms enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">		    
		  
		<cfset enquiryResults = application.genieService.doFirearmsSerialCertif(searchTerms=searchData)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doFirearmsEnquiryTable(firearms=enquiryResults)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doFirearmsEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="firearms" required="true" type="query" hint="query of property objects to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">	  
	
	<cfset var returnTable="">
	<cfset var thisNom="">
	<cfset var iNom="">  
    <cfset var item="">
	
	   <!--- if no results then no results table --->
	   <cfif firearms.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.firearmsTableHeader)>
		
		<cfloop query="firearms">
		 	  	
			<cfset thisNom=duplicate(variables.firearmsTableRow)>
			
			<cfset thisNom=ReplaceNoCase(thisNom,'%nominalClass%',variables.nominalClass,"ALL")>								
			<cfset thisNom=ReplaceNoCase(thisNom,'%personRef%',PERSON_URN,"ALL")>
			<cfset thisNom=ReplaceNoCase(thisNom,'%fullName%','#FORENAMES# #SURNAME#',"ALL")>
			<cfset thisNom=ReplaceNoCase(thisNom,'%SERIAL%',SERIAL_NO,"ALL")>
			<cfset thisNom=ReplaceNoCase(thisNom,'%CERTIFICATE%',CERT_NO,"ALL")>
			<cfset thisNom=ReplaceNoCase(thisNom,'%WEAPON%','#MANUFACTURER# #CALIBRE# #WEAPON_ACTION# #WEAPON_TYPE#',"ALL")>
			
			<cfset returnTable &= thisNom>
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.firearmsTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

</cfcomponent>