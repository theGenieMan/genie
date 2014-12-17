<!---

Module      : custodies.cfm

App         : GENIE

Purpose     : Delivers all custodies nominal has been involved in, html table format

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->

<cfset custodies=application.genieService.getWestMerciaNominalCustodies(nominalRef=nominalRef)>
<div id="dataContainer">
  <div class="nominalTitle">
		CUSTODIES
  </div>

<cfset searchUUID=createUUID()>

<cfif ArrayLen(custodies) GT 0>

  	<table width="100%" class="genieData ninetypc">
	 	<thead>
  	      <tr>
		    <th width="10%">REF</th>
			<th width="8%">DATE</th>
			<th width="6%">STN</th>
			<th width="27%">ARREST REASON / PLACE</th>					
			<th width="29%">DEPARTURE REASON</th>										
			<th width="10%">ARR OFF</th>
			<th width="10%">OIC</th>										
		  </tr>				
		</thead>
		<tbody> 
		
		  <cfoutput>
			<cfset lisCust="">
			<cfloop index="i" from="1" to="#ArrayLen(custodies)#" step="1">								 
				<tr class="row_colour#i mod 2#">				  
				  <td valign="top">										  
					  <b><a href="#custodies[i].getCustody_Ref()#" custodyType="#custodies[i].getCustody_Type()#" searchUUID="#searchUUID#" class="genieCustodyLink">#custodies[i].getCustody_Ref()#</a></b>
					  <cfset lisCust=ListAppend(lisCust,custodies[i].getCustody_Ref()&"|"&custodies[i].getCustody_Type(),",")>					  					
				  <td valign="top">#DateFormat(custodies[i].getArrest_Time(),"DD/MM/YYYY")# #TimeFormat(custodies[i].getArrest_Time(),"HH:mm")#</td>
				  <td valign="top">#custodies[i].getStation()#</td>
				  <td valign="top">				  	
	                <cfset reasons=custodies[i].getCustodyReasons()>
				    <cfloop from="1" to="#ArrayLen(reasons)#" index="y">
			         #y#. #reasons[y].getARREST_REASON_TEXT()#<Br>
			        </cfloop>   
					<br><cfif Len(custodies[i].getPlace_OF_ARREST()) GT 70>#Left(custodies[i].getPlace_OF_ARREST(),70)#<cfelse>#custodies[i].getPlace_OF_ARREST()#</cfif>					
					</td>
					<td valign="top">					
	                <cfset departures=custodies[i].getCustodyDepartures()>
			         <cfloop from="1" to="#ArrayLen(departures)#" index="x">
			         #x#. #departures[x].getREASON_FOR_DEPARTURE()#<Br>
			         </cfloop>						
				    </td>
					<td valign="top">#custodies[i].getAO_BADGE()# #custodies[i].getAO_NAME()#</td>
					<td valign="top">#custodies[i].getOIC_BADGE()# #custodies[i].getOIC_NAME()#</td>										          
				 </tr> 				 				 				 
			 </cfloop>
			 <cffile action="write" file="#application.custodyTempDir##searchUUID#.txt" output="#lisCust#">
			 </cfoutput>
		
		</tbody>
	</table>
	
	<cfelse>
		<p><b>NO CUSTODIES RECORDED</b></p> 		
	</cfif>
</div>    	
<cfif not isDefined("noAudit")>  	 
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - CUSTODIES",0,session.user.getDepartment())>
</cfif>
