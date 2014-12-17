<!---

Module      : documents.cfm

App         : GENIE

Purpose     : Delivers all documents nominal has involvement with, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset qry_Documents=Application.genieService.getWestMerciaNominalDocuments(nominalRef=nominalRef)>
<div id="dataContainer">
  <div class="nominalTitle">
	DOCUMENTS
  </div>
  
	<cfif qry_Documents.RecordCount GT 0>	
	 <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
		  <th width="12%">DOC TYPE</th>
		  <th width="20%">DOC NUMBER</th>				  
		  <th width="13%">NAME</th>
		  <th width="13%">ISSUE PLACE</th>					
		  <th width="10%">DATE ISSUE</th>
		  <th width="10%">DATE EXPIRY</th>
		  <th width="25%">OTHER DETAILS</th>					
		 </tr>
	   </thead>
	   <tbody>	
		  <cfset j=1>
		   <cfloop query="qry_Documents">
			 <cfoutput>
				<tr class="row_colour#j mod 2#">
					<td valign="top"><strong>#DOC_TYPE#</strong></td>
					<td valign="top"><strong>#DOC_NUMBER#</strong></td>
					<td valign="top">#DOC_NAME#</td>
					<td valign="top">#ISSUE_PLACE#</td>						 
					<td valign="top"><cfif Len(DATE_ISSUE) GT 0>
						      #DateFormat(DATE_ISSUE,"DD/MM/YYYY")#
						     <cfelse>
						      &nbsp;
					         </cfif>
					</td>
					<td valign="top"><cfif Len(DATE_EXPIRY) GT 0>
							   #DateFormat(DATE_EXPIRY,"DD/MM/YYYY")#
					         <cfelse>
						      &nbsp;
						     </cfif>
				   </td>
				   <td valign="top">#OTHER_DETAILS#</td>
			    </tr>          
			  </cfoutput> 
			<cfset j=j+1>
		 </cfloop>	
	   </tbody>			 
      </table>		
	<cfelse>
	 <p><b>NO DOCUMENTS RECORDED</b></p>
	</cfif>
</div>
<cfif not isDefined("noAudit")>
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - DOCUMENTS",0,session.user.getDepartment())>
</cfif>