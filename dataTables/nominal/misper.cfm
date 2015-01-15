<!---

Module      : misper.cfm

App         : GENIE

Purpose     : Delivers all missing persons records nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset qry_Misper=application.genieService.getWestMerciaNominalMisper(nominalRef=nominalRef)>
 
<div id="dataContainer">
	
	<div class="dataTableTitle">
	MISSING PERSON
	</div>
	<cfif qry_MisPer.RecordCount GT 0>	
	 <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
		  <th width="10%">CASE</th>
		  <th width="20%">MISSING FROM/TO</th>				  
		  <th width="10%">STATUS</th>            
		  <th width="10%">DURATION</th>
		  <th width="10%">RISK</th>
		  <th>ADDRESS FOUND</th>
		  <th width="10%">DATE FOUND</th>                        
		 </tr> 
        </thead>
		<tbody>
		 <cfset j=1>
		 <cfloop query="qry_MisPer">
		  <cfoutput>
              
           <cfif Len(MISSING_END) IS 0>
            <cfset variables.missingStatus="MISSING">
            <tr bgcolor="##DD0000" style="color:##FFFFFF">
             <cfset tCol="##FFFFFF">
           <cfelse>
            <cfset variables.missingStatus="FOUND">
            <tr class="row_colour#j mod 2#">
           </cfif>
			 <td><a href="#CASE_NO#" class="genieMisperLink"><strong>#CASE_NO#</strong></a></td>
			 <td>
               #DateFormat(MISSING_START,"DD/MM/YYYY")# #TimeFormat(MISSING_START,"HH:mm")#
               <cfif Len(MISSING_END) GT 0>
               to #DateFormat(MISSING_END,"DD/MM/YYYY")# #TimeFormat(MISSING_END,"HH:mm")#
               </cfif> 
             </td>
             <td>#missingStatus#</td>
			 <td>
                <cfif Len(MISSING_PERIOD) GT 0>
                 <cfset sMisPeriod=MISSING_PERIOD>
                <cfelse>
                 <cfif Len(MISSING_END) GT 0>
                   <cfset sMisPeriod=DateDiff("d",MISSING_START,MISSING_END)&" days, #Int(DateDiff('h',MISSING_START,MISSING_END) MOD 24)# hours">
                 <cfelse>
                   <cfset sMisPeriod=DateDiff("d",MISSING_START,now())&" days, #Int(DateDiff("h",MISSING_START,now()) MOD 24)# hours">                 
                 </cfif>
                </cfif>
                #sMisPeriod#
			 <td>
                #RISK_DESC#
			 </td>						 
			 <td>
                #ADDRESS_FOUND#   
             </td>						 
			 <td>
                #DateFormat(DATE_FOUND,"DD/MM/YYYY")#    
             </td>				             
		    </tr>           
			</cfoutput> 
			<cfset j=j+1>
		 </cfloop>
		 </tbody>				 
        </table>		
		<cfelse>
		 <p><b>NO MISSING PERSON DATA RECORDED</b></p>
		</cfif>
</div>		
<cfif not isDefined("noAudit")>
<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - MISSING PERSONS",0,session.user.getDepartment())>
</cfif>