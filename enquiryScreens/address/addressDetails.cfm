<!--- <cftry> --->

<!---

Module      : address_details.cfm

App         : GENIE

Purpose     : Displays the Nominals, Offences, Orgs and Intel for an address

Requires    : 

Author      : Nick Blackham

Date        : 10/08/2006

Revisions   : 

--->

<script>
	$(document).ready(function() {  	
	  var $addrTabs=$( "#adTabs" ).tabs();
	  
	  $('td div.genieToolTip').qtip({
									  	content: {
											        text: function(event, api){
														// Retrieve content from custom attribute of the $('.selector') elements.
														return $(this).children('.toolTip').html();
													}
												  },
										position: {
											      my: 'left top',
								                  at: 'right center',
								                  viewport: $(window)         
											   	}											  															    
									  });
	  
	  $('#adTabs').show();
	});	
</script>

<cfset str_SearchParams=Replace(PREMISE_KEY,","," ","ALL")&"|"&POST_CODE>

<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"ADDRESS DETAILS (address_details.cfm)",str_SearchParams,"",0,session.user.getDepartment())>

<!--- get the address details again --->
 <CFQUERY NAME = "qry_Address" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
 SELECT         DECODE(PART_ID,'','',PART_ID||', ')||
				DECODE(BUILDING_NAME,'','',BUILDING_NAME||', ')||
				DECODE(BUILDING_NUMBER,'','',BUILDING_NUMBER||', ')||
				DECODE(STREET_1,'','',STREET_1||', ')||
				DECODE(LOCALITY,'','',LOCALITY||', ')||
				DECODE(TOWN,'','',TOWN||', ')||
				DECODE(COUNTY,'','',COUNTY||' ')||
				DECODE(POST_CODE,'','',POST_CODE) Address,
				addr.*
 FROM   browser_owner.GE_ADDRESSES addr
 WHERE  PREMISE_KEY='#PREMISE_KEY#'
 AND    POST_CODE='#POST_CODE#'
 </cfquery>

<!--- get all the offences linked to the address ref passed in --->
<CFQUERY NAME = "qry_OffenceResults" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
	SELECT ORG_CODE||'/'||SERIAL_NO||'/'||DECODE(LENGTH(YEAR),1, '0' || YEAR, YEAR) AS CRIME_NO,
           DECODE(O.LAST_COMMITTED,'', TO_CHAR(O.FIRST_COMMITTED,'DD/MM/YYYY HH24:MI'),
           TO_CHAR(O.FIRST_COMMITTED,'DD/MM/YYYY HH24:MI') || ' and ' ||    TO_CHAR(O.LAST_COMMITTED,'DD/MM/YYYY HH24:MI')) Committed,	       
		   REC_TITLE, INCIDENT_NO,
           O.CRIME_REF, TO_CHAR(O.CREATED_DATE,'YYYY') AS REC_YEAR,
		   TO_CHAR(O.CREATED_DATE,'MM') AS REC_MON, TO_CHAR(O.CREATED_DATE,'DD') AS REC_DAY		   
	FROM   browser_owner.OFFENCE_SEARCH o
	WHERE  PREMISE_KEY='#PREMISE_KEY#'
	AND    POST_CODE='#POST_CODE#'
	ORDER BY FIRST_COMMITTED DESC
</cfquery>

