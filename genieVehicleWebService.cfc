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
	  <cfset var resultType=searchData.resultType>
	    
	  <!--- remove the none search related elements from the search terms --->
	  <cfset structDelete(searchData,'wMids')>	  
	  <cfset structDelete(searchData,'resultType')>
	  <cfset structDelete(searchData,'enquiryUser')>
	  <cfset structDelete(searchData,'enquiryUserName')>
	  <cfset structDelete(searchData,'enquiryUserDept')>
	  <cfset structDelete(searchData,'requestFor')>
	  <cfset structDelete(searchData,'reasonCode')>  
	  <cfset structDelete(searchData,'reasonText')>
	  <cfset structDelete(searchData,'sessionId')>  
	  <cfset structDelete(searchData,'terminalId')>    	    
	
		<cfset vehicleResults = application.genieService.doWestMerciaVehicleSearch(searchTerms=searchData)>  
		
		<cfif resultType IS "XML">
		
		<cfelseif resultType IS "html">						
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
		<cfset var searchXml = "<risp:vrm>$vrm$</risp:vrm>">
		
		
	
		<cfset searchXml = Replace(searchXml, '$vrm$', searchData.vrm)>		
		
		<cfset westMidsResults = application.genieService.doWestMidsVehicleSearch(searchTerms=searchXml,
																				 userId=auditData.enquiryUser,
																				 terminalId=auditData.terminalId,
																				 sessionId=auditData.sessionId, 		                                                                         
																				 fromWebService='Y',
																				 wsAudit=auditData)>
		<cfif westMidsResults.searchOK>      
			<cfset westMidsHTML = formatWestMidsResults(westMidsResults.vehicles)>
		<cfelse>
			<cfset westMidsHTML =  "<h4 align='center'>The West Midlands search did not complete successfully</h4>">
			<cfset westMidsHTML &= "<p align='center'>The Error Code is : <b>"&westMidsResults.errorText&"</b><br><br>">
			<cfset westMidsHTML &= "If the error code is 408 Request Time-out this means that search at the West Midlands end ">
			<cfset westMidsHTML &= "did not respond within #Ceiling(application.wMidsTimeout/60)# minutes. You may need to refine your search as broad searches can ">
			<cfset westMidsHTML &= "lead to long running requests which have an adverse effect on GENIE performance.</p>">
			
			<cfmail   to="nick.blackham@westmercia.pnn.police.uk"
					from="genie@westmercia.pnn.police.uk"
					subject="GENIE - West Mids Vehicle Unsuccessful"
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

	<cffunction name="formatWestMidsResults" output="false" returntype="any" access="private"
	            hint="formats the west mids results for display">
		<cfargument name="vehicles" type="any" required="true" 
		            hint="west mids results to be formatted"/>		
	
		<cfset var returnHTML = "">
		<cfset var iVeh = 1>
		<cfset var thisVeh = "">
		
	
		<cfif arrayLen(vehicles) IS 0>
			<cfset returnHTML = "<p><b>Your Search Returned No Results</b></p>">
		<cfelse>
			 <cfoutput>
			    <cfsavecontent variable="thisVeh">
					<div class="vehicleResult">
						<table width="98%" class="genieData">
						 <thead>	
						 <tr>
							<th width="5%">Force</th>				 
							<th width="10%">System Name</th>
							<th width="15%">Reference</th>
							<th width="15%">VRM</th>	
							<th width="20%">Make</th>	
							<th width="20%">Model</th>	
							<th width="20%">Colour</th>	 
						 </tr>
						 </thead>
						 <tbody>
			             <cfloop from="1" to="#arrayLen(vehicles)#" index="iVeh">
			             <tr>
			               <td>#vehicles[iVeh].getDISPLAY_FORCE()#</td>
			               <td>#vehicles[iVeh].getAPP_REF()#</td>
			               <td>#vehicles[iVeh].getSYS_REF()#</td>
			               <td>
			                  <cfif vehicles[iVeh].getAPP_REF() IS NOT "FLINT" and vehicles[iVeh].getAPP_REF() IS NOT "BOF2">                    
			                   <a href="#vehicles[iVeh].getAPP_REF()#|#vehicles[iVeh].getSYS_REF()#|#vehicles[iVeh].getFORCE_REF()#|VEHICLE|#vehicles[iVeh].getVRM()#" class="wMidsVehicle">
			                  </cfif>                       
			                       #vehicles[iVeh].getVRM()#
			                  <cfif vehicles[iVeh].getAPP_REF() IS NOT "FLINT" and vehicles[iVeh].getAPP_REF() IS NOT "BOF2"> 
			                   </a>
			                  </cfif>
			               </td>  
						   <td>#vehicles[iVeh].getMANUFACTURER()#</td>
						   <td>#vehicles[iVeh].getMODEL()#</td>
						   <td>#vehicles[iVeh].getPRIMARY_COL()#</td>                                                       
			             </tr>
			             </cfloop>
			             </tbody> 
			            </table>
			       </div>     					
				</cfsavecontent>	
			 </cfoutput>	
				<cfset returnHTML &= thisVeh>

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