<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.lis_Months="JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC">
<cfset variables.lis_MonthNos="01,02,03,04,05,06,07,08,09,10,11,12">
<cfset variables.wMidsSysCodes="COCO">
<cfset variables.wMidsSysReplaces="OASIS">
	
<cfsavecontent variable="variables.nominalXml">
<nominal>
	<nominalRef>%nominalRef%</nominalRef>
	<fullName><![CDATA[%fullName%]]></fullName>
	<forename1>%forename1%</forename1>
	<surname1>%surname1%</surname1>
	<surname2>%surname2%</surname2>
	<DOB>%DOB%</DOB>
	<Address><![CDATA[%Address%]]></Address>
	<Warnings><![CDATA[%Warnings%]]></Warnings>
	<postTown>%postTown%</postTown>
	<placeOfBirth>%placeOfBirth%</placeOfBirth>
	<photoUrl><![CDATA[%photoUrl%]]></photoUrl>
	<photoDate><![CDATA[%photoDate%]]></photoDate>
	<nameType>%nameType%</nameType>
</nominal>	
</cfsavecontent>

<cfsavecontent variable="variables.noResults">
<table width="98%" align="center" class="dataTable genieData">
  <tbody>
    <tr>
		<td>No Results Found</td>		
    </tr>
  </tbody>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.nominalShortTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="14%">Nom Ref</th>
		<th width="46%">Name</th>
		<th width="10%">DOB</th>
		<th width="10%">Age</th>
		<th width="5%"></th>
		<th width="5%"></th>
		<th width="5%"></th>
		<th width="5%"></th>	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.nominalShortTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.nominalShortTableRow">
<tr id="%nameType%_%nominalRef%">
	<td valign="top"><a href='%nominalRef%' class="%nominalClass%">%nominalRef%</a></td>
	<td valign="top" class="fullName"><a href='%nominalRef%' class="%nominalClass%">%fullName%</a>%relationship%</td>
	<td valign="top">%DOB%</td>
	<td valign="top">%AGE%</td>
	<td valign="top" align="center">%warningData%</td>
	<td valign="top" align="center">%photoData%</td>
	<td valign="top" align="center">%addressData%</td>	
	<td valign="top" align="center">%clickData%</td>
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.nominalLongTableHeader">
<table width="100%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width='5%'>Nom Ref</th>
		<th width='28%'>Name</th>
		<th width='2%'>Sex</th>		
		<th width='1%'>W</th>
		<th width='1%'>&nbsp;</th>
		<th width='8%'>DOB</th>
		<th width='2%'>Age</th>
		<th width='12%'>Birth Place</th>
		<th width='12%'>Post Town</th>
		<th width='1%'>&nbsp;</th>
		<th width='2%'>NT</th>
		<th width='16%'>Ethnic App</th>
		<th width='8%'>Oth Names</th>
		<th width='1%'></th>	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.nominalLongTableRow">
<tr id="%nameType%_%nominalRef%">
	<td valign="top"><a %nominalHRef% class='%nominalClass%' %targetInfo%>%nominalRef%</a></td>
	<td valign="top" class="fullName"><a %nominalHRef% class='%nominalClass%' %targetInfo%>%fullName%</a></td>
	<td valign="top">%SEX%</td>	
	<td valign="top" align="center">%warningData%</td>
	<td valign="top" align="center">%photoData%</td>
	<td valign="top">%DOB%</td>
	<td valign="top">%AGE%</td>
	<td valign="top">%pob%</td>
	<td valign="top">%ptown%</td>	
	<td valign="top" align="center">%addressData%</td>	
	<td valign="top">%nametype%</td>
	<td valign="top">%ethnicapp%</td>
	<td valign="top">%othernames%</td>
	<td valign="top">%checkbox%</td>
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.nominalLongTableFooter">
  </tbody>
</table>	
</cfsavecontent>

<cfsavecontent variable="variables.fNominalTableHeader">	
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width='1%'>Person Ref</th>
		<th width='30%'>Name</th>
		<th width='1%'>&nbsp;</th>
		<th>DOB</th>
		<th>AGE</th>		
		<th>PNC ID</th>
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.fNominalTableRow">
<tr id="F_%personRef%">
	<td valign="top"><a href="%personRef%" class="%nominalClass%">%personRef%</a></td>
	<td valign="top" class="fullName"><a href="%personRef%" class="%nominalClass%">%fullName%</a></td>
	<td valign="top">%photoData%</td>
	<td valign="top">%DOB%</td>
	<td valign="top">%AGE%</td>
	<td valign="top">%PNC%</td>
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.fNominalTableFooter">
  </tbody>
</table>	
</cfsavecontent>

<cfsavecontent variable="variables.wMidsTableHeader">	
<table class='dataTable genieData' width='100%'>
  <thead>
	<tr>
	   <th width='12%'>Force Id</th>
	   <th width='12%'>System Name</th>
	   <th width='12%'>Reference</th>
	   <th width='2%'>&nbsp;</th>
	   <th width='50'>Name</th>
	   <th width='12%'>DOB</th>
	   <th width='2%'>&nbsp;</th>
	  </tr>
  </thead>
  <tbody>
</cfsavecontent>

<cfsavecontent variable="variables.wMidsTableRow">					
<tr>
 <td>%DISPLAY_FORCE%</td>
 <td>%APP_REF%</td>
 <td>%NOM_LINK%</td>
 <td>%NOM_PHOTO%</td> 
 <td class="fullName">%NOM_NAME%</td>
 <td>%NOM_DOB%</td>
 <td><input type='checkbox' id='%wMidsChkRef%'></td>
</tr>
</cfsavecontent>	

