<!DOCTYPE html>
<!---

Module      : /enquiryScreens/telephone/enquiry.cfm

App         : GENIE

Purpose     : Displays the telephone enquiry screen

Requires    : 

Author      : Nick Blackham

Date        : 18/11/2014

Version     : 

Revisions   : 

--->

<cfparam name="tel_No" default="" />
	
<html>	
<head>
	<title>GENIE - Telephone Enquiry</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.min.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.min.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.date.extensions.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.plugin.min.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.timeentry.min.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/telephoneFunctions.js"></script>
	<script type="text/javascript" src="js/telephoneEvents.js"></script>
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript" src="js/main.js"></script>
</head>

<cfset sessionId=createUUID()>
<body>
	<div id="dpa" style="display:none;"></div>
	<cfoutput>	
	
	<cfinclude template="/actionSelectJS.cfm">
	<cfset headerTitle="TELEPHONE ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
		<a href="/help/telephone_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
	</div>
		
	
	<div id="searchPanes">		  
	  <div class="ui-state-highlight" align="center">
		Enter information into <b>at least one</b> of the search fields below.
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <table width="100%" class="searchButtonsTable">
	  	<tr>
	  		<td width="1" valign="bottom"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY" accesskey="N"></td>
			<td align="right" valign="bottom">
				<span id="prevSearchSpan" style="display:none">
			  	<b>Previous Searches:</b>
				<select name="prevSearch" id="prevSearch">
					
				</select>
				&nbsp;
				|
				</span>
				&nbsp;		
				<a href="enquiryForm" class="clearFormLink" accesskey="C">Clear Form</a> | 			
			  	<a href="expandAll" class="searchPaneToggle" searchPane="searchPaneHeader">Expand All</a> | 
				<a href="expandData" class="searchPaneToggle" searchPane="searchPaneHeader">Expand With Data</a> | 
				<a href="collapseAll" class="searchPaneToggle" searchPane="searchPaneHeader">Collapse All</a>				
			</td>
	  	</tr>
	  </table> 
	  <form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	  <div id="sourcePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Data Sources <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><b>Data Sources</b></td>
					<td>
						<input type="checkbox" name="wmpData" id="wmpData" displayInPane="WP/WMP" displayPrevSearch="N" checked disabled noClear='yes'> WP/WMP 						
						<input type="checkbox" name="firearmsData" id="firearmsData" displayInPane="Firearms" displayPrevSearch="N" checked noClear='yes'> Firearms
						<cfif session.isWMidsUser>
						<input type="checkbox" name="wMidsData" id="wMidsData" displayInPane="West Mids" displayPrevSearch="N"> West Mids
						</cfif>	
						<cfif session.isHTCUUser>
						<input type="checkbox" name="htcuData" id="htcuData" displayInPane="HTCU" displayPrevSearch="N"> HTCU
						</cfif>
					</td>										
		  		</tr>				
		  	</table>			
		</div>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="addressPane" class="ui-accordion searchPane">
	  	  <div class="ui-accordion-header ui-state-active searchPaneHeader" initOpen="true"><span class="toggler"><<</span> Telephone Search <span class="dataEntered"></span></div>
		  <div class="ui-widget-content ui-accordion-content searchPaneContent">
			<div id="errorDiv" style="display:none;">
				<div class="error_title">
				*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
				</div>
				<div class="error_text">
				
				</div>
			</div>		  	
		  	<div>
		  	<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><label for="tel_no">Number</label></td>
					<td width="25%" colspan="3">
						<input name="tel_no" id="tel_no" displayInPane="Number" displayPrevSearch="Y" size="15" value="#tel_no#" initialFocus="true"> <cfif session.isWMidsUser><b>WM</b></cfif>						
					</td>																							
		  		</tr>	
		  		<tr>
		  			<td><label for="phone_type">Phone Type</label></td>
					<td colspan="4">
						<select name="phone_type" id="phone_type" displayInPane="Phone Type" displayPrevSearch="Y">
							<option value="">-- Select --</option>
							<cfloop query="application.qry_PhoneType">
								<option value="#DESCRIPTION#">#DESCRIPTION#</option>	
							</cfloop>		
						</select>
					</td>																		
		  		</tr>	
		  		<tr>
		  			<td><label for="body_type">Airtime Supplier</label></td>
					<td colspan="4">
						<select name="supplier" id="supplier" displayInPane="Airtime Supplier" displayPrevSearch="Y">
							<option value="">-- Select --</option>
							<cfloop query="application.qry_PhoneAirtime">
								<option value="#DESCRIPTION#">#DESCRIPTION#</option>	
							</cfloop>		
						</select>						
					</td>																															
		  		</tr>
		  		<tr>
		  			<td><label for="elec_comms">Elec Comms</label></td>
					<td colspan="4">
						<input name="elec_comms" id="elec_comms" displayInPane="Elec Comms" displayPrevSearch="Y" size="25">						
					</td>																		  																	
		  		</tr>	
		  		<tr>
		  			<td><label for="text">Stolen</label></td>
					<td colspan="4">
						<select name="stolen" id="stolen" displayInPane="Stolen" displayPrevSearch="Y">
							<option value="">-- Select --</option>
							<option value="N">NO</option>				 
							<option value="Y">YES</option>				 				 
						</select>	 					
					</td>																							
		  		</tr>	
				<tr>
					<td><label for="dob">Date Created</label></td>
					<td colspan="4">
						<b>Between/On</b> 
						<input name="createdFrom" id="createdFrom" displayInPane="Created Between/On" displayPrevSearch="Y" size="10" value="" datepicker> 
						<b>And</b> 
						<input name="createdTo" id="createdTo" displayInPane="Created To" displayPrevSearch="Y" size="10" value="" datepicker>
					</td>										
				</tr>	
				<tr>
					<td><label for="dob">Date Terminated</label></td>
					<td colspan="4">
						<b>Between/On</b> 
						<input name="terminatedFrom" id="terminatedFrom" displayInPane="Terminated Between/On" displayPrevSearch="Y" size="10" value="" datepicker> 
						<b>And</b> 
						<input name="terminatedTo" id="terminatedTo" displayInPane="Terminated To" size="10" displayPrevSearch="Y" value="" datepicker>
					</td>										
				</tr>			
		  		<tr>
		  			<td><label for="notes">Notes</label></td>
					<td colspan="4">
						<input name="notes" id="notes" displayInPane="Notes" displayPrevSearch="Y" size="50">						
					</td>																		  																	
		  		</tr>																													
		  	</table>
			</div>
		  </div>		
	  </div>		 	  
	  <div class="spacer">&nbsp;</div>
	  <table width="100%" class="searchButtonsTable">
	  		<tr>
	  			<td width="50%" align="left"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY" accesskey="N"></td>
				<td width="50%" align="right">
					<cfif isDefined('startSearch')>
					 <input type="hidden" name="doSearch" id="doSearch" value="true">  	
					</cfif>
					<input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button" accesskey="S"></td>
	  		</tr>
	  </table>	  	  
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none; clear:both">
				
		<div id="resultsTabs">
			
		   <ul>        		
		       <li id="wmpLi"><a href="#wmpResultsDiv">WP / WMP Results &nbsp;&nbsp <div id="wmpSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="wmpResultsCount"></span></a></li>			   
			   <li id="firearmsLi"><a href="#firearmsResultsDiv">Firearms Results &nbsp;&nbsp <div id="firearmsSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="firearmsResultsCount"></span></a></li>
			   <li id="htcuLi"><a href="#htcuResultsDiv">HTCU Results &nbsp;&nbsp <div id="htcuSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="htcuResultsCount"></span></a></li>
			   <li id="wMidsLi"><a href="#wMidsResultsDiv">West Mids Results &nbsp;&nbsp <div id="wMidsSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="wMidsResultsCount"></span></a></li>
		   </ul>
		   
		   <cfoutput>
		   <div id="wmpResultsDiv">
		   	
			<div id="wmpResults" style='display:none;'>
			   	<div id="wmpResultsButtons" class="genieResultButtons">			   		
					<input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
					       printDiv="wmpResults" printTitle="GENIE Address Enquiry Results" printUser="#session.user.getFullName()# - #sessionId#">
			   	</div>
				<div id="wmpResultsData" class="resultsDiv">
					
				</div>
			</div>
			<div id='wmpSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   
		   <div id="firearmsResultsDiv" class="resultsDiv">
			 <div id="firearmsResults" style='display:none;'>
			   	<div id="firearmsResultsButtons">			   		
					<input type="button" id="fireamsPrint" name="firearmsPrint" class="printButton" value="Print (P)" printDiv="firearmsResultsData" accesskey="P">
			   	</div>
				<div id="firearmsResultsData">
					
				</div>
			 </div>
			 <div id='firearmsSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   
		   <div id="htcuResultsDiv" class="resultsDiv">
			 <div id="htcuResults" style='display:none;'>
			   	<div id="htcuResultsButtons">			   		
					<input type="button" id="htcuPrint" name="htcuPrint" class="printButton" value="Print (P)" printDiv="htcuResultsData" accesskey="P">
			   	</div>
				<div id="htcuResultsData">
					
				</div>
			 </div>
			 <div id='htcuSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>		   
		   
		   <div id="wMidsResultsDiv" class="resultsDiv">
		   	<div id="wMidsResults" style='display:none;'>
			   	<div id="wMidsResultsButtons">			   		
					<input type="button" id="wMidsPrint" name="wMidsPrint" class="printButton" value="Print (P)" printDiv="wMidsResultsData" accesskey="P">
			   	</div>
				<div id="wMidsResultsData">
					
				</div>
			 </div>
			 <div id='wMidsSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   </cfoutput>						
		</div>
		
	</div>	
	
	<cfoutput>
	<div id="nominalCountPopup"></div>	
	<input type="hidden" name="sessionId" id="sessionId" value="#sessionId#">
	<input type="hidden" name="sessionId" id="terminalId" value="#session.hostName#">
	<input type="hidden" name="enquiryUser" id="enquiryUser" value="#session.user.getUserId()#">
	<input type="hidden" name="enquiryUserName" id="enquiryUserName" value="#session.user.getFullName()#">
	<input type="hidden" name="enquiryUserDept" id="enquiryUserDept" value="#session.user.getDepartment()#">
	<input type="hidden" name="requestFor" id="requestFor" value="">
	<input type="hidden" name="reasonCode" id="reasonCode" value="">
	<input type="hidden" name="reasonText" id="reasonText" value="">
	<input type="hidden" name="reasonText" id="dpaValid" value="N">
	<input type="hidden" name="ethnicCode" id="ethnicCode" value="">
	<input type="hidden" name="requestForCollar" id="requestForCollar" value="">
	<input type="hidden" name="requestForForce" id="requestForForce" value="">
	<input type="hidden" name="isOCC" id="isOCC" value="#session.isOCC#">
	<input type="hidden" name="lastEnquiryTimestamp" id="lastEnquiryTimestamp" value="">
	
	<div id="vehicleDetailsDialog" style="display:none;">
		<div id='onLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='onData' style="display:none;"></div>
	</div>
	
	<div id="wMidsDialog" style="display:none;">
		<div id='wmLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='wmData' style="display:none;"></div>
	</div>	
	
	<div id="actionDetailsPopup" style="display:none;">
		<div id="actionDetailsPopupBody">
		<table width="95%" align="center">
		 <tr>
		 	<td width="30%" valign="top"><b>Officer Conducting</b></td>
			<td><div id="actionDetailOfficer"></div></td>
		 </tr>
		 <tr>
		 	<td><b>Location</b></td>
			<td><input type="text" name="actionDetailsLocation" id="actionDetailsLocation" size="45"></td>
		 </tr>
		 <tr>
		 	<td colspan="2" align="center">
		 		<br>				
				<input type="hidden" name="inputterUserId" id="inputterUserId" value="#session.user.getTrueUserId()#">				
		 		<input type="button" name="btnActionDetails" id="btnActionDetails" action="" actionType="" class="nominalActionButton" value="">
			</td>
		 </tr>
		</table>
		</div>	
	</div>
	</cfoutput>
	
	
	
</body>	

	
</html>	