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
	<div class="dataTableTitle">
	RISK MANAGEMENT PLANS
	</div>
    
	<cfif ArrayLen(rmp) GT 0>	
	 <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
		  <th width="10%">RMP URN</th>
		  <th width="10%">TYPE</th>
		  <th width="20%">VICTIM(S)</th>
		  <th width="20%">OFFENDER(S)</th>				  
		  <th width="10%">GENERATED</th>				  
		  <th width="10%">DUE</th>				  
		  <th width="10%">RECEIVED</th>
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
			 <!--- process nominals so we have links available to other nominals on
			       plans, format of a nominal is. MR. SURNAME, Forename (NominalRef)
				   regex used to spot (nominalRef) --->			 
		     <tr class='row_colour#i mod 2#'>
			     <td valign="top" #rowUrnStyle#>
			     	<b>
			     		<a href="#application.rmp_link##rmp[i].getRMP_URN()#" rmpUrn="#rmp[i].getRMP_URN()#" class="genieRMPLink">#rmp[i].getRMP_URN()#</a>						
					</b>
				 </td>
				 <td valign="top">
				 	<b>#rmp[i].getRMP_TYPE()#
				 	<cfif rmp[i].getCATS_MAIN_FILE() IS "Y">
					<br>
					*** CATS MAIN FILE	
					</cfif>
				 	</b>
				</td>
				 <td valign="top">
				 	<cfset sVictims=rmp[i].getVICTIMS()>
					<cfset aVictimMatches=ReMatch("\([0-9]{1,7}[A-Z]\)",sVictims)>
					<cfset listVicAlreadyMatched=nominalRef>
				 	<cfloop from="1" to="#arrayLen(aVictimMatches)#" index="iVic">
					 <cfset sMatchedNomRef=Replace(Replace(aVictimMatches[iVic],"(","","ALL"),")","","ALL")>
					 <cfif ListFind(listVicAlreadyMatched,sMatchedNomRef,",") IS 0>
					 	<cfset sVictims=Replace(sVictims,aVictimMatches[iVic],"(<a href='#sMatchedNomRef#' class='genieNominal'>#sMatchedNomRef#</a>)")>
					    <cfset listVicAlreadyMatched=ListAppend(listVicAlreadyMatched,sMatchedNomRef,",")>
					 </cfif>		 
					</cfloop>
				 	#sVictims#
				 </td>
				 <td valign="top">
				 	<cfset sOffenders=rmp[i].getOFFENDERS()>
					<cfset aOffenderMatches=ReMatch("\([0-9]{1,7}[A-Z]\)",sOffenders)>
					<cfset listOffAlreadyMatched=nominalRef>
				 	<cfloop from="1" to="#arrayLen(aOffenderMatches)#" index="iOff">
					 <cfset sMatchedNomRef=Replace(Replace(aOffenderMatches[iOff],"(","","ALL"),")","","ALL")>
					 <cfif ListFind(listOffAlreadyMatched,sMatchedNomRef,",") IS 0>
					 	<cfset sOffenders=Replace(sOffenders,aOffenderMatches[iOff],"(<a href='#sMatchedNomRef#' class='genieNominal'>#sMatchedNomRef#</a>)")>
					    <cfset listOffAlreadyMatched=ListAppend(listOffAlreadyMatched,sMatchedNomRef,",")>
					 </cfif>		 
					</cfloop>
				 	#sOffenders#				 	
				 </td>
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