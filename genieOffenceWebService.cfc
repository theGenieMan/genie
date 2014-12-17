
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.crimeClass="genieCrimeLink">
<cfset variables.incidentClass="genieOISLink">

<cfsavecontent variable="variables.offenceTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th>Crime No</th>
		<th>Incident</th>
		<th>Offence</th>
		<th>Date</th>		
		<th>Detected</th>
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.offenceTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.offenceTableRow">
    <tr>
		<td valign="top">
		 <strong>  
			<a href="%CRIME_NO%" class="%crimeClass%" searchUUID="%searchUUID%">%CRIME_NO%</a>
		 </strong>
		</td>
		<td valign="top">
		  <a href="%INCIDENT_NO%" class="%incidentClass%">	
			%INCIDENT_NO%
          </a>			
		</td>
		<td valign="top">%OFFENCE%</td>		
		<td valign="top">%OFFENCE_DATES%</td>		
		<td valign="top">%DETECTED%</td>				  						  				
    </tr>	
</cfsavecontent>

<cfsavecontent variable="variables.crimeBrowserRow">
	<table align="center" width="100%" class="wmpData">
	 
	 <tr>
	  <th width="12%">Crime No</th>
	  <th width="12%">Date Created</th>
	  <th width="70%">Offence</th>
	  <th width="6%">Beat</th>
	 </tr>
	 <tr>
	  <td rowspan="3" valign="top">
		
	   <b><a href="%CRIME_NO%" searchUUID="%searchUUID%" class="%crimeClass%">%CRIME_NO%</a></b>	
	   <br>
	   %INCIDENT_LINK%				 	   	 
		 
	  </td>
	  <td valign="top">%CREATED_DATE%</td>
	  <td valign="top">%REC_TITLE% (%HOMC%/%HOOC%)</td>
	  <td valign="top">%BEAT_CODE%</td>
	 </tr>
	 <tr>	  			 	
	  <th>Cleared Up?</th>
	  <th colspan="2">Summary</th>
	 </tr>
	 <tr>	  
	  <td valign="top" class="%detectedClass%"><b>%DETECTED_FLAG%</b></td>
	  <td valign="top" colspan="2">				    		  	
        This <strong>%REC_TITLE%</strong> occurred
		%COMMITTED_DATE%            
        <br>
        <strong>%OFFENCEADDRESS%</strong>	                                                                      
      </td>
	 </tr>						  					 
	 </table> 
	 <div style="width:95%" align="center">
	 	<div align="left">
	 		%MO%
	 	</div>
	 </div>
	 <hr>  	
