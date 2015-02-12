<!---

Module      : user_view.cfm

App          : Packages

Purpose     : Shows thenon intel user their current packages and completed packages

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

   <cfset str_Valid="YES">
   <cfset lis_Errors="">

  <cfif ListLen(frm_TxtPackRef,"/") IS 2>
      <cfset s_Ref=ListGetAt(frm_TxtPackRef,2,"/")>	
  <cfelse>
      <cfset s_Ref=UCase(frm_TxtPackRef)>
  </cfif>

  <cfset qry_PackDetails=application.stepReadDAO.Get_Package_Details(s_Ref)>

 <cfif qry_PackDetails.RecordCount IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"Cannot find a package for reference #frm_TxtPackRef#","|")>	

 </cfif>
 
 <cfif str_Valid IS "YES">
	<cflocation url="view_package.cfm?Package_ID=#qry_PackDetails.Package_ID#" addtoken="true">
  </cfif>
  

</cfif>

<!---
<cfset HR_CFCS=CreateObject("component","applications.cfc.hr.hrqueries")>
<cfset str_UserDetails=HR_CFCS.getOfficerDetailsFromUID(HTTP_SMUSER,Application.WarehouseDSN)>
--->

<!--- get the awaiting closures --->
<cfset qry_Current=application.stepReadDAO.Get_Package_List(Filter="USER CURRENT",Division=Session.DIV,userId=session.user.getUserId())>
<!--- get any packges the user is CC'd on --->
<cfset qry_CC=application.stepReadDAO.Get_Package_User_CC_List(session.user.getUserId())>
<!--- get the overdues --->
<cfset qry_Completed=application.stepReadDAO.Get_Package_List(Filter="USER COMPLETED",Division=Session.DIV,userId=session.user.getUserId())>
<!--- get the PPOs --->
<cfset qry_PPOS=application.stepReadDAO.Get_Package_List(Filter="PPOS",Division=Session.DIV,complete='N')>
<!--- get the Curfew Bails --->
<cfset qry_CurfewBail=application.stepReadDAO.Get_Package_List(Filter="CURFEW_BAIL",Division=Session.DIV,complete='N')>
<!--- get the warrants --->
<cfset qry_Warrants=application.stepReadDAO.Get_Package_List(Filter="WARRANTS",Division=Session.DIV,complete='N')>
<!--- get the child protection --->
<cfset qry_ChildProt=application.stepReadDAO.Get_Package_List(Filter="CHILD PROTECTION",Division=Session.DIV,complete='N')>
<!--- get the local district tasking --->
<cfset qry_LDT=application.stepReadDAO.Get_Package_List(Filter="LOCAL DISTRICT TASKING",Division=Session.DIV,complete='N')>
<!--- get the wanted missing --->
<cfset qry_WM=application.stepReadDAO.Get_Package_List(Filter="WANTED MISSING",Division=Session.DIV,complete='N')>
<!--- get the pnc wanted --->
<cfset qry_PNC=application.stepReadDAO.Get_Package_List(Filter="PNC WANTED",Division=Session.DIV,complete='N')>

<cfset qry_PR=application.stepReadDAO.Get_Package_List("PRISON RECALL",Session.DIV)>
<cfset sPrevDate=CreateDate("2008","03","30")>

<cfoutput>
<b>Click on the Package ID Number to view full details of the Package</b><Br><Br>
<div align="center">
	<b><span style="width:130px;">Allocation Column:</span>
	<span style="background-color:##FF0000; width:230px;">Red are Overdue</span>
	<span>&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color:##ff8000; width:230px;">Amber are Current</span>	
	<span>&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color:##00CC00; width:230px;">Green are Completed</span>
	</b>
</div><br>
<div align="center">
	<b><span style="width:130px;">Package Column:</span> 
	<span style="background-color:##FF0000; width:230px;">Red - Risk Level High</span>
	<span>&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color:##ff8000; width:230px;">Amber - Risk Level Medium</span>	
	<span>&nbsp;&nbsp;&nbsp;</span>
    <span style="background-color:##00CC00; width:230px;">Green - Risk Level Standard</span>
	</b>
</div>

