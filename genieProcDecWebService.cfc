
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.caseClass="genieCaseLink">
<cfset variables.custodyClass="genieCustodyLink">
<cfset variables.nominalClass="genieNominal">
<cfset variables.pdOffencesClass="geniePDOffences">

<cfsavecontent variable="variables.pdTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="12%">Proc No</th>
		<th width="12%">Case File</th>
		<th width="10%">Custody Ref</th>		
		<th width="8%">Formalised</th>		
		<th width="8%">Nominal Ref</th>				  
		<th width="20%">Defendant</th>				  
		<th width="8%">DOB</th>				  
		<th width="3%">Sex</th>				  				
		<th width="8%">Decision</th>		
		<th width="10%">&nbsp;</th>		
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.pdTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.pdTableRow">
    <tr>
		<td valign="top">%PD_REF%</td>
		<td valign="top">%CASE_LINK%</td>
		<td valign="top"><b>%CUSTODY_LINK%</b></td>		
		<td valign="top">%DATE_FORMALISED%</td>		
		<td valign="top"><strong><a href="%NOMINAL_REF%" class="genieNominal">%NOMINAL_REF%</a></strong></td>				  
		<td valign="top"><strong><a href="%NOMINAL_REF%" class="genieNominal">%DEFENDANT%</a></strong></td>				  
		<td valign="top">%DOB%</td>				  
		<td valign="top">%SEX%</td>				  				
		<td valign="top">%DECISION%</td>		
		<td valign="top">%OFFENCES_LINK%</td>		
    </tr>	
</cfsavecontent>


  <cffunction name="validatePDEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a process decision search">
	 <cfset var pdArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var pdItem="">
	 <cfset var pdDataFound=false>	
	  	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#pdArgs#" item="pdItem">
	 	 <cfif Len(StructFind(pdArgs,pdItem)) GT 0>
		   <cfset pdDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not pdDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>		
		<cfelse>
			<cfif Len(pdArgs.case_serial) GT 0>
				<cfif not isNumeric(pdArgs.case_serial)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Case File Serial No must be a number","|")>					
				</cfif>
			</cfif>
			<cfif Len(pdArgs.date_form1) GT 0>
				<cfif not LSIsDate(pdArgs.date_form1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Formalised Between/On `#pdArgs.date_form1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(pdArgs.date_form2) GT 0>
				<cfif not LSIsDate(pdArgs.date_form2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Formalised To `#pdArgs.date_form2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
		    <cfif Len(pdArgs.date_form1) GT 0 AND Len(pdArgs.date_form2) GT 0>
				<cfif LSIsDate(pdArgs.date_form1) AND LSIsDate(pdArgs.date_form2)>
					<cfif dateDiff('d',LSParseDateTime(pdArgs.date_form1),LSParseDateTime(pdArgs.date_form2)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Formalised To `#pdArgs.date_form2#` must be after Formalised Between/On `#pdArgs.date_form1#`.","|")>	
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

  <cffunction name="doPDEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do process decsion enquiry">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">
	
		<cfset enquiryResults = application.genieService.doPDEnquiry(searchTerms=searchData, searchUUID=thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doPDEnquiryTable(enquiryResults,thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doPDEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="pds" required="true" type="array" hint="array of pd objects to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">  
	
	<cfset var returnTable="">
	<cfset var thisPd="">
	<cfset var thisPdNom="">
	<cfset var iPd="">  
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(pds) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.pdTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(pds)#" index="iPd">		  	  	
			<cfset thisPd=duplicate(variables.pdTableRow)>
			
			<cfset thisPd=ReplaceNoCase(thisPd,'%caseClass%',variables.caseClass,"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%pdOffencesClass%',variables.pdOffencesClass,"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%nominalClass%',variables.nominalClass,"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%PD_REF%',pds[iPd].getPD_REF(),"ALL")>
			<cfif Len(pds[iPd].getCASE_NO()) GT 0>
				<cfset thisPd=ReplaceNoCase(thisPd,'%CASE_LINK%','<b><a href="'&pds[iPd].getCASE_NO()&'" class="'&variables.caseClass&'" caseType="'&pds[iPd].getCASE_TYPE()&'">'&pds[iPd].getCASE_NO()&'</a></b>',"ALL")>
			<cfelse>
				<cfset thisPd=ReplaceNoCase(thisPd,'%CASE_LINK%','',"ALL")>
			</cfif>
			<cfset thisPd=ReplaceNoCase(thisPd,'%CASE_TYPE%',pds[iPd].getCASE_TYPE(),"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%DATE_FORMALISED%',pds[iPd].getDATE_FORMALISED_TEXT(),"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%DECISION%',pds[iPd].getDECISION(),"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%DOB%',pds[iPd].getDOB_TEXT(),"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%SEX%',pds[iPd].getSEX(),"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%NOMINAL_REF%',pds[iPd].getNOMINAL_REF(),"ALL")>
			<cfset thisPd=ReplaceNoCase(thisPd,'%DEFENDANT%',pds[iPd].getDEFENDANT(),"ALL")>
			<cfif Len(pds[iPd].getCUSTODY_REF()) GT 0>
				<cfset thisPd=ReplaceNoCase(thisPd,'%CUSTODY_LINK%',"<strong><a href='"&pds[iPd].getCUSTODY_REF()&"' custodyType='"&pds[iPd].getCUSTODY_TYPE()&"' class='"&variables.custodyClass&"'>"&pds[iPd].getCUSTODY_REF()&"</a></strong>","ALL")>
			<cfelse>
				<cfset thisPd=ReplaceNoCase(thisPd,'%CUSTODY_LINK%','',"ALL")>
			</cfif>
			<cfset thisPd=ReplaceNoCase(thisPd,'%OFFENCES_LINK%',"<strong><a href='"&pds[iPd].getCASE_NO()&"' pdRef='"&pds[iPd].getPD_REF()&"' nominalRef='"&pds[iPd].getNOMINAL_REF()&"' class='"&variables.pdOffencesClass&"'>Offence Details</a></strong>","ALL")>
					
			<cfset returnTable &= thisPd>			  
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.pdTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
</cfcomponent>