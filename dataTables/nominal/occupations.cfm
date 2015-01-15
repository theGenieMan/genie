<!---

Module      : occupations.cfm

App         : GENIE

Purpose     : Delivers all occupations nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset qry_Occs=Application.genieService.getWestMerciaNominalOccupations(nominalRef=nominalRef)>
 
<div id="dataContainer">
	
<div class="dataTableTitle">
OCCUPATIONS
</div>

	<cfif qry_Occs.RecordCount GT 0>
	 <table width="100%" class="genieData ninetypc">
	   <thead>	
		 <tr>
		  <th width="25%">OCCUPATION</th>
		  <th>CURRENT WORK LOCATION</th>				  
		  <th width="20%">DATE RECORDED</th>
		  <th width="15%">NOTIFIABLE</th>					
		 </tr>
	    </thead>
		<tbody>		
		 <cfset j=1>
		 <cfloop query="qry_Occs">
		  <cfoutput>
			  <tr class="row_colour#j mod 2#">
			     <td valign="top"><strong>#OCCUPATION#</strong></td>
				 <td valign="top">#CURRENT_WORK_LOCATION#</td>
				 <td valign="top">#DateFormat(OCCUPATION_DATE,"DD/MM/YYYY")#</td>
				 <td valign="top">#PROF_BODY#</td>						 
			  </tr>
			</cfoutput> 
			<cfset j=j+1>
		 </cfloop>
	   </tbody>				 
      </table>		
	<cfelse>
	 <p><b>NO OCCUPATIONS RECORDED</b></p>
	</cfif>
</div>

<cfif not isDefined("noAudit")>
 <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - OCCUPATIONS",0,session.user.getDepartment())>
</cfif>