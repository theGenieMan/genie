<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.lis_Months="JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC">
<cfset variables.lis_MonthNos="01,02,03,04,05,06,07,08,09,10,11,12">
<cfset variables.wMidsSysCodes="COCO">
<cfset variables.wMidsSysReplaces="OASIS">
<cfset variables.crimeClass="genieCrime">
<cfset variables.nominalClass="genieNominal">
<cfset variables.addressClass="genieAddressLink">
<cfset variables.addressNomHoverClass="genieAddressNomHover">
<cfset variables.addressOffenceHoverClass="genieAddressOffenceHover">
<cfset variables.addressOrgHoverClass="genieAddressOrgHover">
<cfset variables.addressIntelHoverClass="genieAddressIntelHover">
<cfset variables.addressMapClass="genieAddressMap">
<cfset variables.addressSNTClass="genieAddressSNT">
<cfset variables.googleLink="https://maps.google.com/?q=">

<cfsavecontent variable="variables.wMerAddressTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
    <tr>
	  <th valign="top" width="70%">Address</th>		
	  <th valign="top" width="8%">Nominals</th>
	  <th valign="top" width="8%">Offences</th>
	  <th valign="top" width="8%">Orgs</th>
	  <th valign="top" width="8%">Intel</th>		 
	  <th valign="top" width="3%">SNT</th>
	  <th valign="top" width="3%">Map</th>		 		 		 		 	  	  	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.wMerAddressTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.wMerAddressTableRow">
<tr id="%%PREMISE_KEY%%POST_CODE%">
	<td valign="top"><b><a href="%PREMISE_KEY%%POST_CODE%" premiseKey="%PREMISE_KEY%" postCode="%POST_CODE%" class="%addressClass%"><b>%FULL_ADDRESS%</b></a></b></td>
	<td valign="top" align="center"><b><a href="%PREMISE_KEY%%POST_CODE%" premiseKey="%PREMISE_KEY%" postCode="%POST_CODE%" class="%addressNomHoverClass%">%NOMINAL_COUNT%</a></b></td>
	<td valign="top" align="center"><b><a href="%PREMISE_KEY%%POST_CODE%" premiseKey="%PREMISE_KEY%" postCode="%POST_CODE%" class="%addressOffenceHoverClass%">%OFFENCE_COUNT%</a></b></td>
	<td valign="top" align="center"><b><a href="%PREMISE_KEY%%POST_CODE%" premiseKey="%PREMISE_KEY%" postCode="%POST_CODE%" class="%addressOrgHoverClass%">%ORG_COUNT%</a></b></td>
	<td valign="top" align="center"><b><a href="%PREMISE_KEY%%POST_CODE%" premiseKey="%PREMISE_KEY%" postCode="%POST_CODE%" class="%addressIntelHoverClass%">%INTEL_COUNT%</a></b></td>
	<td valign="top"><b><a href="%PREMISE_KEY%%POST_CODE%" class="%addressSNTClass%">%LPA%</a></b></td>
	<td valign="top">%SEARCH_ADDRESS%</td>	
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.searchAddressLink">
<b><a href="%GOOGLE_LINK%%ADDRESS_DATA%" class="%addressMapClass%" target="_blank">Map</a></b>
</cfsavecontent>	

<cfsavecontent variable="variables.wMerFirearmsAddressTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
    <tr>
	  <th valign="top" width="65%">Address</th>		
	  <th valign="top" width="12%">Tel No</th>
	  <th valign="top" width="23%">Name(s)</th>		 		 		 		 	  	  	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.wMerFirearmsAddressTableRow">
