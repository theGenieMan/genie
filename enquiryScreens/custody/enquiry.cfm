﻿<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Custody Enquiry</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.date.extensions.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.plugin.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.timeentry.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/custodyEnquiryFunctions.js"></script>
	<script type="text/javascript" src="js/custodyEnquiryEvents.js"></script>
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
		
	<cfset headerTitle="CUSTODY ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
	 <a href="/help/custody_whiteboard_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
	</div>
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
	</div>
	<input type="button" class="clearEnquiryForm ui-button" value="CLEAR FORM">
	<form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	<div id="searchPanes">	  
	  <div class="ui-state-highlight" align="center">
		Enter information into <b>at least one</b> of the search fields below.
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Custody Enquiry <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><label for="custNo">Custody No</label></td>
					<td width="30%">
						<input name="custNo" id="custNo" displayInPane="Custody No" size="15" value="">
					</td>
					<td width="5%">&nbsp;</td>
					<td width="15%"><label for="asNo">Arrest Summons No</label></td>
					<td>
						<input name="asNo" id="asNo" displayInPane="Arrest Summons" size="15" value="">
					</td>										
		  		</tr>		
				<tr>
					<td><label for="station">Station</label></td>
					<td>
						<select name="station" id="station" displayInPane="Station">
					    <option value="">-- Select --</option>
						<cfloop query="application.qry_CustodyStation">
						  <option value="#ORG_CODE#">... #ORG_NAME# (#ORG_CODE#)</option>																					
						</cfloop>						
						</select>
					</td>										
				</tr>	
				<tr>
					<td><label for="nominalRef">Nominal Ref</label></td>
					<td>
						<input name="nominalRef" id="nominalRef" displayInPane="Nominal" size="10" value="">
					</td>										
				</tr>		
				<tr>
					<td><label for="sex">Sex</label></td>
					<td>
						<select name="sex" id="sex" displayInPane="Sex">
					    <option value="">-- Select --</option>
						<cfloop query="application.qry_SEX">
						  <option value="#rv_low_value#">#rv_meaning#</option>																					
						</cfloop>						
						</select>
					</td>	
					<td>&nbsp;</td>
					<td><label for="ethnicApp">Ethnic App</label></td>
					<td>
						<select name="ethnicApp" id="ethnicApp" displayInPane="Ethnic App">
					    <option value="">-- Select --</option>						
						<cfloop query="application.qry_Ethnic">
						  <option value="#EA_CODE#">#DESCRIPTION#</option>						  																					
						</cfloop>						
						</select>
					</td>										
				</tr>	
				<tr>
					<td><label for="dob">Date of Birth</label></td>
					<td colspan="4">
						<b>Between/On</b> 
						<input name="dobFrom" id="dobFrom" displayInPane="DOB Between/On" size="10" value="" datepicker> 
						<b>And</b> 
						<input name="dobTo" id="dobTo" displayInPane="DOB To" size="10" value="" datepicker>
					</td>										
				</tr>	
				<tr>
					<td><label for="arrestReason">Arrest Reason</label></td>
					<td colspan="4">
						<input name="arrestReason" id="arrestReason" displayInPane="Arrest Reason" size="50" value="">
					</td>										
				</tr>
				<tr>
					<td><label for="placeOfArrest">Place of Arrest</label></td>
					<td colspan="4">
						<input name="placeOfArrest" id="placeOfArrest" displayInPane="Place of Arrest" size="50" value="">
					</td>										
				</tr>		
				<tr>
					<td><label for="arrestDateFrom">Date of Arrest</label></td>
					<td colspan="4">
						<b>Between/On</b> 
						<input name="arrestDateFrom" id="arrestDateFrom" displayInPane="Date Arrest Between/On" size="10" value="" datepicker> 
						@
						<input name="arrestTimeFrom" id="arrestTimeFrom" displayInPane=" Time" size="4" value="" timepicker>
						<b>And</b> 
						<input name="arrestDateTo" id="arrestDateTo" displayInPane="Date Arrest To" size="10" value="" datepicker>
						@
						<input name="arrestTimeTo" id="arrestTimeTo" displayInPane=" Time" size="4" value="" timepicker>
					</td>										
				</tr>
				<tr>
					<td><label for="departureDateFrom">Date of Departure</label></td>
					<td colspan="4">
						<b>Between/On</b> 
						<input name="departureDateFrom" id="departureDateFrom" displayInPane="Date Departure Between/On" size="10" value="" datepicker> 
						@
						<input name="departureTimeFrom" id="departureTimeFrom" displayInPane=" Time" size="4" value="" timepicker>
						<b>And</b> 
						<input name="departureDateTo" id="departureDateTo" displayInPane="Date Departure To" size="10" value="" datepicker>
						@
						<input name="departureTimeTo" id="departureTimeTo" displayInPane=" Time" size="4" value="" timepicker>
					</td>										
				</tr>	
				<tr>
					<td><label for="arrOffBadge">Arresting Officer</label></td>
					<td colspan="3">
					  <b>Badge No</b> 
					  <input type="text" name="arrOffBadge" id="arrOffBadge" size="5" displayInPane="Arresting Off"> 
					  <b>Force</b> 
					  <select name="arrOffForce" id="arrOffForce" displayInPane="Arresting Off Force">
					  	<option value="">-- Select --</option>
						<cfloop query="application.qry_Force">
						 <option value="#ORG_CODE#">(#ORG_CODE#) #Replace(Replace(Replace(ORG_NAME,"CONSTABULARY","","ALL"),"POLICE","","ALL"),"CONSTABULRY","","ALL")#</option>
						</cfloop>
					  </select>
					</td>
				</tr>		
				<tr>
					<td><label for="oicOffBadge">OIC</label></td>
					<td colspan="3">
					  <b>Badge No</b> 
					  <input type="text" name="oicOffBadge" id="oicOffBadge" size="5" displayInPane="OIC Badge"> 
					  <b>Force</b> 
					  <select name="oicOffForce" id="oicOffForce" displayInPane="OIC Force">
					  	<option value="">-- Select --</option>
						<cfloop query="application.qry_Force">
						 <option value="#ORG_CODE#">(#ORG_CODE#) #Replace(Replace(Replace(ORG_NAME,"CONSTABULARY","","ALL"),"POLICE","","ALL"),"CONSTABULRY","","ALL")#</option>
						</cfloop>
					  </select>
					</td>
				</tr>	
				<tr>
					<td><label for="departureReason">Reason for Departure</label></td>
					<td>
						<input name="departureReason" id="departureReason" displayInPane="Reason for Departure" size="30" value="">
					</td>
					<td>&nbsp;</td>
					<td><label for="origCustNo">Original Custody No</label></td>
					<td>
						<input name="origCustNo" id="origCustNo" displayInPane="Original Custody No" size="10" value="">
					</td>										
				</tr>		
				<tr>
					<td><label for="cancelBail">Cancel/Answer Bail</label></td>
					<td colspan="4">
						<input name="cancelBail" id="cancelBail" displayInPane="Cancel Bail" size="2" value="">
						 <b>Reason</b> 
						<input name="cancelReason" id="cancelReason" displayInPane="Cancel Reason" size="25" value="">
					</td>										
				</tr>
				<tr>
					<td><label for="warningMarker">Warning Marker</label></td>
					<td colspan="4">
					  <select name="warningMarker" id="warningMarker" displayInPane="Warning Marker">
					  	<option value="">-- Select --</option>
						<cfset x=1>
				        <cfloop list="#Application.custWarningMarkers#" index="warnMark" delimiters=",">
				         <option value="#warnMark#">#warnMark# - #ListGetAt(Application.custWarningMarkersDesc,x,",")#</option>
				         <cfset x=x+1>
				        </cfloop>
					  </select>						
					</td>										
				</tr>				
		  	</table>			
		</div>
	  </div>	    
	  <div class="spacer">&nbsp;</div>
	  <div align="right">
	  	<input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button">
	  </div>
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none;">
		
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
	<input type="hidden" name="sessionId" id="terminalId" value="#session.hostName#">
	<input type="hidden" name="enquiryUser" id="enquiryUser" value="#session.user.getUserId()#">
	<input type="hidden" name="enquiryUserName" id="enquiryUserName" value="#session.user.getFullName()#">
	<input type="hidden" name="enquiryUserDept" id="enquiryUserDept" value="#session.user.getDepartment()#">
	<input type="hidden" name="requestFor" id="requestFor" value="">
	<input type="hidden" name="reasonCode" id="reasonCode" value="">
	<input type="hidden" name="reasonText" id="reasonText" value="">
	<input type="hidden" name="reasonText" id="dpaValid" value="N">
	
	
	<div id="custodySummaryDialog" style="display:none;">
		<div id='onLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='onData' style="display:none;"></div>
	</div>
		
	</cfoutput>
	
</body>	

	
</html>	