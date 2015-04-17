<!---

Module      : iraqs.cfm

App         : GENIE

Purpose     : Delivers all intelligence nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<script>
$(document).ready(function() {  
 
	 // unbind any previous click events otherwise as the tab is reload we get multiple triggers
	 $( "#iraqsTable.thSortable" ).unbind( "click" );
	 
	 $('#iraqsTable').on('click','.thSortable',function(){	 	
		// sortable column clicked
		// get the new sort type / nominalRef and form the url
			var sortType=$(this).attr('sort');
			var nominalRef=$(this).attr('nominalRef');
			var newUrl='/dataTables/nominal/iraqs.cfm?nominalRef='+nominalRef+'&sort='+sortType;
			
        //	get the tabs, change the url and reload the tab					
			var tabs = $("#nominalTabs");
			var currentTabIndex = tabs.tabs("option", "active");			
			var tab = $(tabs.data('uiTabs').tabs[currentTabIndex]);			
			tab.find('.ui-tabs-anchor').attr('href', newUrl);										
			tabs.tabs("load", currentTabIndex);			
	 })	 
})
</script>

<cfif not isDefined("sort")>
 <cfset sort="date">
</cfif>

<cfset qry_Iraqs=application.genieService.getWestMerciaNominalIraqs(nominalRef=nominalRef,sort=sort)>

<!--- users of log access level 1,2 or 3 can see that logs exists for lower access levels
      but they are not actually allowed to read the logs they just appear in the list 
	  1 = Display all logs but deny access if < level 20
	  2 = Display all logs but deny access if < level 15
	  3 = Display all logs but deny access if < level 10 --->
<cfif Session.LoggedInUserLogAccess IS 1 OR Session.LoggedInUserLogAccess IS 2 
   OR Session.LoggedInUserLogAccess IS 3 OR Session.LoggedInUserLogAccess IS 15>
   <cfset viewAllLogs="YES">
   <cfif Session.LoggedInUserLogAccess IS 1>
	 <cfset actualLogLevel=20>
   <cfelseif Session.LoggedInUserLogAccess IS 2>
	 <cfset actualLogLevel=15>
   <cfelseif Session.LoggedInUserLogAccess IS 3>
	 <cfset actualLogLevel=10>
   <cfelse>
   	 <cfset actualLogLevel=Session.LoggedInUserLogAccess>
   </cfif>
<cfelse>
 <cfset actualLogLevel=Session.LoggedInUserLogAccess>
 <cfset viewAllLogs="NO">
</cfif>

<cfloop query="qry_Iraqs">
 <cfif SECURITY_ACCESS_LEVEL LT actualLogLevel>
  <cfset str_Message="OTHER LOGS ARE RECORDED FOR WHICH YOU DO NOT HAVE ACCESS">
  <cfbreak>
 </cfif>
</cfloop>

<div id="dataContainer">
	<div class="dataTableTitle">
	INTELLIGENCE
	</div>
	<cfif isDefined("str_Message")>
	<cfoutput>	
	<div class="error_title" align="center">
	 #str_Message#
	</div>
	</cfoutput>
	</cfif>
	
	<cfset searchUUID=CreateUUID()>		
    <cfoutput>
	  <cfif qry_Iraqs.RecordCount GT 0>
 	  <table width="100%" id="iraqsTable" class="genieData ninetypc">
	   <thead>	  	  
		 <tr>
		 	<cfif isDefined('includePrintChecks')>
			<th width="1%">&nbsp;INC?&nbsp;</th> 	
			</cfif>
		    <th width="5%" class="#iif(sort IS "logno",de('thSorted'),de('thSortable'))#" sort="logno" nominalRef="#nominalRef#">REF</th>					 
		    <th width="8%">EVALUATION</th>
			<th width="20%" class="#iif(sort IS "date",de('thSorted'),de('thSortable'))#" sort="date" nominalRef="#nominalRef#">DATE FROM/TO</th>
			<th width="17%">SOURCE DOC REF</th>			
			<th width="3%" class="#iif(sort IS "sal",de('thSorted'),de('thSortable'))#" sort="sal" nominalRef="#nominalRef#">SAL</th>										
			<th>INDICATOR</th>										
		 </tr>
		</thead>
		<tbody>		
		 <cfset j=1>
		 <cfset lisLogs=""> 
		 <cfloop query="qry_Iraqs">				
		
			<cfset str_Avail="YES">
			<cfset displayThisRow="YES">
			
			<cfif viewAllLogs IS "NO">
			  <cfif SECURITY_ACCESS_LEVEL LT actualLogLevel>				
			    <cfset displayThisRow="NO">	  
		      </cfif>		  
			</cfif>
			
			<cfset displayLogLink="YES">
			
			<cfif viewAllLogs IS "YES">
			  <cfif SECURITY_ACCESS_LEVEL LT actualLogLevel>				
				<cfset displayLogLink="NO">
			  </cfif>
			</cfif>
			 
			<cfif displayThisRow IS "YES">
			<cfset logData=LOG_REF&"|"&SECURITY_ACCESS_LEVEL>
			<cfset logData &= "|"&HAND_CODE&"|"&Replace(iif(Len(HAND_GUIDANCE) GT 0,DE(HAND_GUIDANCE),DE('None')),chr(10),"~","ALL")>
			<cfif displayLogLink>
				<cfset lisLogs=ListAppend(lisLogs,logData,chr(10))>
			</cfif>	 	
		<tr class="row_colour#j mod 2#">
		 <cfif isDefined('includePrintChecks')>
		  <td><input type="checkbox" name="chkIncludeIntel" id="chkIncludeIntel" value="#LOG_REF#|#SECURITY_ACCESS_LEVEL#"></td>
		 </cfif>										
		  <td>
		  <cfif displayLogLink IS "YES">
			 <strong>  
				<a href="#LOG_REF#" class="genieIntelLink" searchUUID="#searchUUID#" handCode="#HAND_CODE#" handGuide="#HAND_GUIDANCE#">#LOG_REF#</a>
			 </strong>	   
		  <cfelse>
		  	  #LOG_REF#		 	 
		  </cfif>
		  </td>
		  <td>#FIVE_BY_FIVE#</td>
		  <td>
			  #DateFormat(DATEFROM,"DD/MM/YYYY")#
			 <cfif isDate(DATETO)>
			  -#DateFormat(DATETO,"DD/MM/YYYY")#
			 </cfif>					 
			 </td>
		  <td>#SOURCE_DOC_REF#</td>		
		  <td>#SECURITY_ACCESS_LEVEL#</td>
		  <td>#LOG_INDICATOR#</td>														  
		 </tr>
		 <cfset j=j+1>
		 </cfif>
		 </cfloop>
		</tbody>
	   </table>
	   <cffile action="write" file="#application.intelFTSTempDir##searchUUID#.txt" output="#lisLogs#">	   
	   <cfelse>
		<p><b>NO INTELLIGENCE RECORDED</b></p>		 
	   </cfif>		
	</cfoutput>
 </div>		 

<cfif not isDefined("noAudit")>	
<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# #application.genieService.getWestMerciaNominalFullName(nominalRef)# - IRAQS",0,session.user.getDepartment())>
</cfif>