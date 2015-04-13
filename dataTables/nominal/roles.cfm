<!---

Module      : roles.cfm

App         : GENIE

Purpose     : Delivers all offences nominal has been involved in, html table format

Requires    : 

Author      : Nick Blackham

Date        : 27/10/2014

Revisions   : 

--->

<cfif not isDefined("sort")>
 <cfset sort="DATE_CREATED">
</cfif>

<script>
$(document).ready(function() {  
 
	 // unbind any previous click events otherwise as the tab is reload we get multiple triggers
	 $( "#rolesTable.thSortable" ).unbind( "click" );
	 
	 $('#rolesTable').on('click','.thSortable',function(){	 	
		// sortable column clicked
		// get the new sort type / nominalRef and form the url
			var sortType=$(this).attr('sort');
			var nominalRef=$(this).attr('nominalRef');
			var newUrl='/dataTables/nominal/roles.cfm?nominalRef='+nominalRef+'&sort='+sortType;
			
        //	get the tabs, change the url and reload the tab					
			var tabs = $("#nominalTabs");
			var currentTabIndex = tabs.tabs("option", "active");			
			var tab = $(tabs.data('uiTabs').tabs[currentTabIndex]);			
			tab.find('.ui-tabs-anchor').attr('href', newUrl);										
			tabs.tabs("load", currentTabIndex);			
	 })	 
})
</script>

<cfset qry_CrimeDetails=Application.genieService.getWestMerciaNominalOffences(nominalRef=nominalRef,sort=sort)>

<!--- create a query of part iv bail roles, to help us decide if we need to colour the
      role as outstanding or not --->
<cfquery name="qPart4" dbtype="query">
	SELECT CRIME_NUMBER
	FROM   qry_CrimeDetails
	WHERE  ROLE_CODE='PTIV'
</cfquery>
<cfset lisPart4Crimes=ValueList(qPart4.CRIME_NUMBER,',')>      

<div id="dataContainer"> 
  <div class="dataTableTitle">
		ROLES
  </div>

  <cfoutput>
  <cfif qry_CrimeDetails.RecordCount GT 0>
	  <table width="100%" id="rolesTable" class="genieData ninetypc">
	 	<thead>
				 <tr>
				  <cfif isDefined('includePrintChecks')>
				  <th>&nbsp;INC?&nbsp;</th>
				  </cfif>	  
				  <th width="5%" class="#iif(sort IS "ROLE",de('thSorted'),de('thSortable'))#" sort="ROLE" nominalRef="#nominalRef#">ROLE</th>				
				  <th width="4%">PROC</th>	
				  <th width="4%">ELIM</th>				  
				  <th width="10%">OFFENCE</th>
				  <th width="12%">INCIDENT</th>
				  <th>OFFENCE TITLE</th>
				  <th width="18%" class="#iif(sort IS "DATE_COM",de('thSorted'),de('thSortable'))#" sort="DATE_COM" nominalRef="#nominalRef#">DATES COMMITTED</th>	
				  <th width="8%" class="#iif(sort IS "DATE_CREATED",de('thSorted'),de('thSortable'))#" sort="DATE_CREATED" nominalRef="#nominalRef#">CREATED</th>
				  <th width="8%">REFERRED</th>				
				  <th width="8%">FILED</th>				  					
				 </tr>
		 </thead>
		 <tbody>
		 <cfset j=1>
				 <!--- Just output the offences they should always have some --->
				 <cfset lisCrimes="">
				 <cfset searchUUID=createUUID()>
				 <cfloop query="qry_CrimeDetails">				  
				  	 <cfif ListFind(lisCrimes,CRIME_NUMBER&"|"&CRIME_REF,",") IS 0>					   	   
		             	<cfset lisCrimes=ListAppend(lisCrimes,CRIME_NUMBER&"|"&CRIME_REF,",")>
					 </cfif>
					 <cfif Len(DATE_FILED) IS 0
					   AND DETECTED_FLAG IS "2"
					   AND ROLE_CODE IS "SUSP"
					   AND DateDiff("d",CreateDate(2013,1,1),CREATED_DATE) GT 0
					   AND ListFind(lisPart4Crimes,CRIME_NUMBER) IS 0>
					   	<cfset highlightCrime=true>
					<cfelse>
						<cfset highlightCrime=false>
					</cfif>   
           				<tr class="#iif(highlightCrime,de('highlightCrime'),de('row_colour#j mod 2#'))#">
           				 <cfif isDefined('includePrintChecks')>
						 <td><input type="checkbox" name="chkIncludeCrimes" id="chkIncludeCrimes" value="#CRIME_NUMBER#"></td>
						 </cfif>	
					     <td><strong>#ROLE_CODE#</strong></td>
						 <td>#PROC_TYPE#</td>
						 <td>#ELIMINATED#</td>
						 <td>
						 	<strong><a href="#CRIME_NUMBER#" searchUUID="#searchUUID#" class="genieCrimeLink">#CRIME_NUMBER#</a></strong></td>
						 </td>
						 <td>
						  <cfif Len(INCIDENT_NO) IS 12>
							<a href="#INCIDENT_NO#" class="genieOISLink">#INCIDENT_NO#</a>
						  <cfelse>
						    #INCIDENT_NO#
						  </cfif>
						 </td>						 
						 <td>						 	
                            <cfif Len(SHORT_OFFENCE_TITLE) GT 50>#Left(SHORT_OFFENCE_TITLE,50)#<cfelse>#SHORT_OFFENCE_TITLE#</cfif>		                            				
						 </td>
						 <td>#DATE_COMM#</td>
						 <td>#CREATED_DATE#</td>
						 <td>#REFERRED_DATE#</td>
						 <td>#DATE_FILED#</td>
					  </tr>					
					<cfset j=j+1>
				 </cfloop>	
			<cffile action="write" file="#application.crimeTempDir##searchUUID#.txt" output="#lisCrimes#">	 
		 </tbody>
	  </table>	
   <cfelse>
		<p><b>NO ROLES RECORDED</b></p>
   </cfif>
  </cfoutput> 
</div>  
<cfif not isDefined("noAudit")>
    <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - ROLES",0,session.user.getDepartment())>
</cfif>