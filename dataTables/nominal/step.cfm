<!---

Module      : step.cfm

App         : GENIE

Purpose     : Delivers all step packages nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset qry_Step=application.genieService.getWestMerciaNominalSTEP(nominalRef=nominalRef)>

<div id="dataContainer">
	
<div class="dataTableTitle">
STEP PACKAGES
</div>

 	<cfif qry_Step.RecordCount GT 0>
	 <table width="100%" class="genieData ninetypc">
	   <thead>		  	  
		 <tr>
		    <th width="8%">URN</th>
			<th width="12%">CATEGORY</th>
			<th width="8%">SECTION</th>
			<th width="10%">TARGET DATE</th>					
			<th width="10%">DATE RETURNED</th>										
			<th>PROBLEM OUTLINE</th>									
		 </tr>
	  </thead>
	  <tbody>				 
		 <cfoutput>
		 <cfset i=1>
		 <cfloop query="qry_StEP">			
		 
		 <cfif Len(COMPLETED) IS 0>
          <cfif Len(RECEIVED_DATE) IS 0 AND DateDiff('d',RETURN_DATE,now()) GT 0>
		   <cfset  rowCol="style='background-color:##FF3E3E'">	 
          <cfelseif DateDiff('d',RETURN_DATE,now()) LTE 0>
			   <cfset  rowCol="style='background-color:##FF9933'">	
          <cfelse>
		   <cfset  rowCol="style='background-color:##FF9933'">			                               
			  </cfif>
		 <cfelse>
		   <cfset rowCol="style='background-color:##99FF33'">
		 </cfif>
		 
		 <tr #rowCol#>
           <td valign="top"><strong><a href="#PACKAGE_URN#" class="genieSTEPLink">#PACKAGE_URN#</a></strong></td>
		   <td valign="top">#CATEGORY_DESCRIPTION#</td>
		   <td valign="top">#SECTION_NAME#</td>
		   <td valign="top">#DateFormat(RETURN_DATE,'DD/MM/YYYY')#</td>
		   <td valign="top">#DateFormat(RECEIVED_DATE,'DD/MM/YYYY')#</td>
		   <td valign="top">#PROBLEM_OUTLINE#<cfif Len(NOTES) GT 0><br><br>#NOTES#</cfif></td>
		 </tr> 		
		  <cfset i=i+1>		 				 				 
		 </cfloop>
		 </cfoutput>
	  </body>
	 </table>
	 <cfelse>
		<p><b>NO STEP PACKAGES RECORDED</b></p>	
	 </cfif>
</div>	 	
    
<cfset str_SearchResults="STEP">		
<cfif not isDefined("noAudit")> 
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# #application.genieService.getWestMerciaNominalFullName(nominalRef)# - STEP",0,session.user.getDepartment())>
</cfif>