<tr>
	<td valign="top"><b>%ADDRESS%</b></td>
	<td valign="top">%TEL_NO%</td>
	<td valign="top"><b>%PERSON_DATA%</b></td>	
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.wMerFirearmsNominal">
<a href="%PERSON_URN%" class="genieFirearmsNominal">%NOMINAL_NAME%</a>
</cfsavecontent>

   <cffunction name="validateAddressEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a person search">
	 <cfset var adArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">	 	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 	<cfif Len(adArgs.post_code) IS 0
		  AND Len(adArgs.building_name) IS 0
		  AND Len(adArgs.building_number) IS 0
		  AND Len(adArgs.part_id) IS 0
		  AND Len(adArgs.street_1) IS 0
		  AND Len(adArgs.locality) IS 0		
		  AND Len(adArgs.town) IS 0
		  AND Len(adArgs.county) IS 0>	  
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data in at least one of the fields below ","|")>		
		<cfelse>
			<cfif adArgs.wMids IS "Y">
				<cfif   Len(adArgs.post_code) IS 0
		  			AND Len(adArgs.building_number) IS 0
		  			AND Len(adArgs.part_id) IS 0
					AND Len(adArgs.street_1) IS 0>
				   <cfset validation.valid=false>
		    	   <cfset validation.errors=ListAppend(validation.errors,"West Mids Search requires one of Postcode, Premise No, Flat No or Street","|")>						
				</cfif>		  	
			</cfif>
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

   <cffunction name="doWMerAddressEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="West Mercia Address search">  	  	  	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>
	  <cfset var nominalXml="">
	  <cfset var searchFields = ArrayNew(1)>
  	  <cfset var keyPair = StructNew()>	
	  <cfset var westMerResults = "">
 	  <cfset var addressXmlResults="">
	  <cfset var thisAddress=""> 		  
	  <cfset var iAddrCount=0>
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 	     	  
	  <cfset var returnTable=''>
	
		<cfset addressResults = application.genieService.doWestMerciaAddressSearch(searchTerms=searchData)>  
		
		<cfif searchData.resultType IS "XML">
		
		<cfelseif searchData.resultType IS "html">						
				<cfset returnData = doWMerAddressTable(addressResults)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>
		
   <cffunction name="doWMerAddressTable" access="private" output="false" returntype="string">
  	<cfargument name="addresses" required="true" type="query" hint="query of addresses returned">	  
	
	<cfset var returnTable="">
	<cfset var thisAddress="">
	<cfset var thisGoogleSearch="">
		 
	   <!--- if no results then no results table --->
	   <cfif addresses.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.wMerAddressTableHeader)>
		
	
		<cfloop query="addresses">		  	  	
			<cfset thisAddress=duplicate(variables.wMerAddressTableRow)>
			<cfset thisGoogleSearch=duplicate(variables.searchAddressLink)>
			
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressClass%',variables.addressClass,"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressNomHoverClass%',iif(NOMINAL_COUNT GT 0,de(variables.addressNomHoverClass),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressOffenceHoverClass%',iif(OFFENCE_COUNT GT 0,de(variables.addressOffenceHoverClass),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressOrgHoverClass%',iif(ORG_COUNT GT 0,de(variables.addressOrgHoverClass),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressIntelHoverClass%',iif(INTEL_COUNT GT 0,de(variables.addressIntelHoverClass),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressMapClass%',variables.addressMapClass,"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%addressSNTClass%',variables.addressSNTClass,"ALL")>
						
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%FULL_ADDRESS%',ADDRESS,"ALL")>			
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%NOMINAL_COUNT%',iif(NOMINAL_COUNT GT 0,de(NOMINAL_COUNT),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%OFFENCE_COUNT%',iif(OFFENCE_COUNT GT 0,de(OFFENCE_COUNT),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%ORG_COUNT%',iif(ORG_COUNT GT 0,de(ORG_COUNT),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%INTEL_COUNT%',iif(INTEL_COUNT GT 0,de(INTEL_COUNT),de('')),"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%LPA%',LPA,"ALL")>
			
			<cfif Len(POST_CODE) GT 0 AND POST_CODE IS NOT "*">
				<cfset thisGoogleSearch = ReplaceNoCase(thisGoogleSearch,'%GOOGLE_LINK%',variables.googleLink)>
				<cfset thisGoogleSearch = ReplaceNoCase(thisGoogleSearch,'%ADDRESS_DATA%','#BUILDING_NUMBER# #STREET_1# #TOWN# #POST_CODE#')>
				<cfset thisGoogleSearch = ReplaceNoCase(thisGoogleSearch,'%addressMapClass%',variables.addressMapClass,"ALL")>
				<cfset thisAddress=ReplaceNoCase(thisAddress,'%SEARCH_ADDRESS%',thisGoogleSearch)>
			<cfelse>
				<cfset thisAddress=ReplaceNoCase(thisAddress,'%SEARCH_ADDRESS%','',"ALL")>
			</cfif>			
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%PREMISE_KEY%',PREMISE_KEY,"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%POST_CODE%',POST_CODE,"ALL")>						
						
			<cfset returnTable &= thisAddress>			  
		</cfloop>
		
	    <Cfset returnTable &=duplicate(variables.wMerAddressTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
   <cffunction name="doWMerFirearmsAddressEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="West Mercia NFLMS Firearms Address search">  	  	  	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
 	  <cfset var addressXmlResults="">
	  <cfset var thisAddress=""> 		  
	  <cfset var iAddrCount=0>
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 	     	  
	  <cfset var returnData=''>
	  <cfset var addressResults=''>
	
		<cfset addressResults = application.genieService.doWestMerciaAddressFirearmsSearch(searchTerms=searchData, searchType='addressEnquiry')>  
		
		<cfif searchData.resultType IS "XML">
		
		<cfelseif searchData.resultType IS "html">						
			<cfset returnData = doWMerFirearmsAddressTable(addressResults)>		 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>   

   <cffunction name="doWMerFirearmsAddressTable" access="private" output="false" returntype="string">
  	<cfargument name="addrStruct" required="true" type="struct" hint="struct 2  queries query of addresses returned and nominals at them">	  
	
	<cfset var returnTable="">
	<cfset var thisAddress="">
	<cfset var thisNominal="">
	<cfset var qFNominal="">
	<cfset var addrNominals="">
		 
	   <!--- if no results then no results table --->
	   <cfif addrStruct.qAddress.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.wMerFirearmsAddressTableHeader)>

		<cfloop query="addrStruct.qAddress">		  	  	
			<cfset thisAddress=duplicate(variables.wMerFirearmsAddressTableRow)>
						
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%ADDRESS%',ADDRESS,"ALL")>			
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%TEL_NO%',TEL_NO,"ALL")>
			
			<cfquery name="qFNominal" dbtype="query">
			 SELECT *
			 FROM   addrStruct.qPeople	 
			 WHERE  PERSON_URN=<cfqueryparam value="#PERSON_URN#" cfsqltype="cf_sql_varchar">
			</cfquery>  
			
			<cfset addrNominals=''>
			<cfloop query="qFNominal">
				<cfset thisNominal=duplicate(variables.wMerFirearmsNominal)>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%PERSON_URN%',PERSON_URN,"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%NOMINAL_NAME%',FORENAMES&" "&SURNAME,"ALL")>
				<cfset addrNominals=ListAppend(addrNominals,thisNominal,"~")>
			</cfloop>   		
			
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%PERSON_DATA%', Replace(addrNominals,"~","<br>","ALL"),"ALL")>
						
			<cfset returnTable &= thisAddress>			  
		</cfloop>
		
	    <Cfset returnTable &=duplicate(variables.wMerAddressTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

    <cffunction name="doFNominalTable" access="private" output="false" returntype="string">
  	<cfargument name="nominalQuery" required="true" type="query" hint="query of nominals to format into a firearms table">
	
	<cfset var returnTable="">
	<cfset var thisNominal="">  
	
		<cfset returnTable  =duplicate(variables.fNominalTableHeader)>
		<cfloop query="nominalQuery">		  	  	
			<cfset thisNominal=duplicate(variables.fNominalTableRow)>			
			<cfif Len(PHOTO_URL) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',variables.fPhotoDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',"","ALL")>
			</cfif>											
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%personRef%',PERSON_URN,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%fullName%',FORENAMES & " " & SURNAME,"ALL")>								
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%DOB%',LSDateFormat(DOB,"DD/MM/YYYY"),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%PNC%',PNCID,"ALL")>
			<cfif Len(DOB) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',getAge(LSDateFormat(DOB,"DD/MM/YYYY")),"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',"","ALL")>
			</cfif>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','firearmsNominal',"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoUrl%',PHOTO_URL,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoTitle%',PERSON_URN&" "&SURNAME,"ALL")>
											
			<cfset returnTable &= thisNominal>			  
		</cfloop>				
	    <Cfset returnTable &=duplicate(variables.fNominalTableFooter)>	
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
    <cffunction name="doWestMidsPersonEnquiry" output="false" returntype="any" access="remote"  returnformat="plain">
	
		<cfset var return = StructNew()>
		<cfset var westMidsResults = "">
		<cfset var westMidsHTML = "">
		<cfset var sDob = "">
		<cfset var sDobPart = "">
		<cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
		<cfset var auditData=createAuditStructure(searchData)>
		<cfset var searchXml = "<risp:surname>$surname$</risp:surname><risp:forenames>$forename$</risp:forenames><risp:dob>$dob$</risp:dob><risp:cro/><risp:gender>$gender$</risp:gender><risp:pncid/><risp:maiden_name>$maidenname$</risp:maiden_name><risp:agefrom>$agefrom$</risp:agefrom><risp:ageto>$ageto$</risp:ageto><risp:place_of_birth>$pob$</risp:place_of_birth><risp:postal_town>$postal$</risp:postal_town><risp:fuzzy_name>Y</risp:fuzzy_name>">
	
		<cfset searchXml = Replace(searchXml, '$surname$', searchData.surname1)>
		<cfset searchXml = Replace(searchXml, '$forename$', searchData.forename1)>
	
		<!--- dob, we need to see if all fields are filled if so full dob and no part
		      otherwise part dob and no full --->
		<cfif Len(searchData.dobDay) GT 0 AND Len(searchData.dobMonth) GT 0 AND Len(searchData.dobYear) GT 0>
			<!--- full dob --->
			<cfset sDob = searchData.dobDay & "/" & searchData.dobMonth & "/" & searchData.dobYear>
			<cfset searchXml = Replace(searchXml, '$dob$', sDob)>
		<cfelse>
			<cfif Len(searchData.dobYear) GT 0>
			
				<cfset sDobPart = searchData.dobYear>
				<cfset sDobPart = Replace(sDobPart, "%%", "%")>
				<cfset searchXml = Replace(searchXml, '$dob$', sDobPart)>
			</cfif>
			<cfif Len(searchData.dobDay) IS 0 AND Len(searchData.dobMonth) IS 0 AND Len(searchData.dobYear) IS 0>
				<cfset searchXml = Replace(searchXml, '$dob$', '')>
			</cfif>
		</cfif>
	
		<cfset searchXml = Replace(searchXml, '$gender$', 
		                           iif(Len(searchData.sex) IS 0, de('U'), de(searchData.sex)))>
		<cfset searchXml = Replace(searchXml, '$maidenname$', searchData.maiden)>
		<cfset searchXml = Replace(searchXml, '$pob$', searchData.pob)>
		<cfset searchXml = Replace(searchXml, '$postal$', searchData.pTown)>
		<cfset searchXml = Replace(searchXml, '$agefrom$', searchData.ageFrom)>
		<cfset searchXml = Replace(searchXml, '$ageto$', searchData.ageTo)>
		
		<cfset westMidsResults = application.genieService.doWestMidsPersonSearch(searchTerms=searchXml,
																				 userId=auditData.enquiryUser,
																				 terminalId=auditData.terminalId,
																				 sessionId=auditData.sessionId, 		                                                                         
																				 fromWebService='Y',
																				 wsAudit=auditData)>
	
	    <cflog file="geniePersonWS" type="information" text="xxx#searchData.wMidsOrder#xxx" />
		<cfset westMidsNominalsGrouped = application.genieService.doWestMidsNominalGrouping(nominals=westMidsResults.nominals, 
		                                                                                    group=searchData.wMidsOrder)>
	
		<cfset westMidsHTML = formatWestMidsResults(westMidsNominalsGrouped, searchData.wMidsOrder)>
	
		<cfreturn westMidsHTML>
	
	</cffunction>  

	<cffunction name="formatWestMidsResults" output="false" returntype="any" access="private"
	            hint="formats the west mids results for display">
		<cfargument name="qWestMidsResults" type="any" required="true" 
		            hint="west mids results to be formatted"/>
		<cfargument name="westMidsOrder" type="string" required="true" 
		            hint="how the west mids data should be ordered options name,force,system"/>
	
		<cfset var returnHTML = "">
		<cfset var iNom = 1>
		<cfset var qMatches = "">
	
		<cfif qWestMidsResults.distinctQuery.recordCount IS 0>
			<cfset returnHTML = "<p><b>Your Search Returned No Results</b></p>">
		<cfelse>
		
			<cfloop query="arguments.qWestMidsResults.distinctQuery">
			
				<cfif arguments.westMidsOrder IS "name">
					<cfset returnHTML &= "<h3>#FIRSTNAME# #SURNAME# #DOB#</h3>">
					<cfquery name="qMatches" dbtype="query">
						SELECT *
						 FROM arguments.qWestMidsResults.fullquery
						 WHERE firstname='#FIRSTNAME#'
						 AND surname ='#SURNAME#'
						 AND dob ='#DOB#'
					</cfquery>
				<cfelseif arguments.westMidsOrder IS "system">
					<cfset returnHTML &= "<h3>#APP_REF#</h3>">
					<cfquery name="qMatches" dbtype="query">
						SELECT *
						 FROM arguments.qWestMidsResults.fullquery
						 WHERE app_ref=<cfqueryparam value="#app_REF#" cfsqltype="cf_sql_varchar">
						ORDER BY force_ref
					</cfquery>
				<cfelseif arguments.westMidsOrder IS "force">
					<cfset returnHTML &= "<h3>#FORCE_REF#</h3>">
					<cfquery name="qMatches" dbtype="query">
						SELECT *
						 FROM arguments.qWestMidsResults.fullquery
						 WHERE force_ref=<cfqueryparam value="#Force_REF#" cfsqltype="cf_sql_varchar">
						ORDER BY force_ref, app_ref
					</cfquery>
				</cfif>
				<cfset returnHTML &= variables.wMidsTableHeader>
			
				<cfset iNom = 1>
				<cfloop query="qMatches">
					<cfset checkBoxLink = "#app_ref##Replace(Replace(sys_ref,"/","","ALL"),":","","ALL")##force_ref#">
					
					<cfset thisRow=Duplicate(variables.wMidsTableRow)>
					<cfset thisRow=ReplaceNoCase(thisRow,'%DISPLAY_FORCE%',DISPLAY_FORCE,"ALL")>
					<cfset thisRow=ReplaceNoCase(thisRow,'%APP_REF%',ReplaceList(APP_REF, variables.wMidsSysCodes, variables.wMidsSysReplaces) & chr(13) & chr(10),"ALL")>					
					
					<cfif APP_REF IS NOT "FLINT" and APP_REF IS NOT "BOF2">
					<cfset thisRow=ReplaceNoCase(thisRow,'%NOM_LINK%',variables.wMidsHref,"ALL")>
					<cfset thisRow=ReplaceNoCase(thisRow,'%nominalHref%','href="#APP_REF#|#SYS_REF#|#FORCE_REF#|#Nominal_Ref#|PERSON"',"ALL")>
					<cfset thisRow=ReplaceNoCase(thisRow,'%REFERENCE%',NOMINAL_REF,"ALL")>
					<cfelse>
					<cfset thisRow=ReplaceNoCase(thisRow,'%NOM_LINK%',NOMINAL_REF,"ALL")>
					</cfif>
					
				
					<cfif RISP_PHOTO_EXISTS IS "Y">
	  					<cfset thisRow=ReplaceNoCase(thisRow,'%NOM_PHOTO%',variables.fPhotoDiv,"ALL")>
					<cfelse>
					    <cfset thisRow=ReplaceNoCase(thisRow,'%NOM_PHOTO%','',"ALL")>
					</cfif>
					<cfset thisRow=ReplaceNoCase(thisRow,'%photoUrl%',RISP_PHOTO,"ALL")>
					<cfset thisRow=ReplaceNoCase(thisRow,'%photoTitle%',NOMINAL_REF & " " & REPLACE(SURNAME, "'", "", "ALL"),"ALL")>					
					<cfset thisRow=ReplaceNoCase(thisRow,'%NOM_NAME%',FIRSTNAME & " " & SURNAME,"ALL")> 
					<cfset thisRow=ReplaceNoCase(thisRow,'%NOM_DOB%',DOB,"ALL")>
					<cfset returnHTML &= thisRow>
					
				</cfloop>
				
				
				<cfset returnHTML &= variables.wMidsTableFooter>
				
			</cfloop>
		</cfif>
	
	   <cfreturn returnHTML>
	
	</cffunction>
  
  

   
</cfcomponent>