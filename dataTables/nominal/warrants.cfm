<!---

Module      : warrants.cfm

App         : GENIE

Purpose     : Delivers all warrants nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset arr_Warrants=application.genieService.getWestMerciaNominalWarrants(nominalRef=nominalRef)>
<div id="dataContainer">
<div class="dataTableTitle">
WARRANTS
</div>

    <cfif ArrayLen(arr_Warrants) GT 0>
		<table width="100%" class="genieData ninetypc">
	  	  <thead>	 			 
			 <tr>
			    <th width="4%">REF</th>
				<th width="20%">TYPE</th>					
				<th width="6%">CLASS</th>                    
				<th width="6%">ISSUED</th>
				<th width="6%">EXEC</th>
				<th width="21%">COURT</th>					
				<th width="19%">OFFENCE</th>										
				<th width="18%">EXECUTION METHOD</th>															
			 </tr>
		  </thead>
		  <tbody>
			 <cfoutput>
			 <cfloop index="i" from="1" to="#ArrayLen(arr_Warrants)#" step="1">
			 
			  <cfif i MOD 2 IS 0>
			    <cfset i_Col="FFFFC6">
			  <cfelse>
			    <cfset i_Col="CACACA">
			  </cfif>			
			 
			  <cfif Len(arr_Warrants[i].Executed) IS 0> 
			    <cfset i_Col="DD0000">
				<tr bgcolor="#i_Col#">
			  <cfelse>
				 <tr class="row_colour#i mod 2#">				 
			  </cfif>
	
				  <td valign="top"><b>#arr_Warrants[i].Ref#</b></td>
	     		  <td valign="top"><b>#arr_Warrants[i].WType#</b></td>					
				  <td valign="top">Cat #arr_Warrants[i].Classification#</td>          
				  <td valign="top">#arr_Warrants[i].Issued#</td>
				  <td valign="top">#arr_Warrants[i].Executed#</td>
				  <td valign="top"><cfif Len(arr_Warrants[i].Court) GT 40>#Left(arr_Warrants[i].Court,40)#<cfelse>#arr_Warrants[i].Court#</cfif></td>
				  <td valign="top">#arr_Warrants[i].Offence#</td>
				  <td valign="top">#arr_Warrants[i].ExMeth#</td>														
				</tr>
		      <cfif Len(arr_Warrants[i].Notes) GT 0>
		        <tr class="row_colour#i mod 2#">
		          <td valign="top" colspan="8"> Notes : #arr_Warrants[i].Notes#</td>
		        </tr>  
		      </cfif>
		      <tr>
		      	<td colspan="8"><hr></td>
		      </tr>
	 		</cfloop>
	 		</cfoutput>
	 	 </tbody>
		</table>
	 <cfelse>
		 <p><b>NO WARRANTS RECORDED</b></p>						 
	 </cfif>
</div>
<cfif not isDefined("noAudit")>
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - WARRANTS",0,session.user.getDepartment())>
</cfif>