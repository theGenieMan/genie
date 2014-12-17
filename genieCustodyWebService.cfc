
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfset variables.lis_Months="JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC">
<cfset variables.lis_MonthNos="01,02,03,04,05,06,07,08,09,10,11,12">

<cfset variables.bailTimes="08,09,10,11,12,13,14,15,16,17,18,19,20,21,22">

<cfset variables.custodyClass="genieCustodyLink">
<cfset variables.nominalClass="genieNominal">
<cfset variables.custodyPasteClass="genieCustodyPaste">
<cfset variables.custodySummaryClass="genieCustodySummary">

<cfsavecontent variable="variables.custodyWhiteboardTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
	  <th valign="top" width="3%">Stn</th>		
	  <th valign="top" width="10%">Ref</th>
	  <th valign="top" width="25%">Name</th>
	  <th valign="top" width="2%"></th>
	  <th valign="top" width="5%">DOB/Age</th>		 
	  <th valign="top" width="10%">Review</th>
	  <th valign="top" width="15%">Status</th>		 		 		 		 	  
	  <th valign="top">Officers</td>	
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.custodyWhiteboardTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.custodyWhiteboardTableRow">
<tr id="%custodyRefRP%_1">
	<td valign="top"><b>%cStn%</b></td>
	<td valign="top"><a href='%custodyRef%' class='%custodyClass%' custodyType='%custodyType%' searchUUID='%searchUUID%'>%custodyRef%</a>
	                 <br><br>
					 <a href='%custodyRef%' class='%custodyPasteClass%'>OIS Paste</a>
	</td>
	<td valign="top">
		%iomBanner%
		%ocgmBanner%
		<a href='%cNominalRef%' class='%nominalClass%'>%cNominalRef%, %cName%</a>
		%whtbPhotoDiv%
	</td>
	<td valign="top">%warningData%</td>
	<td valign="top">%cDob%<br>Age:%cAge%</td>
	<td valign="top">%reviewDate%</td>
	<td valign="top">
		<strong>Absent</strong> : %cAbsent%<br>
        <strong>Charged</strong> : %cCharged%<br>
	    <strong>Rights Read</strong> : %cRights%
	</td>
	<td valign="top">
		    <strong>Arr Off</strong><br>%aoBadge% %aoName%<br>
		<br><strong>OIC</strong> <br> %oicBadge% %oicName%
	</td>		
</tr>	
<tr id="%custodyRefRP%_2">
	<td colspan="8">
		<b>Time of Arrest</b>: %timeOfArrest%<Br>
		<b>Arrest Reason(s)</b>: %arrestReasons%<br>
		<b>Place of Arrest</b>: %placeOfArrest%
		<hr>
	</td>
</tr>	
</cfsavecontent>

<cfsavecontent variable="variables.whtbPhotoDiv">
<div align="center">
	<img src="%photoUrl%" height="100" alt="Photo Of %cNominalRef%" class="whiteboardPhoto"><br>
	%dateTaken%
</div>		
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

<cfsavecontent variable="variables.ocgmBanner">
<div class="warning" style="width:100%">
 <b>O C G M</b>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.iomBanner">
<div class="iom%iomSubType%" style="width:100%">
 <b>IOM - %iomTextType%</b>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.custodyEnquiryTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
	 <tr>
		<th width="3%">Stn</th>	 
		<th width="6%">Cust Ref</th>
		<th width="5%">Nom Ref</th>
		<th width="22%">PIC/Place of Arrest</th>	
		<th>&nbsp;</th>
		<th>&nbsp;</th>	
		<th width="5%">DOB</th>		
		<th width="30%">Arrest/Departure Reason</th>
  	    <th width="10%">Arrest Date</th>
		<th width="12%">Arresting Officer</th>	
		<th width="5%">&nbsp;</th>	
	 </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.custodyEnquiryTableRow">
	 <tr id="custRef%CUSTODY_REF%">
		<td valign="top"><b>%cStn%</b></td>	 
		<td valign="top"><a href='%custodyRef%' class='%custodyClass%' custodyType='%custodyType%' searchUUID='%searchUUID%'>%custodyRef%</a><br><br><a href='%custodyRef%' nominalRef="%cNominalRef%" class='%custodySummaryClass%'>Summary</a></td>
		<td valign="top"><a href='%cNominalRef%' class='%nominalClass%'>%cNominalRef%</a></td>
		<td valign="top">%iomBanner%
		    %ocgmBanner%
			<a href='%cNominalRef%' class='%nominalClass%'>%cName%</a><br><br>%placeOfArrest%</td>	
		<td valign="top">%photoDiv%</td>
		<td valign="top">%warningData%</td>	
		<td valign="top">%cDob%</td>		
		<td valign="top">%arrestReasons%<br><br>%departureReasons%</td>
  	    <td valign="top">%timeOfArrest%</td>
		<td valign="top">%aoBadge% %aoName%</td>	
		<td valign="top"><a href='%custodyRef%' class='%custodyPasteClass%'>Paste</a></td>	
	 </tr>
