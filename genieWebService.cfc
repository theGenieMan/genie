<cfcomponent>
<cfset locale=SetLocale("English (UK)")>
	
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


<cfsavecontent variable="variables.nominalShortNoResults">
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
	<td valign="top"><a class="%nominalClass%">%nominalRef%</a></td>
	<td valign="top" class="fullName"><a class="%nominalClass%">%fullName%</a>%relationship%</td>
	<td valign="top">%DOB%</td>
	<td valign="top">%AGE%</td>
	<td valign="top" align="center">%warningData%</td>
	<td valign="top" align="center">%photoData%</td>
	<td valign="top" align="center">%addressData%</td>	
	<td valign="top" align="center">%clickData%</td>
</tr>	
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
   
</cfcomponent>