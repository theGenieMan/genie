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
<cfset variables.custodyClass="genieCustodyLink">
<cfset variables.incidentClass="genieOISLink">
<cfset variables.TelephoneIntelClass="genieTelephoneIntelLink">
<cfset variables.nflmsClass="genieFirearmsNominal">

<cfsavecontent variable="variables.wMerTelephoneTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="5%">Own/Use</th>
		<th width="5%">Type</th>		
		<th width="15%">Tel No/Elec Comms</th>		
		<th width="8%">Nom Ref</th>				  
		<th width="25%">Name/Organisation</th>
		<th width="25%">Notes/Source</th>		
		<th width="7%">From</th>
		<th width="7%">To</th>
		<th width="10%">Intel?</th>		  		 		 		 		 	  	  	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.wMerTelephoneTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.wMerTelephoneTableRow">
<tr>
		<td valign="top">%OWNER_USER%</td>
		<td valign="top">%PHONE_TYPE%</td>		
		<td valign="top">%TEL_NO%%ELEC_COMMS%</td>		
		<td valign="top">%NOMINAL_REF_LINK%</td>				  
		<td valign="top">%NOMINAL_NAME_LINK%%ORGANISATION%</td>
		<td valign="top">%NOTE%%SOURCE_INFO%</td>		
		<td valign="top">%DATE_FROM%</td>
		<td valign="top">%DATE_TO%</td>
		<td valign="top">%HAS_INTEL%</td>			
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.firearmsTelephoneTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
   <tr>
		<th>Person Ref</th>
		<th>Name</th>		
		<th>DOB</th>
		<th>PNC ID</th>
   </tr>
  </thead>
  <tbody>
</cfsavecontent>

<cfsavecontent variable="variables.firearmsTelephoneTableRow">
<tr>
		<td valign="top">%PERSON_REF%</td>
		<td valign="top">%PERSON_NAME%</td>		
		<td valign="top">%DOB%</td>		
		<td valign="top">%PNCID%</td>				  		
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.htcuTelephoneTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
   <tr>
		<th>Phone Number</th>
		<th>Submission URN</th>		
		<th>Date of Examination</th>
		<th>Examiner</th>
   </tr>
  </thead>
  <tbody>
</cfsavecontent>

<cfsavecontent variable="variables.htcuTelephoneTableRow">
<tr>
		<td valign="top">%PHONE_NO%</td>
		<td valign="top">%HTCU_URN_LINK%</td>		
		<td valign="top">%DATE_EXAM%</td>		
		<td valign="top">%EXAMINER%</td>				  		