</cfsavecontent>

<cfsavecontent variable="variables.bailDiaryTableHeader">
 <table width="98%" class="genieData">
  <thead>
	<tr>
		<td width="1%">&nbsp;</td>	
		%CUSTODY_SUITE_HEADERS%
	</tr>
  </thead>
  <tbody>
</cfsavecontent>

<cfsavecontent variable="variables.bailConditionsTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th nowrap>CUSTODY</th>
		<th nowrap>NOMINAL</th>
		<th nowrap>DATE SET</th>
		<th>CONDITIONS</th>
    </tr>
  </thead>  	
</cfsavecontent>

<cfsavecontent variable="variables.bailConditionsTableRow">
<tr>	
	<td valign="top" width="12%">
		<a href='%custodyRef%' class='%custodyClass%' custodyType='%custodyType%' searchUUID='%searchUUID%'>%custodyRef%</a>	                 
	</td>
	<td valign="top" width="20%">
		<a href='%nominalRef%' class='%nominalClass%'>%nominalRef%, %nominalName%</a>	
	</td>
	<td valign="top" width="15%">%conditiondate%</td>	
	<td valign="top">
		 <ol class="bailConditions">%theConditions%</ol>
	</td>		
</tr>	
</cfsavecontent>

<!---
width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor="000000" style="margin-bottom:5px;"

 <table>
	<tr>
		<td rowspan="2" style="font-size:130%; font-weight:bold" width="10%" align="center">%SEQ_NO%</td>
	    <td width="10%"><b>Condition</b></td>
	    <td>%CONDITION%</td>
	</tr>
	<tr>
	    <td width="10%"><b>Reason</b></td>
	    <td>%REASON%</td>
	</tr>						
 </table>

--->
<cfsavecontent variable="variables.bailConditionsReasonTableRow">
  <li><b>Condition</b>: %CONDITION%<br>
  <b>Reason</b>: %REASON%  	
