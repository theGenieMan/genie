<!---

Module      : vehicles.cfm

App         : GENIE

Purpose     : Delivers all vehicles nominal has involvement with, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset arr_Vehicles=Application.genieService.getWestMerciaNominalVehicles(nominalRef=nominalRef)>
<div id="dataContainer">
  <div class="dataTableTitle">
		VEHICLES
  </div>

  <cfif ArrayLen(arr_Vehicles) GT 0>
    <table width="100%" class="genieData ninetypc">
    	<thead>								 
		 <tr>
	 	 <cfif isDefined('includePrintChecks')>
		    <th width="1%">&nbsp;INC?&nbsp;</th> 	
		 </cfif>					 	
		    <th width="20%">REASON</th>
			<th width="10%">REG</th>
			<th width="10%">COLOUR</th>
			<th width="20%">MAKE</th>					
			<th width="20%">MODEL</th>										
			<th width="10%">BODY TYPE</th>					
			<th width="10%">FROM</th>															
		 </tr>
		</thead>
		 <tbody>		 
		<cfoutput>
		 <cfloop index="i" from="1" to="#ArrayLen(arr_Vehicles)#" step="1">
				<tr class="row_colour#i mod 2#">
			       <cfif ListLen(arr_Vehicles[i].Role,":") GT 1>
					<cfset theRole=ListGetAt(arr_Vehicles[i].Role,1,":")>
				   <cfelse>
					<cfset theRole=arr_Vehicles[i].Role>
				   </cfif>	
				 <cfif isDefined('includePrintChecks')>
					<td><input type="checkbox" name="chkIncludeVehicles" id="chkIncludeVehicles" value="#arr_Vehicles[i].Reg#|#DateFormat(arr_Vehicles[i].DateFrom,"DD-MMM-YYYY")#|#arr_Vehicles[i].Colour#|#arr_Vehicles[i].Make#|#arr_Vehicles[i].Model#|#REReplaceNoCase(theRole,'<[^>]*>', '','ALL')#"></td>				 
				 </cfif>	
				  <td>				  					   
					#theRole#				   
				  </td>
				  <td>
					<strong><a href="#arr_Vehicles[i].Reg#" class="genieVehicleSearchLink">#arr_Vehicles[i].Reg#</a></strong>
				  </td>
				  <td>#arr_Vehicles[i].Colour#</td>
				  <td>#arr_Vehicles[i].Make#</td>
				  <td>#arr_Vehicles[i].Model#</td>
				  <td>#arr_Vehicles[i].Body#</td>
				  <td>#DateFormat(arr_Vehicles[i].DateFrom,"DD-MMM-YYYY")#</td>																				
				 </tr>			 
				  </cfloop>
				 </cfoutput>
		  </tbody>
		</table>
		<cfelse>
		  <p><b>NO VEHICLES RECORDED</b></p>
	 	</cfif>			
</div>
<cfif not isDefined("noAudit")>
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# #application.genieService.getWestMerciaNominalFullName(nominalRef)# - VEHICLES",0,session.user.getDepartment())>
</cfif>