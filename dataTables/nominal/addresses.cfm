<!---

Module      : Nominal_Addresses.cfm

App         : Nominal Photo Searching

Purpose     : Delivers all addresses nominal has associations with. This is included from NominalDetails.cfm

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->

<cfset qry_AddressDetails=Application.genieService.getWestMerciaNominalAddresses(nominalRef=nominalRef)>
<div id="dataContainer">
 <div class="nominalTitle">
 ADDRESSES
 </div>
 
 <cfif qry_AddressDetails.RecordCount GT 0>
   <table width="100%" class="genieData ninetypc">
   	<thead>
 		<tr>
		 	<cfif isDefined('includePrintChecks')>
		    <th>&nbsp;INC?&nbsp;</th>
		    </cfif>
		    <th>Address</th>
			<th>Recorded</th>
			<th>Type</th>
			<th>SNT</th>
			<th>&nbsp;</th>
	    </tr>  	
	</thead>
    <tbody>
		<cfset i=1>
		 <cfloop query="qry_AddressDetails">
			 <cfoutput>
			 <tr class="row_colour#i mod 2#">
				<cfif isDefined('includePrintChecks')>
				<td><input type="checkbox" name="chkIncludeAddresses" id="chkIncludeAddresses" value="#Replace(ADDRESS,",","~","ALL")#|#DATE_REC#|#TYPE#"></td>
				</cfif>				 	
			    <td>#ADDRESS#</td>
			    <td>#DATE_REC#</td>
				<td>#TYPE#</td>
				<td><a href="#SNT_CODE#" class="genieAddressSNT">#SNT_CODE#</a></td>
				<td>
					<cfif Len(POST_CODE) GT 0 AND POST_CODE IS NOT "*">
					<a href="#BUILDING_NUMBER# #STREET_1# #TOWN# #POST_CODE#" class="genieAddressMap">Map</a>
					</cfif>
				</td>
			 </tr>
			 </cfoutput>
			 <cfset i=i+1>
		 </cfloop>
	</tbody>
   </table>	 
 <cfelse>
   <p><b>NO ADDRESSES RECORDED</b></p>	 
 </cfif>
</div> 
 <cfif not isDefined("noAudit")>  
    <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - ADDRESSES",0,session.user.getDepartment())>    
</cfif>