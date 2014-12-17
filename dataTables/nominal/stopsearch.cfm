<!---

Module      : stopsearches.cfm

App         : GENIE

Purpose     : Delivers all stop searches a nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset stopSearches=Application.genieService.getWestMerciaNominalStopSearch(nominalRef=nominalRef)>
<cfset searchUUID=createUUID()>
<div id="dataContainer"> 
	<div class="nominalTitle">
		STOP SEARCHES
	</div>
	
	<cfif ArrayLen(stopSearches) GT 0>
	<cfset lisSS="">
	 <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
		  <th width="5%">URN</th>
		  <th width="8%">DATE</th>				  
		  <th width="7%">OFFICER</th>				  
		  <th width="20%">TPU / LOCATION</th>		  				  
		  <th width="20%">REASON / GROUNDS</th>		  
		  <th width="8%">+TIVE / ARR</th>		  
		  <th width="8%">VEHICLE</th>
		  <th>COMMENTS</th>	
		  <th width="8%">IRAQS</th>					
		 </tr>
	   </thead>			 
	   <tbody>	 				 
		 <cfloop from="1" to="#ArrayLen(stopSearches)#" index="i">
		  <cfoutput>
		  	 <cfset lisSS=ListAppend(lisSS,stopSearches[i].getSS_URN(),",")>
		     <tr class="row_colour#i mod 2#">
			     <td valign="top"><strong><a href="#stopSearches[i].getSS_URN()#" searchUUID="#searchUUID#" class="genieStopSearchLink">#stopSearches[i].getSS_URN()#</a></strong></td>
				 <td valign="top">#stopSearches[i].getSS_DATE()#</td>
				 <td valign="top">#stopSearches[i].getOFFICER()#</td>
				 <td valign="top">#stopSearches[i].getTPU()# / #stopSearches[i].getSS_LOCATION()#</td>				 
				 <td valign="top">#stopSearches[i].getSS_REASON()#<br>#stopSearches[i].getSS_GROUNDS()#</td>				 
				 <td valign="top">+ : #stopSearches[i].getSS_POS_SEARCH()# <br> Arr: #stopSearches[i].getSS_ARREST()#</td>				 
				 <td valign="top">#stopSearches[i].getVEHICLE()#</td>	
				 <td valign="top">#stopSearches[i].getADD_COMMENTS()#</td>		
				 <td valign="top">
				 	<cfif ArrayLen(stopSearches[i].getLINKED_INTEL()) GT 0>
				       <cfset linkedIntel=stopSearches[i].getLINKED_INTEL()>
					   <cfloop from="1" to="#arrayLen(linkedIntel)#" index="iIntel">
					   	   <a href="#linkedIntel[iIntel]#" class="genieIntelLink"><strong>#linkedIntel[iIntel]#</strong></a><br>
					   </cfloop>
					</cfif>	 	
				 </td>				 
			  </tr>
		   </cfoutput> 					
		 </cfloop>				
		 <cffile action="write" file="#application.ssTempDir##searchUUID#.txt" output="#lisSS#">
	   </tbody> 
     </table>
	<cfelse>
		  <p><b>NO STOP SEARCHES RECORDED</b></p>
	</cfif>
</div>
<cfif not isDefined("noAudit")>
 <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - STOP SEARCH",0,session.user.getDepartment())>
</cfif>