</tr>	
</cfsavecontent>

   <cffunction name="validateTelephoneEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a person search">
	 <cfset var telArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var telItem="">
	 <cfset var telDataFound=false>		 	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#telArgs#" item="telItem">
	   <!--- ignore the non user data fields --->
	   <cfif ListFindNoCase('wMids,firearms,htcu,resultType',telItem) IS 0>	 
	 	 <cfif Len(StructFind(telArgs,telItem)) GT 0>
		   <cfset telDataFound=true>
		 </cfif>
	   </cfif>
	 </cfloop>
	 
	 	<cfif not telDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>		
		<cfelse>
			<cfif telArgs.wMids IS "Y">
				<cfif   Len(telArgs.tel_no) IS 0>
				   <cfset validation.valid=false>
		    	   <cfset validation.errors=ListAppend(validation.errors,"West Mids Search requires Number","|")>						
				</cfif>		  	
			</cfif>
			<cfif telArgs.firearms IS "Y">
				<cfif   Len(telArgs.tel_no) IS 0>
				   <cfset validation.valid=false>
		    	   <cfset validation.errors=ListAppend(validation.errors,"Firearms Search requires Number","|")>						
				</cfif>		  	
			</cfif>
			<cfif telArgs.htcu IS "Y">
				<cfif   Len(telArgs.tel_no) IS 0>
				   <cfset validation.valid=false>
		    	   <cfset validation.errors=ListAppend(validation.errors,"HTCU Search requires Number","|")>						
				</cfif>		  	
			</cfif>
				<cfif Len(telArgs.date_from1) GT 0>
					<cfif not LSIsDate(telArgs.date_from1)>
						<cfset validation.valid=false>
			    		<cfset validation.errors=ListAppend(validation.errors,"Created Between/On `#telArgs.date_from1#` is not a valid date.","|")>	
					</cfif>
				</cfif>
				<cfif Len(telArgs.date_from2) GT 0>
					<cfif not LSIsDate(telArgs.date_from2)>
						<cfset validation.valid=false>
			    		<cfset validation.errors=ListAppend(validation.errors,"Created To `#telArgs.date_from2#` is not a valid date.","|")>					
					</cfif>
				</cfif>
				<cfif Len(telArgs.date_to1) GT 0>
					<cfif not LSIsDate(telArgs.date_to1)>
						<cfset validation.valid=false>
			    		<cfset validation.errors=ListAppend(validation.errors,"Terminated Between/On `#telArgs.date_to1#` is not a valid date.","|")>	
					</cfif>
				</cfif>
				<cfif Len(telArgs.date_to2) GT 0>
					<cfif not LSIsDate(telArgs.date_to2)>
						<cfset validation.valid=false>
			    		<cfset validation.errors=ListAppend(validation.errors,"Terminated Date To `#telArgs.date_to2#` is not a valid date.","|")>					
					</cfif>
				</cfif>		
			</cfif>	
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

   <cffunction name="doWMerTelephoneEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="GENIE Telephone search">  	  	  	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>	  
	  <cfset var searchFields = ArrayNew(1)>
  	  <cfset var keyPair = StructNew()>	
	  <cfset var telephoneResults = "">
 	  <cfset var telephoneXmlResults="">
	  <cfset var thisTelephone=""> 		  
	  <cfset var iTelCount=0>
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 	     	  
	  <cfset var returnTable=''>
	  <cfset var resultType=searchData.resultType>
	
	  <!--- remove the none search related elements from the search terms --->
	  <cfset structDelete(searchData,'wMids')>
	  <cfset structDelete(searchData,'firearms')>  
	  <cfset structDelete(searchData,'htcu')>
	  <cfset structDelete(searchData,'resultType')>
	
		<cfset telephoneResults = application.genieService.doWestMerciaTelephoneSearch(searchTerms=searchData)>  
		
		<cfif resultType IS "XML">
		
		<cfelseif resultType IS "html">			
			<cfset returnData = doWMerTelephoneTable(TelephoneResults)>			 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>
		
   <cffunction name="doWMerTelephoneTable" access="private" output="false" returntype="string">
  	<cfargument name="telephones" required="true" type="query" hint="query of telephones returned">	  
	
	<cfset var returnTable="">
	<cfset var thisTelephone="">
	<cfset var sInfo="">
		 
	   <!--- if no results then no results table --->
	   <cfif telephones.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.wMerTelephoneTableHeader)>
		
	
		<cfloop query="telephones">	
			<cfset sInfo=''>	  	  	
			<cfset thisTelephone=duplicate(variables.wMerTelephoneTableRow)>
			
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%OWNER_USER%',OWNER_USER,"ALL")>						
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%PHONE_TYPE%',PHONE_TYPE,"ALL")>
			<cfif TEL_NO IS NOT ELEC_COMMS>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%TEL_NO%','<strong>'&TEL_NO&'</strong>',"ALL")>
			</cfif>
			<cfif Len(ELEC_COMMS) GT 0>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%ELEC_COMMS%',iif(TEL_NO IS NOT ELEC_COMMS,de('<br>'),de(''))&ELEC_COMMS,"ALL")>
			<cfelse>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%ELEC_COMMS%','',"ALL")>
			</cfif>
			<cfif Len(NOMINAL_REF) GT 0>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%NOMINAL_REF_LINK%','<a href="'&NOMINAL_REF&'" class="genieNominal">'&NOMINAL_REF&'</a>',"ALL")>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%NOMINAL_NAME_LINK%','<a href="'&NOMINAL_REF&'" class="genieNominal">'&NOMINAL_NAME&'</a>',"ALL")>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%ORGANISATION%','',"ALL")>
			<cfelse>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%NOMINAL_REF_LINK%','',"ALL")>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%NOMINAL_NAME_LINK%','',"ALL")>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%ORGANISATION%',ORGANISATION,"ALL")>
			</cfif>
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%NOTE%',NOTE&iif(Len(NOTE) GT 0,de('<Br>'),de('')),"ALL")>	
			<cfif PHONE_TYPE IS "CALLER OIS">					
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%DATE_FROM%',DateFormat(DATE_FROM,"DD/MM/YYYY")&" "&TimeFormat(DATE_FROM,"HH:mm"),"ALL")>
			<cfelse>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%DATE_FROM%',DateFormat(DATE_FROM,"DD/MM/YYYY"),"ALL")>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%DATE_TO%',DateFormat(DATE_TO,"DD/MM/YYYY"),"ALL")>
			</cfif>
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%DATE_TO%',DateFormat(DATE_TO,"DD/MM/YYYY"),"ALL")>
			<cfif HAS_INTEL IS "YES">
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%HAS_INTEL%',"<a href='"&TEL_NO&"' source='"&SOURCE&"' sourceId='"&SOURCE_ID&"' class='"&variables.TelephoneIntelClass&"'>"&HAS_INTEL&"</a>","ALL")>
			<cfelse>
				<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%HAS_INTEL%','',"ALL")>
			</cfif>
			
			<cfif Len(CUSTODY_REF) GT 0>
				<cfset sInfo&=iif(Len(sInfo) GT 0,de('<br>'),de(''))&"CUSTODY: <a href='#CUSTODY_REF#' custodyType='NSPIS' class='#variables.custodyClass#'>#CUSTODY_REF#</a>">
			</cfif>
			
			<cfif Len(CASE_REF) GT 0>
				<cfset sInfo&=iif(Len(sInfo) GT 0,de('<br>'),de(''))&"CASE: <a href='#CASE_REF#' custodyType='NSPIS' class='#variables.caseClass#'>#CASE_REF#</a>">
			</cfif>
			
			<cfif Len(OIS_LOG) GT 0>
				<cfset sInfo&=iif(Len(sInfo) GT 0,de('<br>'),de(''))&"OIS LOG: <a href='#OIS_LOG#' class='#variables.incidentClass#'>#OIS_LOG#</a>">
			</cfif>
			
			<cfif Len(CRIME_REF) GT 0>
				<cfset sInfo&=iif(Len(sInfo) GT 0,de('<br>'),de(''))&"CRIME: <a href='#CRIME_NO#' class='#variables.crimeClass#'>#CRIME_NO#</a>">
			</cfif>
			
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%SOURCE_INFO%',sInfo,"ALL")>
						
			<cfset returnTable &= thisTelephone>			  
		</cfloop>
		
	    <Cfset returnTable &=duplicate(variables.wMerTelephoneTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
   <cffunction name="doWestMidsTelephoneEnquiry" output="false" returntype="any" access="remote"  returnformat="plain">
	
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

   <cffunction name="doFirearmsTelephoneEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="GENIE Telephone search">  	  	  	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>	  
	  <cfset var searchFields = ArrayNew(1)>
	  <cfset var telephoneResults = "">
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 	     	  
	  <cfset var resultType=searchData.resultType>
	    
		<cfset telephoneResults = application.genieService.doWestMerciaFirearmsTelephoneSearch(telephoneNumber=searchData.TEL_NO)>  
		
		<cfif resultType IS "XML">
		
		<cfelseif resultType IS "html">			
			<cfset returnData = doFirearmsTelephoneTable(TelephoneResults)>			 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

   <cffunction name="doFirearmsTelephoneTable" access="private" output="false" returntype="string">
  	<cfargument name="telephones" required="true" type="query" hint="query of telephones returned">	  
	
	<cfset var returnTable="">
	<cfset var thisTelephone="">
	<cfset var sInfo="">
		 
	   <!--- if no results then no results table --->
	   <cfif telephones.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.firearmsTelephoneTableHeader)>
		
	
		<cfloop query="telephones">	
			<cfset sInfo=''>	  	  	
			<cfset thisTelephone=duplicate(variables.firearmsTelephoneTableRow)>
			
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%PERSON_REF%','<a href="'&PERSON_URN&'" class="'&variables.nflmsClass&'">'&PERSON_URN&'</a>',"ALL")>						
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%PERSON_NAME%','<a href="'&PERSON_URN&'" class="'&variables.nflmsClass&'">'&FORENAMES&' '&SURNAME&'</a>',"ALL")>
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%DOB%',DateFormat(DOB,"DD/MM/YYYY"),"ALL")>
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%PNCID%',PNCID,"ALL")>
			
						
			<cfset returnTable &= thisTelephone>			  
		</cfloop>
		
	    <Cfset returnTable &=duplicate(variables.wMerTelephoneTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

   <cffunction name="doHTCUTelephoneEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="GENIE Telephone search">  	  	  	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>	  
	  <cfset var searchFields = ArrayNew(1)>
	  <cfset var telephoneResults = "">
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 	     	  
	  <cfset var resultType=searchData.resultType>
	    
		<cfset telephoneResults = application.genieService.doHTCUSearch(telNo=searchData.TEL_NO)>  
		
		<cfif resultType IS "XML">
		
		<cfelseif resultType IS "html">			
			<cfset returnData = doHTCUTelephoneTable(TelephoneResults)>			 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>
   
   <cffunction name="doHTCUTelephoneTable" access="private" output="false" returntype="string">
  	<cfargument name="telephones" required="true" type="query" hint="query of telephones returned">	  
	
	<cfset var returnTable="">
	<cfset var thisTelephone="">
	<cfset var sInfo="">
		 
	   <!--- if no results then no results table --->
	   <cfif telephones.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.htcuTelephoneTableHeader)>
		
	
		<cfloop query="telephones">	  	
			<cfset thisTelephone=duplicate(variables.htcuTelephoneTableRow)>
			
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%PHONE_NO%','<b>'&PHONE_NO&'</b>',"ALL")>						
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%HTCU_URN_LINK%','<a href="/redirector/redirector.cfm?type=htcuMobile&ref=#MB_URN#" target="_blank" class="genieHTCULink">#MB_URN#</a></b>',"ALL")>
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%DATE_EXAM%',DateFormat(EXAM_DATE,'DD/MM/YYYY'),"ALL")>
			<cfset thisTelephone=ReplaceNoCase(thisTelephone,'%EXAMINER%',EXAMINER,"ALL")>
						
			<cfset returnTable &= thisTelephone>			  
		</cfloop>
		
	    <Cfset returnTable &=duplicate(variables.wMerTelephoneTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
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