<cfsavecontent variable="variables.wMidsHref">
<a %nominalHRef% class="wMidsNominal">%REFERENCE%</a>	
</cfsavecontent>	

<cfsavecontent variable="variables.wMidsTableFooter">
  </tbody>
</table>	
</cfsavecontent>

<cfsavecontent variable="variables.photoDiv">
<div class="genieCamera genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%photoTitle%
	  </div>
	  <div class="genieTooltipHolder geniePhotoHolder">
	  	<img src="%photoUrl%" height=200 width=160>
		<br>Date Taken: <strong>%photoDate%</strong>
	  </div>
	</div>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.fPhotoDiv">
<div class="genieCamera genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%photoTitle%
	  </div>
	  <div class="genieTooltipHolder geniePhotoHolder">
	  	<img src="%photoUrl%" height=200 width=160>		
	  </div>
	</div>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.warningDiv">
<div class="genieWarning genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%shortName% Warnings
	  </div>
	  <div class="genieTooltipHolder">
	  	%Warnings%
	  </div>
	</div>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.addressDiv">
<div class="genieAddress genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%shortName% Address
	  </div>
	  <div class="genieTooltipHolder">
	  	%Address%
		<br>
		RECORDED: %DateAddressRecorded%
	  </div>	  
	</div>
</div>
</cfsavecontent>

<cfsavecontent variable="variables.clickData">
<div class="geniePlus">
	<div style="display:none;">
	  <input type="hidden" name="nominalRef" id="nominalRef" value="%nominalRef%">
	  <input type="hidden" name="fullName" id="fullName" value="%fullName%">
	  <input type="hidden" name="photoUrl" id="photoUrl" value="%photoUrl%">
	  <input type="hidden" name="dob" id="dob" value="%dob%">
	</div>
