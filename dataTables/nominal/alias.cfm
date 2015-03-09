<!---

Module      : alias.cfm

App         : GENIE

Purpose     : Delivers all aliases nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset qry_NominalRelationships=Application.genieService.getWestMerciaNominalAlias(nominalRef=nominalRef)>
<div id="dataContainer">
<div class="dataTableTitle">
ALIASES
</div>

	 <cfif qry_NominalRelationships.RecordCount GT 0>
	 <table width="100%" class="genieData ninetypc">
	   <thead>
	   	<tr>
		    <cfif isDefined('includePrintChecks')>
		    <th>&nbsp;INC?&nbsp;</th>
			</cfif>					 	
		    <th width="8%">TYPE</th>
			<th width="2%">NT</th>
			<th width="20%">NOMINAL REF</th>
			<th width="25%">NAME</th>				
			<th>DOB</th>						
	 	</tr>
	   </thead>
	   <tbody>	 
	   <cfoutput>
	   <cfset i=1>
  	   <cfloop query="qry_NominalRelationships">
		<tr class="row_colour#i mod 2#">
			  <cfif isDefined('includePrintChecks')>
			  <td><input type="checkbox" name="chkIncludeAlias" id="chkIncludeAlias" value="#REL_TYPE#|#NOMINAL_REF#|#Replace(NAME,",","~","ALL")#|#DOB#"></td>
			  </cfif>					  			
			  <td>#REL_TYPE#</td>
			  <td>#NAME_TYPE#</td>
			  <td>#NOMINAL_REF#</td>
			  <td>#NAME#</td>
			  <td>#DOB#</td>
		</tr>
	    <cfset i=i+1>
	    </cfloop>
	  </tbody>
	 </table>
	 </cfoutput>
	 <cfelse>
		<p><b>NO ALIASES RECORDED</b></p>			 
	 </cfif>
</div>
<cfif not isDefined("noAudit")>
    <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - ALIASES",0,session.user.getDepartment())>
</cfif>