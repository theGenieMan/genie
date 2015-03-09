<!DOCTYPE html>
<!---

Module      : /enquiryScreens/vehicle/enquiry.cfm

App         : GENIE

Purpose     : Displays the vehicle enquiry screen

Requires    : 

Author      : Nick Blackham

Date        : 18/11/2014

Version     : 

Revisions   : 

--->

<cfparam name="vrm" default="" />
<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">
	
<html>	
<head>
	<title>GENIE - Vehicle Enquiry</title>
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
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/vehicleFunctions.js"></script>
	<script type="text/javascript" src="js/vehicleEvents.js"></script>
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
	
	<input type="hidden" name="redirector" id="redirector" value="#redirector#">
	<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
	<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">	
	
	<cfinclude template="/actionSelectJS.cfm">
	<cfset headerTitle="VEHICLE ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
		<a href="/help/vehicle_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
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
						<cfif session.isWMidsUser>
						<input type="checkbox" name="wMidsData" id="wMidsData" displayInPane="West Mids" displayPrevSearch="N"> West Mids
						</cfif>	
					</td>										
		  		</tr>				
		  	</table>			
		</div>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="addressPane" class="ui-accordion searchPane" initOpen="true">
	  	  <div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Vehicle Search <span class="dataEntered"></span></div>
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
		  			<td width="15%"><label for="vrm">VRM</label></td>
					<td width="25%" colspan="3">
						<input name="vrm" id="vrm" displayInPane="VRM" displayPrevSearch="Y" size="8" value="#vrm#" initialFocus="true"> <cfif session.isWMidsUser><b>WM</b></cfif>
						&nbsp;&nbsp;Special Search Available (eg. T%*312*%Y - NB. *ANYORDER*, Warks / West Mercia Data Only)						
					</td>																							
		  		</tr>	
		  		<tr>
		  			<td width="15%"><label for="manu">Manufacturer</label></td>
					<td width="25%">
						<input name="manufacturer" id="manufacturer" displayInPane="Manufacturer" displayPrevSearch="Y" size="25">
					</td>
					<td width="15%"><label for="model">Model</label></td>
					<td>
						<input name="model" id="model" displayInPane="Model" displayPrevSearch="Y" size="25">						
					</td>																		
		  		</tr>	
		  		<tr>
		  			<td><label for="body_type">Body Type</label></td>
					<td>
						<input name="body_type" id="body_type" displayInPane="Body Type" displayPrevSearch="Y" size="25">						
					</td>																
		  			<td><label for="shade">Shade</label></td>
					<td>
						<input name="shade" id="shade" displayInPane="Shade" displayPrevSearch="Y" size="25">						
					</td>																
		  		</tr>
		  		<tr>
		  			<td><label for="primary_col">Primary Colour</label></td>
					<td>
						<input name="primary_col" id="primary_col" displayInPane="Primary Colour" displayPrevSearch="Y" size="25">						
					</td>																		  		
		  			<td><label for="secondary_col">Secondary Colour</label></td>
					<td>
						<input name="secondary_col" id="secondary_col" displayInPane="Secondary Colour" displayPrevSearch="Y" size="25">						
					</td>																
		  		</tr>	
		  		<tr>
		  			<td width="15%"><label for="text">Text</label></td>
					<td width="25%" colspan="3">
						<input name="text" id="text" displayInPane="Text" displayPrevSearch="Y" size="50" value=""> 					
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
		
		<!---  --->
		<div id="resultsTabs">
			
		   <ul>        		
		       <li id="wmpLi"><a href="#wmpResultsDiv">WP / WMP Results &nbsp;&nbsp <div id="wmpSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="wmpResultsCount"></span></a></li>			   
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