</cfsavecontent>

  <cffunction name="validateOffenceEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates an intel search">
	 <cfset var offArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var offItem="">
	 <cfset var offDataFound=false>	
	
	 <cfset structDelete(offArgs,'includeNominals')>  	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#offArgs#" item="offItem">
	 	 <cfif Len(StructFind(offArgs,offItem)) GT 0>
		   <cfset offDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not offDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>		
		<cfelse>
			<cfif Len(offArgs.date_created1) GT 0>
				<cfif not LSIsDate(offArgs.date_created1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date Created Between/On `#offArgs.date_created1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(offArgs.date_created2) GT 0>
				<cfif not LSIsDate(offArgs.date_created2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date Created To `#offArgs.date_created2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(offArgs.date_created1) GT 0 AND Len(offArgs.date_created2) GT 0>
				<cfif LSIsDate(offArgs.date_created1) AND LSIsDate(offArgs.date_created2)>
					<cfif dateDiff('d',LSParseDateTime(offArgs.date_created1),LSParseDateTime(offArgs.date_created2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date Created To `#offArgs.date_created2#` must be after Created Between/On `#offArgs.date_created1#`.","|")>	
					</cfif>
				</cfif>
			</cfif>
			
			<cfif Len(offArgs.date_offence1) GT 0>
				<cfif not LSIsDate(offArgs.date_offence1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Offence Date Between/On `#offArgs.date_offence1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(offArgs.date_offence2) GT 0>
				<cfif not LSIsDate(offArgs.date_offence2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Offence Date To `#offArgs.date_offence2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(offArgs.date_offence1) GT 0 AND Len(offArgs.date_offence2) GT 0>
				<cfif LSIsDate(offArgs.date_offence1) AND LSIsDate(offArgs.date_offence2)>
					<cfif dateDiff('d',LSParseDateTime(offArgs.date_offence1),LSParseDateTime(offArgs.date_offence2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Offence Date To `#offArgs.date_offence2#` must be after Offence Date Between/On `#offArgs.date_offence1#`.","|")>	
					</cfif>
				</cfif>
			</cfif>			
			
			<cfif Len(offArgs.date_reported1) GT 0>
				<cfif not LSIsDate(offArgs.date_reported1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date Reported Between/On `#offArgs.date_reported1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(offArgs.date_reported2) GT 0>
				<cfif not LSIsDate(offArgs.date_reported2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date Reported To `#offArgs.date_reported2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(offArgs.date_reported1) GT 0 AND Len(offArgs.date_reported2) GT 0>
				<cfif LSIsDate(offArgs.date_reported1) AND LSIsDate(offArgs.date_reported2)>
					<cfif dateDiff('d',LSParseDateTime(offArgs.date_reported1),LSParseDateTime(offArgs.date_reported2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date Reported To `#offArgs.date_reported2#` must be after Date Reported Between/On `#offArgs.date_reported1#`.","|")>	
					</cfif>
				</cfif>
			</cfif>		
			
			<cfif Len(offArgs.date_horeported1) GT 0>
				<cfif not LSIsDate(offArgs.date_horeported1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date HO Reported Between/On `#offArgs.date_horeported1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(offArgs.date_horeported2) GT 0>
				<cfif not LSIsDate(offArgs.date_horeported2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date HO Reported To `#offArgs.date_horeported2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(offArgs.date_horeported1) GT 0 AND Len(offArgs.date_horeported2) GT 0>
				<cfif LSIsDate(offArgs.date_horeported1) AND LSIsDate(offArgs.date_horeported2)>
					<cfif dateDiff('d',LSParseDateTime(offArgs.date_horeported1),LSParseDateTime(offArgs.date_horeported2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date HO Reported To `#offArgs.date_horeported2#` must be after Date HO Reported Between/On `#offArgs.date_horeported1#`.","|")>	
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

  <cffunction name="doOffenceEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do offence enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">		    
		  
		<cfset enquiryResults = application.genieService.doOffenceEnquiry(searchTerms=searchData, 
																		  searchUUID=thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doOffenceEnquiryTable(offences=enquiryResults,
			                                        searchUUID=thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doOffenceEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="offences" required="true" type="array" hint="array of intel objects to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">	  
	
	<cfset var returnTable="">
	<cfset var thisOff="">
	<cfset var iOff="">  
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(offences) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.offenceTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(offences)#" index="iOff">
		 		  	  	
			<cfset thisOff=duplicate(variables.offenceTableRow)>
									
			<cfset thisOff=ReplaceNoCase(thisOff,'%CRIME_REF%',offences[iOff].getCRIME_REF(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%CRIME_NO%',offences[iOff].getCRIMENO(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%INCIDENT_NO%',offences[iOff].getINCIDENT_NO(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%OFFENCE%',offences[iOff].getREP_TITLE(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DETECTED%',offences[iOff].getDETECTED_DESC(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%OFFENCE_DATES%',offences[iOff].getCOMMITTED(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%crimeClass%',variables.crimeClass,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%incidentClass%',variables.incidentClass,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%searchUUID%',arguments.searchUUID,"ALL")>			
			
			<!---
			<cfif Len(intel[iOff].getSOURCE_CODE()) GT 0>
				<cfset thisOff=ReplaceNoCase(thisOff,'%EVALUATION%',intel[iOff].getSOURCE_CODE()&intel[iOff].getINFO_CODE()&intel[iOff].getHAND_CODE()&intel[iOff].getHAND5_OPT(),"ALL")>
			<cfelse>
				<cfset thisOff=ReplaceNoCase(thisOff,'%EVALUATION%','',"ALL")>
			</cfif>
			<cfset thisOff=ReplaceNoCase(thisOff,'%SECURITY_ACCESS_LEVEL%',intel[iOff].getSECURITY_ACCESS_LEVEL(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DATE_START%',intel[iOff].getDATE_START_TEXT(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DATE_END%',intel[iOff].getDATE_END_TEXT(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%SOURCE_DOC_REF%',intel[iOff].getSOURCE_DOC_REF(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%INDICATOR%',intel[iOff].getINDICATOR(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DATE_CREATED%',intel[iOff].getDATE_CREATED_TEXT(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%HAND_CODE%',intel[iOff].getHAND_CODE(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%HAND_GUIDANCE%',intel[iOff].getHAND_GUIDANCE(),"ALL")>
			
			<cfset thisOff=ReplaceNoCase(thisOff,'%searchUUID%',arguments.searchUUID,"ALL")>	
			<cfset thisOff=ReplaceNoCase(thisOff,'%intelClass%',variables.intelClass,"ALL")>							
			
			<cfif includeNominals IS "Y">
				<cfset thisOffNomRow=duplicate(variables.offences[iOff]ominalRow)>
				<cfset thisOffNominals=intel[iOff].getINDEXED_NOMINALS()>
				<cfset thisOffNomsData="">
				<cfloop from="1" to="#arrayLen(thisOffNominals)#" index="iNom">
					<cfset thisNom=thisOffNominals[iNom]>
					<cfif iNom GT 1>
						<cfset thisOffNomsData &= "<br>">
					</cfif>
					<cfset thisOffNomsData &= '<a href="'&thisNom.getNOMINAL_REF()&'" class="%nominalClass%">'&thisNom.getFULL_NAME()&' ('&thisNom.getNOMINAL_REF()&')</a> DOB:'&thisNom.getDATE_OF_BIRTH_TEXT()>					
				</cfloop>
				<cfset thisOffNomRow=ReplaceNoCase(thisOffNomRow,'%NOMINAL_DATA%',thisOffNomsData)>
				<cfset thisOffNomRow=ReplaceNoCase(thisOffNomRow,'%LOG_REF%',intel[iOff].getLOG_REF())>	
	   		</cfif>
			<cfset thisOff &= thisOffNomRow>	
			
			<cfset thisOff=ReplaceNoCase(thisOff,'%nominalClass%',variables.nominalClass,"ALL")>
			--->
			<cfset returnTable &= thisOff>
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.offenceTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
  <cffunction name="wmcRecRepAsLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="true" type="string" hint="what to search on">
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qWMCRecAs="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_WMCRecordedAS')>  
	      
		<cfquery name="qWMCRecAs" dbtype="query">
		SELECT WMC_OFFENCE_CODE, SHORT_OFFENCE_TITLE
		FROM   queryTable
		WHERE  (('F'||WMC_OFFENCE_CODE) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> OR ('F'||SHORT_OFFENCE_TITLE) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">)
		ORDER BY 1
		</cfquery>
    
      <cfreturn  qWMCRecAs>
    
  </cffunction>
  
  <cffunction name="wmcHOMCLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="true" type="string" hint="what to search on">
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qHOMC="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_HOMC')>  
	      
		<cfquery name="qHOMC" dbtype="query">
		SELECT   homc_code, description
		FROM     queryTable
    	WHERE  (('F'||DESCRIPTION) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> OR ('F'||homc_code) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar">)	
		ORDER BY homc_code	
		</cfquery>
    
      <cfreturn  qHOMC>
    
  </cffunction>  
  
  <cffunction name="wmcHOOCLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="false" default="" type="string" hint="what to search on">
	  <cfargument name="homcCode" required="true" type="string" hint="homc to filter on">	
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qHOOC="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_HOOC')>  
	      
		<cfquery name="qHOOC" dbtype="query">
		SELECT   homc_code, description
		FROM     queryTable
		WHERE (1=1)
		<cfif Len(searchText) GT 0>
    	AND  (('F'||DESCRIPTION) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> OR ('F'||homc_code) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">)
		</cfif>
		AND      homc_code=<cfqueryparam value ="#arguments.homcCode#" cfsqltype="cf_sql_varchar">	
		ORDER BY homc_code	
		</cfquery>
    
      <cfreturn  qHOOC>
    
  </cffunction>   

  <cffunction name="validateCrimeBrowser" access="remote" returntype="string" returnformat="plain" output="false" hint="validates an intel search">
	 <cfset var offArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var offItem="">
	 <cfset var offDataFound=false>	
	
	 <cfset structDelete(offArgs,'includeNominals')>  	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
     <cfif Len(offArgs.frmDateFrom) IS 0
	    OR Len(offArgs.frmDateTo) IS 0
		OR Len(offArgs.frmTimeFrom) IS 0
		OR Len(offArgs.frmTimeTo) IS 0
		OR Len(offArgs.frmOffenceGroupings) IS 0>
		<cfset validation.valid=false>
		<cfset validation.errors=ListAppend(validation.errors,"Date/Time From/To and at least 1 theme must be completed ","|")>			
	 <cfelse>		
			<cfif Len(offArgs.frmDateFrom) GT 0>
				<cfif not LSIsDate(offArgs.frmDateFrom)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date From `#offArgs.frmDateFrom#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(offArgs.frmDateTo) GT 0>
				<cfif not LSIsDate(offArgs.frmDateTo)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date To `#offArgs.frmDateTo#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(offArgs.frmDateFrom) GT 0 AND Len(offArgs.frmDateTo) GT 0>
				<cfif LSIsDate(offArgs.frmDateFrom) AND LSIsDate(offArgs.frmDateTo)>
					<cfif dateDiff('d',LSParseDateTime(offArgs.frmDateFrom),LSParseDateTime(offArgs.frmDateTo)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date To `#offArgs.frmDateTo#` must be after Date From `#offArgs.frmDateFrom#`.","|")>	
					</cfif>
				</cfif>
			</cfif>
			<cfif not isValid('time',offArgs.frmTimeFrom)>
				<cfset validation.valid=false>
		    	<cfset validation.errors=ListAppend(validation.errors,"Time From `#offArgs.frmTimeFrom#`is not valid.","|")>				
			</cfif>
			<cfif not isValid('time',offArgs.frmTimeTo)>
				<cfset validation.valid=false>
		    	<cfset validation.errors=ListAppend(validation.errors,"Time To `#offArgs.frmTimeTo#`is not valid.","|")>
			</cfif>
	  </cfif>
	  	
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doCrimeBrowser" access="remote" returntype="string" returnFormat="plain" output="false" hint="do crime browser enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">		    
		  
		<cfset enquiryResults = application.genieService.doCrimeBrowserSearch(Form=searchData, 
																		      searchUUID=thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    							
			<cfset returnData = "<div>"&doCrimeBrowserTable(offences=enquiryResults.query,searchUUID=thisUUID)&"<span id='noResults'>"&enquiryResults.query.recordCount&"</span></div>">			                                        			 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

   <cffunction name="doCrimeBrowserTable" access="private" output="false" returntype="string">
  	<cfargument name="offences" required="true" type="query" hint="query of offences to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">	  
	
	<cfset var returnTable="">
	<cfset var thisOff="">	
	<cfset var sCommitted="">
	<cfset var sIncLink="">
	
	   <!--- if no results then no results table --->
	   <cfif offences.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->		
		
				
		<cfloop query="offences">
		 <cfset sCommitted="">
		 <cfset sIncLink="">
		   		  	  	
			<cfset thisOff=duplicate(variables.crimeBrowserRow)>
									
			<cfset thisOff=ReplaceNoCase(thisOff,'%CRIME_REF%',CRIME_REF,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%CRIME_NO%',CRIME_NO,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%REC_TITLE%',REC_TITLE,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%HOMC%',HOMC,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%HOOC%',HOOC,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%MO%',MO,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%BEAT_CODE%',BEAT_CODE,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%OFFENCEADDRESS%',OFFENCEADDRESS,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%CREATED_DATE%',DateFormat(CREATED_DATE,"DD/MM/YYYY"),"ALL")>
						
			<cfif Len(LAST_COMMITTED) GT 0>
				<cfsavecontent variable="sCommitted">
				<cfoutput>
	            between <strong>#DateFormat(FIRST_COMMITTED,'DDD DD/MM/YYYY')# #TimeFormat(FIRST_COMMITTED,'HH:mm')#</strong> and
	            <strong>#DateFormat(LAST_COMMITTED,'DDD DD/MM/YYYY')# #TimeFormat(LAST_COMMITTED,'HH:mm')#</strong>.
				</cfoutput>
				</cfsavecontent>
        	<cfelse>
				<cfsavecontent variable="sCommitted">
				<cfoutput>	
            	on <strong>#DateFormat(FIRST_COMMITTED,'DDD DD/MM/YYYY')# #TimeFormat(FIRST_COMMITTED,'HH:mm')#</strong>.
				</cfoutput>
				</cfsavecontent>
        	</cfif>
        	
        	<cfif Len(INCIDENT_NO) GT 0>
				<cfoutput>
				<cfsavecontent variable="sIncLink">
			    <br>
				<a href="#INCIDENT_NO#" class="genieOISLink">#INCIDENT_NO#</a>		
				</cfsavecontent>
				</cfoutput>
				<cfset thisOff=ReplaceNoCase(thisOff,'%INCIDENT_LINK%',sIncLink,"ALL")>
			<cfelse>
				<cfset thisOff=ReplaceNoCase(thisOff,'%INCIDENT_LINK%','',"ALL")>
			</cfif>
			
			<cfset thisOff=ReplaceNoCase(thisOff,'%COMMITTED_DATE%',sCommitted,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%detectedClass%',IIF(DETECTED_FLAG IS '1',DE('undetected'),DE('detected')),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DETECTED_FLAG%',IIF(DETECTED_FLAG IS '1',DE('Detected'),DE('Undetected')),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%crimeClass%',variables.crimeClass,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%incidentClass%',variables.incidentClass,"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%searchUUID%',arguments.searchUUID,"ALL")>			
			
			<!---
			<cfif Len(intel[iOff].getSOURCE_CODE()) GT 0>
				<cfset thisOff=ReplaceNoCase(thisOff,'%EVALUATION%',intel[iOff].getSOURCE_CODE()&intel[iOff].getINFO_CODE()&intel[iOff].getHAND_CODE()&intel[iOff].getHAND5_OPT(),"ALL")>
			<cfelse>
				<cfset thisOff=ReplaceNoCase(thisOff,'%EVALUATION%','',"ALL")>
			</cfif>
			<cfset thisOff=ReplaceNoCase(thisOff,'%SECURITY_ACCESS_LEVEL%',intel[iOff].getSECURITY_ACCESS_LEVEL(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DATE_START%',intel[iOff].getDATE_START_TEXT(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DATE_END%',intel[iOff].getDATE_END_TEXT(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%SOURCE_DOC_REF%',intel[iOff].getSOURCE_DOC_REF(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%INDICATOR%',intel[iOff].getINDICATOR(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%DATE_CREATED%',intel[iOff].getDATE_CREATED_TEXT(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%HAND_CODE%',intel[iOff].getHAND_CODE(),"ALL")>
			<cfset thisOff=ReplaceNoCase(thisOff,'%HAND_GUIDANCE%',intel[iOff].getHAND_GUIDANCE(),"ALL")>
			
			<cfset thisOff=ReplaceNoCase(thisOff,'%searchUUID%',arguments.searchUUID,"ALL")>	
			<cfset thisOff=ReplaceNoCase(thisOff,'%intelClass%',variables.intelClass,"ALL")>							
			
			<cfif includeNominals IS "Y">
				<cfset thisOffNomRow=duplicate(variables.offences[iOff]ominalRow)>
				<cfset thisOffNominals=intel[iOff].getINDEXED_NOMINALS()>
				<cfset thisOffNomsData="">
				<cfloop from="1" to="#arrayLen(thisOffNominals)#" index="iNom">
					<cfset thisNom=thisOffNominals[iNom]>
					<cfif iNom GT 1>
						<cfset thisOffNomsData &= "<br>">
					</cfif>
					<cfset thisOffNomsData &= '<a href="'&thisNom.getNOMINAL_REF()&'" class="%nominalClass%">'&thisNom.getFULL_NAME()&' ('&thisNom.getNOMINAL_REF()&')</a> DOB:'&thisNom.getDATE_OF_BIRTH_TEXT()>					
				</cfloop>
				<cfset thisOffNomRow=ReplaceNoCase(thisOffNomRow,'%NOMINAL_DATA%',thisOffNomsData)>
				<cfset thisOffNomRow=ReplaceNoCase(thisOffNomRow,'%LOG_REF%',intel[iOff].getLOG_REF())>	
	   		</cfif>
			<cfset thisOff &= thisOffNomRow>	
			
			<cfset thisOff=ReplaceNoCase(thisOff,'%nominalClass%',variables.nominalClass,"ALL")>
			--->
			<cfset returnTable &= thisOff>
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.offenceTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

</cfcomponent>