<!---

Module      : pdOffences.cfm

App         : GENIE

Purpose     : Displays Offences and hearings for a given process decision

Requires    : pdRef, caseNo and nominalRef

Author      : Nick Blackham

Date        : 03/12/2014

Revisions   : 

--->

<!--- get the offence details --->
 <CFQUERY NAME = "qry_Offences" DATASOURCE="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
 SELECT po.*, ph.*
 FROM   browser_owner.PD_HEARINGS ph, browser_owner.PD_OFFENCES po
 WHERE  po.PD_REF=ph.PD_REF(+)
 AND    po.LINE_REF=ph.LINE_REF(+)
 AND    po.PD_REF='#pdREF#'
 ORDER BY HEARING_DATE DESC, ph.LINE_REF
 </cfquery>

 <cfset lis_CrimeRef="">
 <cfset lis_CrimeRefV7="">
 <cfloop query="qry_Offences"> 
	<cfif Len(CRIME_REF) GT 0>
	  <cfset lis_CrimeRef=ListAppend(lis_CrimeRef,CRIME_REF,",")>
	  <cfset lis_CrimeRefV7=ListAppend(lis_CrimeRefV7,"'"&CRIME_REF&"'",",")>	  
	</cfif>
 </cfloop>

<cfif ListLen(lis_CrimeRef,",") GT 0>
 <cfquery name="qry_Crimes" datasource="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
  SELECT O.CRIME_REF, TO_CHAR(O.CREATED_DATE,'YYYY') AS REC_YEAR,
		 TO_CHAR(O.CREATED_DATE,'MM') AS REC_MON, TO_CHAR(O.CREATED_DATE,'DD') AS REC_DAY
  FROM browser_owner.OFFENCE_SEARCH o
  WHERE CRIME_REF IN (#PreserveSingleQuotes(lis_CrimeRefV7)#)
 </cfquery>
 <!--- V8 <cfqueryparam value="#lis_CrimeRef#" cfsqltype="cf_sql_integer" list="true"> --->
</cfif>

<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef)>

<cfoutput>

 <h3 align="center">#caseNo# - #nominal.getFULL_NAME()# (#nominalRef#)</h3>
 <div class="geniePanel">
  <div class="header">Offences</div>
	<cfif qry_Offences.RecordCount GT 0>
  <table width="100%" class="genieData">
   <thead>
	 <tr>
		<th>Crime No</th>
		<th>Offence</th>
		<th>Court</th>	
		<th>Date</th>
		<th>Status</th>	
	 </tr>
	</thead>
	<tbody>
	 <cfset i=1>
	 <cfloop query="qry_Offences">
     <tr class="row_colour#i mod 2#">
		<td>
		<cfif Len(CRIME_REF) GT 0>	
		 <cfset s_CrimeNo=UCase(CRIME_NO)>
		 <!-- get crime details --->
		 <cfquery name="qry_Offence" dbtype="query">
	      SELECT *
		  FROM qry_Crimes
		  WHERE CRIME_REF=<cfqueryparam value="#CRIME_REF#" cfsqltype="cf_sql_integer">
		</cfquery>
		 <cfloop query="qry_Offence">
			<strong><a href="#s_CRIMENo#" class="genieCrimeLink">#s_CrimeNo#</a></strong></td>
		 </cfloop>
        <cfelse>
 		 #CRIME_NO#
		</cfif>
        </td>
		<td><cfif Len(OFFENCE_TITLE) GT 60>#Left(OFFENCE_TITLE,60)#<cfelse>#OFFENCE_TITLE#</cfif></td>
		<td>#COURT_NAME#</td>
		<td>#DateFormat(HEARING_DATE,"DD/MM/YYYY")#</td>
		<td>#STATUS#</td>						
	 </tr>	
	 <cfset i=i+1>
	 </cfloop>
	 </tbody>
	</table>
 </cfif>
 </div>
</cfoutput>

<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"PROC DEC OFFENCE DETAILS (pd_offences.cfm)","Case No:#CaseNo#", "Nom Ref:#nominalRef#",qry_Offences.RecordCount,session.user.getDepartment())>  