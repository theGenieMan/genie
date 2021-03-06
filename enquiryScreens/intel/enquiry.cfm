﻿<!DOCTYPE html>	
<!---

Module      : /enquiryScreens/intel/enquiry.cfm

App         : GENIE

Purpose     : Displays the intel enquiry screen

Requires    : 

Author      : Nick Blackham

Date        : 18/11/2014

Version     : 

Revisions   : 

--->
	
<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">	
<cfparam name="division" default="">
<cfparam name="date_created1" default="">
<cfparam name="date_created2" default="">	
	
<cfset qCats=application.genieService.getIntelCategories()>
<html>	
<head>
	<title>GENIE - Intel Enquiry</title>
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
	<script type="text/javascript" src="js/intelEnquiryFunctions.js"></script>
	<script type="text/javascript" src="js/intelEnquiryEvents.js"></script>
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
		
	<cfset headerTitle="INTEL ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
	 <a href="/help/intel_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
	</div>
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
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
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Intel Enquiry <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="log_ref">Log Ref</label></td>
					<td  valign="top" width="30%">
						<input name="log_ref" id="log_ref" displayInPane="Log Ref" displayPrevSearch="Y" initialFocus="true" size="15">
					</td>
					<td width="5%">&nbsp;</td>
					<td width="15%"><label for="source_doc_ref">Src Doc</label></td>
					<td valign="top">
						<input name="source_doc_ref" id="source_doc_ref" displayInPane="Src Doc" displayPrevSearch="Y" size="25">
						<!---
						<select name="source_doc_ref" id="source_doc_ref" displayInPane="Src Doc" displayPrevSearch="Y">
							<option value="">-- Select --</option>
							<cfloop query="Application.qry_SrcDoc">
							<option value="#DOCUMENT_CODE#">#DESCRIPTION#</option>		
							</cfloop>
						</select>
						--->
					</td>										
		  		</tr>		
				<tr>
					<td valign="top"><label for="division">Policing Area</label></td>
					<td valign="top">
						<select name="division" id="division" displayInPane="Policing Area" displayPrevSearch="Y" multiple size="5">							
							<cfloop query="Application.qry_Division">
							<option value="#ORG_CODE#" #iif(ORG_CODE IS division,de('selected'),de(''))#>#Replace(ORG_NAME,' POLICING AREA','')#</option>		
							</cfloop>
						</select>
					</td>	
					<td>&nbsp;</td>						
					<td valign="top"><label for="indicator">Indicator</label></td>
					<td valign="top">
						<select name="indicator" id="indicator" displayInPane="Indicator" displayPrevSearch="Y">
							<option value="">-- Select --</option>
							<cfloop query="Application.qry_Ind">
							<option value="%#DESCRIPTION#%">#DESCRIPTION#</option>		
							</cfloop>
						</select>
					</td>								
				</tr>	
				<tr>
					<td valign="top"><label for="security_access_level">Access</label></td>
					<td valign="top" colspan="4">
						<select name="security_access_level" id="security_access_level" displayInPane="Access" displayPrevSearch="Y">
							<option value="">-- Select --</option>
							<cfloop query="Application.qry_Access">
				 				<cfif isNumeric(CRC_CODE)>
				 					<cfif Int(CRC_CODE) GTE Int(Session.LoggedInUserLogAccess)>						
									<option value="#CRC_CODE#">#CRC_CODE# - #DESCRIPTION#</option>
				 					</cfif>
				 				</cfif>
				 			</cfloop>		
						</select>
					</td>														
				</tr>					
				<tr>
					<td valign="top"><label for="date_created1">Created</label></td>
					<td valign="top" colspan="4">
						<b>Between/On</b> 
						<input name="date_created1" id="date_created1" displayInPane="Created Between/On" displayPrevSearch="Y" size="10" value="#date_created1#" datepicker> 
						<b>And</b> 
						<input name="date_created2" id="date_created2" displayInPane="Created To" displayPrevSearch="Y" size="10" value="#date_created2#" datepicker>
					</td>										
				</tr>	
				<tr>
					<td valign="top"><label for="category">Category</label></td>
					<td valign="top">
						<select name="category" id="category" displayInPane="Category" displayPrevSearch="Y" multiple size="6">							
						<cfloop query="qCats">
			  	  			<option value="#INDEX_CODE#">#DESCRIPTION#</option>
			  			</cfloop>	
						</select>
					</td>	
					<td>&nbsp;</td>						
					<td valign="top"><label for="includeNominals">Show Nominals</label></td>
					<td valign="top">
						<select name="includeNominals" id="includeNominals" displayInPane="Show Nominals" displayPrevSearch="Y" initSelect="N">
							<option value="N">N</option>							
							<option value="Y">Y</option>									
						</select>
					</td>								
				</tr>					
		  	</table>			
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
					<input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button" accesskey="S">
				</td>
	  		</tr>
	  </table>
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none; clear:both;">
		
		<!---  --->
		<div id="resultsTabs">
			
		   <ul>        		
		       <li id="wmpLi"><a href="#wmpResultsDiv">WP / WMP Results &nbsp;&nbsp <div id="wmpSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="wmpResultsCount"></span></a></li>			   
		   </ul>
		   
		   <cfoutput>
		   <div id="wmpResultsDiv">
		   	
			<div id="wmpResults" style='display:none;'>
			   	<div id="wmpResultsButtons" class="genieResultButtons">			   					   		
					<input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
					       printDiv="wmpResults" printTitle="GENIE Custody Enquiry Results" printUser="#session.user.getFullName()# - #sessionId#">
			   	</div>
				<div id="wmpResultsData" class="resultsDiv">
					
				</div>
			</div>
			<div id='wmpSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   
		   </cfoutput>						
		</div>
		
	</div>
	
	<cfoutput>
	<input type="hidden" name="sessionId" id="sessionId" value="#sessionId#">
	<input type="hidden" name="terminalId" id="terminalId" value="#session.hostName#">
	<input type="hidden" name="userAccessLevel" id="userAccessLevel" value="#session.LoggedInUserLogAccess#">
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
	
	<div id="pdOffencesDialog" style="display:none;">
		<div id='onLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='onData' style="display:none;"></div>
	</div>
		
	</cfoutput>
	
</body>	

	
</html>	