<!--- get all the nominals lined to the address ref passed in --->
<CFQUERY NAME = "qry_NominalResults" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">	
	SELECT nom.NOMINAL_REF,
    	   REPLACE(REPLACE(LTRIM(
		                   RTRIM(nomd.TITLE)||' '||
					       RTRIM(nom.SURNAME_1)||DECODE(nom.SURNAME_2,NULL,'','-'||nom.SURNAME_2)||', '||
					       RTRIM(INITCAP(FORENAME_1))||' '||
					       RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ')
		        || DECODE(FAMILIAR_NAME,'','', ' (Nick ' || FAMILIAR_NAME || ')')
				|| DECODE(MAIDEN_NAME,NULL,'',' (Nee ' || MAIDEN_NAME || ')') Name,
		  TO_CHAR(RECORDED,'DD/MM/YYYY') AS START_DATE,
		  TO_CHAR(DATE_OF_BIRTH,'DD/MM/YYYY') AS DOB,
		  TYPE,
		  SEX,
		  FORENAME_1,
		  SURNAME_1
	FROM  browser_owner.GE_ADD_NOMINALS a_nom, browser_owner.NOMINAL_SEARCH nom, browser_owner.NOMINAL_DETAILS nomd
	WHERE a_nom.NOMINAL_REF=nom.NOMINAL_REF
	AND   a_nom.PREMISE_KEY='#PREMISE_KEY#'
	AND   a_nom.POST_CODE='#POST_CODE#'
	AND   nomd.NOMINAL_REF=nom.NOMINAL_REF
	ORDER BY a_nom.RECORDED DESC, SURNAME_1, FORENAME_1, FORENAME_2, DATE_OF_BIRTH
</cfquery>

<cfquery name="qNomsCount" dbtype="query">
	SELECT COUNT(DISTINCT NOMINAL_REF) AS COUNT_NOMS
	FROM qry_NominalResults
</cfquery>	

  <!--- crate a list of nominals refs for database `in` queries --->
  <cfset lis_NomRefs="">
  <cfset lis_NomRefsV7="">
  <cfloop query="qry_NominalResults" startrow="1" endrow="200">
    <cfset lis_NomRefs=ListAppend(lis_NomRefs,NOMINAL_REF,",")>
    <cfset lis_NomRefsV7=ListAppend(lis_NomRefsV7,"'"&NOMINAL_REF&"'",",")>	
  </cfloop>

 <cfif ListLen(lis_NomRefsV7,",") GT 0>

<!--- get all the warnings for these nominals --->
  <cfquery name="qry_WarnDetails" datasource="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
	 SELECT w.NOMINAL_REF, '<b>'||w.WSC_DESC||'</b>-'||TO_CHAR(w.DATE_MARKED,'DD/MM/YYYY') AS WARNING_TEXT
	 FROM browser_owner.GE_WARNINGS w
	 WHERE NOMINAL_REF IN (#PreserveSingleQuotes(lis_NomRefsV7)#)
	 AND   END_DATE IS NULL OR (TRUNC(END_DATE) >= TRUNC(SYSDATE))
	 ORDER BY DATE_MARKED DESC
  </cfquery> 		
  <!--- V8 <cfqueryparam value="#PreserveSingleQuotes(lis_NomRefs)#" cfsqltype="cf_sql_varchar" list="true">--->

 </cfif>

<!--- get all the organisation lined to the address ref passed in --->
<CFQUERY NAME = "qry_Organisations" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">	
	SELECT   ORG_CODE,ORG_TYPE,NAME, TO_CHAR(RECORDED,'DD/MM/YYYY') AS DATE_REC
	FROM     browser_owner.GE_ADD_ORG a_org
	WHERE    a_org.PREMISE_KEY='#PREMISE_KEY#'
	AND      a_org.POST_CODE='#POST_CODE#'
	ORDER BY a_org.RECORDED DESC, NAME
</cfquery>

<!--- get all the intel linked to the address ref passed in --->
<CFQUERY NAME = "qry_Intel" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">	
  SELECT int.*
  FROM   browser_owner.INTELL_SEARCH int, browser_owner.INTELL_ADDS addr
  WHERE  addr.LOG_REF=int.LOG_REF
  AND    addr.POST_CODE='#POST_CODE#'
  AND    addr.PREMISE_KEY='#PREMISE_KEY#'
  ORDER BY DATE_START DESC
</cfquery>

<cfloop query="qry_Intel">
 <cfif SECURITY_ACCESS_LEVEL LT Session.LoggedInUserLogAccess>
  <cfset str_Message="OTHER LOGS ARE RECORDED FOR WHICH YOU DO NOT HAVE ACCESS">
 </cfif>
</cfloop>

<!--- create the pastable text view for the address --->
<!--- generate random filename --->
<cfset str_Filename=createUUID()&".txt">
<cfset str_AddressTextFile=Application.OpenPastesPath&"ADDR_"&str_Filename>
<cfset str_AddressTextURL=Application.OpenPastesURL&"ADDR_"&str_Filename>

<cfset arr_Lines=ArrayNew(1)>

<cfset arr_Lines[1]="West Mercia Police">
<cfset arr_Lines[2]="View Address/Nominals">
<cfset arr_Lines[3]="+-- Address -------------------------------------------------------------------+">
<cfset arr_Lines[4]="|                                                                              |">

<cfset i_AddressTxt=5>


    <cfset arr_Lines[i_AddressTxt]="|  "&qry_Address.Address>
		<cfset i_Spaces=75-Len(qry_Address.Address)>
		<cfloop index="z" from="1" to="#i_Spaces#" step="1">
		<cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&chr(32)>
		</cfloop>
		<cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&" |">
		<cfset i_AddressTxt=i_AddressTxt+1>
		<cfset arr_Lines[i_AddressTxt]="|                                                                              |">
		<cfset i_AddressTxt=i_AddressTxt+1>
		<cfset arr_Lines[i_AddressTxt]="++-- Nominals-----------------------------------------------------------------++">
		<cfset i_AddressTxt=i_AddressTxt+1>
    <cfloop query="qry_NominalResults" startrow="1" endrow="6">
		<cfset arr_Lines[i_AddressTxt]=" |                                                                            |">		
		<cfset i_AddressTxt=i_AddressTxt+1>
		<cfset arr_Lines[i_AddressTxt]=" | Name      ">
		<cfif Len(NAME) GT 42>
		 <cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&Left(NAME,42)&" |">
    <cfelse>
		 <cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&NAME>		
			<cfset i_Spaces=43-Len(NAME)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&chr(32)>
			</cfloop>		 
		</cfif>		 
		<cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&" DOB "&DOB&" Sex "&SEX&" |">				
		<cfset i_AddressTxt=i_AddressTxt+1>
		<cfset arr_Lines[i_AddressTxt]=" | Relevance "&TYPE>
    <cfset i_Spaces=33-Len(TYPE)>
			<cfloop index="z" from="1" to="#i_Spaces#" step="1">
			<cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&chr(32)>
			</cfloop>			
		  <cfset arr_Lines[i_AddressTxt]=arr_Lines[i_AddressTxt]&" Date Recorded "&START_DATE&"       |">			
		 <cfset i_AddressTxt=i_AddressTxt+1>			
		 <cfset arr_Lines[i_AddressTxt]=" |                                                                            |">
		</cfloop>	
		<cfset i_AddressTxt=i_AddressTxt+1>	
		<cfset arr_Lines[i_AddressTxt]=" +----------------------------------------------------------------------------+">
		
	<!--- write to file --->
	<cffile action="write" addnewline="no" file="#str_AddressTextFile#" output="#ArrayToList(arr_Lines,chr(13)&chr(10))#">	

<input type="button" name="frm_SubPrint" value="Print Results (P)" onClick="goPrint();"  AccessKey="P">

<a name="offences"></a>

<cfoutput>
<h3 align="center">#qry_Address.Address#</h3>
</cfoutput>

<div id="adTabs" style="display:none;">
			
		   <ul>        		
		       <li id="nominalsLi"><a href="#adNominals">Nominals (<cfoutput>#qNomsCount.COUNT_NOMS#</cfoutput>)</a></li>
			   <li id="offencesLi"><a href="#adOffences">Offences (<cfoutput>#qry_OffenceResults.RecordCount#</cfoutput>)</a></li>
			   <li id="intelLi"><a href="#adIntel">Intel (<cfoutput>#qry_Intel.RecordCount#</cfoutput>)</a></li>
			   <li id="orgLi"><a href="#adOrgs">Orgs (<cfoutput>#qry_Organisations.RecordCount#</cfoutput>)</a></li>
		   </ul>

	<div id="adNominals">	  
      <cfoutput>
		<cfif qry_NominalResults.RecordCount GT 0>
	  	<cfset searchUUID=createUUID()>
	    <cfset lisNoms="">
        <br>		
	 	<form action="#str_AddressTextURL#" method="get" target="_blank">
		 <input type="submit" name="frm_SubOIS" value="OIS Paste">
		</form>	
		<br>
		A Maximum of 200 nominals will be displayed
		<br>
		<table width="100%" class="dataTable genieData">
		 <thead>
			 <tr>
				<th width="10%">Nominal Ref</th>
				<th width="40%">Name</th>
				<th width="2%">Sex</th>
				<th width="2%">W</th>		
				<th width="10%">DOB</th>
				<th width="10%">Date Recorded</th>
				<th width="26%">&nbsp;</th>					
			 </tr>
		 </thead>
		 <tbody>
		 <cfset i=1>
		 <cfloop query="qry_NominalResults" startrow="1" endrow="200" >
		 	<cfif ListFind(lisNoms,NOMINAL_REF,",") IS 0>
			 	<cfset lisNoms=ListAppend(lisNoms,NOMINAL_REF,",")>
			 </cfif>
	        <cfquery name="qry_WarnSignals" dbtype="query">
			 SELECT *
			 FROM qry_WarnDetails
			 WHERE NOMINAL_REF=<cfqueryparam value="#NOMINAL_REF#" cfsqltype="cf_sql_varchar">
			</cfquery> 
			
			<cfif qry_WarnSignals.RecordCount GT 0>
			 <cfset str_WarnSignals="">
			 <cfloop query="qry_WarnSignals">
			  <cfset str_WarnSignals=str_WarnSignals&WARNING_TEXT&"<br>">
			 </cfloop>
			</cfif> 
		  <tr class="row_colour#i mod 2#">
			<td valign="top">
			<a name="#NOMINAL_REF#"></a>
			<cfset str_Nom_Link=Application..NominalLink&"&searchUUID=#searchUUID#&#session.URLToken#&str_CRO=#NOMINAL_REF#">		
			<b><a href="#NOMINAL_REF#" class="genieNominal">#NOMINAL_REF#</a></b>
			</td>
			<td valign="top">
			<b><a href="#NOMINAL_REF#" class="genieNominal">#NAME#</a></b>
			</td>
			<td valign="top">#SEX#</td>
			<td valign="top">
			  <cfif qry_WarnSignals.RecordCount GT 0>
	          <div class="genieWarning genieToolTip">
					<div style="display:none;" class="toolTip">
					  <div class="genieTooltipHeader">
					  	#FORENAME_1# #REPLACE(SURNAME_1,chr(39),chr(96),'ALL')# #NOMINAL_REF# Warnings
					  </div>
					  <div class="genieTooltipHolder">
					  	#str_WARNSignals#
					  </div>
					</div>
			  </div>	   
			  <cfelse>
			  &nbsp;
			  </cfif>		
			</td>
			<td valign="top">#DOB#</td>
			<td valign="top">#START_DATE#</td>
			<td valign="top">#TYPE#</td>
		  </tr>
		 <cfset i=i+1>
		 </cfloop>	
		 </tbody>
		 <cffile action="write" file="#application.nominalTempDir##searchUUID#.txt" output="#lisNoms#">
		</table>
		<cfelse>
		 <h3 align="center">No Nominals Recorded</h3>
		</cfif>	  	  
	  </cfoutput>		
	</div>
	
	<div id="adOffences">
	  <cfoutput>
		 <cfif qry_OffenceResults.RecordCount GT 0>
		  <cfset searchUUID=createUUID()>
		    <br>
		    <table width="100%" class="dataTable genieData">
		     <thead>
			  <tr>
				<th>Crime No</th>
				<th>Incident</th>
				<th>Offence</th>
				<th>Date</th>		
			  </tr>
			 </thead>
			 <cfset i=1>
			 <cfset lisCrimes="">
			 <cfloop query="qry_OffenceResults">
		     <cfset lisCrimes=listAppend(lisCrimes,CRIME_NO&"|"&CRIME_REF,",")>
			 <tr class="row_colour#i mod 2#">
				<td valign="top"><strong><a href="#CRIME_NO#" searchUUID="#searchUUID#" class="genieCrimeLink">#CRIME_NO#</a></strong></td>
				<td valign="top">
				<cfif Len(INCIDENT_NO) GT 0>
				<a href="#INCIDENT_NO#" class="genieOISLink" target="_blank">#INCIDENT_NO#</a>
				<cfelse>
				#INCIDENT_NO#
				</cfif>	
				</td>
				<td valign="top">
				<cfif Len(REC_TITLE) GT 50>
				#Left(REC_TITLE,50)#
				<cfelse>
				#REC_TITLE#
				</cfif>
				</td>
				<td valign="top">#COMMITTED#</td>
			 </tr>
			 <cfset i=i+1>
			 </cfloop>	
			 <cffile action="write" file="#application.crimeTempDir##searchUUID#.txt" output="#lisCrimes#">
			</table>
			<cfelse>
			 <h3 align="center">No Offences Recorded</h3>
			</cfif>			  	  
	  </cfoutput>
	</div>
	
	<div id="adIntel">
	 <cfoutput>
		  <cfif isDefined("str_Message")>
		   <div class="error_title" align="center" style="clear:both;margin-top:3px;">
		    #str_Message#
		   </div>
		  </cfif>
		  <cfif qry_Intel.RecordCount GT 0>
		  <Cfset searchUUID=createUUID()>
		 	<table width="100%" class="dataTable genieData">
		 	 <thead>
			 <tr>
				<th width="5%">LOG</th>
				<th width="3%">SAL</th>		
				<th width="16%">DATE FROM/TO</th>		
				<th width="11%">SOURCE DOC REF</th>							
				<th width="18%">INDICATOR</th>			                  		
				<th width="8%">CREATED</th>
			 </tr>
			 </thead>
			 <tbody>
			 <cfset i=1>
			 <cfset lisLogs="">
			 <cfloop query="qry_Intel">	  
			 <cfif SECURITY_ACCESS_LEVEL GTE Session.LoggedInUserLogAccess>
			 <cfset logData=LOG_REF&"|"&SECURITY_ACCESS_LEVEL>
			 <cfset logData &= "|"&HAND_CODE&"|"&Replace(iif(Len(HAND_GUIDANCE) GT 0,DE(HAND_GUIDANCE),DE('None')),chr(10),"~","ALL")>
			 <cfset lisLogs=ListAppend(lisLogs,logData,chr(10))>	 				 	 	 	  
			 <tr class="row_colour#i mod 2#">
		        <td valign="top"><strong>		          					  				
				  <a href="#LOG_REF#" class="genieIntelLink" searchUUID="#searchUUID#" handCode="#HAND_CODE#" handGuide="#HAND_GUIDANCE#">#LOG_REF#</a>					 
				</strong></td>
				<td valign="top">#SECURITY_ACCESS_LEVEL#</td>
				<td valign="top">#DateFormat(DATE_START,"DD/MM/YYYY")# To #DateFormat(DATE_END,"DD/MM/YYYY")#</td>
				<td valign="top">#SOURCE_DOC_REF#</td>					
				<td valign="top"><strong>#INDICATOR#</strong></td>		                  
				<td valign="top">#DateFormat(DATE_CREATED,"DD/MM/YYYY")#</td>
		     </tr>	
			 <cfset i=i+1>
			 </cfif>
			 </cfloop>
			 </tbody>
			 </table>
			 <cffile action="write" file="#application.intelFTSTempDir##searchUUID#.txt" output="#lisLogs#">
		 <cfelse>
		 <h3 align="center">No Intelligence Recorded</h3>
		 </cfif> 	
	 </cfoutput>	
	</div>
	
	<div id="adOrgs">
	 <cfoutput>
		<cfif qry_Organisations.RecordCOunt GT 0>
		<table width="100%" class="dataTable genieData">
	     <thead>
		 <tr>
			<th width="12%">Org Code</th>
			<th width="13%">Org Type</th>
			<th width="55%">Name</th>
			<th width="20%">Date Recorded</th>
		 </tr>
		 </thead>
		 <cfset i=1>
		 <tbody>
		 <cfloop query="qry_Organisations" startrow="1" endrow="100" >
		 <tr class="row_colour#i mod 2#">
			<td valign="top">#ORG_CODE#</td>
			<td valign="top">#ORG_TYPE#</td>
			<td valign="top"><strong>#NAME#</strong></td>
			<td valign="top">#DATE_REC#</td>
		 </tr>
		 <cfset i=i+1>
		 </cfloop>	
		 </tbody>
		</table>
		<cfelse>
		 <h3 align="center">No Organisations Recorded</h3>
		</cfif>
	 </cfoutput>	
	</div>
		   
</div>		   