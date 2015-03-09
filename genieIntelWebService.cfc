
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.intelClass="genieIntelLink">
<cfset variables.nominalClass="genieNominal">

<cfsavecontent variable="variables.intelTableHeader">
%HIGHER_LOGS_MESSAGE%	
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="5%">LOG</th>
		<th width="8%">EVALUTAION</th>
		<th width="3%">SAL</th>		
		<th width="20%">DATE FROM/TO</th>		
		<th width="17%">SOURCE DOC REF</th>
		<th width="35%">INDICATOR</th>		
		<th width="10%">CREATED</th>
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.intelTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.intelTableRow">
    <tr>
		<td valign="top">
		 <strong>  
			<a href="%LOG_REF%" class="%intelClass%" searchUUID="%searchUUID%" handCode="%HAND_CODE%" handGuide="%HAND_GUIDANCE%">%LOG_REF%</a>
		 </strong>
		</td>
		<td valign="top">%EVALUATION%</td>
		<td valign="top">%SECURITY_ACCESS_LEVEL%</td>		
		<td valign="top">%DATE_START% To %DATE_END%</td>		
		<td valign="top">%SOURCE_DOC_REF%</td>				  
		<td valign="top"><strong>%INDICATOR%</strong></td>				  
		<td valign="top">%DATE_CREATED%</td>				  				
    </tr>	
</cfsavecontent>

<cfsavecontent variable="variables.intelNominalRow">
    <tr>
		<td colspan="7">
		  <b>Nominals Indexed On Log %LOG_REF%: </b><br>
		  %NOMINAL_DATA%
		</td>						  				
    </tr>	
</cfsavecontent>

<cfsavecontent variable="variables.higherLogsMessage">
<div class="error_title" align="center">
OTHER LOGS ARE RECORDED FOR WHICH YOU DO NOT HAVE ACCESS
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.intelFTSTableHeader">
%HIGHER_LOGS_MESSAGE%	
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
 		<th>&nbsp;</td>
		<th width="5%">LOG</td>
		<th width="5%">EVAL</td>
		<th width="5%">POL AREA</td>
		<th width="5%">SAL</td>		
		<th width="18%">DATE FROM/TO</td>		
		<th width="17%">SOURCE DOC REF</td>		
		<th width="35%">INDICATOR</td>				
		<th width="10%">CREATED</td>	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.intelFTSTableRow">
    <tr>
    	<td>
			<div class="summaryIcon genieMagglass">
				<div style="display:none;" id="dre%LOG_REF%" class="summaryData">
					  %DRE_DATA%
				</div>    		
			</div>
    	</td>
		<td valign="top">
		 <strong>  
			<a href="%LOG_REF%" class="%intelClass%" searchUUID="%searchUUID%" handCode="%HAND_CODE%" handGuide="%HAND_GUIDANCE%">%LOG_REF%</a>
		 </strong>
		</td>
		<td valign="top">%EVALUATION%</td>
		<td valign="top">%DIVISION%</td>
		<td valign="top">%SECURITY_ACCESS_LEVEL%</td>		
		<td valign="top">%DATE_START% To %DATE_END%</td>		
		<td valign="top">%SOURCE_DOC_REF%</td>				  
		<td valign="top"><strong>%INDICATOR%</strong></td>				  
		<td valign="top">%DATE_CREATED%</td>				  				
    </tr>	
</cfsavecontent>

<cfsavecontent variable="variables.intelByAreaTableHeader">	
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
			<th width="5%">LOG</th>
			<th width="3%">SAL</th>		
			<th width="12%">CREATED</th>		
			<th width="12%">SOURCE DOC REF</th>			
			<th width="18%">INDICATOR</th>		
			<th width="50%">NOMINAL / ADDRESS</th>
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.intelByAreaTableRow">	
<tr>
 <td valign="top">
 <strong>  
  <a href="%LOG_REF%" class="%intelClass%" searchUUID="%searchUUID%" handCode="%HAND_CODE%" handGuide="%HAND_GUIDANCE%">%LOG_REF%</a>
	 </strong>	 			
 </td>
 <td valign="top">%SECURITY_ACCESS_LEVEL%</td>
 <td valign="top">%DATE_CREATED%</td>
 <td valign="top">%SOURCE_DOC_REF%</td>
 <td valign="top">%INDICATOR%</td>
 <td valign="top">
	%NOMINAL_DATA%
	%INTEL_ADDRESS%	
 </td>
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.intelByAreaNominal">     	
	 <b><a href='%NOMINAL_REF%' class='genieNominal'>%FULL_NAME%</a></b>
	 <br>
	 Address: <b>%ADDRESS%</b> (%DATE_REC%)	
