<!---

Module      : ftaWarrantdashboard.cfm

App         : Packages

Purpose     : Shows the intel dashboard for intel users, included from index.cfm

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfinclude template="lookups.cfm">

<script>
	function updateSector() {
				
		document.getElementById('frm_HidSection').value=document.getElementById('frm_SelSection').value		
		dashboardForm.submit();
	}
</script>	

<cfoutput>
<div style="font-size:110%; font-weight:bold;">
<ul>
 <li><a href="create_package_stage1.cfm?#session.URLToken#">Create A New Package</a>
 <li><a href="create_wanted_warrant_stage1.cfm?#session.URLToken#">Create An FTA Wanted Package</a>
 <li><a href="admin_package_updates.cfm?#session.URLToken#">View Updates To Packages</a>
 <li><a href="search.cfm?#session.URLToken#">Search</a>
 <cfif session.superUser IS "YES">
 <li><a href="update_users.cfm?#session.URLToken#">Update Admin Users</a>
 </cfif>
 <li><a href="update_generic_emails.cfm?#session.URLToken#">Update Generic Email Addresses</a>
 <li><a href="update_constables.cfm?#session.URLToken#">Update Constables (Who can return Packages)</a>
 <li><a href="reportMenu.cfm?#session.URLToken#">Report Menu</a>
 <li><a href="admin_reg_user_view.cfm?#session.URLToken#">Regular User View</a></li>

 <!---
 <li><a href="excel_export.cfm?#session.URLToken#">Export #Session.LoggedInUserDiv# Div Data To Excel</a> 
 <li><a href="officer_counts.cfm?Division=#Session.loggedInUserDiv#&#session.URLToken#">Officers Report</a></li> 
 --->
</ul>
</div>

<hr>
<div align="center">
<cfif not isDefined("frm_SelDivision")>
 <cfset frm_SelDivision=session.Div>
</cfif>
<cfif not isDefined("frm_SelCat")>
 <cfset frm_SelCat=32>
</cfif>
<cfif not isDefined("frm_SelCrime")>
 <cfset frm_SelCrime="">
</cfif>
<cfif not isDefined("frm_SelSection")>
 <cfset frm_SelSection="">
</cfif>
<cfif not isDefined("tab")>
  <cfset tab="tab1">
</cfif>

<cfform style="margin:0px;" id="dashboardForm" name="dashboardForm">
	<table width="98%">		
		<tr>
			<td nowrap width="125"><b>Filter By Area : </b></td>
			<td width="1">
			     <select name="frm_SelDivision" id="frm_SelDivision" onChange="document.getElementById('frm_SelSection').value='';updateSector()">
			      <option value="">-- Select --</option>
				  <cfloop query="Application.qry_Division">
				   	 <option value="#AREAID#" <cfif frm_SelDivision IS AREAID>selected</cfif>>#AREANAME#</option>
				  </cfloop>
				 </select>					
			</td>
			<td width="10"></td>
		    <td width="80">
		    	<b>Sector : </b>
		    </td>
			<td width="1"><cfinput type="hidden" name="frm_HidSection" id="frm_HidSection" value="#frm_SelSection#"><cfdiv bind="url:sections_cfdiv.cfm?thisDiv={frm_SelDivision}&currentSection=#frm_SelSection#&dashboard=yes" ID="section" style="" /></td>
			<td width="10"></td>
			<td width="80">
				<b>Category : </b>
			</td>
			<td width="1">
			   <select name="frm_SelCat">
                 <option value="">ALL</option>
                 <cfloop query="application.qry_Categories">
                 <option value="#CATEGORY_ID#" <cfif CATEGORY_ID IS frm_SelCat>selected</cfif>>#CATEGORY_DESCRIPTION#</option>	
                 </cfloop>                                         
              </select>				
			</td>
			<td width="10"></td>
			<td width="100"><b>Crime : </b></td>
			<td>
 				<select name="frm_SelCrime">
                 <option value="">ALL</option>
                 <cfloop query="application.qry_CrimeType">
                 <option value="#CRIME_TYPE_ID#" <cfif CRIME_TYPE_ID IS frm_SelCrime>selected</cfif>>#DESCRIPTION#</option>	
                 </cfloop>                                         
                </select>		
				<cfinput type="hidden" name="tab" value="#tab#">			
			</td>
	</table>
</cfform>										
</div>
<hr>

<cflayout type="tab" name="dashboardTabs">
 <cflayoutarea source="listPackages.cfm?listType=OPEN&Div={frm_SelDivision}&frm_SelCat={frm_SelCat}&frm_SelCrime={frm_SelCrime}&frm_SelSector={frm_HidSection}&from=dashboard&tab=tab1" name="tab1" title="Open" refreshOnActivate="true"  selected="#Iif(tab IS 'tab1',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab1',DE('true'),DE('false'))#"/>	
 <cflayoutarea source="listPackages.cfm?listType=OVERDUE&Div={frm_SelDivision}&frm_SelCat={frm_SelCat}&frm_SelCrime={frm_SelCrime}&frm_SelSector={frm_HidSection}&from=dashboard&tab=tab2" name="tab2" title="Overdue" refreshOnActivate="true"  selected="#Iif(tab IS 'tab2',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab2',DE('true'),DE('false'))#"/>
 <cflayoutarea source="listPackages.cfm?listType=OUTSTANDING&Div={frm_SelDivision}&frm_SelCat={frm_SelCat}&frm_SelCrime={frm_SelCrime}&frm_SelSector={frm_HidSection}&from=dashboard&tab=tab3" name="tab3" title="Outstanding" refreshOnActivate="true"  selected="#Iif(tab IS 'tab3',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab3',DE('true'),DE('false'))#"/>   
 <cflayoutarea source="listPackages.cfm?listType=COMPLETED&Div={frm_SelDivision}&frm_SelCat={frm_SelCat}&frm_SelCrime={frm_SelCrime}&frm_SelSector={frm_HidSection}&from=dashboard&tab=tab4" name="tab4" title="Completed" refreshOnActivate="true"  selected="#Iif(tab IS 'tab7',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab4',DE('true'),DE('false'))#"/>            
</cflayout>

</cfoutput>