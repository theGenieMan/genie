<!---

Module      : warnings.cfm

App         : GENIE

Purpose     : Delivers all warnings a nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset warnings=Application.genieService.getWestMerciaNominalWarnings(nominalRef=nominalRef, includeExpired='Y')>
 
<div id="dataContainer">
	
<div class="nominalTitle">
WARNINGS FULL HISTORY
</div>
	<cfif ArrayLen(warnings) GT 0>	
	 <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
	 	  <cfif isDefined('includePrintChecks')>
	      <th>&nbsp;INC?&nbsp;</th>
	      </cfif>				 	
		  <th width="25%">WARNING</th>
		  <th>NOTES</th>				  
		  <th width="15%">START DATE</th>
		  <th width="15%">END DATE</th>					
		 </tr>
       </thead>	
	   <tbody>			 
		 <cfloop from="1" to="#arrayLen(warnings)#" index="j">
		  <cfoutput> 
		      <tr class="row_colour#j mod 2#">
			     <cfif isDefined('includePrintChecks')>
			     <td><input type="checkbox" name="chkIncludeWarnings" id="chkIncludeWarnings" value="#warnings[j].getWSC_DESC()#|#warnings[j].getDATE_MARKED()#"></td>
			     </cfif>				 					      	
			     <td valign="top"><strong>#warnings[j].getWSC_DESC()#</strong></td>
				 <td valign="top">#warnings[j].getWS_NOTE()#</td>
				 <td valign="top">#warnings[j].getDATE_MARKED()#</td>
				 <td valign="top">#warnings[j].getEND_DATE()#</td>
			  </tr>             
		  </cfoutput> 
		 </cfloop>
	   </tbody>				 
      </table>		
	<cfelse>
 		<p><b>NO WARNINGS RECORDED</b></p>
	</cfif>
</div>

<cfif not isDefined("noAudit")>
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - WARNINGS",0,session.user.getDepartment())>
</cfif>