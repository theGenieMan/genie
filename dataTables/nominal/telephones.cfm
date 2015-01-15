<!---

Module      : telephones.cfm

App         : GENIE

Purpose     : Delivers all telephones nominal has involvement with, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset variables.qry_NominalTelNos=Application.genieService.getWestMerciaNominalTelephones(nominalRef=nominalRef)>
<div id="dataContainer">
  <div class="dataTableTitle">
	TELEPHONE NUMBERS
  </div>
  <cfoutput>
    
	  <cfif variables.qry_NominalTelNos.RecordCount GT 0>
	  <table width="100%" class="genieData ninetypc">
	  	<thead>	  
			<tr>
		 	 <cfif isDefined('includePrintChecks')>
			 <th width="1%">&nbsp;INC?&nbsp;</th> 	
			 </cfif>					
     		 <th width="10%">DATE FROM</th>				
			 <th width="15%">TEL NO</th>
			 <th width="10%">OWN/USE</th>
			 <th width="10%">TYPE</th>
			 <th width="10%">E COMMS</th>
			 <th width="55%">NOTES</th>				 				 				 
			</tr>
		</thead>
		<tbody>
		<cfset i=1>
		<cfloop query="variables.qry_NominalTelNos">
		<tr class="row_colour#i mod 2#">
		 <cfif isDefined('includePrintChecks')>
			<td><input type="checkbox" name="chkIncludeTelephones" id="chkIncludeTelephones" value="#TEL_NO#|#IIF(Len(DATE_CREATED) GT 0,de(DateFormat(DATE_CREATED,"DD-MMM-YYYY")),de(DateFormat(DATE_FROM,"DD-MMM-YYYY")))#"></td>				 
		 </cfif>			
		 <td valign="top">#IIF(Len(DATE_CREATED) GT 0,de(DateFormat(DATE_CREATED,"DD-MMM-YYYY")),de(DateFormat(DATE_FROM,"DD-MMM-YYYY")))#</td>
		 <td valign="top">
          <cfif isNumeric(#TEL_NO#)>
          <strong><a href="#TEL_NO#" class="genieTelNoSearchLink">#TEL_NO#</a></strong>
          <cfelse>
          <b>#TEL_NO#</b>
          </cfif>
 		 </td>
		 <td valign="top">#OWNER_USER#</td>
		 <td valign="top">#TYPE#</td>
		 <td valign="top">#ELEC_COMMS#</td>
		 <td valign="top">
		  
		  <cfset sCrimeRegExp="2[23][A-Z][A-Z0-9]/[0-9][0-9]*[A-Z]/[0-9][0-9]">
		  <cfset crimeMatches=REMatch(sCrimeRegExp,TEXT)>			    	  
		  <cfset outputText=TEXT>		  
		  <cfloop from="1" to="#arrayLen(crimeMatches)#" index="iMatch">
		  	 <cfset outputText=Replace(outputText,crimeMatches[iMatch],"<a href='"&crimeMatches[iMatch]&"' class='genieCrimeLink'>"&crimeMatches[iMatch]&"</a>","ALL")>
		  </cfloop>
		  #outputText#
		 <cfif Len(CUSTODY_REF) GT 0>
		 <br>
		  CUSTODY REF : <cfif Len(CUSTODY_TYPE) GT 0><a href="#CUSTODY_REF#" custodyType="#CUSTODY_TYPE#" class="genieCustodyLink">#CUSTODY_REF#</a><cfelse>#CUSTODY_REF#</cfif>
		 </cfif>
		 <cfif Len(CASE_REF) GT 0>
		 <br>
		  CASE REF : <cfif Len(CASE_TYPE) GT 0><a href="#CASE_REF#" caseType="#CASE_TYPE#" class="genieCaseLink">#CASE_REF#</a><cfelse>#CASE_REF#</cfif>
		 </cfif>		 
		 <cfif Len(INTEL_LOG) GT 0>
		 <br>
		  INTEL LOG : <a href="#INTEL_LOG#" class="genieIntelLink">#INTEL_LOG#</a>
		 </cfif>
		 <cfif Len(OIS_LOG) GT 0>
		 <br>
		  OIS REF : <a href="#OIS_LOG#" class="genieOISLink">#OIS_LOG#</a>
		 </cfif>	
		 	 				  
		 </td>
		</tr>
		<cfset i=i+1>
		</cfloop>
		</body>
		</table>
	<cfelse>
	  <p><b>NO VEHICLES RECORDED</b></p>
	</cfif>
			
 </cfoutput>			
</div>		
<cfif not isDefined("noAudit")>
 <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - TEL NOS",0,session.user.getDepartment())>
</cfif>