</div>	
</cfsavecontent>

    <cffunction name="validateQuickNominalSearch" access="private" returntype="struct" output="false" hint="validates a quick nominal search">
     <cfargument name="qsArgs" type="Struct" required="true" hint="args being passed into the quick nominal search">     
	 <cfset var validation=StructNew()>	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 	<cfif Len(qsArgs.nominalSurname) IS 0
		  AND Len(qsArgs.nominalForename) IS 0
		  AND Len(qsArgs.nominalDOB) IS 0
		  AND Len(qsArgs.nominalRef) IS 0>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must complete some search fields","|")>		
		<cfelse>
		    <cfif Len(qsArgs.nominalRef) IS 0>
			<!--- some search fields have been completed, if we don't have a nom ref 
			      then the minimum for a search is 2 chars of surname --->
			      <cfif Len(qsArgs.nominalSurname) LT 2 AND (Len(qsArgs.nominalForename) IS 0 AND Len(qsArgs.nominalDOB) IS 0)>
				  	 <cfset validation.valid=false>
		    		 <cfset validation.errors=ListAppend(validation.errors,"Minimum requirements for a name search is 2 characters of the surname","|")> 
				  </cfif>
			</cfif>		  
		</cfif>
				 
		<cfreturn validation> 	
			
	</cffunction>
	
	<cffunction name="quickNominalSearch" access="remote" returntype="string" returnFormat="plain" output="false" hint="quick search for nominals forename, surname, dob and nominal ref only options">
  	  <cfargument name="user" type="string" required="true" hint="person requesting search">	  	
	  <cfargument name="nominalForename" type="string" required="true" hint="nominal forename">
	  <cfargument name="nominalSurname" type="string" required="true" hint="nominal Surname">
	  <cfargument name="nominalDOB" type="string" required="true" hint="nominal DOB">
	  <cfargument name="nominalRef" type="string" required="true" hint="nominalRef">
	  <cfargument name="resultType"	type="string" required="false" default="xml" hint="what you want returned. Options xml (default), shortHTML html data table limited fields, longHTML html data table all usual fields ">   

      <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>
	  <cfset var nominalXml="">
	  <cfset var searchFields = ArrayNew(1)>
  	  <cfset var keyPair = StructNew()>	
	  <cfset var westMerResults = "">
 	  <cfset var sDob = "">
	  <cfset var sDobPart = "">  
	  <cfset var nominalXmlResults="">
	  <cfset var thisNominal=""> 		  
	  <cfset var iNomCount=0>
	  <cfset var validation=validateQuickNominalSearch(arguments)>
	  <cfset var errorHtmlStart="<div class='error' id='searchErrors'>">
	  <cfset var errorHtmlEnd="</div>">
	  
	  <cflog file="genieWebService" text="quick genie search resultType=#arguments.resultType#, Forename: #arguments.nominalForename#; Surname: #arguments.nominalSurname#; DOB: #arguments.nominalDOB#; Ref: #arguments.nominalRef# by #arguments.user#" type="information" />	
	  
	  <!--- search request is valid --->
	  <cfif validation.valid>
	   
      <!--- setup the search structure --->	
		
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_NOMINAL_REF">
		<cfset keyPair.value = UCase(arguments.nominalRef)>
		<cfset searchFields[1] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_PNC">
		<cfset keyPair.value = ''>
		<cfset searchFields[2] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_SURNAME_1">
		<cfset keyPair.value = UCase(arguments.nominalSurname)>
		<cfset searchFields[3] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_SURNAME_2">
		<cfset keyPair.value = ''>
		<cfset searchFields[4] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FORENAME_1">
		<cfset keyPair.value = UCase(arguments.nominalForename)>
		<cfset searchFields[5] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FORENAME_2">
		<cfset keyPair.value = ''>
		<cfset searchFields[6] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_MAIDEN">
		<cfset keyPair.value = ''>
		<cfset searchFields[7] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FAMILIAR">
		<cfset keyPair.value = ''>
		<cfset searchFields[8] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FUZZY">
		<cfset keyPair.value = iif(REFind("[%*_]",arguments.nominalSurname) GT 0 OR REFind("[%*_]",arguments.nominalForename) GT 0,de('Y'),de('N'))>
		<cfset searchFields[9] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_SEX">
		<cfset keyPair.value = ''>
		<cfset searchFields[10] = keyPair>
	
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_DOB_PART">
		<cfset keyPair.value = ''>
		<cfset searchFields[11] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_DOB">
		<cfset keyPair.value = arguments.nominalDOB>
		<cfset searchFields[12] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_AGE_1">
		<cfset keyPair.value = ''>
		<cfset searchFields[13] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_AGE_2">
		<cfset keyPair.value = ''>
		<cfset searchFields[14] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_CRO">
		<cfset keyPair.value = ''>
		<cfset searchFields[15] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_POB">
		<cfset keyPair.value = ''>
		<cfset searchFields[16] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_TOWN">
		<cfset keyPair.value = ''>
		<cfset searchFields[17] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_EXACT">
		<cfset keyPair.value = 'N'>
		<cfset searchFields[18] = keyPair>
	
		<cfset westMerResults = application.genieService.doWestMerciaPersonSearch(searchTerms=searchFields, 
		                                                                          pasteReq='Y',
																				  auditReq='N')>     
	    
	    <cfsavecontent variable="queryDump">
			<cfdump var="#westMerResults#">
		</cfsavecontent>
		
		<cflog type="information" file="genieWS" text="#queryDump#">
	    
	    <!--- only get the nominals that are a primary name type 
		<cfquery name="qNameTypeP" dbtype="query">
			SELECT *
			FROM   westMerResults.queryResult
			WHERE  NAME_TYPE='P' 
		</cfquery>	--->
	    <cfif resultType IS "xml"> 	    
	    <cfloop query="westMerResults.queryResult">		  	  	
			<cfset thisNominal=duplicate(variables.nominalXml)>
			<cfset thisNominal=Replace(thisNominal,'%nominalRef%',NOMINAL_REF)>
			<cfset thisNominal=Replace(thisNominal,'%forename1%',FORENAME_1)>				
			<cfset thisNominal=Replace(thisNominal,'%surname1%',SURNAME_1)>	
			<cfset thisNominal=Replace(thisNominal,'%surname2%',SURNAME_2)>	
			<cfset thisNominal=Replace(thisNominal,'%fullName%',NAME)>	
			<cfset thisNominal=Replace(thisNominal,'%DOB%',DOB)>
			<cfset thisNominal=Replace(thisNominal,'%Address%',ADDRESS)>
			<cfset thisNominal=Replace(thisNominal,'%Warnings%',WARNINGS)>
			<cfset thisNominal=Replace(thisNominal,'%postTown%',POST_TOWN)>
			<cfset thisNominal=Replace(thisNominal,'%placeOfBirth%',PLACE_OF_BIRTH)>
			<cfset thisNominal=Replace(thisNominal,'%photoUrl%',PHOTO_URL)>
			<cfset thisNominal=Replace(thisNominal,'%photoDate%',PHOTO_DATE)>
			<cfset thisNominal=Replace(thisNominal,'%nameType%',NAME_TYPE)>								
			<cfset nominalXmlResults &= thisNominal>
			<cfset iNomCount++>		  
		</cfloop>
	    
	    <cfset returnXml=Replace(returnXml,'%resultCount%',iNomCount)>
		<cfset returnXml=Replace(returnXml,'%nominalResults%',nominalXmlResults)>
		<cflog file="genieWebService" text="returning XML" type="information" />
		
	    <cfreturn returnXml>
		
		<cfelseif resultType IS "shortTable">
			
			<cfif westMerResults.queryResult.recordCount GT 0>
				<cfset returnTable = doNominalShortTable(westMerResults.queryResult)>				
			<cfelse>
				<cfset returnTable = '<p><b>Your Search Returned No Results</b></p>'>	
			</cfif>
		    			
			
			<cfreturn returnTable>
			
		<cfelseif resultType IS "longTable">
			
		</cfif>
			
	 <cfelse>
	   <!--- search request is not valid --->	   	
	   <cfif resultType IS "XML">
	   	   
	   <cfelse>
	      <cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
	   </cfif>	 
	 </cfif>	
    </cffunction>	

    <cffunction name="validatePersonEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a person search">
	 <cfset var peArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">	 	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 	<cfif Len(peArgs.surname1) IS 0
		  AND Len(peArgs.forename1) IS 0
		  AND Len(peArgs.surname2) IS 0
		  AND Len(peArgs.forename2) IS 0
		  AND Len(peArgs.pncid) IS 0
		  AND Len(peArgs.cro) IS 0		
		  AND Len(peArgs.nominalRef) IS 0>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter either Nominal Ref, PNC ID, CRO, Surname 1, Surname 2, Forename 1, Forename 2, Maiden Name or Nickname ","|")>		
		<cfelse>
			<cfif Len(peArgs.ageFrom) GT 0>
				<cfif not isNumeric(peArgs.ageFrom)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Age From Must Be A Number","|")>					
				</cfif>
			</cfif>
			
			<cfif Len(peArgs.ageTo) GT 0>				
				<cfif not isNumeric(peArgs.ageTo)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Age To Must Be A Number","|")>					
				</cfif>
			</cfif>
			
			<cfif Len(peArgs.dobDay) GT 0 AND Len(peArgs.dobMonth) GT 0 AND Len(peArgs.dobYear) GT 0>
				<cfif not LSIsDate(peArgs.dobDay & "/" & peArgs.dobMonth & "/" &peArgs.dobYear)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date of Birth #peArgs.dobDay#/#peArgs.dobMonth#/#peArgs.dobYear# is not valid","|")>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

	<cffunction name="doWMerPersonEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="full genie person enquiry">  	  	  	

      <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>
	  <cfset var nominalXml="">
	  <cfset var searchFields = ArrayNew(1)>
  	  <cfset var keyPair = StructNew()>	
	  <cfset var westMerResults = "">
 	  <cfset var sDob = "">
	  <cfset var sDobPart = "">  
	  <cfset var nominalXmlResults="">
	  <cfset var thisNominal=""> 		  
	  <cfset var iNomCount=0>
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))> 
	  <cfset var auditData=createAuditStructure(searchData)>   
	  <cfset var thisUUID=createUUID()>
	  <cfset var returnTable=''>
	  
	    <cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_NOMINAL_REF">
		<cfset keyPair.value = UCase(searchData.nominalRef)>
		<cfset searchFields[1] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_PNC">
		<cfset keyPair.value = searchData.pncid>
		<cfset searchFields[2] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_SURNAME_1">
		<cfset keyPair.value = UCase(searchData.surname1)>
		<cfset searchFields[3] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_SURNAME_2">
		<cfset keyPair.value = UCase(searchData.surname2)>
		<cfset searchFields[4] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FORENAME_1">
		<cfset keyPair.value = UCase(searchData.forename1)>
		<cfset searchFields[5] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FORENAME_2">
		<cfset keyPair.value = UCase(searchData.forename2)>
		<cfset searchFields[6] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_MAIDEN">
		<cfset keyPair.value = UCase(searchData.maiden)>
		<cfset searchFields[7] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FAMILIAR">
		<cfset keyPair.value = UCase(searchData.nickname)>
		<cfset searchFields[8] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_FUZZY">
		<cfset keyPair.value = iif(searchData.searchType IS "Wildcard",de('Y'),de('N'))>
		<cfset searchFields[9] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_SEX">
		<cfset keyPair.value = searchData.sex>
		<cfset searchFields[10] = keyPair>
	
		<!--- dob, we need to see if all fields are filled if so full dob and no part
		      otherwise part dob and no full --->
		<cfif Len(searchData.dobDay) GT 0 AND Len(searchData.dobMonth) GT 0 AND Len(searchData.dobYear) GT 0>
			<!--- full dob --->
			<cfset sDob = searchData.dobDay & "/" & searchData.dobMonth & "/" & searchData.dobYear>
		<cfelse>
			<cfif Len(searchData.dobDay) GT 0 OR Len(searchData.dobMonth) GT 0 OR Len(searchData.dobYear) GT 0>
			
				<cfif Len(searchData.dobMonth) GT 0>
					<cfset searchData.dobMonth = ListGetAt(variables.lis_Months, Int(searchData.dobMonth), ",")>
				</cfif>
			
				<cfset sDobPart = searchData.dobDay & "%" & searchData.dobMonth & "%" & searchData.dobYear>
			</cfif>
		</cfif>	
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_DOB_PART">
		<cfset keyPair.value = sDobPart>>
		<cfset searchFields[11] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_DOB">
		<cfset keyPair.value = sDob>
		<cfset searchFields[12] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_AGE_1">
		<cfset keyPair.value = searchData.ageFrom>
		<cfset searchFields[13] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_AGE_2">
		<cfset keyPair.value = searchData.ageTo>
		<cfset searchFields[14] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_CRO">
		<cfset keyPair.value = searchData.cro>
		<cfset searchFields[15] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_POB">
		<cfset keyPair.value = searchData.pob>
		<cfset searchFields[16] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_TOWN">
		<cfset keyPair.value = searchData.pTown>
		<cfset searchFields[17] = keyPair>
	
		<cfset keyPair = StructNew()>
		<cfset keyPair.key = "P_EXACT">
		<cfset keyPair.value = searchData.exactDOB>
		<cfset searchFields[18] = keyPair>
	
		<cfset westMerResults = application.genieService.doWestMerciaPersonSearch(searchTerms=searchFields, 
		                                                                          pasteReq='Y',
																				  auditReq='Y',
                                                                                  searchUUID=thisUUID)>  
		
		<cfif searchData.resultType IS "XML">
		
		<cfelseif searchData.resultType IS "Short Table">

			<cfif westMerResults.queryResult.recordCount GT 0>				
				<cfset returnTable = doNominalShortTable(westMerResults.queryResult)>				 				
			<cfelse>
				<cfset returnTable = '<p><b>Your Search Returned No Results</b></p>'>	
			</cfif>
				
		<cfelseif searchData.resultType IS "Long Table">

			<cfif westMerResults.queryResult.recordCount GT 0>
				<cfset returnTable  = "<input type='hidden' id='pastePath' value='#westMerResults.pastePath#'>">				
				<cfset returnTable &= doNominalLongTable(nominalQuery=westMerResults.queryResult,uuid=thisUUID)>				
			<cfelse>
				<cfset returnTable = '<p><b>Your Search Returned No Results</b></p>'>	
			</cfif>	
				
		<cfelse>
			<cfset returnTable = 'No Valid Return Format Specified, options are XML,Short Table,Long Table'>
		</cfif>				
																  
		<cfreturn returnTable>																		  		
   
   </cffunction>

	<cffunction name="doFirearmsPersonEnquiry" output="false" returntype="string" returnFormat="plain" access="remote" hint="does a nflms firearms enquiry">
			
		<cfset var keyPair = StructNew()>		
		<cfset var firearmsHTML = "">
		<cfset var firearmsResults = "">
		<cfset var sDob = "">
		<cfset var sDobPart = "">
		<cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
		<cfset var auditData=createAuditStructure(searchData)>  
	
		<cfset keyPair.P_SURNAME_1 = searchData.surname1>
		<cfset keyPair.P_SURNAME_2 = searchData.surname2>
		<cfset keyPair.P_FORENAME_1 = searchData.forename1>
		<cfset keyPair.P_FORENAME_2 = searchData.forename2>
		<cfset keyPair.P_PNC = searchData.pncid>
	
		<!--- dob, we need to see if all fields are filled if so full dob and no part
		      otherwise part dob and no full --->
		<cfif Len(searchData.dobDay) GT 0 AND Len(searchData.dobMonth) GT 0 AND Len(searchData.dobYear) GT 0>
			<!--- full dob --->
			<cfset sDob = searchData.dobDay & "/" & searchData.dobMonth & "/" & searchData.dobYear>
		<cfelse>
			<cfif Len(searchData.dobDay) GT 0 OR Len(searchData.dobMonth) GT 0 OR Len(searchData.dobYear) GT 0>
			
				<!--- format the month differently for firearms searching --->
				<cfif Len(searchData.dobMonth) GT 0>
					<cfset searchData.dobMonth = ListGetAt(variables.lis_Months, Int(searchData.dobMonth), ",")>
				</cfif>
			
				<cfset sDobPart = searchData.dobDay & "%" & searchData.dobMonth & "%" & searchData.dobYear>
				<cfset sDobPart = Replace(sDobPart, "%%", "%")>
			</cfif>
		</cfif>
	
		<cfset keyPair.P_DOB = sDob>
		<cfset keyPair.P_EXACT = searchData.exactDob>
		<cfset keyPair.P_DOB_PART = sDobPart>
		<cfset keyPair.P_FUZZY = searchData.searchType>

		<cfset firearmsResults = application.genieService.doWestMerciaFirearmsSearch(searchTerms=keyPair,
																					 fromWebService='Y',
																					 wsAudit=auditData)>
	
		<cfif firearmsResults.recordCount GT 0>
				<cfset firearmsHTML = doFNominalTable(firearmsResults)>				
		<cfelse>
				<cfset firearmsHTML = '<p><b>Your Search Returned No Results</b></p>'>	
		</cfif>	
	
		<cfreturn firearmsHTML>
	
	</cffunction>
   		
    <cffunction name="doNominalShortTable" access="private" output="false" returntype="string">
  	<cfargument name="nominalQuery" required="true" type="query" hint="query of nominals to format into a short table">
	
	<cfset var returnTable="">
	<cfset var thisNominal="">  
	
		<cfset returnTable  =duplicate(variables.nominalShortTableHeader)>
		<cfloop query="nominalQuery">		  	  	
			<cfset thisNominal=duplicate(variables.nominalShortTableRow)>
			<cfif Len(PHOTO_URL) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',variables.photoDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',"","ALL")>
			</cfif>
			<cfif Len(ADDRESS) GT 0>
			    <cfset thisNominal=ReplaceNoCase(thisNominal,'%addressData%',variables.addressDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%addressData%',"","ALL")>
			</cfif>
			<cfif Len(WARNINGS) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%warningData%',variables.warningDiv,"ALL")>					
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%warningData%',"","ALL")>
			</cfif>
			<cfif NAME_TYPE IS "P">
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%clickData%',variables.clickData,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%clickData%','',"ALL")>
			</cfif>					
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalRef%',NOMINAL_REF,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%forename1%',FORENAME_1,"ALL")>				
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%surname1%',SURNAME_1,"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%surname2%',SURNAME_2,"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%fullName%',NAME,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%shortName%',FORENAME_1&" "&SURNAME_1,"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%DOB%',DOB,"ALL")>
			<cfif Len(DOB) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',getAge(LSDateFormat(DOB,"DD/MM/YYYY")),"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',"","ALL")>
			</cfif>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%Address%',ADDRESS,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%Warnings%',WARNINGS,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%postTown%',POST_TOWN,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%placeOfBirth%',PLACE_OF_BIRTH,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoUrl%',PHOTO_URL,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoDate%',PHOTO_DATE,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoTitle%',NOMINAL_REF&" "&SURNAME_1&IIF(Len(SURNAME_2) GT 0,de('-'&SURNAME_2),de('')),"ALL")>
			
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nameType%',NAME_TYPE,"ALL")>
			
			<cfif isDefined("RELATIONSHIP")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%relationship%',"<br>(<b>"&RELATIONSHIP&"</b>)","ALL")>
            <cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%relationship%'," ","ALL")>					
			</cfif>
			
			<cfif NAME_TYPE IS "P">
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','genieNominal',"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','',"ALL")>
			</cfif>								
			<cfset returnTable &= thisNominal>			  
		</cfloop>				
	    <Cfset returnTable &=duplicate(variables.nominalShortTableFooter)>	
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
    <cffunction name="doNominalLongTable" access="private" output="false" returntype="string">
  	<cfargument name="nominalQuery" required="true" type="query" hint="query of nominals to format into a long table">
	<cfargument name="uuid" required="false" type="string" hint="if not blank will create a searchUUID file that can be used for scroll thru nominals without going back to the list">  
	
	<cfset var returnTable="">
	<cfset var thisNominal="">  
	<cfset var str_Name="">
	<cfset var lisNominals="">
	
		<cfset returnTable  =duplicate(variables.nominalLongTableHeader)>
		<cfloop query="nominalQuery">		  	  	
			<cfset thisNominal=duplicate(variables.nominalLongTableRow)>
			<cfif Len(PHOTO_URL) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',variables.photoDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',"","ALL")>
			</cfif>
			<cfif Len(ADDRESS) GT 0>
			    <cfset thisNominal=ReplaceNoCase(thisNominal,'%addressData%',variables.addressDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%addressData%',"","ALL")>
			</cfif>
			<cfif Len(WARNINGS) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%warningData%',variables.warningDiv,"ALL")>					
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%warningData%',"","ALL")>
			</cfif>
			<cfif NAME_TYPE IS "P">
				<cfset lisNominals=ListAppend(lisNominals,NOMINAL_REF)>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%clickData%',variables.clickData,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%clickData%','',"ALL")>
			</cfif>					
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalRef%',NOMINAL_REF,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%forename1%',FORENAME_1,"ALL")>				
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%surname1%',SURNAME_1,"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%surname2%',SURNAME_2,"ALL")>	
			
			 <!--- check the type of the nominal, if it's an O then it's an official
		     record of an Employee so display the employee info --->
				<cfif SUB_TYPE IS "O" AND Len(RANK) GT 0 AND LEN(BADGE_NUMBER) GT 0>
					<cfset str_Name = RANK & " " & BADGE_NUMBER & " " & SURNAME_1>
					<cfif Len(SURNAME_2) GT 0>
						<cfset str_Name = str_Name & "-" & SURNAME_2>
					</cfif>
				<cfelse>
					<cfset str_Name = NAME>
				</cfif>
			
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%fullName%',str_Name,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%shortName%',FORENAME_1&" "&SURNAME_1,"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%DOB%',DOB,"ALL")>
			<cfif Len(DOB) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',getAge(LSDateFormat(DOB,"DD/MM/YYYY")),"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',"","ALL")>
			</cfif>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%Address%',ADDRESS,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%DateAddressRecorded%',DATE_REC,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%Warnings%',WARNINGS,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%pTown%',POST_TOWN,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%pob%',PLACE_OF_BIRTH,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%sex%',SEX,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoUrl%',PHOTO_URL,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoDate%',PHOTO_DATE,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoTitle%',NOMINAL_REF&" "&SURNAME_1&IIF(Len(SURNAME_2) GT 0,de('-'&SURNAME_2),de('')),"ALL")>
			
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nameType%',NAME_TYPE,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%ethnicapp%',ETHNICITY_16,"ALL")>
			
			<cfif Len(OTHER_NAMES_FLAG) GT 0 OR (NAME_TYPE IS NOT "P" AND NAME_TYPE IS NOT "T")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%othernames%','<a href="#NOMINAL_REF#" class="genieNominalAlias">Other Names</a>',"ALL")>	
		    <cfelse>
			    <cfset thisNominal=ReplaceNoCase(thisNominal,'%othernames%','',"ALL")>
			</cfif>			
			
			<cfif isDefined("RELATIONSHIP")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%relationship%',"<br>(<b>"&RELATIONSHIP&"</b>)","ALL")>
            <cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%relationship%'," ","ALL")>					
			</cfif>
			
			<cfif NAME_TYPE IS "P">
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','genieNominal',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalHRef%','href="#NOMINAL_REF#" uuid="#arguments.uuid#"',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%checkbox%','<input type="checkbox" id="chk_#NOMINAL_REF#">',"ALL")>
				<cfif Len(TARGET) GT 0>
					<cfset thisNominal=ReplaceNoCase(thisNominal,'%targetInfo%','target="'&TARGET&'"',"ALL")>	
				<cfelse>
					<cfset thisNominal=ReplaceNoCase(thisNominal,'%targetInfo%','',"ALL")>
				</cfif>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%targetInfo%','',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalHRef%','',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%checkbox%','',"ALL")>
			</cfif>								
			
			<cfset returnTable &= thisNominal>			  
		</cfloop>				
	    <Cfset returnTable &=duplicate(variables.nominalLongTableFooter)>	
		
		<!--- if we have a uuid set then write the uuid file --->
	    <cfif Len(UUID) GT 0>
			<cffile action="write" file="#variables.appVars.nominalTempDir##uuid#.txt" output="#lisNominals#" />
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
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','genieFirearmsNominal',"ALL")>
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
  
    <cffunction name="getAge" access="private" output="false" returntype="Numeric">
  	  <cfargument name="birthDate" required="true" type="string" hint="dd/mm/yyyy">
	
	  <cfset iAge=0>
	  <cfset dBday=CreateDate(ListGetAt(arguments.birthDate,3,"/"),ListGetAt(arguments.birthDate,2,"/"),ListGetAt(arguments.birthDate,1,"/"))>
	    
	  <cfset iAge = DatePart("yyyy", now()) - DatePart("yyyy", dBday)>
      
	  <cfif DatePart("m", now()) LT DatePart("m", dBday)>
	    <cfset iAge-->
	  <cfelseif (DatePart("m", now()) EQ DatePart("m", dBday)) AND (DatePart("d", now()) LT DatePart("d", dBday))>
        <cfset iAge-->
      </cfif>
      
	  <cfreturn iAge>  	
		
  </cffunction> 
  
    <cffunction name="getNominalFamily" access="remote" returntype="string" returnFormat="plain" output="false" hint="gets all familial associates for a given nominal ref">
   	  <cfargument name="user" type="string" required="true" hint="person requesting search">
	  <cfargument name="nominalRef" type="string" required="true" hint="nominal ref to get family for">
	  <cfargument name="resultType"	type="string" required="false" default="xml" hint="what you want returned. Options xml (default), shortHTML html data table limited fields, longHTML html data table all usual fields ">
	
	  <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>
	  <cfset var nominalXml="">
	  <cfset var westMerResults = "">
	  <cfset var nominalXmlResults="">
	  <cfset var thisNominal=""> 		  
	  <cfset var iNomCount=0>
	  <cfset var errorHtmlStart="<div class='error' id='searchErrors'>">
	  <cfset var errorHtmlEnd="</div>">
	    
	  <cfset westMerResults = application.genieService.getNominalFamily(nominalRef=arguments.nominalRef, 
		                                                                user=arguments.user)>    	
		                                                                
	  
	  <cfif westMerResults.recordCount GT 0>
	  	  <cfset returnTable=doNominalShortTable(westMerResults)>
	  <cfelse>
	  	  <cfset returnTable=variables.nominalShortNoResults>
	  </cfif>
	    
	  <cfreturn returnTable>  
	    
  </cffunction>  	

    <cffunction name="addNominalFavourite" access="remote" returntype="string" returnFormat="plain" output="false" hint="adds a user favourite nominal">
   	  <cfargument name="userId" type="string" required="true" hint="person to add favourite for">
	  <cfargument name="nominalRef" type="string" required="true" hint="nominal ref to add">
	  <cfargument name="showUpdates" type="string" required="true" hint="Y or N for updates required">
	  <cfargument name="notes" type="string" required="true" hint="any notes to add">  	  
	
	  <cfset var returnData="">
	    
	  <cfset application.genieUserService.addUserFavourite(userId=userId,
	                                                       nominalRef=nominalRef,
														   showUpdates=showUpdates,
														   notes=notes)>  
	    
	  <cfreturn returnData>  
	    
  </cffunction>  	
  
    <cffunction name="deleteNominalFavourite" access="remote" returntype="string" returnFormat="plain" output="false" hint="deletes a user favourite nominal">
   	  <cfargument name="userId" type="string" required="true" hint="person to add favourite for">
	  <cfargument name="nominalRef" type="string" required="true" hint="nominal ref to add">
	    	  
	
	  <cfset var returnData="">
	    
	  <cfset application.genieUserService.deleteFavouriteNominal(userId=userId,
	                                                       		 nominalRef=nominalRef)>  
	    
	  <cfreturn returnData>  
	    
  </cffunction>   
  
    <cffunction name="updateNominalFavourite" access="remote" returntype="string" returnFormat="plain" output="false" hint="deletes a user favourite nominal">
   	  <cfargument name="userId" type="string" required="true" hint="person to add favourite for">
	  <cfargument name="nominalRef" type="string" required="true" hint="nominal ref to add">
	  <cfargument name="showUpdates" type="string" required="true" hint="show update value">
	  <cfargument name="notes" type="string" required="true" hint="notes">  	  
	
	  <cfset var returnData="">
	    
	  <cfset application.genieUserService.updateFavouriteNominals(userId=userId,
	                                                       		 nominalRef=nominalRef,
																 showUpdates=showUpdates,
																 notes=notes)>  
	    
	  <cfreturn returnData>  
	    
  </cffunction>   

    <cffunction name="validateWarningEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a warning enquiry">
     <cfset var wArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">

	    <cfif Len(wArgs.frmWarnings) IS 0>			
		  <cfset validation.valid=false>
		  <cfset validation.errors=ListAppend(validation.errors,"You must select at least one warning marker to search on","|")> 			
		</cfif>		 
		
		<cfif Len(wArgs.date_marked1) GT 0>
			<cfif not LSIsDate(wArgs.date_marked1)>
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"Date Marked Between/Of `#wArgs.date_marked1#` is not a valid date.","|")>	
			</cfif>
		</cfif>
		<cfif Len(wArgs.date_marked2) GT 0>
			<cfif not LSIsDate(wArgs.date_marked2)>
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"Date Marked To `#wArgs.date_marked2#` is not a valid date.","|")>					
			</cfif>
		</cfif>
	    <cfif Len(wArgs.date_marked1) GT 0 AND Len(wArgs.date_marked2) GT 0>
			<cfif LSIsDate(wArgs.date_marked1) AND LSIsDate(wArgs.date_marked2)>
				<cfif dateDiff('d',LSParseDateTime(wArgs.date_marked1),LSParseDateTime(wArgs.date_marked2)) LT 0>
					<cfset validation.valid=false>
	    			<cfset validation.errors=ListAppend(validation.errors,"Date Marked To `#wArgs.date_marked2#` must be after Date Marked Between/Of `#wArgs.date_marked1#`.","|")>	
				</cfif>
			</cfif>
		</cfif>		 
		
		<cfif Len(wArgs.age1) GT 0>
			<cfif not isNumeric(wArgs.age1)>
				<cfset validation.valid=false>
    			<cfset validation.errors=ListAppend(validation.errors,"Age Between/On `#wArgs.age1#` must be a number.","|")>
			</cfif>
	    </cfif>

		<cfif Len(wArgs.age2) GT 0>
			<cfif not isNumeric(wArgs.age2)>
				<cfset validation.valid=false>
    			<cfset validation.errors=ListAppend(validation.errors,"Age To `#wArgs.age2#` must be a number.","|")>
			</cfif>
	    </cfif>

	    <cfif Len(wArgs.age1) GT 0 AND Len(wArgs.age2) GT 0>
			<cfif isNumeric(wArgs.age1) AND isNumeric(wArgs.age2)>
				<cfif int(wArgs.age2) LT int(wArgs.age1)>
					<cfset validation.valid=false>
	    			<cfset validation.errors=ListAppend(validation.errors,"Age To `#wArgs.age2#` must be greater than Age Between/On `#wArgs.age1#`.","|")>
				</cfif>
			</cfif>
		</cfif>	

				 
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>	
			
	</cffunction>

  <cffunction name="doWarningEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do warning enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">	
	  	  
		<cfset enquiryResults = application.genieService.doWarningMarkerSearch(searchData.frmWarnings,
																		  searchData.current_only,
																		  searchData.how_to_use,
																		  searchData.sort_by,
																		  searchData.date_marked1,
																		  searchData.date_marked2,
																		  searchData.age1,
																		  searchData.age2,
																		  searchData.sex,
																		  searchData.post_town, 
																		  thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doWarningEnquiryTable(nominalArray=enquiryResults.nominals,
			                                        UUID=thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>
   
   <cffunction name="doWarningEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="nominalArray" required="true" type="array" hint="query of nominals to format into a long table">
	<cfargument name="uuid" required="false" type="string" hint="if not blank will create a searchUUID file that can be used for scroll thru nominals without going back to the list">  
	
	<cfset var returnTable="">
	<cfset var thisNominal="">  
	<cfset var str_Name="">
	<cfset var i=0>
	
	 <cfif arrayLen(nominalArray) GT 0>
		<cfset returnTable  =duplicate(variables.nominalLongTableHeader)>
		<cfloop from="1" to="#ArrayLen(nominalArray)#" index=i>		  	  	
			<cfset thisNominal=duplicate(variables.nominalLongTableRow)>
			<cfif ListLast(nominalArray[i].getLATEST_PHOTO().getPHOTO_URL(),'/') IS NOT "noimage.gif">
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',variables.photoDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoData%',"","ALL")>
			</cfif>
			<cfif Len(nominalArray[i].getLATEST_ADDRESS()) GT 0>
			    <cfset thisNominal=ReplaceNoCase(thisNominal,'%addressData%',variables.addressDiv,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%addressData%',"","ALL")>
			</cfif>
			<cfif Len(nominalArray[i].getWARNINGS_TEXT()) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%warningData%',variables.warningDiv,"ALL")>					
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%warningData%',"","ALL")>
			</cfif>
			<cfif nominalArray[i].getNAME_TYPE() IS "P">				
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%clickData%',variables.clickData,"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%clickData%','',"ALL")>
			</cfif>					
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalRef%',nominalArray[i].getNOMINAL_REF(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%forename1%',nominalArray[i].getFORENAME_1(),"ALL")>				
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%surname1%',nominalArray[i].getSURNAME_1(),"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%surname2%',nominalArray[i].getSURNAME_2(),"ALL")>	
			
			 <!--- check the type of the nominal, if it's an O then it's an official
		     record of an Employee so display the employee info --->
				<cfif nominalArray[i].getSUB_TYPE() IS "O" AND Len(nominalArray[i].getRANK()) GT 0 AND LEN(nominalArray[i].getBADGE_NUMBER()) GT 0>
					<cfset str_Name = nominalArray[i].getRANK() & " " & nominalArray[i].getBADGE_NUMBER() & " " & nominalArray[i].getURNAME_1()>
					<cfif Len(nominalArray[i].getSURNAME_2()) GT 0>
						<cfset str_Name = str_Name & "-" & nominalArray[i].getSURNAME_2()>
					</cfif>
				<cfelse>
					<cfset str_Name = nominalArray[i].getFULL_NAME()>
				</cfif>
			
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%fullName%',str_Name,"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%shortName%',nominalArray[i].getFORENAME_1()&" "&nominalArray[i].getSURNAME_1(),"ALL")>	
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%DOB%',nominalArray[i].getDATE_OF_BIRTH_TEXT(),"ALL")>
			<cfif Len(nominalArray[i].getDATE_OF_BIRTH_TEXT()) GT 0>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',getAge(LSDateFormat(nominalArray[i].getDATE_OF_BIRTH_TEXT(),"DD/MM/YYYY")),"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%AGE%',"","ALL")>
			</cfif>
			
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%Address%',nominalArray[i].getLATEST_ADDRESS(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%Warnings%',nominalArray[i].getWARNINGS_TEXT(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%pTown%',nominalArray[i].getPOST_TOWN(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%pob%',nominalArray[i].getPLACE_OF_BIRTH(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%sex%',nominalArray[i].getSEX(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoUrl%',nominalArray[i].getLATEST_PHOTO().getPHOTO_URL(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoDate%',nominalArray[i].getLATEST_PHOTO().getDatePhotoTaken(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%photoTitle%',nominalArray[i].getNOMINAL_REF()&" "&nominalArray[i].getSURNAME_1()&IIF(Len(nominalArray[i].getSURNAME_2()) GT 0,de('-'&nominalArray[i].getSURNAME_2()),de('')),"ALL")>
			
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%nameType%',nominalArray[i].getNAME_TYPE(),"ALL")>
			<cfset thisNominal=ReplaceNoCase(thisNominal,'%ethnicapp%',nominalArray[i].getETHNICITY_16(),"ALL")>
			
			<cfif Len(nominalArray[i].getOTHER_NAMES_FLAG()) GT 0 OR (nominalArray[i].getNAME_TYPE() IS NOT "P" AND nominalArray[i].getNAME_TYPE() IS NOT "T")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%othernames%','<a href="#nominalArray[i].getNOMINAL_REF()#" class="genieNominalAlias">Other Names</a>',"ALL")>	
		    <cfelse>
			    <cfset thisNominal=ReplaceNoCase(thisNominal,'%othernames%','',"ALL")>
			</cfif>			
						
			<cfif nominalArray[i].getNAME_TYPE() IS "P">
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','genieNominal',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalHRef%','href="#nominalArray[i].getNOMINAL_REF()#" uuid="#arguments.uuid#"',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%checkbox%','<input type="checkbox" id="chk_#nominalArray[i].getNOMINAL_REF()#">',"ALL")>
			<cfelse>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalClass%','',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%nominalHRef%','',"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%checkbox%','',"ALL")>
			</cfif>								
			
			<cfset returnTable &= thisNominal>			  
		</cfloop>				
	    <Cfset returnTable &=duplicate(variables.nominalLongTableFooter)>	
				
	<cfelse>
		<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	</cfif> 
	  
	<cfreturn returnTable>  
	  	  
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