</cfsavecontent>	

  <cffunction name="validateCustodyEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a person search">
	 <cfset var ceArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var ceItem="">
	 <cfset var ceDataFound=false>	 	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#ceArgs#" item="ceItem">
	 	 <cfif Len(StructFind(ceArgs,ceItem)) GT 0>
		   <cfset ceDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not ceDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>		
		<cfelse>
			<cfif Len(ceArgs.dob_1) GT 0>
				<cfif not LSIsDate(ceArgs.dob_1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"DOB Between/On `#ceArgs.dob_1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(ceArgs.dob_2) GT 0>
				<cfif not LSIsDate(ceArgs.dob_2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"DOB To `#ceArgs.dob_2#` is not a valid date.","|")>					
				</cfif>
			</cfif>
			<cfif Len(ceArgs.arrest_date_1) GT 0>
				<cfif not LSIsDate(ceArgs.arrest_date_1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Arrest Date Between/On `#ceArgs.arrest_date_1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(ceArgs.arrest_date_2) GT 0>
				<cfif not LSIsDate(ceArgs.arrest_date_2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Arrest Date To `#ceArgs.arrest_date_2#` is not a valid date.","|")>					
				</cfif>
			</cfif>		
			<cfif Len(ceArgs.dep_date_1) GT 0>
				<cfif not LSIsDate(ceArgs.dep_date_1)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Departure Date Between/On `#ceArgs.dep_date_1#` is not a valid date.","|")>	
				</cfif>
			</cfif>
			<cfif Len(ceArgs.dep_date_2) GT 0>
				<cfif not LSIsDate(ceArgs.dep_date_2)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Departure Date To `#ceArgs.dep_date_2#` is not a valid date.","|")>					
				</cfif>
			</cfif>		
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doCustodyWhiteboard" access="remote" returntype="string" returnFormat="plain" output="false" hint="custody whiteboard search">  	  	  	
      <cfargument name="custodySuite" type="string" required="true" hint="Custody Suite Code to get whiteboard for. Can use ALL (all custody suites), ALLWP (all warks), ALL WMP (all west mercia)" >
	  <cfargument name="resultType" type="string" required="false" default="html" hint="Type of return, xml or html table. Default html table" >  

      <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnTable=''>
	  <cfset var nominalXml="">
	  <cfset var whiteboardResults = "">
	  <cfset var nominalXmlResults="">
	  <cfset var thisUUID=createUUID()>
	
		<cfset whiteboardResults = application.genieService.doCustodyWhiteboard(custodySuite=arguments.custodySuite, 
		                                                                        pasteReq='Y',
																			    auditReq='Y',
																				searchUUID=thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">						
				<cfset returnData = doCustodyWhiteboardTable(whiteboardResults,thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>
		
  <cffunction name="doCustodyWhiteboardTable" access="private" output="false" returntype="string">
  	<cfargument name="custodies" required="true" type="array" hint="array of custody object to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">  
	
	<cfset var returnTable="">
	<cfset var thisCustody="">
	<cfset var thisCustodyNom="">
	<cfset var thisCustodyNomW="">
	<cfset var thisPhoto="">
	<cfset var iCust="">  
	<cfset var iWarn="">
	<cfset var isOCGM="">
	<cfset var isIOM="">
	<cfset var iomClass="">
	<cfset var reasonText="">
    <cfset var iReason="">
	<cfset var arrestReasons="">
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(custodies) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.custodyWhiteboardTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(custodies)#" index="iCust">		  	  	
			<cfset thisCustody=duplicate(variables.custodyWhiteboardTableRow)>
			<cfset thisCustodyNom=custodies[iCust].getNOMINAL()>
			
			<!--- do the nominal photo --->
			<cfif thisCustodyNom.getLATEST_PHOTO().getPHOTO_URL() IS NOT "/genie_photos/noimage.gif">
			    <cfset thisPhoto=duplicate(variables.whtbPhotoDiv)>
				<cfset thisPhoto=Replace(thisPhoto,'%photoUrl%',thisCustodyNom.getLATEST_PHOTO().getPHOTO_URL())>
				<cfset thisPhoto=Replace(thisPhoto,'%dateTaken%',thisCustodyNom.getLATEST_PHOTO().getDatePhotoTaken())>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%whtbPhotoDiv%',thisPhoto,"ALL")>
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%whtbPhotoDiv%','',"ALL")>		
	   		</cfif>
	   		
	   		<!--- do the warnings, see if an IO or OC nominal --->
			<cfset isOCGM=false>
			<cfset isIOM=false>
			<cfset iomClass="">
			<cfset thisCustodyNomW=thisCustodyNom.getWARNINGS()>
			<cfloop from="1" to="#ArrayLen(thisCustodyNomW)#" index="iWarn">
				<cfif thisCustodyNomW[iWarn].getWSC_CODE() IS "OC">
					<cfset isOCGM=true>
				</cfif>
				<cfif thisCustodyNomW[iWarn].getWSC_CODE() IS "IO">
					<cfset isIOM=true>
					<cfset iomClass=thisCustodyNomW[iWarn].getSUB_TYPE()>
				</cfif>
			</cfloop>   	

			<cfif isOCGM>
			  <cfset thisCustody=ReplaceNoCase(thisCustody,'%ocgmBanner%',variables.ocgmBanner,"ALL")>			    	
			<cfelse>
			  <cfset thisCustody=ReplaceNoCase(thisCustody,'%ocgmBanner%','',"ALL")>
			</cfif>
			
			<cfif isIOM>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomBanner%',variables.iomBanner,"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomSubType%',iomClass,"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomTextType%',ReplaceList(iomClass,'1,2,3,4','RED,AMBER,GREEN,IN CUSTODY'),"ALL")>
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomBanner%','',"ALL")>
			</cfif>
			
			<cfif Len(thisCustodyNom.getWARNINGS_TEXT()) GT 0>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%warningData%',variables.warningDiv,"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%shortName%',custodies[iCust].getNAME(),"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%Warnings%',thisCustodyNom.getWARNINGS_TEXT(),"ALL")>									
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%warningData%',"","ALL")>
			</cfif>

			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyClass%',variables.custodyClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyPasteClass%',variables.custodyPasteClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%nominalClass%',variables.nominalClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyRefRP%',Replace(custodies[iCust].getCUSTODY_REF(),"/","_","ALL"),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyRef%',custodies[iCust].getCUSTODY_REF(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cStn%',custodies[iCust].getSTATION(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cNominalRef%',custodies[iCust].getNOMINAL_REF(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cName%',custodies[iCust].getNAME(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cDob%',custodies[iCust].getDOB_TEXT(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cAge%',custodies[iCust].getAGE(),"ALL")>			
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%placeOfArrest%',custodies[iCust].getPLACE_OF_ARREST(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%timeOfArrest%',custodies[iCust].getARREST_TIME_TEXT(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cAbsent%',iif(custodies[iCust].getSTATUS() IS "C",de('N'),de('Y')),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cCharged%',custodies[iCust].getCHARGED(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cRights%',custodies[iCust].getRIGHTS(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%reviewDate%',custodies[iCust].getNEXT_REVIEW_DATE_TEXT(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%aoBadge%',custodies[iCust].getAO_BADGE(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%aoName%',custodies[iCust].getAO_NAME(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%oicBadge%',custodies[iCust].getOIC_BADGE(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%oicName%',custodies[iCust].getOIC_NAME(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyType%',custodies[iCust].getCUSTODY_TYPE(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%searchUUID%',arguments.searchUUID,"ALL")>
			
			<!--- do the arrest reasons --->
			<cfset arrestReasons=custodies[iCust].getCustodyReasons()>
			<cfset reasonText=''>
			<cfloop from="1" to="#arrayLen(arrestReasons)#" index="iReason">
				<cfset reasonText = ListAppend(reasonText,iif(iReason GT 1,DE(' '),de(''))&arrestReasons[iReason].getSEQ_NO()&". "&arrestReasons[iReason].getARREST_REASON_TEXT(),",")>
			</cfloop>		
			
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%arrestReasons%',reasonText,"ALL")>
						
			<cfset returnTable &= thisCustody>			  
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.custodyWhiteboardTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
  <cffunction name="doCustodyEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="custody whiteboard search">
  	  <cfargument name="resultType" type="string" required="false" default="html" hint="result format, options html or xml">
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">
	
		<cfset enquiryResults = application.genieService.doCustodyEnquiry(searchTerms=searchData, searchUUID=thisUUID)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">					    				
			<cfset returnData = doCustodyEnquiryTable(enquiryResults,thisUUID)>				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doCustodyEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="custodies" required="true" type="array" hint="array of custody object to create the table from">
	<cfargument name="searchUUID" required="false" type="string" hint="unique id of this search">  
	
	<cfset var returnTable="">
	<cfset var thisCustody="">
	<cfset var thisCustodyNom="">
	<cfset var thisCustodyNomW="">
	<cfset var thisPhoto="">
	<cfset var iCust="">  
	<cfset var iWarn="">
	<cfset var isOCGM="">
	<cfset var isIOM="">
	<cfset var iomClass="">
	<cfset var reasonText="">
    <cfset var iReason="">
	<cfset var arrestReasons="">
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(custodies) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.custodyEnquiryTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(custodies)#" index="iCust">		  	  	
			<cfset thisCustody=duplicate(variables.custodyEnquiryTableRow)>
			<cfset thisCustodyNom=custodies[iCust].getNOMINAL()>
			
			<!--- do the nominal photo --->
			<cfif thisCustodyNom.getLATEST_PHOTO().getPHOTO_URL() IS NOT "/genie_photos/noimage.gif">
			    <cfset thisPhoto=duplicate(variables.photoDiv)>
				<cfset thisPhoto=Replace(thisPhoto,'%photoUrl%',thisCustodyNom.getLATEST_PHOTO().getPHOTO_URL())>
				<cfset thisPhoto=Replace(thisPhoto,'%photoDate%',thisCustodyNom.getLATEST_PHOTO().getDatePhotoTaken())>
				<cfset thisPhoto=ReplaceNoCase(thisPhoto,'%photoTitle%',thisCustodyNom.getSURNAME_1()&iif(Len(thisCustodyNom.getSURNAME_2()) GT 0,DE('-'&thisCustodyNom.getSURNAME_2()),de(''))&" "&thisCustodyNom.getNOMINAL_REF(),"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%photoDiv%',thisPhoto,"ALL")>
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%photoDiv%','',"ALL")>		
	   		</cfif> 
			
			<!--- do the nominal photo --->
			<cfif thisCustodyNom.getLATEST_PHOTO().getPHOTO_URL() IS NOT "/genie_photos/noimage.gif">
			    <cfset thisPhoto=duplicate(variables.whtbPhotoDiv)>
				<cfset thisPhoto=Replace(thisPhoto,'%photoUrl%',thisCustodyNom.getLATEST_PHOTO().getPHOTO_URL())>
				<cfset thisPhoto=Replace(thisPhoto,'%dateTaken%',thisCustodyNom.getLATEST_PHOTO().getDatePhotoTaken())>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%whtbPhotoDiv%',thisPhoto,"ALL")>
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%whtbPhotoDiv%','',"ALL")>		
	   		</cfif> 
	   		
	   		<!--- do the warnings, see if an IO or OC nominal --->
			<cfset isOCGM=false>
			<cfset isIOM=false>
			<cfset iomClass="">
			<cfset thisCustodyNomW=thisCustodyNom.getWARNINGS()>
			<cfloop from="1" to="#ArrayLen(thisCustodyNomW)#" index="iWarn">
				<cfif thisCustodyNomW[iWarn].getWSC_CODE() IS "OC">
					<cfset isOCGM=true>
				</cfif>
				<cfif thisCustodyNomW[iWarn].getWSC_CODE() IS "IO">
					<cfset isIOM=true>
					<cfset iomClass=thisCustodyNomW[iWarn].getSUB_TYPE()>
				</cfif>
			</cfloop>   	

			<cfif isOCGM>
			  <cfset thisCustody=ReplaceNoCase(thisCustody,'%ocgmBanner%',variables.ocgmBanner,"ALL")>			    	
			<cfelse>
			  <cfset thisCustody=ReplaceNoCase(thisCustody,'%ocgmBanner%','',"ALL")>
			</cfif>
			
			<cfif isIOM>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomBanner%',variables.iomBanner,"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomSubType%',iomClass,"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomTextType%',ReplaceList(iomClass,'1,2,3,4','RED,AMBER,GREEN,IN CUSTODY'),"ALL")>
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%iomBanner%','',"ALL")>
			</cfif>
			
			<cfif Len(thisCustodyNom.getWARNINGS_TEXT()) GT 0>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%warningData%',variables.warningDiv,"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%shortName%',custodies[iCust].getNAME(),"ALL")>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%Warnings%',thisCustodyNom.getWARNINGS_TEXT(),"ALL")>									
			<cfelse>
				<cfset thisCustody=ReplaceNoCase(thisCustody,'%warningData%',"","ALL")>
			</cfif>

			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyClass%',variables.custodyClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyPasteClass%',variables.custodyPasteClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodySummaryClass%',variables.custodySummaryClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%nominalClass%',variables.nominalClass,"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyRefRP%',Replace(custodies[iCust].getCUSTODY_REF(),"/","_","ALL"),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyRef%',custodies[iCust].getCUSTODY_REF(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cStn%',custodies[iCust].getSTATION(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cNominalRef%',custodies[iCust].getNOMINAL_REF(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cName%',custodies[iCust].getNAME(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cDob%',custodies[iCust].getDOB_TEXT(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cAge%',custodies[iCust].getAGE(),"ALL")>			
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%placeOfArrest%',custodies[iCust].getPLACE_OF_ARREST(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%timeOfArrest%',custodies[iCust].getARREST_TIME_TEXT(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cAbsent%',iif(custodies[iCust].getSTATUS() IS "C",de('N'),de('Y')),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cCharged%',custodies[iCust].getCHARGED(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%cRights%',custodies[iCust].getRIGHTS(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%reviewDate%',custodies[iCust].getNEXT_REVIEW_DATE_TEXT(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%aoBadge%',custodies[iCust].getAO_BADGE(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%aoName%',custodies[iCust].getAO_NAME(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%oicBadge%',custodies[iCust].getOIC_BADGE(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%oicName%',custodies[iCust].getOIC_NAME(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%custodyType%',custodies[iCust].getCUSTODY_TYPE(),"ALL")>
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%searchUUID%',arguments.searchUUID,"ALL")>
			
			<!--- do the arrest reasons --->
			<cfset arrestReasons=custodies[iCust].getCustodyReasons()>
			<cfset reasonText=''>
			<cfloop from="1" to="#arrayLen(arrestReasons)#" index="iReason">
				<cfset reasonText = ListAppend(reasonText,iif(iReason GT 1,DE(' '),de(''))&arrestReasons[iReason].getSEQ_NO()&". "&arrestReasons[iReason].getARREST_REASON_TEXT(),",")>
			</cfloop>		
			
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%arrestReasons%',reasonText,"ALL")>
			
			<!--- do the arrest departures --->
			<cfset arrestDeps=custodies[iCust].getCustodyDepartures()>
			<cfset depText=''>
			<cfloop from="1" to="#arrayLen(arrestDeps)#" index="iDep">
				<cfset depText = ListAppend(depText,iif(iDep GT 1,DE(' '),de(''))&arrestDeps[iDep].getSERIAL_NO()&". "&arrestDeps[iDep].getREASON_FOR_DEPARTURE(),",")>
			</cfloop>
			
			<cfset thisCustody=ReplaceNoCase(thisCustody,'%departureReasons%',depText,"ALL")>
						
			<cfset returnTable &= thisCustody>			  
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.custodyWhiteboardTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

  <cffunction name="validateBailDiary" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a bail diary search">
	 <cfset var bdArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
		<cfif Len(bdArgs.diaryDate) IS 0>				
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"Bail Diary Date must be completed","|")>	
		<cfelse>
				<cfif not LSIsDate(bdArgs.diaryDate)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"Bail Diary Date `#bdArgs.diaryDate#` is not a valid date.","|")>					
				</cfif>
		</cfif>
		<cfif Len(bdArgs.custSuite) IS 0>				
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"At least one Custody Suite must be selected","|")>
	    <cfelse>
			<cfif ListLen(bdArgs.custSuite,",") GT 4>
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"A maxmium of 4 custody suites can be selected","|")>				
			</cfif>									
		</cfif>
					
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doBailDiary" access="remote" returntype="string" returnFormat="plain" output="false" hint="do the bail dairy search">  	  	  	      
	  <cfargument name="resultType" type="string" required="false" default="html" hint="Type of return, xml or html table. Default html table" >  

      <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnData="">	  
	  <cfset var bailDiary = "">	  	  
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
	
	  <cfset searchData.frmDiaryDate=searchData.diaryDate>
	  <cfset searchData.frmDiarySuite=searchData.custSuite>
	
		<cfset bailDiary = application.genieService.getWestMerciaDueOnBail(searchData)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">						
				<cfset returnData = "<div>"&doBailDiaryTable(bailDiary.bails,searchData.custSuite)&"<span id='noResults'>"&arrayLen(bailDiary.bails)&"</span></div>">				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doBailDiaryTable" access="private" output="false" returntype="string">
  	<cfargument name="bailDiary" required="true" type="array" hint="array of custody object to create the table from">
	<cfargument name="custSuites" required="false" type="string" hint="unique id of this search">  
	
	<cfset var returnTable="">
	<cfset var thisCustody="">
	<cfset var thisCustodyNom="">
	<cfset var thisCustodyNomW="">
	<cfset var thisPhoto="">
	<cfset var iCust="">  
	<cfset var iWarn="">
	<cfset var isOCGM="">
	<cfset var isIOM="">
	<cfset var iomClass="">
	<cfset var reasonText="">
    <cfset var iReason="">
	<cfset var custSuiteCols="">
	<cfset var cSuite="">
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(bailDiary) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.bailDiaryTableHeader)>
		
		<cfloop list="#custSuites#" index="cSuite" delimiters=",">
			<cfset custSuiteCols &=	 '<th width="#(90/ListLen(custSuites,","))#%">#cSuite#</th>'>
		</cfloop>
		
		<cfset returnTable = replaceNoCase(returnTable,'%CUSTODY_SUITE_HEADERS%',custSuiteCols)>
		
		
		<!--- loop round each hour of the day we are outputting as a row ***1 --->
			<cfloop list="#variables.bailTimes#" index="hourOfDay" delimiters=",">
             <cfset returnTable &= '<tr class="bailDiaryRow" valign="top">'>'
             <cfset returnTable &= '<td class="bailHour">#hourOfDay#</td>'>
				
				<!--- loop round each custody suite so we are doing each hour for each custody suite ***2 --->
				<cfset iCsuite=1>
				<cfloop list="#custSuites#" index="cSuite" delimiters=",">
					<cfset returnTable &= '<td class="row_colour#iCsuite MOD 2#">'>
					
					<cfset i=1>
					
					<!--- loop round all the bails we have been returned so we can match on the hour of day and the custody suite ***3 --->
					<cfset iCellCount=1>
					<cfloop from="1" to="#ArrayLen(bailDiary)#" index="i">
					
					    <!--- if the hour of day for this bail matches the hour we are currently on ***4 --->
						<cfif TimeFormat(bailDiary[i].bail.getBAILED_TO_DATE(),"HH") IS hourOfDay>
						
						    <!--- if the custody suite we are on matches the current custody suite ***5 --->
							<cfif bailDiary[i].bail.getBAILED_TO_TRUNC() IS cSuite>
							
							<!--- more than 1 bail in the cell so put a space between them --->
							<cfif iCellCount GT 1>
								<cfset returnTable &= '<br>'>
							</cfif>
							
							<!--- then output the bail details in this cell --->
								<cfset returnTable &= '<div style="font-weight:bold;">'>							 
							    <cfset returnTable &= '#TimeFormat(bailDiary[i].bail.getBAILED_TO_DATE(),"HH:mm")# - '>
							    <cfset returnTable &= '<a href="#bailDiary[i].bail.getCUSTODY_REF()#" custodyType="#bailDiary[i].custody.getCUSTODY_TYPE()#" class="genieCustodyLink">'> 
							    <cfset returnTable &= '#bailDiary[i].bail.getCUSTODY_REF()#'>' 
							    <cfset returnTable &= '</a>'>
							    <cfset returnTable &= ' - #bailDiary[i].custody.getOIC_BADGE()# #bailDiary[i].custody.getOIC_NAME()#'> 
							    <cfset returnTable &= ' <br> <a href="#bailDiary[i].nominal.getNOMINAL_REF()#" class="genieNominal">#bailDiary[i].nominal.getFULL_NAME()# (#bailDiary[i].nominal.getNOMINAL_REF()#)</a>'>	
							 
								 <cfset bailDetails=bailDiary[i].bail.getBailDetails()>
								 <cfset returnTable &= '<br>'>'
								 <cfloop from="1" to="#ArrayLen(bailDetails)#" index="iBailFor">
								 	 <cfif iBailFor GT 1>
									 <cfset returnTable &= ',&nbsp;'>
								     </cfif>
								     <cfset returnTable &= '#bailDetails[iBailFor].getOFFENCE_DETAIL()#'>'
								 </cfloop>						 								
								 <cfset returnTable &= '</div>'>
							 <cfset iCellCount++>
							</cfif>
							<!--- end ***5 --->
						</cfif>
						<!--- end ***4 --->
					</cfloop>
					<!--- end ***3 --->					
					
					<cfset returnTable &= ' </td>'>			
					
					<cfset iCsuite++>
				</cfloop>
			 <cfset returnTable &= '</tr>'>	
			</cfloop>
						
	    <Cfset returnTable &=duplicate(variables.custodyWhiteboardTableFooter)>	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>

  <cffunction name="validateBailConditions" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a bail conditions search">
	 <cfset var bcArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
		<cfif Len(bcArgs.frmFromDate) IS 0>				
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"From Date must be completed","|")>	
		<cfelse>
				<cfif not LSIsDate(bcArgs.frmFromDate)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"From Date `#bcArgs.frmFromDate#` is not a valid date.","|")>					
				</cfif>
		</cfif>
		
		<cfif Len(bcArgs.frmFromTime) IS 0>				
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"From Time must be completed","|")>	
		</cfif>
		
		<cfif Len(bcArgs.frmToDate) IS 0>				
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"To Date must be completed","|")>	
		<cfelse>
				<cfif not LSIsDate(bcArgs.frmToDate)>
					<cfset validation.valid=false>
		    		<cfset validation.errors=ListAppend(validation.errors,"To Date `#bcArgs.frmToDate#` is not a valid date.","|")>					
				</cfif>
		</cfif>
		
		<cfif Len(bcArgs.frmToTime) IS 0>				
				<cfset validation.valid=false>
	    		<cfset validation.errors=ListAppend(validation.errors,"To Time must be completed","|")>	
		</cfif>
		
		<cfif Len(bcArgs.frmFromDate) GT 0 AND Len(bcArgs.frmToDate) GT 0>
				<cfif LSIsDate(bcArgs.frmFromDate) AND LSIsDate(bcArgs.frmToDate)>
					<cfif dateDiff('d',LSParseDateTime(bcArgs.frmFromDate),LSParseDateTime(bcArgs.frmToDate)) LT 0>
						<cfset validation.valid=false>
		    			<cfset validation.errors=ListAppend(validation.errors,"Date To `#bcArgs.frmToDate#` must be after Date From  `#bcArgs.frmFromDate#`.","|")>	
					</cfif>
				</cfif>
		</cfif>
					
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doBailConditions" access="remote" returntype="string" returnFormat="plain" output="false" hint="do the bail conditions search">  	  	  	      
	  <cfargument name="resultType" type="string" required="false" default="html" hint="Type of return, xml or html table. Default html table" >  

      <cfset var returnXml='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><NominalSearchResults xmlns="http://tempuri.org/"><resultCount>%resultCount%</resultCount><nominalResults>%nominalResults%</nominalResults></NominalSearchResults></soap:Body></soap:Envelope>'>
	  <cfset var returnData="">	  
	  <cfset var bailConditions = "">	  	  
	  <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
	
		<cfset bailConditions = application.genieService.getWestMerciaBailConditions(searchData)>  
		
		<cfif arguments.resultType IS "XML">
		
		<cfelseif arguments.resultType IS "html">						
				<cfset returnData = "<div>"&doBailConditionsTable(bailConditions.bails)&"<span id='noResults'>"&arrayLen(bailConditions.bails)&"</span></div>">				 														
		<cfelse>
			<cfset returnData = 'No Valid Return Format Specified. options are XML  or HTML'>
		</cfif>				
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doBailConditionsTable" access="private" output="false" returntype="string">
  	<cfargument name="bails" required="true" type="array" hint="array of bails object to create the table from">
	 
	<cfset var returnTable="">
	<cfset var thisBail="">
	<cfset var thisCondition="">
	<cfset var iBail=""> 
	<cfset var arrConditions="">
	<cfset var iCond=""> 
	<cfset var theConditions="">
	
	   <!--- if no results then no results table --->
	   <cfif arrayLen(bails) IS 0>
	   	<cfset returnTable  = "<p><b>Your Search Returned No Results</b></p>">
	   <cfelse>	 
	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.bailConditionsTableHeader)>
		
		<cfloop from="1" to="#ArrayLen(bails)#" index="iBail">		  	  	
			<cfset thisBail=duplicate(variables.bailConditionsTableRow)>			

			<cfset thisBail=ReplaceNoCase(thisBail,'%custodyClass%',variables.custodyClass,"ALL")>			
			<cfset thisBail=ReplaceNoCase(thisBail,'%nominalClass%',variables.nominalClass,"ALL")>			
			<cfset thisBail=ReplaceNoCase(thisBail,'%custodyRef%',bails[iBail].custody.getCUSTODY_REF(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%custodyType%',bails[iBail].custody.getCUSTODY_TYPE(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%nominalRef%',bails[iBail].nominal.getNOMINAL_REF(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%nominalName%',bails[iBail].nominal.getFULL_NAME(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%conditionDate%',bails[iBail].bail.getDATE_SET_TEXT(),"ALL")>
			
			<cfset theConditions="">
			
			<cfset arrConditions=bails[iBail].bail.getBailConditions()>
			<cfloop from="1" to="#ArrayLen(arrConditions)#" index="iCond">
				<cfset thisCondition=duplicate(variables.bailConditionsReasonTableRow)>
				<cfset thisCondition=ReplaceNoCase(thisCondition,'%SEQ_NO%',arrConditions[iCond].getSEQ_NO(),"ALL")>
				<cfset thisCondition=ReplaceNoCase(thisCondition,'%CONDITION%',arrConditions[iCond].getCONDITION(),"ALL")>
				<cfset thisCondition=ReplaceNoCase(thisCondition,'%REASON%',arrConditions[iCond].getREASON(),"ALL")>	
				<cfset theConditions &= thisCondition>
			</cfloop>
			<cfset thisBail=ReplaceNoCase(thisBail,'%theConditions%',"<div>"&theConditions&"</div>","ALL")>
			
			<!---
			<cfset thisBail=ReplaceNoCase(thisBail,'%cAge%',custodies[iCust].getAGE(),"ALL")>			
			<cfset thisBail=ReplaceNoCase(thisBail,'%placeOfArrest%',custodies[iCust].getPLACE_OF_ARREST(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%timeOfArrest%',custodies[iCust].getARREST_TIME_TEXT(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%cAbsent%',iif(custodies[iCust].getSTATUS() IS "C",de('N'),de('Y')),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%cCharged%',custodies[iCust].getCHARGED(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%cRights%',custodies[iCust].getRIGHTS(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%reviewDate%',custodies[iCust].getNEXT_REVIEW_DATE_TEXT(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%aoBadge%',custodies[iCust].getAO_BADGE(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%aoName%',custodies[iCust].getAO_NAME(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%oicBadge%',custodies[iCust].getOIC_BADGE(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%oicName%',custodies[iCust].getOIC_NAME(),"ALL")>
			<cfset thisBail=ReplaceNoCase(thisBail,'%custodyType%',custodies[iCust].getCUSTODY_TYPE(),"ALL")> --->
						
			<cfset returnTable &= thisBail>			  
		</cfloop>
				
	    <Cfset returnTable &= "</table>">	
	  </cfif>
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
</cfcomponent>