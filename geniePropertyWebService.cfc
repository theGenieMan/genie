
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.crimeClass="genieCrimeLink">

<cfsavecontent variable="variables.propertyTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="8%">DATE</th>
		<th width="12%">CRIME</th>		
		<th width="15%">USAGE</th>		
		<th width="45%">ITEM</th>		
		<th width="22%">NOTES</th>
		<th width="2%">ID</th>	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.propertyTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.propertyTableRow">
    <tr>
    	<td valign="top">%DATE%</td>
		<td valign="top">
		 <strong>  
			<a href="%CRIME_NO%" class="%crimeClass%" searchUUID="%searchUUID%">%CRIME_NO%</a>
		 </strong>
		</td>
		<td valign="top">
		  %USAGE%			
		</td>
		<td valign="top">%ITEM%</td>		
		<td valign="top">%NOTES%</td>		
		<td valign="top">%ID%</td>				  						  				
    </tr>	
</cfsavecontent>

  <cffunction name="validatePropertyEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates an property enquiry">
	 <cfset var pArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var pItem="">
	 <cfset var pDataFound=false>	
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#pArgs#" item="pItem">
	 	 <cfif Len(StructFind(pArgs,pItem)) GT 0>
		   <cfset pDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not pDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>		
		<cfelse>
			<cfif Len(pArgs.date_from1) GT 0>
				<cfif not LSIsDate(pArgs.date_from1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date From `#pArgs.date_from1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(pArgs.date_from2) GT 0>
				<cfif not LSIsDate(pArgs.date_from2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Date To `#pArgs.date_from2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(pArgs.date_from1) GT 0 AND Len(pArgs.date_from2) GT 0>
				<cfif LSIsDate(pArgs.date_from1) AND LSIsDate(pArgs.date_from2)>
					<cfif dateDiff('d',LSParseDateTime(pArgs.date_from1),LSParseDateTime(pArgs.date_from2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date To `#pArgs.date_from2#` must be after Date From  `#pArgs.date_from1#`.","|")>	
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

  <cffunction name="doPropertyEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do property enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">		    
		  
		<cfset enquiryResults = application.genieService.doPropertyEnquiry(searchTerms=searchData, 
																		  searchUUID=thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doPropertyEnquiryTable(property=enquiryResults,
			                                        searchUUID=thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doPropertyEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="property" required="true" type="query" hint="query of property objects to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">	  
	
	<cfset var returnTable="">
	<cfset var thisProp="">
	<cfset var iProp="">  
    <cfset var item="">
	
	   <!--- if no results then no results table --->
	   <cfif property.recordCount IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.propertyTableHeader)>
		
		<cfloop query="property">
		 	  	
			<cfset thisProp=duplicate(variables.propertyTableRow)>
				  							
			<cfset thisProp=ReplaceNoCase(thisProp,'%DATE%',DateFormat(DATE_USED,"DD/MM/YYYY"),"ALL")>
			<cfset thisProp=ReplaceNoCase(thisProp,'%CRIME_NO%',CRIME_NUMBER,"ALL")>
			<cfset thisProp=ReplaceNoCase(thisProp,'%USAGE%',USAGE,"ALL")>
			
			<cfset item=CATEGORY>
			<cfif Len(SUB_CATEGORY) GT 0>
				<cfset item &= "("&SUB_CATEGORY&")">
			</cfif>
		 	<cfif Len(VRM) GT 0 OR Len(Manufacturer) GT 0 OR Len(Model) GT 0 OR Len(CHASSIS_NUMBER) GT 0 
 		  	    OR Len(ENGINE_NUMBER) GT 0 OR Len(FRAME_NUMBER) GT 0>
		  	    <cfset item &= "<br>#VRM# #MANUFACTURER# #MODEL# #CHASSIS_NUMBER# #ENGINE_NUMBER# #FRAME_NUMBER#">
		    </cfif>
			<cfif Len(CARD_NUMBER) GT 0 Or Len(CHEQUE_NUMBERS) GT 0>
		      <cfset item &= "<br>#CARD_NUMBER# #CARD_EXPIRY# #CHEQUE_NUMBERS#">
		    </cfif>
		    <cfif Len(MAN_SERIAL_NUMBER) GT 0>
			  <cfset item &= "<br><b>Serial No</b> : #MAN_SERIAL_NUMBER#">
		    </cfif>
		    <cfif Len(DOCUMENT_NUMBER) GT 0>
		      <cfset item &= "<br>#DOCUMENT_NUMBER# #BANK_SORT_CODE# #DOCUMENT_NAME#">
            </cfif>
		    <cfif Len(Unit) GT 0 OR Len(QUANTITY) GT 0 OR Len(PROP_VALUE)>
		      <cfset item &= "<br>Unit : #UNIT#, Quantity : #QUANTITY#">
			  <cfif Len(PROP_VALUE) GT 0>
			  	<cfset item &=", Value : #PROP_VALUE#">
			  </cfif>
		    </cfif>		
			<cfset thisProp=ReplaceNoCase(thisProp,'%ITEM%',item,"ALL")>
			<cfset thisProp=ReplaceNoCase(thisProp,'%NOTES%',NOTES&iif(Len(OTHER_MARKS) GT 0,de('<Br>'&OTHER_MARKS),de('')),"ALL")>
			<cfset thisProp=ReplaceNoCase(thisProp,'%ID%',IDENTIFIABLE,"ALL")>
			<cfset thisProp=ReplaceNoCase(thisProp,'%crimeClass%',variables.crimeClass,"ALL")>			
			<cfset thisProp=ReplaceNoCase(thisProp,'%searchUUID%',arguments.searchUUID,"ALL")>						
			
			<cfset returnTable &= thisProp>
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.propertyTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
  <cffunction name="propCategoryLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="true" type="string" hint="what to search on">
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qPropCat="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_PropCat')>  
	      
		<cfquery name="qPropCat" dbtype="query">
		 SELECT PRPC_CODE, DESCRIPTION
	  	 FROM     queryTable
	  	 <cfif searchText IS NOT "*">
    	 WHERE  (('F'||DESCRIPTION) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> OR ('F'||prpc_code) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar">)
		 </cfif>	
		 ORDER BY description
		</cfquery>
    
      <cfreturn  qPropCat>
    
  </cffunction>
  
  <cffunction name="propSubCategoryLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="false" default="" type="string" hint="what to search on">
	  <cfargument name="categoryCode" required="true" type="string" hint="category to filter on">	
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qSubCategory="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_SubCats')>  
	      
		<cfquery name="qSubCategory" dbtype="query">
		SELECT   PRPC_CODE, PSC_CODE, SUB_DESC, CAT_DESC
		FROM     queryTable
		WHERE (1=1)
		<cfif Len(searchText) GT 0>
    	AND  (('F'||SUB_DESC) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> OR ('F'||psc_code) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">)
		</cfif>
		AND      prpc_code=<cfqueryparam value ="#arguments.categoryCode#" cfsqltype="cf_sql_varchar">	
		ORDER BY sub_desc	
		</cfquery>
    
      <cfreturn  qSubCategory>
    
  </cffunction>   

  <cffunction name="propManufacturerLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="true" type="string" hint="what to search on">
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qManu="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_Manu')>  
	      
		<cfquery name="qManu" dbtype="query">
		 SELECT MNF_CODE, DESCRIPTION
	  	 FROM     queryTable	  	 
    	 WHERE  (('F'||DESCRIPTION) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar"> OR ('F'||mnf_code) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar">)		 
		 ORDER BY DESCRIPTION	
		</cfquery>
    
      <cfreturn  qManu>
    
  </cffunction>

  <cffunction name="propModelLookup" access="remote" output="false" returntype="any" returnformat="JSON">
  	  <cfargument name="searchText" required="false" default="" type="string" hint="what to search on">
	  <cfargument name="manufacturerCode" required="true" type="string" hint="manufacturer to filter on">	
    
      <cfset var returnStruct=structNew()>
	  <cfset var returnArray=arrayNew(1)>
	  <cfset var qModel="">
	  <cfset var queryTable=application.genieVarService.getAppVar('qry_Model')>  
	      
		<cfquery name="qModel" dbtype="query">
		SELECT   MOD_CODE, DESCRIPTION AS MOD_DESC, MNF_CODE, MAN_DESC
		FROM     queryTable
		WHERE (1=1)
		<cfif Len(searchText) GT 0>
    	AND  (('F'||DESCRIPTION) LIKE <cfqueryparam value ="'F#UCase(arguments.searchText)#" cfsqltype="cf_sql_varchar"> OR ('F'||mod_code) LIKE <cfqueryparam value ="'F%#UCase(arguments.searchText)#%" cfsqltype="cf_sql_varchar">)
		</cfif>
		AND      mnf_code=<cfqueryparam value ="#arguments.manufacturerCode#" cfsqltype="cf_sql_varchar">	
		ORDER BY mod_desc
		</cfquery>
    
      <cfreturn  qModel>
    
  </cffunction>   

</cfcomponent>