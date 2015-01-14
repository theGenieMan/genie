<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Bail Conditions</title>
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
	<script type="text/javascript" src="js/bailConditionsFunctions.js"></script>
	<script type="text/javascript" src="js/bailConditionsEvents.js"></script>
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
		
	<cfset headerTitle="BAIL CONDITIONS">	
	<cfinclude template="/header.cfm">
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
	</div>
		
	<div id="searchPanes">	  
	  <div class="ui-state-highlight" align="center">
		Enter information into <b>both</b> of the search fields below.
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div class="searchButtonsDiv">
		<input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY">
	  
		  <div align="right">		    
			<span id="prevSearchSpan" style="display:none">
		  	<b>Previous Searches:</b>
			<select name="prevSearch" id="prevSearch">
				
			</select>
			&nbsp;
			|
			</span>
			&nbsp;			
		  	<a href="expandAll" class="searchPaneToggle" searchPane="searchPaneHeader">Expand All</a> | 
			<a href="expandData" class="searchPaneToggle" searchPane="searchPaneHeader">Expand With Data</a> | 
			<a href="collapseAll" class="searchPaneToggle" searchPane="searchPaneHeader">Collapse All</a>
		  </div>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Bail Conditions <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="fromDate">From Date/Time</label></td>
					<td  valign="top" width="30%">
						<input name="fromDate" id="fromDate" displayInPane="From Date" displayPrevSearch="Y" size="12" datepicker value="#DateFormat(DateAdd("d","-1",now()),"DD/MM/YYYY")#" class="mandatory" resetValue="#DateFormat(DateAdd("d","-1",now()),"DD/MM/YYYY")#" initialFocus="true">
						<input name="fromTime" id="fromTime" displayInPane="From Time" displayPrevSearch="Y" size="6" timepicker value="#TimeFormat(now(),"HH")#:00" class="mandatory" noClear resetValue="#TimeFormat(now(),"HH")#:00">
					</td>
					<td colspan="3">&nbsp;</td>															
		  		</tr>
				<tr>
		  			<td valign="top" width="15%"><label for="toDate">To Date/Time</label></td>
					<td  valign="top" width="30%">
						<input name="toDate" id="toDate" displayInPane="To Date" displayPrevSearch="Y" size="12" datepicker value="#DateFormat(now(),"DD/MM/YYYY")#" class="mandatory" resetValue="#DateFormat(now(),"DD/MM/YYYY")#">
						<input name="toTime" id="toTime" displayInPane="To Time" displayPrevSearch="Y" size="6" timepicker value="#TimeFormat(now(),"HH")#:00" class="mandatory" resetValue="#TimeFormat(now(),"HH")#:00">
					</td>
					<td colspan="3">&nbsp;</td>															
		  		</tr>																
		  	</table>			
		</div>
	  </div>	    
	  <div class="spacer">&nbsp;</div>
	  <div class="searchButtonsDiv">
	  	<input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY">
	  	<input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button searchButton">
	  </div>
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none; clear:both">
		
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
	<input type="hidden" name="lastEnquiryTimestamp" id="lastEnquiryTimestamp" value="">	
	</cfoutput>
	
</body>	

	
</html>	