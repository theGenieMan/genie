<cfsilent>
<!---

Module      : showIntelList.cfm

App         : GENIE

Purpose     : Displays a list of intelligence logs based on information passed from the vehicle/telephone searches 

Requires    : 

Author      : Nick Blackham

Date        : 19/11/2014

Revisions   : 

--->

<cfif type IS "Vehicle">
 <!--- get intel logs based on Veh_Ref --->
 <cfquery name="qry_Intel" datasource="#Application.WarehouseDSN#">
  SELECT int.*
  FROM   browser_owner.INTELL_SEARCH int, browser_owner.INTELL_VEHS iv
  WHERE  iv.LOG_REF=int.LOG_REF
  AND    iv.VEH_REF='#REF#'
  ORDER BY DATE_START DESC
 </cfquery>
 <cfset s_Title="Intelligence for #TYPE# <strong>#VRM#</strong>">
 <cfset Form_Title=Application..Form_Title&" - #Type# Intelligence - #VRM#">
<cfelseif type IS "Telephone">
<cfquery name="qry_Intel" datasource="#Application.WarehouseDSN#">
  SELECT int.*
  FROM   browser_owner.INTELL_SEARCH int, browser_owner.INTELL_TELS itl
  WHERE  itl.LOG_REF=int.LOG_REF
  AND    (itl.SOURCE='#SOURCE#'  AND   itl.SOURCE_ID='#SOURCE_ID#')
  ORDER BY DATE_START DESC
 </cfquery>
 <cfset Ref=TEL_NO>
 <cfset s_Title="Intelligence for #TYPE# <strong>#TEL_NO#</strong>">
 <cfset Form_Title=Application..Form_Title&" - #Type# Intelligence - #Tel_No#">
</cfif>

<cfloop query="qry_Intel">
 <cfif SECURITY_ACCESS_LEVEL LT Session.LoggedInUserLogAccess>
  <cfset str_Message="OTHER LOGS ARE RECORDED FOR WHICH YOU DO NOT HAVE ACCESS">
 </cfif>
</cfloop>

<cfset searchUUID=createUUID()>
</cfsilent>

<cfoutput>

 <h3 align="center">#s_Title#</h3>

  <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="intelMatches" printTitle="GENIE #s_Title#" printUser="#session.user.getFullName()#">

  <div id="intelMatches">
  <div>
  <cfif isDefined("str_Message")>
   <div class="error_title" align="center" style="clear:both;margin-top:3px;">
    #str_Message#
   </div>
  </cfif>
  <cfif qry_Intel.RecordCount GT 0>
 	<table width="98%" align="center" class="dataTable genieData">
 	 <thead>	
		 <tr>
			<th width="5%">LOG</th>
			<th width="3%">SAL</th>		
			<th width="16%">DATE FROM/TO</th>		
			<th width="11%">SOURCE DOC REF</th>			
			<th width="18%">INDICATOR</th>	            			
			<th width="8%">CREATED</th>
	     </tr>
	 </thead>
	 <tbody>
	 <cfset i=1>
	 <cfset lisLogs="">
	 <cfloop query="qry_Intel">	  
	 <cfif SECURITY_ACCESS_LEVEL GTE Session.LoggedInUserLogAccess>
		 <cfset logData=LOG_REF&"|"&SECURITY_ACCESS_LEVEL>
		 <cfset logData &= "|"&HAND_CODE&"|"&Replace(iif(Len(HAND_GUIDANCE) GT 0,DE(HAND_GUIDANCE),DE('None')),chr(10),"~","ALL")>
		 <cfset lisLogs=ListAppend(lisLogs,logData,chr(10))> 	 	  
		 <tr class="row_colour#i mod 2#">
			<td valign="top"><strong>		          					  				
				  <a href="#LOG_REF#" class="genieIntelLink" searchUUID="#searchUUID#" handCode="#HAND_CODE#" handGuide="#HAND_GUIDANCE#">#LOG_REF#</a>					 
			</strong></td>
			<td valign="top">#SECURITY_ACCESS_LEVEL#</td>
			<td valign="top">#DateFormat(DATE_START,"DD/MM/YYYY")# To #DateFormat(DATE_END,"DD/MM/YYYY")#</td>
			<td valign="top">#SOURCE_DOC_REF#</td>		
			<td valign="top"><strong>#INDICATOR#</strong></td>            
			<td valign="top">#DateFormat(DATE_CREATED,"DD/MM/YYYY")#</td>
	     </tr>	
		 <cfset i=i+1>
	   </cfif>
	 </cfloop>
	 </tbody>
	 </table>
	 <cffile action="write" file="#application.intelFTSTempDir##searchUUID#.txt" output="#lisLogs#">
 <cfelse>
 <h3 align="center">No Intelligence Available</h3>
 </cfif>
 </div>
 </div>
</cfoutput>

<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"INTEL LIST (show_intel_list.cfm)","","Type:#Type# Ref:#Ref#",0,session.user.getDepartment())>