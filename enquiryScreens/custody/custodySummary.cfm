<!---

Module      : custodySummary.cfm

App         : GENIE

Purpose     : Displays the detention summary, bails and process decisions related to a custody

Requires    : custody_ref (custody no for the summary), nominalRef (nominal on the custody)

Author      : Nick Blackham

Date        : 02/12/2014

Revisions   : 

--->

<!--- get the detention summary --->
 <cfset lis_CustRefs="'"&CUSTODY_REF&"'">
 <cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef)>
 <!--- work out if we have a linked custody --->
 <CFQUERY NAME = "qry_CustCR" DATASOURCE="#Application.WarehouseDSN#" >
  SELECT *
  FROM   browser_owner.CUSTODY_CROSS_REF
  WHERE  CUSTODY_URN='#CUSTODY_REF#'
 </cfquery>

 <cfif qry_CustCR.RecordCount GT 0>
  <!--- used linked urns and current ref --->
  <cfloop query="qry_CustCR">
   <cfset lis_CustRefs=ListAppend(lis_CustRefs,"'"&LINKED_CUSTODY_URN&"'",",")>
  </cfloop>
 <cfelse>
  <!--- see if it's a link urn --->
	 <CFQUERY NAME = "qry_CustLU" DATASOURCE="#Application.WarehouseDSN#">
	  SELECT *
	  FROM   browser_owner.CUSTODY_CROSS_REF
	  WHERE  LINKED_CUSTODY_URN='#CUSTODY_REF#'
	 </cfquery>
	 
	 <cfif qry_CustLU.RecordCount GT 0>
		 <CFQUERY NAME = "qry_CustCR1" DATASOURCE="#Application.WarehouseDSN#" >
		  SELECT *
		  FROM   browser_owner.CUSTODY_CROSS_REF
		  WHERE  CUSTODY_URN='#qry_CustLU.CUSTODY_URN#'
		 </cfquery>
		
		 <cfif qry_CustCR1.RecordCount GT 0>
		  <cfset lis_CustRefs=ListAppend(lis_CustRefs,"'"&qry_CustLU.CUSTODY_URN&"'",",")>
		  <!--- used linked urns and current ref --->
		  <cfloop query="qry_CustCR1">
		   <cfset lis_CustRefs=ListAppend(lis_CustRefs,"'"&LINKED_CUSTODY_URN&"'",",")>
		  </cfloop>		 
		 </cfif>
	 </cfif>

 </cfif>

 <CFQUERY NAME = "qry_DistDet" DATASOURCE="#Application.WarehouseDSN#" >
	SELECT DISTINCT CUSTODY_REF,DETENTION_NO
	FROM   browser_owner.CUSTODY_DEPARTURES
	WHERE  CUSTODY_REF IN (#PreserveSingleQuotes(lis_CustRefs)#)
 </cfquery>

 <cfset lis_QueryTerms="">
 <cfloop query="qry_DistDet">
  <Cfset s_Term="(CUSTODY_REF='#CUSTODY_REF#' AND DETENTION_NO=#DETENTION_NO#)">
  <cfset lis_QueryTerms=ListAppend(lis_QueryTerms,s_Term,",")>
 </cfloop>

 <cfif ListLen(lis_QueryTerms,",") GT 0>

 <cfset s_Query=Replace(lis_QueryTerms,","," OR ","ALL")>

 <CFQUERY NAME = "qry_DetentionSummary" DATASOURCE="#Application.WarehouseDSN#" >
	SELECT CUSTODY_REF,DETENTION_NO,MIN(DATE_ARRIVED) AS DATE_ARRIVED,Max(DATE_RELEASED) AS DATE_RELEASED
	FROM   browser_owner.CUSTODY_DEPARTURES
	WHERE  (1=1)
	AND (#PreserveSingleQuotes(s_Query)#)
	GROUP BY CUSTODY_REF,DETENTION_NO
 </cfquery>

 <!--- check every record in the custody has a release date --->
 <cfset s_AllReleasePresent="YES">
 <cfloop query="qry_DetentionSummary">
  <cfif LEN(DATE_RELEASED) IS 0>
	<cfset s_AllReleasePresent="NO">
  </cfif>
 </cfloop>

<cfelse>
  <cfset s_AllReleasePresent="NO">
</cfif>

<!--- get the bail summary --->
 <CFQUERY NAME = "qry_BailSummary" DATASOURCE="#Application.WarehouseDSN#" >
	SELECT bs.*
	FROM   browser_owner.BAIL_SEARCH BS
	WHERE  CUSTODY_REF IN (#PreserveSingleQuotes(lis_CustRefs)#)
	ORDER BY DATE_SET DESC
</cfquery>

<!--- get the process summary --->
<CFQUERY NAME = "qry_ProcSummary" DATASOURCE="#Application.WarehouseDSN#" >
SELECT   PD.*,TO_CHAR(DATE_CREATED,'DD') AS REC_DAY, TO_CHAR(DATE_CREATED,'MM') AS REC_MON, 
         TO_CHAR(DATE_CREATED,'YYYY') AS REC_YEAR
FROM     browser_owner.PD_SEARCH pd
WHERE    CUSTODY_REF IN (#PreserveSingleQuotes(lis_CustRefs)#)
ORDER BY NVL(DATE_FORMALISED,'01-Jan-1900') DESC
</cfquery>

<cfoutput>
<div class="content">
 <cfset s_Title="Dentention / Bail / Process Summary. Custody Ref : #CUSTODY_REF#">	
 <h3 align="center">#s_Title#</h3>
 
 <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="dententionSummary" printTitle="GENIE #s_Title#" printUser="#session.user.getFullName()#">
 
 <br>
 <div id="dententionSummary">
 	
	 <div class="geniePanel">
	  <div class="header">Detention Summary<cfif isDefined("qry_DetentionSummary")> - #qry_DetentionSummary.RecordCount# Results</cfif></div>
	  <br>
	  <strong>#CUSTODY_REF# - #nominal.getFULL_NAME()#</strong>
	  <br><br>
	  <cfif s_AllReleasePresent IS "NO">
	   <strong>Time in detention for NSPIS custodies is only available when the custody is closed</strong>
	  <cfelse>
	  <cfif qry_DetentionSummary.RecordCount GT 0>
	    <table width="100%" class="genieData">
	     <thead>
		  <tr>
			<th>Custody Ref</th>		 
			<th>Arrival Time</th>
			<th>Departure Time</th>
			<th>Reason For Departure</th>
			<th>Time in Detention</th>		
		  </tr>
		 </thead>
		 <cfset j=1>
		 <cfset i_detTotal=0>
		 <cfset s_CurCust="">
		 <cfset s_OldCust="">
	     <cfset s_LastDep="">
		 <cfloop query="qry_DetentionSummary">
		 
	     <cfset s_CurCust=CUSTODY_REF>
		
		 <cfif j GT 1 AND s_CurCust IS NOT s_OldCust>
		 <!--- it's a transfer so get the date of arrival of the next custody --->
		 <cfset i_HrsInDet=DateDiff("h",s_LastDep,DATE_ARRIVED)>
		 <cfset i_MinsInDet=DateDiff("n",s_LastDep,DATE_ARRIVED)>
		 <cfset i_DetTotal=i_DetTotal+i_MinsInDet>
		 <cfset i_Mins=Int(i_MinsInDet MOD 60)>
		 <cfif i_Mins GTE 0 AND i_Mins LTE 9>
		   <cfset i_Mins="0"&i_Mins>
		 </cfif>
	     <tbody>
		  <tr class="row_colour#j mod 2#">
		   <td>&nbsp;</td>
		   <td>&nbsp;</td>
		   <td>&nbsp;</td>
		   <td>TRANSFER TIME</td>	  	  
	       <td>#i_HrsInDet#:#i_Mins#</td>
		  </tr>
		 <cfset j=j+1>
		 </cfif>	
		
		  <tr class="row_colour#j mod 2#">
			<td valign="top">#CUSTODY_REF#</td>		 
			<td valign="top">#TimeFormat(DATE_ARRIVED,"HH:mm")# #DateFormat(DATE_ARRIVED,"dd/mm/YYYY")#</td>
			<td valign="top">#TimeFormat(DATE_RELEASED,"HH:mm")# #DateFormat(DATE_RELEASED,"dd/mm/YYYY")#</td>
			<td valign="top">
			  <CFQUERY NAME = "qry_DepReasons" DATASOURCE="#Application..WarehouseDSN#" >
			   SELECT REASON_FOR_DEPARTURE
			   FROM browser_owner.CUSTODY_DEPARTURES
			   WHERE CUSTODY_REF='#CUSTODY_REF#'
			   AND   DETENTION_NO=#DETENTION_NO#
			  </cfquery>
			  <cfset i=1>
			  <cfloop query="qry_DepReasons">
				<cfif i GT 1>
				, 
				</cfif>
				#REASON_FOR_DEPARTURE#
				<cfset i=i+1>
			  </cfloop>
			</td>
			<td valign="top">
			<cfif not isDate(DATE_RELEASED)>
			 <cfset s_DATE_RELEASED=now()>
			<cfelse>
			 <cfset s_DATE_RELEASED=DATE_RELEASED>
			</cfif>
			 <cfset i_HrsInDet=DateDiff("h",DATE_ARRIVED,s_DATE_RELEASED)>
			 <cfset i_MinsInDet=DateDiff("n",DATE_ARRIVED,s_DATE_RELEASED)>
			 <cfset i_DetTotal=i_DetTotal+i_MinsInDet>
			 <cfset i_Mins=Int(i_MinsInDet MOD 60)>
			 <cfif i_Mins GTE 0 AND i_Mins LTE 9>
			   <cfset i_Mins="0"&i_Mins>
			 </cfif>
			 #i_HrsInDet#:#i_Mins#
			</td>
		  </tr>
		 
		 <cfset s_OldCust=s_CurCust>
		 <cfset s_LastDep=DATE_RELEASED>
		 <cfset j=j+1>
		 </cfloop>	
		  <tr class="row_colour#i mod 2#">
		   <td>&nbsp;</td>
		   <td>&nbsp;</td>
		   <td>&nbsp;</td>	  
		   <td align="right"><b>Total Time In Detention</b></td>
		   <td>
		   <cfset i_TotMins=i_DetTotal MOD 60>
		   <cfif i_TotMins GTE 0 and i_TotMins LTE 9>
			 <cfset i_TotMins="0"&i_TotMins>
		   </cfif>
		   #Int(i_DetTotal/60)#:#i_TotMins#
		   </td>
		  </tr>
		 </tbody>
		</table>
		<cfelse>
		 <h3 align="center">No Detentions Recorded</h3>
		</cfif>
		</cfif>
	
	 </div>
 <br>
 
 <!--- output bails --->
 <div class="geniePanel">
  <div class="header">Bail Summary - #qry_BailSummary.RecordCount# Results</div>
  <br>
  <strong>#CUSTODY_REF# - #nominal.getFULL_NAME()#</strong>
  <br><br>
  <cfif qry_BailSummary.RecordCount GT 0>
    <table width="100%" class="genieData">
     <thead>
      <tr>
       <th width="10%">TYPE</th>				
	   <th width="30%">BAILED BY/TO</th>
	   <th width="30%">IN CONNECTION WITH</th>				 
	   <th width="15%">OFFICER</th>
	   <th width="15%">STATUS</th>				 				 				 
	  </tr>
	 </thead>
	 <tbody>
	 <cfset i=1>
	 <cfloop query="qry_BailSummary">
	 <tr class="row_colour#i mod 2#">
	  <td valign="top">#BAIL_TYPE#</td>
	  <td valign="top"><b>Bail By</b> : #BAILED_FROM# #DateFormat(DATE_SET,"DD/MM/YYY")#<br>
	     <b>Bail To</b> : #BAILED_TO# #DateFormat(BAILED_TO_DATE,"DD/MM/YYY")# 
         <cfif BAIL_TYPE IS "POLICE">#TimeFormat(BAILED_TO_DATE,"HH:mm")#</cfif>
		 <cfif Len(Cancellation_Reason) GT 0>
		 <br><br><b>Cancellation Reason</b> : #CANCELLATION_REASON#
		 </cfif>
		 
		 <cfquery name="qry_BailConds" DATASOURCE="#Application..WarehouseDSN#" >
		  SELECT * 
		  FROM browser_owner.BAIL_CONDITIONS
		  WHERE BAIL_REF='#BAIL_REF#'
		  ORDER BY SEQ_NO
		 </cfquery>
		 
		 <cfif qry_BailConds.RecordCOunt GT 0>
		   <br><br><b>Bail Conditions</b>	 
		   <cfloop query="qry_BailConds">
			 <br>
			 #CONDITION#
			 <br><br><b>Reason</b> : #REASON#
		   </cfloop>
		 </cfif>						 
	  </td>
	  <td valign="top">
	  <cfquery name="qry_BailOffences" DATASOURCE="#Application..WarehouseDSN#" >
	   SELECT *
	   FROM browser_owner.BAIL_DETAILS
	   WHERE BAIL_REF='#BAIL_REF#'
	   ORDER BY SEQ_NO
	  </cfquery>

	  <cfif qry_BailOffences.RecordCount GT 0>
	  <cfset z=1>					  
		<cfloop query="qry_BailOffences">
		<cfif z GT 1><br></cfif>#OFFENCE_DETAIL#
		<cfset z=z+1>
		</cfloop>
	  </cfif>
	  </td>
	  <td valign="top">#BAIL_OFFICER#</td>
	  <td valign="top">#STATUS#</td>
	 </tr>
	 <cfset i=i+1>
	</cfloop>
	</tbody>
   </table>
  <cfelse>
    <h3 align="center">No Bails Recorded</h3>
  </cfif>
 </div>
 <br>
 
 <!--- output process decisions --->
 <div class="geniePanel">
  <div class="header">Process Decision Summary - #qry_ProcSummary.RecordCount# Results</div>
  <br>
  <strong>#CUSTODY_REF# - #nominal.getFULL_NAME()#</strong>
  <br><br>
  <cfif qry_ProcSummary.RecordCount GT 0>
	<table width="100%" class="genieData">
	 <thead>
	 <tr>
		  <th width="10%">PROCESS NO</th>
		  <th width="10%">CASE NO</th>					
		  <th width="10%">CUSTODY NO</th>				  
		  <th width="10%">DECISION</th>
		  <th width="10%">FORMALISED</th>
		  <th width="60%">COURT DETAILS</th>							
	 </tr>
	 </thead>
	 <cfset j=1>
	 <tbody>	 
		 <cfloop query="qry_ProcSummary">
		 
		  <cfif Len(CASE_ORG) GT 0 AND Len(CASE_SERIAL) GT 0 AND Len(CASE_YEAR) GT 0>
		   	 <cfset caseURN=CASE_ORG&"/"&CASE_SERIAL&"/"&iif(Len(CASE_YEAR) IS 1,DE('0'&CASE_YEAR),DE(CASE_YEAR))>               
		                
		    <cfif Left(PD_REF,3) IS "22/" OR Left(PD_REF,3) IS "23/">
			 <cfset caseType="NSPIS">					 
			<cfelse>
			 <cfset caseType="CRIME">					 						 
		    </cfif>	                 
				    
	      <cfelse>
	        <cfset caseUrn="">
	      </cfif>	 
		 	 
         <tr class="row_colour#j MOD 2#">
			   <td valign="top"><strong>#PD_REF#</strong></td>
 			   <td valign="top">
						 <cfif Len(caseURN) GT 0>	 
							 <strong><a href="#caseURN#" caseType="#caseType#" class="genieCaseLink">#caseURN#</a></strong>
						 <cfelse>
						     &nbsp;
						 </cfif>
			   </td>
			   <td valign="top">
				 <cfif Len(CUSTODY_REF) GT 0>
				  <CFQUERY NAME="qry_CustRef" DATASOURCE="#Application.WarehouseDSN#" >
				  	 SELECT  ARREST_TIME, TO_CHAR(CREATION_DATE,'DD') AS REC_DAY, TO_CHAR(CREATION_DATE,'MM') AS REC_MON,
                             TO_CHAR(CREATION_DATE,'YYYY') AS REC_YEAR, CUSTODY_TYPE, CUSTODY_REF
                     FROM    browser_owner.CUSTODY_SEARCH
                     WHERE   CUSTODY_REF='#CUSTODY_REF#'
				  </cfquery>
				  <cfif qry_CustRef.recordCount GT 0>
					<cfif qry_CustRef.CUSTODY_TYPE IS "NSPIS">
		              <a href="#qry_CustRef.CUSTODY_REF#" custodyType="NSPIS" class="genieCustodyLink">#qry_CustRef.CUSTODY_REF#</a>
		            <cfelse>
		              <a href="#qry_CustRef.CUSTODY_REF#" custodyType="CRIME" class="genieCustodyLink">#qry_CustRef.CUSTODY_REF#</a>          
		            </cfif>  	 	
				  </cfif>
				 <cfelse>
				 	 &nbsp; 				  
				 </cfif>
				 </td>						 
				 <td valign="top">#DECISION#</td>						 
				 <td valign="top">#DateFormat(DATE_FORMALISED,"DD/MM/YYYY")#</td>
				 <td valign="top">
					 <CFQUERY NAME = "qry_Offences" DATASOURCE="#Application..WarehouseDSN#" >
					 SELECT po.*, ph.*
					 FROM   browser_owner.PD_HEARINGS ph, browser_owner.PD_OFFENCES po
					 WHERE  po.PD_REF=ph.PD_REF
					 AND    po.LINE_REF=ph.LINE_REF
					 AND    po.PD_REF='#PD_REF#'
					 ORDER BY HEARING_DATE DESC, ph.LINE_REF
					 </cfquery>
					<cfif qry_Offences.RecordCount GT 0>
					<table width="100%" class="genieData">
				    <cfloop query="qry_Offences">
					<tr>
						<td width="35%" valign="top"><cfif Len(OFFENCE_TITLE) GT 60>#Left(OFFENCE_TITLE,60)#<cfelse>#OFFENCE_TITLE#</cfif></td>
						<td width="35%" valign="top">#COURT_NAME#</td>
						<td width="12%" valign="top">#DateFormat(HEARING_DATE,"DD/MM/YYYY")#</td>
						<td width="13%" valign="top">#STATUS#</td>							    
					</tr>
					</cfloop>
					</table>
					<cfelse>
					&nbsp;
					</cfif>
				 </td>
			  </tr>
    <cfset j=j+1>
	</cfloop>
	</tbody>	
	</table>
  <cfelse>
    <h3 align="center">No Process Decisions Recorded</h3>
  </cfif>
 </div>
</div>

</div>

<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"CUSTODY DETENTION DETAILS (detention_summary.cfm)","","Custody Ref:#CUSTODY_REF#",0,session.user.getDepartment())>

</cfoutput>

