<!---

Module      : bails.cfm

App         : GENIE

Purpose     : Delivers all bails nominal has been involved in, html table format

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->

<cfset bails=Application.genieService.getWestMerciaNominalBails(nominalRef=nominalRef)>
<div id="dataContainer">
  <div class="dataTableTitle">
		BAILS
  </div>
  
  <cfif ArrayLen(bails) GT 0>
  	<table width="100%" class="genieData ninetypc">
	 	<thead>
  	      <tr>
            <th width="10%">TYPE</th>				
		    <th width="15%">CUST REF</th>
			<th width="30%">BAILED BY/TO</th>
			<th width="30%">IN CONNECTION WITH</th>				 
			<th width="15%">OFFICER</th>
		  </tr>
		</thead>
		<tbody>
		  <cfoutput>
			<cfloop from="1" to="#ArrayLen(bails)#" index="i">
				<cfif (Len(bails[i].getSTATUS()) IS 0 OR bails[i].getSTATUS() IS "GRANTED") AND
					   DateDiff("n",bails[i].getBAILED_TO_DATE(),now()) LTE 0>
				<tr bgcolor="##DD0000">						   
				<cfelse>
				<tr class="row_colour#i mod 2#">
			    </cfif>
				 <td valign="top">#bails[i].getBAIL_TYPE()#</td>
				 <td valign="top">#bails[i].getCUSTODY_REF()#</td>
				 <td valign="top"><b>Bail By</b> : #bails[i].getBAILED_FROM()# #DateFormat(bails[i].getDATE_SET(),"DD/MM/YYY")#<br>
				     <b>Bail To</b> : #bails[i].getBAILED_TO()# #DateFormat(bails[i].getBAILED_TO_DATE(),"DD/MM/YYY")#
				     <cfif bails[i].getBAIL_TYPE() IS "POLICE">#TimeFormat(bails[i].getBAILED_TO_DATE(),"HH:mm")#</cfif>
					 <cfif bails[i].getSTATUS() IS "CANCELLED" or Len(bails[i].getCANCELLATION_DATE()) GT 0>
					 <br><br><b>Cancelled Reason</b> : #bails[i].getCANCELLATION_REASON()#
					 </cfif>
					 
                     <cfset bailConds=bails[i].getBailConditions()>
					 <cfif ArrayLen(bailConds) GT 0>
					   <br><br><b>Bail Conditions</b>	 
					   <cfloop from="1" to="#ArrayLen(bailConds)#" index="j">
						 <br>
						 <b>Condition</b> : #bailConds[j].getCONDITION()#
						 <br><b>Reason</b> : #bailConds[j].getREASON()#
					   </cfloop>
					 </cfif>						 
				 </td>
				 <td valign="top">
                  <cfset bailDetails=bails[i].getBailDetails()>

				  <cfif ArrayLen(bailDetails) GT 0>  
					<cfloop from="1" to="#ArrayLen(bailDetails)#" index="k">
					<cfif k GT 1><br></cfif>#bailDetails[k].getOFFENCE_DETAIL()#
					</cfloop>
				  </cfif>
				 </td>
				 <td valign="top">#bails[i].getBAIL_OFFICER()#</td>
				</tr>
				<cfset i=i+1>
			</cfloop>
		  </cfoutput>			
		</tbody>
	</table>
  <cfelse>
  	 <p><b>NO BAILS RECORDED</b></p> 
  </cfif>
</div>  
<cfif not isDefined("noAudit")>	
<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - BAILS",0,session.user.getDepartment())>
</cfif>  