</cfsavecontent>	

<cfsavecontent variable="variables.intelByAreaFooter">
  </tbody>
</table>	
</cfsavecontent>

  <cffunction name="validateIntelEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates an intel search">
	 <cfset var intArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var intItem="">
	 <cfset var intDataFound=false>	
	
	 <cfset structDelete(intArgs,'includeNominals')>  	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#intArgs#" item="intItem">
	 	 <cfif Len(StructFind(intArgs,intItem)) GT 0>
		   <cfset intDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not intDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>		
		<cfelse>
			<cfif Len(intArgs.date_created1) GT 0>
				<cfif not LSIsDate(intArgs.date_created1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Created Between/On `#intArgs.date_created1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(intArgs.date_created2) GT 0>
				<cfif not LSIsDate(intArgs.date_created2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Created To `#intArgs.date_created2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(intArgs.date_created1) GT 0 AND Len(intArgs.date_created2) GT 0>
				<cfif LSIsDate(intArgs.date_created1) AND LSIsDate(intArgs.date_created2)>
					<cfif dateDiff('d',LSParseDateTime(intArgs.date_created1),LSParseDateTime(intArgs.date_created2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Created To `#intArgs.date_created2#` must be after Created Between/On `#intArgs.date_created1#`.","|")>	
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doIntelEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do intel enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">	
	  <cfset var includeNominals=searchData.includeNominals>
	  <cfset var userAccessLevel=searchData.userAccessLevel>  
	
	  <!--- remove the none search related elements from the search terms --->	  
	  <cfset structDelete(searchData,'includeNominals')>
	  <cfset structDelete(searchData,'userAccessLevel')>  
	
		<cfset enquiryResults = application.genieService.doIntelEnquiry(searchTerms=searchData, 
																		searchUUID=thisUUID, 
																		includeNominals=includeNominals)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doIntelEnquiryTable(intel=enquiryResults,
			                                        searchUUID=thisUUID, 
													includeNominals=includeNominals, 
													userAccessLevel=userAccessLevel)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doIntelEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="intel" required="true" type="array" hint="array of intel objects to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">
	<cfargument name="includeNominals" required="false" type="string" default="N" hint="include indexed nominals in results">
	<cfargument name="userAccessLevel" required="false" type="string" default="99" hint="user doing the enquiries log access level">  
	
	<cfset var returnTable="">
	<cfset var thisIntel="">
	<cfset var thisIntelNomRow="">
	<cfset var thisIntelNomsData="">
	<cfset var thisIntelNominals="">
	<cfset var iInt="">  
	<cfset var higherLogsFlag=false>
	<cfset var thisNom="">
	<cfset var iNom="">
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(intel) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.intelTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(intel)#" index="iInt">
		 <cfif intel[iInt].getSECURITY_ACCESS_LEVEL() GTE arguments.userAccessLevel>		  	  	
			<cfset thisIntel=duplicate(variables.intelTableRow)>
									
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%LOG_REF%',intel[iInt].getLOG_REF(),"ALL")>
			<cfif Len(intel[iInt].getSOURCE_CODE()) GT 0>
				<cfset thisIntel=ReplaceNoCase(thisIntel,'%EVALUATION%',intel[iInt].getSOURCE_CODE()&intel[iInt].getINFO_CODE()&intel[iInt].getHAND_CODE()&intel[iInt].getHAND5_OPT(),"ALL")>
			<cfelse>
				<cfset thisIntel=ReplaceNoCase(thisIntel,'%EVALUATION%','',"ALL")>
			</cfif>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%SECURITY_ACCESS_LEVEL%',intel[iInt].getSECURITY_ACCESS_LEVEL(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_START%',intel[iInt].getDATE_START_TEXT(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_END%',intel[iInt].getDATE_END_TEXT(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%SOURCE_DOC_REF%',intel[iInt].getSOURCE_DOC_REF(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%INDICATOR%',intel[iInt].getINDICATOR(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_CREATED%',intel[iInt].getDATE_CREATED_TEXT(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%HAND_CODE%',intel[iInt].getHAND_CODE(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%HAND_GUIDANCE%',intel[iInt].getHAND_GUIDANCE(),"ALL")>
			
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%searchUUID%',arguments.searchUUID,"ALL")>	
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%intelClass%',variables.intelClass,"ALL")>							
			
			<cfif includeNominals IS "Y">
				<cfset thisIntelNomRow=duplicate(variables.intelNominalRow)>
				<cfset thisIntelNominals=intel[iInt].getINDEXED_NOMINALS()>
				<cfset thisIntelNomsData="">
				<cfloop from="1" to="#arrayLen(thisIntelNominals)#" index="iNom">
					<cfset thisNom=thisIntelNominals[iNom]>
					<cfif iNom GT 1>
						<cfset thisIntelNomsData &= "<br>">
					</cfif>
					<cfset thisIntelNomsData &= '<a href="'&thisNom.getNOMINAL_REF()&'" class="%nominalClass%">'&thisNom.getFULL_NAME()&' ('&thisNom.getNOMINAL_REF()&')</a> DOB:'&thisNom.getDATE_OF_BIRTH_TEXT()>					
				</cfloop>
				<cfset thisIntelNomRow=ReplaceNoCase(thisIntelNomRow,'%NOMINAL_DATA%',thisIntelNomsData)>
				<cfset thisIntelNomRow=ReplaceNoCase(thisIntelNomRow,'%LOG_REF%',intel[iInt].getLOG_REF())>	
	   		</cfif>
			<cfset thisIntel &= thisIntelNomRow>	
			
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%nominalClass%',variables.nominalClass,"ALL")>
			
			<cfset returnTable &= thisIntel>
		 <cfelse>
		 	 <cfset higherLogsFlag=true>			  
		 </cfif>
		</cfloop>
		
		<cfif higherLogsFlag>
			<cfset returnTable=ReplaceNoCase(returnTable,'%HIGHER_LOGS_MESSAGE%',variables.higherLogsMessage,"ALL")>
		<cfelse>
			<cfset returnTable=ReplaceNoCase(returnTable,'%HIGHER_LOGS_MESSAGE%','',"ALL")>
		</cfif>
				
	    <Cfset returnTable &=duplicate(variables.intelTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

  <cffunction name="validateIntelFTS" access="remote" returntype="string" returnformat="plain" output="false" hint="validates an intel free text search">
	 <cfset var intArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	  
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	    <cfif Len(intArgs.search_text) IS 0>
			<cfset validation.valid=false>
	    	<cfset validation.errors=ListAppend(validation.errors,"You must enter some search text","|")>					
		</cfif>
	 
 		<cfif Len(intArgs.date_created1) GT 0>
			<cfif not LSIsDate(intArgs.date_created1)>
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"Created Between/On `#intArgs.date_created1#` is not a valid date.","|")>	
			</cfif>
		</cfif>
		<cfif Len(intArgs.date_created2) GT 0>
			<cfif not LSIsDate(intArgs.date_created2)>
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"Created To `#intArgs.date_created2#` is not a valid date.","|")>					
			</cfif>
		</cfif>
	    <cfif Len(intArgs.date_created1) GT 0 AND Len(intArgs.date_created2) GT 0>
			<cfif LSIsDate(intArgs.date_created1) AND LSIsDate(intArgs.date_created2)>
				<cfif dateDiff('d',LSParseDateTime(intArgs.date_created1),LSParseDateTime(intArgs.date_created2)) LT 0>
					<cfset validation.valid=false>
	    			<cfset validation.errors=ListAppend(validation.errors,"Created To `#intArgs.date_created2#` must be after Created Between/On `#intArgs.date_created1#`.","|")>	
				</cfif>
			</cfif>
		</cfif>
	
	<cfif validation.valid>
		<cfreturn true>
	<cfelse>
		<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
	</cfif>
				 			
  </cffunction>
  
  <cffunction name="doIntelFTS" access="remote" returntype="string" returnFormat="plain" output="false" hint="do intel free text search">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">	
	  
		<cfset enquiryResults=application.genieService.doWestMerciaIntelFreeText(searchText=searchData.search_text,
  																		 division=searchData.division,
																		 order=searchData.sort_order,
																		 fromDate=searchData.date_created1,
																		 toDate=searchData.date_created2,
																		 relevance=searchData.relevance,
																		 accessLevel=searchData.userAccessLevel)>
			
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doIntelFTSTable(resultStruct=enquiryResults,
			                                        searchUUID=thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>  

  <cffunction name="doIntelFTSTable" access="private" output="false" returntype="string">
  	<cfargument name="resultStruct" required="true" type="struct" hint="struct with array of intel objects to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">  
	
	<cfset var intel="">
	<cfset var returnTable="">
	<cfset var thisIntel="">
	<cfset var iInt="">  
	
	   <!--- if no results then no results table --->
	   <cfif resultStruct.totalHits IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   	<cfset intel=resultStruct.logRefs>   
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.intelFTSTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(intel)#" index="iInt">		 		  	  	
			<cfset thisIntel=duplicate(variables.intelFTSTableRow)>
									
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%LOG_REF%',intel[iInt].getLOG_REF(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DRE_DATA%',resultStruct.logDRES[iInt],"ALL")>
			<cfif Len(intel[iInt].getSOURCE_CODE()) GT 0>
				<cfset thisIntel=ReplaceNoCase(thisIntel,'%EVALUATION%',intel[iInt].getSOURCE_CODE()&intel[iInt].getINFO_CODE()&intel[iInt].getHAND_CODE()&intel[iInt].getHAND5_OPT(),"ALL")>
			<cfelse>
				<cfset thisIntel=ReplaceNoCase(thisIntel,'%EVALUATION%','',"ALL")>
			</cfif>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%SECURITY_ACCESS_LEVEL%',intel[iInt].getSECURITY_ACCESS_LEVEL(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_START%',intel[iInt].getDATE_START_TEXT(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_END%',intel[iInt].getDATE_END_TEXT(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%SOURCE_DOC_REF%',intel[iInt].getSOURCE_DOC_REF(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%INDICATOR%',intel[iInt].getINDICATOR(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_CREATED%',intel[iInt].getDATE_CREATED_TEXT(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%HAND_CODE%',intel[iInt].getHAND_CODE(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%HAND_GUIDANCE%',intel[iInt].getHAND_GUIDANCE(),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DIVISION%',intel[iInt].getDIVISION(),"ALL")>
			
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%searchUUID%',arguments.searchUUID,"ALL")>	
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%intelClass%',variables.intelClass,"ALL")>									
			
			<cfset returnTable &= thisIntel>
		 
		</cfloop>
		
		<cfif resultStruct.hasHigherAccessLogs>
			<cfset returnTable=ReplaceNoCase(returnTable,'%HIGHER_LOGS_MESSAGE%',variables.higherLogsMessage,"ALL")>
		<cfelse>
			<cfset returnTable=ReplaceNoCase(returnTable,'%HIGHER_LOGS_MESSAGE%','',"ALL")>
		</cfif>
				
	    <Cfset returnTable &=duplicate(variables.intelTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

  <cffunction name="validateIntelByArea" access="remote" returntype="string" returnformat="plain" output="false" hint="validates an intel by area search">
	 <cfset var intArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var intItem="">
	 <cfset var intDataFound=true>	
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#intArgs#" item="intItem">
	 	 <cfif Len(StructFind(intArgs,intItem)) IS 0>
		   <cfset intDataFound=false>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not intDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into ALL search fields","|")>		
		<cfelse>
			<cfif Len(intArgs.dateFrom) GT 0>
				<cfif not LSIsDate(intArgs.dateFrom)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date From `#intArgs.dateFrom#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(intArgs.dateTo) GT 0>
				<cfif not LSIsDate(intArgs.dateTo)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date To `#intArgs.dateTo#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(intArgs.dateFrom) GT 0 AND Len(intArgs.dateTo) GT 0>
				<cfif LSIsDate(intArgs.dateFrom) AND LSIsDate(intArgs.dateTo)>
					<cfif dateDiff('d',LSParseDateTime(intArgs.dateFrom),LSParseDateTime(intArgs.dateTo)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date To `#intArgs.dateTo#` must be after Date From `#intArgs.dateFrom#`.","|")>	
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>
  
     <cffunction name="doIntelByArea" access="remote" returntype="string" returnFormat="plain" output="false" hint="do intel by area search">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  <cfargument name="sal" type="string" required="true" default="99" hint="security access level of the user querying">	 
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">
	  <cfset var qUserIntel = "">  	
	  
	  <cfsavecontent variable="dumpSearch">
	  	  <cfdump var="#searchData#" format="text">
	  </cfsavecontent>
	  
	  <cflog file="intelByArea" type="information" text="#dumpSearch#">
	  
		<cfset enquiryResults=application.genieService.getIntelByArea(area=searchData.area,
		                                                              dateFrom=searchData.dateFrom,
																	  dateTo=searchData.dateTo)>			
		
		<!--- work out if any logs are above the security access level of the person logged in, query back just those they can see --->
    	<cfquery name="qUserIntel" dbtype="query">
		SELECT *
		FROM   enquiryResults
		WHERE  SECURITY_ACCESS_LEVEL >= <cfqueryparam value="#searchData.sal#" cfsqltype="cf_sql_numeric">
		ORDER BY DATE_CREATED DESC
		</cfquery>	
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doIntelByAreaTable(resultQuery=qUserIntel,
			                                        searchUUID=thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>  
  
   <cffunction name="doIntelByAreaTable" access="private" output="false" returntype="string">
  	<cfargument name="resultQuery" required="true" type="query" hint="query of intel results">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">  
	
	<cfset var intel="">
	<cfset var returnTable="">
	<cfset var thisIntel="">
	<cfset var iInt="">  
	<cfset var thisNominal="">
	
	   <!--- if no results then no results table --->
	   <cfif resultQuery.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   	   
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.intelByAreaTableHeader)>
		
		<cfloop query="resultQuery">		 		  	  	
			<cfset thisIntel=duplicate(variables.intelByAreaTableRow)>
									
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%LOG_REF%',LOG_REF,"ALL")>			
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%SECURITY_ACCESS_LEVEL%',SECURITY_ACCESS_LEVEL,"ALL")>			
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%SOURCE_DOC_REF%',SOURCE_DOC_REF,"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%INDICATOR%',INDICATOR,"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DATE_CREATED%',DateFormat(DATE_CREATED,"DD/MM/YYYY"),"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%HAND_CODE%',HAND_CODE,"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%HAND_GUIDANCE%',HAND_GUIDANCE,"ALL")>
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%DIVISION%',DIVISION,"ALL")>
			
			<cfif Len(NOMINAL_REF) GT 0>
				<cfset thisNominal=duplicate(variables.intelByAreaNominal)>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%NOMINAL_REF%',NOMINAL_REF,"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%FULL_NAME%',FULL_NAME,"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%ADDRESS%',ADDRESS,"ALL")>
				<cfset thisNominal=ReplaceNoCase(thisNominal,'%DATE_REC%',DATE_REC,"ALL")>
				<cfset thisIntel=ReplaceNoCase(thisIntel,'%NOMINAL_DATA%',thisNominal,"ALL")>
			    <cfset thisIntel=ReplaceNoCase(thisIntel,'%INTEL_ADDRESS%','',"ALL")>					 
			<cfelse>
				 <cfset thisIntel=ReplaceNoCase(thisIntel,'%NOMINAL_DATA%','',"ALL")>
				 <cfset thisIntel=ReplaceNoCase(thisIntel,'%INTEL_ADDRESS%',ADDRESS,"ALL")>	
	 		</cfif>
			
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%searchUUID%',arguments.searchUUID,"ALL")>	
			<cfset thisIntel=ReplaceNoCase(thisIntel,'%intelClass%',variables.intelClass,"ALL")>									
			
			<cfset returnTable &= thisIntel>
		 
		</cfloop>		
				
	    <cfset returnTable &=duplicate(variables.intelTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
</cfcomponent>