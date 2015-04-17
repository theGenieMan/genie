<!---

Module      : organisations.cfm

App         : GENIE

Purpose     : Delivers all organisation nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->


<cfset qry_Organisations=application.genieService.getWestMerciaNominalOrganisations(nominalRef=nominalRef)>

<div id="dataContainer">
<div class="dataTableTitle">
ORGANIASTIONS
</div>
 
 <cfif qry_Organisations.RecordCount GT 0>
   <table width="100%" class="genieData ninetypc">
	 <thead>  
		 <tr>
		    <th width="25%">ORGANISATION</th>
			<th width="25%">ADDRESS</th>
			<th width="10%">RECORDED</th>
			<th width="10%">TELEPHONE</th>					
			<th width="15%">NATURE OF ORG</th>										
			<th width="15%">RELATIONSHIP</th>										
		 </tr>
	 </thead>
	 <tbody>
	  <cfoutput>
		<cfset i=1>		
		<cfloop query="qry_Organisations">								  			  
		 <tr class="row_colour#i mod 2#">			
           <td valign="top">#ORG_NAME#</td>
		   <td valign="top">
		   #ADDRESS#
		  </td>
		  <td valign="top">#DATE_REC#</td>
		  <td valign="top">
		   <cfif Len(Telephone_1) GT 0 AND Len(Telephone_2) GT 0>
			 #TELEPHONE_1#<br>#TELEPHONE_2#
		   <cfelseif Len(Telephone_1) GT 0>
		     #TELEPHONE_1#
		   <cfelseif Len(Telephone_2) GT 0>
		     #TELEPHONE_2#				   
		   <cfelse>
		     &nbsp;
		   </cfif>
		  </td>
		  <td valign="top">#DESCRIPTION#</td>
		  <td valign="top">#RELATIONSHIP_TO_ORG#</td>				  						
		 </tr>
		 <cfset i++>
		 </cfloop>
		 </tbody>
		</table>
		</cfoutput>
	<cfelse>
	  <p><b>NO ORGANISATIONS RECORDED</b></p>	
 	</cfif>
</div>		 

<cfif not isDefined("noAudit")>
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# #application.genieService.getWestMerciaNominalFullName(nominalRef)# - ORGANISATIONS",0,session.user.getDepartment())>
</cfif>