<br>

<div align="center">
 <div style="width:50%">
	 <form action="#ListLast(SCRIPT_NAME,"/")#" method="post" style="margin:0px;">
	  <b>Package Ref</b> : <input type="text" name="frm_TxtPackRef" size="8" <cfif isDefined("frm_TxtPackRef")>value="#frm_TxtPackRef#"</cfif>>
	                                    <input type="hidden" name="frm_hidAction" value="Show">
	                                   <input type="submit" name="frm_SubSearch" value="Show Package">
	 </form>
	 <br>	 
	 <strong><a href="search.cfm?#session.URLToken#">Click For Package Search Screen</a></strong>	  
 </div>
</div>

<cfif not isDefined("tab")>
 <cfset tab="tab1">
</cfif>

<!---
#IIf(session.LoggedInUserDiv IS 'H',DE('Current'),DE('Current ('&qry_Current.RecordCount&')'))#
--->
<input type="hidden" name="frmSelDiv" value="#session.Div#">
<cflayout type="tab">
 <cflayoutarea name="tab1" title="#IIf(session.Div IS 'H',DE('Current'),DE('Current ('&qry_Current.RecordCount&')'))#" 
               source="listPackages.cfm?cfdebug=yes&listType=USER CURRENT&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab1" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab1',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab1',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab2" title="#IIf(session.Div IS 'H',DE('Complete'),DE('Complete ('&qry_Completed.RecordCount&')'))#"
               source="listPackages.cfm?listType=USER COMPLETED&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab2" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab2',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab2',DE('true'),DE('false'))#" />
 <cflayoutarea name="tab3" title="#IIf(session.Div IS 'H',DE('CCd'),DE('CCd ('&qry_CC.RecordCount&')'))#"  
               source="listPackages.cfm?listType=CC&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab3" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab3',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab3',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab4" title="#IIf(session.Div IS 'H',DE('Curfew Check'),DE('Curfew Check ('&qry_CurfewBail.RecordCount&')'))#" 
               source="listPackages.cfm?listType=CURFEW_BAIL&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab4&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab4',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab4',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab5" title="#IIf(session.Div IS 'H',DE('PPOs'),DE('PPO / IOM ('&qry_PPOs.RecordCount&')'))#"  
               source="listPackages.cfm?listType=PPOS&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab5&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab5',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab5',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab6" title="#IIf(session.Div IS 'H',DE('Warrant'),DE('Warrant ('&qry_Warrants.RecordCount&')'))#"  
               source="listPackages.cfm?listType=WARRANTS&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab6&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab6',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab6',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab7" title="#IIf(session.Div IS 'H',DE('Child Prot'),DE('Child Prot ('&qry_ChildProt.RecordCount&')'))#" 
               source="listPackages.cfm?listType=CHILD PROTECTION&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab7&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab7',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab7',DE('true'),DE('false'))#"/>    
 <cflayoutarea name="tab8" title="#IIf(session.Div IS 'H',DE('Local Dist Tasking'),DE('Local Dist Tasking ('&qry_LDT.RecordCount&')'))#" 
               source="listPackages.cfm?listType=LOCAL DISTRICT TASKING&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab8&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab8',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab8',DE('true'),DE('false'))#"/>
 <!---			   	       
 <cflayoutarea name="tab9" title="#IIf(session.Div IS 'H',DE('Wanted/Missing'),DE('Wanted/Missing ('&qry_WM.RecordCount&')'))#" 
               source="listPackages.cfm?listType=WANTED MISSING&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab9&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab9',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab9',DE('true'),DE('false'))#"/> --->                 
 <cflayoutarea name="tab10" title="#IIf(session.Div IS 'H',DE('Prison Recall'),DE('Prison Recall ('&qry_PR.RecordCount&')'))#" 
               source="listPackages.cfm?listType=PRISON RECALL&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab10&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab10',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab10',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab11" title="#IIf(session.Div IS 'H',DE('PNC Wanted'),DE('PNC Wanted ('&qry_PNC.RecordCount&')'))#" 
               source="listPackages.cfm?listType=PNC WANTED&Div={frmSelDiv}&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab11&complete=N" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab11',DE('true'),DE('false'))#" bindonload="#Iif(tab IS 'tab11',DE('true'),DE('false'))#"/>			   	      			
