<!---

Module      : rmps.cfm

App         : GENIE

Purpose     : Delivers all risk man plans a nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->


<cfset rmp=Application.genieService.getWestMerciaNominalRMP(nominalRef=nominalRef)>

<div id="dataContainer"> 
	<div class="nominalTitle">
	RISK MANAGEMENT PLANS
	</div>
    
	<cfif ArrayLen(rmp) GT 0>	
	 <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
		  <th width="15%">RMP URN</th>
		  <th width="20%">TYPE</th>				  
		  <th width="15%">GENERATED</th>				  
		  <th width="15%">DUE</th>				  
		  <th width="15%">RECEIVED</th>
		  <th width="10%">COMPLETED</th>
		  <th>SNT</th>				  					
		 </tr>
		</thead>
		<tbody> 				 				 
		 <cfloop from="1" to="#ArrayLen(rmp)#" index="i">
		  <cfoutput>
		  	 <cfif rmp[i].getCOMPLETED() IS NOT "Y">
			   	 <cfset rowUrnStyle="style='background-color:red; color:white'">						 
			 <cfelse>
			 	 <cfset rowUrnStyle="">
			 </cfif>
		     <tr class='row_colour#i mod 2#'>
			     <td valign="top" #rowUrnStyle#><b><a href="#rmp[i].getRMP_URN()#" class="genieRMPLink">#rmp[i].getRMP_URN()#</a></b></td>
				 <td valign="top"><b>#rmp[i].getRMP_TYPE()#</b></td>
				 <td valign="top">#rmp[i].getDATE_GENERATED_TEXT()#</td>
				 <td valign="top">#rmp[i].getDATE_DUE_TEXT()#</td>
				 <td valign="top">#rmp[i].getDATE_RECEIVED_TEXT()#</td>
				 <td valign="top">#rmp[i].getCOMPLETED()#</td>
				 <td valign="top">#rmp[i].getLPA()#</td>						 								 				 
			  </tr>
			</cfoutput> 					
		 </cfloop>
		</tbody>				 
       </table>		
   <cfelse>
	<p><b>NO RISK MANAGEMENT PLANS RECORDED</b></p>
   </cfif>

<cfif not isDefined("noAudit")>
 <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - RMP",0,session.user.getDepartment())>
</cfif>