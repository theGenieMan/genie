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
			<!---
			<cfif telArgs.firearms IS "Y">
				<cfif   Len(telArgs.tel_no) IS 0>
				   <cfset validation.valid=false>
		    	   <cfset validation.errors=ListAppend(validation.errors,"Firearms Search requires Number","|")>						
				</cfif>		  	
			</cfif>
			--->
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
	  <cfset structDelete(searchData,'enquiryUser')>
	  <cfset structDelete(searchData,'enquiryUserName')>
	  <cfset structDelete(searchData,'enquiryUserDept')>
	  <cfset structDelete(searchData,'requestFor')>
	  <cfset structDelete(searchData,'reasonCode')>  
	  <cfset structDelete(searchData,'reasonText')>
	  <cfset structDelete(searchData,'sessionId')>  
	  <cfset structDelete(searchData,'terminalId')>    
	
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
				<cfset sInfo&=iif(Len(sInfo) GT 0,de('<br>'),de(''))&"CASE: <a href='#CASE_REF#' caseType='NSPIS' class='#variables.caseClass#'>#CASE_REF#</a>">
			</cfif>
			
			<cfif Len(OIS_LOG) GT 0>
				<cfset sInfo&=iif(Len(sInfo) GT 0,de('<br>'),de(''))&"OIS LOG: <a href='#OIS_LOG#' class='#variables.incidentClass#'>#OIS_LOG#</a>">
			</cfif>
			
			<cfif Len(CRIME_NO)>					
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
		<cfset var searchXml = "<risp:telno>$telno$</risp:telno>">
	
		<cfset searchXml = Replace(searchXml, '$telno$', searchData.tel_no)>		
		
		<cfset westMidsResults = application.genieService.doWestMidsTelephoneSearch(searchTerms=searchXml,
																				 userId=auditData.enquiryUser,
																				 terminalId=auditData.terminalId,
																				 sessionId=auditData.sessionId, 		                                                                         
																				 fromWebService='Y',
																				 wsAudit=auditData)>
		<cfif westMidsResults.searchOK>       
			<cfset westMidsHTML = formatWestMidsResults(westMidsResults.telephones, westMidsResults.overflow)>
		<cfelse>
			<cfset westMidsHTML =  "<h4 align='center'>The West Midlands search did not complete successfully</h4>">
			<cfset westMidsHTML &= "<p align='center'>The Error Code is : <b>"&westMidsResults.errorText&"</b><br><br>">
			<cfset westMidsHTML &= "If the error code is 408 Request Time-out this means that search at the West Midlands end ">
			<cfset westMidsHTML &= "did not respond within #Ceiling(application.wMidsTimeout/60)# minutes. You may need to refine your search as broad searches can ">
			<cfset westMidsHTML &= "lead to long running requests which have an adverse effect on GENIE performance.</p>">
			
			<cfmail   to="nick.blackham@westmercia.pnn.police.uk"
					from="genie@westmercia.pnn.police.uk"
					subject="GENIE - West Mids Telephone Unsuccessful"
					type="html">
				<html>
					<head>
						<style>
							body { 
								font-family:Arial;
								font-size:11pt
							}						
						</style>						
					</head>
					<body>
						<h4>Error Code: #westMidsResults.errorText#</h4>
						<p>
							<b>User Id : #auditData.enquiryUser#</b><br>
							<b>Search Xml : 
								<pre>#HTMLEditFormat(searchXml)#</pre>
							</b>
						</p>
					</body>
				</html>			
 		    </cfmail>		
	   	</cfif>
	
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
		<cfargument name="telephones" type="any" required="true" 
		            hint="west mids results to be formatted"/>		
		<cfargument name="overflow" type="boolean" required="false" 
		            hint="has the west mids data breached it's 500 record limit" default="false" />		            
	
		<cfset var returnHTML = "">
		<cfset var iTel = 1>
		<cfset var thisTel = "">
		
	
		<cfif arrayLen(telephones) IS 0>
			<cfset returnHTML = "<p><b>Your Search Returned No Results</b></p>">
		<cfelse>
			 <cfoutput>
			    <cfsavecontent variable="thisTel">
					<cfif arguments.overflow>
						<cfset returnHTML = "<h4 align='center'>Your Search Returned &gt; 500 results. Only the first 500 are being shown</h4>">
					</cfif>					
					<div class="telephoneResult">
						<table width="98%" class="genieData">
						 <thead>	
						 <tr>
							<th width="10%">Force Id</th>                    
							<th width="10%">System Name</th>
							<th width="15%">Reference</th>
							<th width="65%">Telephone No</th>	
						 </tr>
						 </thead>
						 <tbody>
			             <cfloop from="1" to="#arrayLen(telephones)#" index="iTel">
			             <tr>
			               <td>#telephones[iTel].getDISPLAY_FORCE()#</td>
			               <td>#telephones[iTel].getAPP_REF()#</td>
			               <td>#telephones[iTel].getSYS_REF()#</td>
			               <td>
			                  <cfif telephones[iTel].getAPP_REF() IS NOT "FLINT" and telephones[iTel].getAPP_REF() IS NOT "BOF2">                    
			                   <a href="#telephones[iTel].getAPP_REF()#|#telephones[iTel].getSYS_REF()#|#telephones[iTel].getFORCE_REF()#|TELEPHONE|#telephones[iTel].getTEL_NO()#" class="wMidsTelephone">
			                  </cfif>                       
			                       #telephones[iTel].getTEL_NO()#
			                  <cfif telephones[iTel].getAPP_REF() IS NOT "FLINT" and telephones[iTel].getAPP_REF() IS NOT "BOF2"> 
			                   </a>
			                  </cfif>
			               </td>                                                         
			             </tr>
			             </cfloop>
			             </tbody> 
			            </table>
			       </div>     					
				</cfsavecontent>	
			 </cfoutput>	
				<cfset returnHTML &= thisTel>

		</cfif>
	
	   <cfreturn returnHTML>
	
	</cffunction>
  
<cffunction name="createAuditStructure" access="private" output="false" returntype="struct">
  	  <cfargument name="auditData" required="true" type="struct" hint="struct containing audit data">
	  
	  <cfset var auditStruct=structNew()>
	    
	  <cfset auditStruct.enquiryUser=auditData.enquiryUser>
      <cfset auditStruct.enquiryUserName=auditData.enquiryUserName>
	  <cfset auditStruct.enquiryUserDept=auditData.enquiryUserDept>
	  <cfset auditStruct.requestFor=auditData.requestFor>
	  <cfset auditStruct.reasonCode=auditData.reasonCode>
	  <cfset auditStruct.reasonText=auditData.reasonText>   
	  <cfset auditStruct.sessionId=auditData.sessionId>	  
	  <cfset auditStruct.terminalId=auditData.terminalId>	  
      
	  <cfreturn auditStruct>  	
		
    </cffunction>  
  
</cfcomponent>