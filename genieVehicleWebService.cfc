<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.lis_Months="JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC">
<cfset variables.lis_MonthNos="01,02,03,04,05,06,07,08,09,10,11,12">
<cfset variables.wMidsSysCodes="COCO">
<cfset variables.wMidsSysReplaces="OASIS">
<cfset variables.crimeClass="genieCrimeLink">
<cfset variables.nominalClass="genieNominal">
<cfset variables.caseClass="genieCaseLink">
<cfset variables.crashClass="genieCrashLink">
<cfset variables.incidentClass="genieOISLink">
<cfset variables.anprSearchClass="genieANPRSearch">
<cfset variables.vehicleIntelClass="genieVehicleIntelLink">

<cfsavecontent variable="variables.wMerVehicleTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
    <tr>
	  <th valign="top" width="8%">VRM</th>		
	  <th valign="top" width="24%">Vehicle Details</th>
	  <th valign="top" width="40%">Reason</th>
	  <th valign="top" width="10%">From</th>
	  <th valign="top" width="10%">To</th>		 
	  <th valign="top" width="8%">Intel</th>	  		 		 		 		 	  	  	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.wMerVehicleTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.wMerVehicleTableRow">
<tr>
	<td valign="top"><b>%VRM%</b></a></b></td>
	<td valign="top">%VEH_DETAILS%</td>
	<td valign="top">%INFORMATION%<br>%TEXT%</td>
	<td valign="top">%DATE_FROM%</td>
	<td valign="top">%DATE_TO%</td>
	<td valign="top">%HAS_INTEL%</td>		
</tr>	
</cfsavecontent>

    <cffunction name="validateVehicleEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a person search">
	 <cfset var adArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">	 	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 	<cfif Len(adArgs.vrm) IS 0
		  AND Len(adArgs.manufacturer) IS 0
		  AND Len(adArgs.model) IS 0
		  AND Len(adArgs.body_type) IS 0
		  AND Len(adArgs.shade) IS 0
		  AND Len(adArgs.primary_col) IS 0		
		  AND Len(adArgs.secondary_col) IS 0
		  AND Len(adArgs.text) IS 0>	  
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data in at least one of the fields below ","|")>		
		<cfelse>
			<cfif adArgs.wMids IS "Y">
				<cfif   Len(adArgs.vrm) IS 0>
				   <cfset validation.valid=false>
		    	   <cfset validation.errors=ListAppend(validation.errors,"West Mids Search requires VRM","|")>						
				</cfif>		  	
			</cfif>
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

	<cffunction name="doWMerVehicleEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="West Mercia Address search">  	  	  	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>	  
	  <cfset var searchFields = ArrayNew(1)>
  	  <cfset var keyPair = StructNew()>	
	  <cfset var vehicleResults = "">
 	  <cfset var vehicleXmlResults="">
	  <cfset var thisVehicle=""> 		  
	  <cfset var iVehCount=0>
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 	     	  
	  <cfset var returnTable=''>
	
		<cfset vehicleResults = application.genieService.doWestMerciaVehicleSearch(searchTerms=searchData)>  
		
		<cfif searchData.resultType IS "XML">
		
		<cfelseif searchData.resultType IS "html">						
				<cfset returnData = doWMerVehicleTable(vehicleResults)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>
		
   <cffunction name="doWMerVehicleTable" access="private" output="false" returntype="string">
  	<cfargument name="vehicles" required="true" type="query" hint="query of addresses returned">	  
	
	<cfset var returnTable="">
	<cfset var thisVehicle="">
	<Cfset var sInfo="">
		 
	   <!--- if no results then no results table --->
	   <cfif vehicles.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.wMerVehicleTableHeader)>
		
	
		<cfloop query="vehicles">		  	  	
			<cfset thisVehicle=duplicate(variables.wMerVehicleTableRow)>
			
			<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%VRM%',"<a href='"&VRM&"' class='"&variables.anprSearchClass&"'>"&VRM&"</a>","ALL")>						
			<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%VEH_DETAILS%',VEH_DETAILS,"ALL")>
			<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%TEXT%',TEXT,"ALL")>						
			<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%DATE_FROM%',DateFormat(DATE_FROM,"DD/MM/YYYY"),"ALL")>
			<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%DATE_TO%',DateFormat(DATE_TO,"DD/MM/YYYY"),"ALL")>
			<cfif hasIntel IS "YES">
				<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%HAS_INTEL%',"<a href='"&VEH_REF&"' vrm='"&VRM&"' class='"&variables.vehicleIntelClass&"'>"&HASINTEL&"</a>","ALL")>
			<cfelse>
				<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%HAS_INTEL%','',"ALL")>
			</cfif>
			
			<cfset sInfo="">
			<cfif TYPE IS "NOMINAL">			
				 <cfif Len(REASON) GT 0>
				 	 <cfset sInfo=REASON&": ">
				 <cfelseif Len(USAGE) GT 0>
				 	 <Cfset sInfo=USAGE&": ">
				 </cfif>				 
				 <cfset sInfo &= "<a href='"&REF&"' class='"&variables.nominalClass&"'>"&REF_TEXT&"</a>">
			<cfelseif TYPE IS "CRIME">
				 <cfset sInfo &= USAGE & ": <a href='"&REF&"' class='"&variables.crimeClass&"'>"&REF_TEXT&"</a>">				 
			<cfelseif TYPE IS "CASE">				
				 <cfset sInfo &= "CASE: <a href='"&REF&"' class='"&variables.caseClass&"' caseType='NSPIS'>"&REF_TEXT&"</a>">
				 <cfif Len(REF2) GT 0>
				 	<cfset sInfo &= "<br>">
					<cfset sInfo &= "NOMINAL: <a href='"&REF2&"' class='"&variables.nominalClass&"'>"&REF_TEXT2&"</a>"> 
				 </cfif>
			<cfelseif TYPE IS "CRASH">
				 <cfset sInfo &= "RTC: <a href='"&REF&"' class='"&variables.crashClass&"' crashDate='"&DateFormat(DATE_FROM,"DD/MM/YYYY")&"'>"&REF_TEXT&"</a>">
				 <cfif Len(REF2) GT 0>
				   <cfset sInfo &= "<br>">
				   <cfset sInfo &= "INCIDENT: <a href='"&INSERT(' ',REF2,5)&"' class='"&variables.incidentClass&"'>"&INSERT(' ',REF2,5)&"</a>">
				 </cfif>
			<cfelseif TYPE IS "ORG">
				 <cfset sInfo &= "ORG: "&REF_TEXT>				    				  				 				    				  				 
			</cfif>
			
			<cfset thisVehicle=ReplaceNoCase(thisVehicle,'%INFORMATION%',sInfo,"ALL")>
						
			<cfset returnTable &= thisVehicle>			  
		</cfloop>
		
	    <Cfset returnTable &=duplicate(variables.wMerVehicleTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
  <cffunction name="doWestMidsVehicleEnquiry" output="false" returntype="any" access="remote"  returnformat="plain">
	
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