</cflayout>

<!---

<cflayout type="tab">
 <cflayoutarea name="tab1" title="Current (#qry_Current.RecordCount#)" 
               source="listPackages.cfm?listType=USER CURRENT&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab1" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab1',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab2" title="Complete (#qry_Completed.RecordCount#)"
               source="listPackages.cfm?listType=USER COMPLETED&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab2" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab2',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab3" title="CC'd (#qry_CC.RecordCount#)"  
               source="listPackages.cfm?listType=CC&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab3" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab3',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab4" title="Curfew Bail (#qry_CurfewBail.RecordCount#)" 
               source="listPackages.cfm?listType=CURFEW_BAIL&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab4" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab4',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab5" title="PPOs (#qry_PPOs.RecordCount#)"  
               source="listPackages.cfm?listType=PPOS&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab5" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab5',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab6" title="Warrant (#qry_Warrants.RecordCount#)"  
               source="listPackages.cfm?listType=WARRANTS&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab6" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab6',DE('true'),DE('false'))#"/>
 <cflayoutarea name="tab7" title="Child Prot (#qry_ChildProt.RecordCount#)" 
               source="listPackages.cfm?listType=CHILD PROTECTION&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab7" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab7',DE('true'),DE('false'))#"/>    
 <cflayoutarea name="tab8" title="Local Dist Tasking (#qry_LDT.RecordCount#)" 
               source="listPackages.cfm?listType=LOCAL DISTRICT TASKING&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab8" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab8',DE('true'),DE('false'))#"/>     
 <cflayoutarea name="tab9" title="Wanted/Missing (#qry_WM.RecordCount#)" 
               source="listPackages.cfm?listType=WANTED MISSING&Div=#Session.DIV#&frm_SelCat=&frm_SelCrime=&frm_SelSector=&regUser=YES&from=user_view&tab=tab9" 
               refreshOnActivate="true" selected="#Iif(tab IS 'tab9',DE('true'),DE('false'))#"/>                 
</cflayout>

--->
<!---

<div align="center">
<br>
<cfif qry_Current.RecordCount GT 0>
 <a href="##Current">My Packages Outstanding (#qry_Current.RecordCount#)</a>
<cfelse>
 My Packages Outstanding (0)
</cfif>
 | 
<cfif qry_Completed.RecordCount GT 0>
 <a href="##Completed">My Completed Packages (#qry_Completed.RecordCount#)</a>
<cfelse>
 My Completed Packages (0)
</cfif>
|
<cfif qry_CC.RecordCount GT 0>
 <a href="##Completed">My CC'd' Packages (#qry_CC.RecordCount#)</a>
<cfelse>
 My CC'd Packages (0)
</cfif>
 | 
<cfif qry_CurfewBail.RecordCount GT 0>
 <a href="##Curfew">#Session.DIV# Curfew Bail Packages (#qry_CurfewBail.RecordCount#)</a>
<cfelse>
#Session.DIV# Curfew Bail Packages (0)
</cfif>
 | 
<cfif qry_PPOS.RecordCount GT 0>
 <a href="##PPOS">#Session.DIV# PPO Packages (#qry_Completed.RecordCount#)</a>
<cfelse>
#Session.DIV# PPO Packages (0)
</cfif>
 | 
<cfif qry_Warrants.RecordCount GT 0>
 <a href="##Warrants">#Session.DIV# Warrant Packages (#qry_Warrants.RecordCount#)</a>
<cfelse>
#Session.DIV# Warrant Packages (0)
</cfif>
|
<cfif qry_ChildProt.RecordCount GT 0>
 <a href="##Warrants">#Session.DIV# Child Prot Packages (#qry_ChildProt.RecordCount#)</a>
<cfelse>
#Session.DIV# Child Prot Packages (0)
</cfif>
|
<cfif qry_LDT.RecordCount GT 0>
 <a href="##LDT">#Session.DIV# Local District Tasking Packages (#qry_LDT.RecordCount#)</a>
<cfelse>
#Session.DIV# Local District Tasking Packages (0)
</cfif>


</div>
<hr>
<div align="center">
 <div style="width:50%">
<cfif isDefined("lis_Errors")>
 <cfif ListLen(lis_Errors,"|") GT 0>
<br><br>
  <div class="error_title">
	*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
	</div>
	<div class="error_text">
	#Replace(lis_Errors,"|","<br>","ALL")#
	</div>
 </cfif>
</cfif> 	

 <form action="#ListLast(SCRIPT_NAME,"/")#" method="post" style="margin:0px;">
  <b>Package Ref</b> : <input type="text" name="frm_TxtPackRef" size="8" <cfif isDefined("frm_TxtPackRef")>value="#frm_TxtPackRef#"</cfif>>
                                    <input type="hidden" name="frm_hidAction" value="Show">
                                   <input type="submit" name="frm_SubSearch" value="Show Package">
 </form>
 <br>
 <cfif Session.IsSupervisor IS "YES">
    <strong><a href="search.cfm?#session.URLToken#">Click For Package Search Screen</a></strong>
 </cfif>
 </div>
</div>
<hr>

<cfif qry_Current.RecordCount GT 0>
<fieldset>
 <a name="##Current"></a>
 <legend>Current Packages Assigned To You</legend>
 <div style="height:175px;overflow:auto;">
 <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Current Allocation</td>			
    </tr>
  <cfloop query="qry_Current">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
		</td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div> 
</fieldset>
</cfif>

<cfif qry_Completed.RecordCount GT 0>
<fieldset>
 <a name="##completed"></a>
 <legend>Your Completed Packages</legend>
 <div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Current Allocation</td>			
    </tr>
  <cfloop query="qry_Completed">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
		</td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>

<cfif qry_CC.RecordCount GT 0>
<fieldset>
 <a name="##cc"></a>
 <legend>Your CC'd Packages</legend>
 <div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Current Allocation</td>			
    </tr>
  <cfloop query="qry_CC">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
		</td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>

<cfif qry_CurfewBail.RecordCount GT 0>
<fieldset>
  <a name="##curfew"></a>
 <legend>Current #Session.DIV# Div Curfew Bail Packages</legend>
 <div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Current Allocation</td>			
    </tr>
  <cfloop query="qry_CurfewBail">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>	
        </td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>

<cfif qry_PPOs.RecordCount GT 0>
<fieldset>
  <a name="##PPOS"></a>
 <legend>Current #Session.DIV# Div PPO Packages</legend>
<div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Allocation</td>			
    </tr>
  <cfloop query="qry_PPOs">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
        </td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>

<cfif qry_Warrants.RecordCount GT 0>
<fieldset>
 <a name="##Warrants"></a>
 <legend>Current #Session.DIV# Div Warrant Packages</legend>
<div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Allocation</td>			
    </tr>
  <cfloop query="qry_Warrants">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
		</td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>

<cfif qry_ChildProt.RecordCount GT 0>
<fieldset>
 <a name="##ChildProt"></a>
 <legend>Current #Session.DIV# Div Child Protection Packages</legend>
<div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Allocation</td>			
    </tr>
  <cfloop query="qry_ChildProt">
	<tr style="background-color:###STATUS#">
		<td valign="top">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>		
		</td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>

<cfif qry_LDT.RecordCount GT 0>
<fieldset>
 <a name="##LDT"></a>
 <legend>Current #Session.DIV# Div Local District Tasking Packages</legend>
<div style="height:175px; overflow:auto;">
  <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Allocation</td>			
    </tr>
  <cfloop query="qry_LDT">
	<tr style="background-color:###STATUS#">
		<td valign="top"><strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#">#DIVISION_ENTERING#/#PACKAGE_ID#</a></strong></td>
		<td valign="top">#PROBLEM_OUTLINE#</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top">#ASSIGNED_TO#</td>
	</tr>
  </cfloop>  
</table>
</div>
</fieldset>
</cfif>
--->
</cfoutput>