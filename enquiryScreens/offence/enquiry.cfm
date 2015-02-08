<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Offence Enquiry</title>
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
	<script type="text/javascript" src="/jQuery/jquery.typing-0.2.0.min.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/offenceEnquiryFunctions.js"></script>
	<script type="text/javascript" src="js/offenceEnquiryEvents.js"></script>
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
		
	<cfset headerTitle="OFFENCE ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
	 <a href="/help/offence_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
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
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Reference Nos <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="org_dsp">Crime No</label></td>
					<td  valign="top" width="30%">
						<input name="org_code" id="org_code" displayInPane="Org Code" displayPrevSearch="Y" size="4" initialFocus="true">
						/
						<input name="serial_no" id="serial_no" displayInPane="Serial No" displayPrevSearch="Y"  size="7">
						/
						<input name="year" id="year" displayInPane="Year" displayPrevSearch="Y"  size="2">
					</td>
					<td width="5%">&nbsp;</td>
					<td width="15%" valign="top"><label for="beat_code">Beat Code</label></td>
					<td valign="top">
						<select name="beat_code" id="beat_code" displayInPane="Beat" displayPrevSearch="Y"  multiple size="5">							
							<cfloop query="Application.qry_Beats">
							<option value="#ORG_CODE#">#ORG_CODE# - #Left(ORG_NAME,30)#</option>		
							</cfloop>
						</select>
					</td>										
		  		</tr>		
				<tr>
					<td valign="top"><label for="old_crime_ref">Old Crime No</label></td>
					<td valign="top" colspan="4">
						<input name="old_crime_ref" id="old_crime_ref" displayInPane="Old Crime Ref" displayPrevSearch="Y"  size="10" value="">
					</td>														
				</tr>	
				<tr>
					<td valign="top"><label for="incident_no">Incident No</label></td>
					<td valign="top"4">
						<input name="incident_no" id="incident_no" displayInPane="Incident No" displayPrevSearch="Y"  size="12" value="">
					</td>			
					<td>&nbsp;</td>
					<td valign="top"><label for="soco_report_no">Soco Report No</label></td>
					<td valign="top"4">
						<input name="soco_report_no" id="soco_report_no" displayInPane="Soco" displayPrevSearch="Y"  size="12" value="">
					</td>											
				</tr>									
		  	</table>			
		</div>
		<div class="spacer">&nbsp;</div>
		<div class="ui-accordion-header ui-state-default searchPaneHeader"><span class="toggler">>></span> Recorded / Reported As <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent" style="display:none;">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="rec_wmc_code">Force Recorded As</label></td>
					<td  valign="top" colspan="4">
						<input name="rec_wmc_code" id="rec_wmc_code" displayInPane="Force Recorded As " displayPrevSearch="Y"  size="5" value="" readonly>						
						<input name="rec_wmc_desc" id="rec_wmc_desc" size="60" value="" codeElement="rec_wmc_code">						
					</td>											
		  		</tr>		
		  		<tr>
		  			<td valign="top"><label for="rec_homc_code">HO Code</label></td>
					<td  valign="top" colspan="4">
						<input name="rec_homc_code" id="rec_homc_code" displayInPane="Rec HOMC Code" displayPrevSearch="Y"  size="3" value="" readonly>
						<input name="rec_homc_desc" id="rec_homc_desc" size="20" value="" codeElement="rec_homc_code" hoocField="rec_hooc_code">
						/
						<input name="rec_hooc_code" id="rec_hooc_code" displayInPane="Rec HOOC Code" size="2" value="" readonly homcField="rec_homc_code">						
					</td>															
		  		</tr>
		  		<tr>
		  			<td valign="top"><label for="rep_wmc_code">Force Reported As</label></td>
					<td  valign="top" colspan="4">
						<input name="rep_wmc_code" id="rep_wmc_code" displayInPane="Force Reported As " displayPrevSearch="Y"  size="5" value="" readonly>						
						<input name="rep_wmc_desc" id="rep_wmc_desc" size="60" value=""  codeElement="rep_wmc_code">						
					</td>											
		  		</tr>		
		  		<tr>
		  			<td valign="top"><label for="rep_homc_code">HO Code</label></td>
					<td  valign="top" colspan="4">
						<input name="rep_homc_code" id="rep_homc_code" displayInPane="Rep HOMC Code" displayPrevSearch="Y"  size="2" value="" readonly>
						<input name="rep_homc_desc" id="rep_homc_desc" size="20" value="" codeElement="rep_homc_code"  hoocField="rep_hooc_code">
						/
						<input name="rep_hooc_code" id="rep_hooc_code" displayInPane="Rep HOOC Code" displayPrevSearch="Y"  size="2" value="" readonly homcField="rep_homc_code">						
					</td>														
		  		</tr>								
		  	</table>	
	  </div>	
	  <div class="spacer">&nbsp;</div>
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Dates <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
					<td valign="top" width="15%"><label for="date_offence1">Offence Times</label></td>
					<td valign="top">
						<b>Between/On</b> 
						<input name="date_offence1" id="date_offence1" displayInPane="Offence Times Between/On" displayPrevSearch="Y"  size="10" value="" datepicker> 
						<b>And</b> 
						<input name="date_offence2" id="date_offence2" displayInPane="Offence Times To" displayPrevSearch="Y"  size="10" value="" datepicker>
					</td>										
				</tr>
				<tr>
					<td valign="top" width="15%"><label for="date_created1">Date Created</label></td>
					<td valign="top">
						<b>Between/On</b> 
						<input name="date_created1" id="date_created1" displayInPane="Date Created Between/On" displayPrevSearch="Y"  size="10" value="" datepicker> 
						<b>And</b> 
						<input name="date_created2" id="date_created2" displayInPane="Date Created To" displayPrevSearch="Y"  size="10" value="" datepicker>
					</td>										
				</tr>
				<tr>
					<td valign="top" width="15%"><label for="date_reported1">Date Reported</label></td>
					<td valign="top">
						<b>Between/On</b> 
						<input name="date_reported1" id="date_reported1" displayInPane="Date Reported Between/On" displayPrevSearch="Y"  size="10" value="" datepicker> 
						<b>And</b> 
						<input name="date_reported2" id="date_reported2" displayInPane="Date Reported To" displayPrevSearch="Y"  size="10" value="" datepicker>
					</td>										
				</tr>
				<tr>
					<td valign="top" width="15%"><label for="date_horeported1">HO Date Reported</label></td>
					<td valign="top">
						<b>Between/On</b> 
						<input name="date_horeported1" id="date_horeported1" displayInPane="HO Date Reported Between/On" displayPrevSearch="Y"  size="10" value="" datepicker> 
						<b>And</b> 
						<input name="date_horeported2" id="date_horeported2" displayInPane="HO Date Reported To" displayPrevSearch="Y"  size="10" value="" datepicker>
					</td>										
				</tr>									
		  	</table>			
		</div>
		<div class="spacer">&nbsp;</div>	 
		<div class="ui-accordion-header ui-state-default searchPaneHeader"><span class="toggler">>></span> Detection / No Crime / Outcome <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent" style="display:none;">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top"><label for="ncr_code">No Crime Reason</label></td>
					<td  valign="top" colspan="4">
						<select name="ncr_code" id="ncr_code" displayInPane="No Crime Reason" displayPrevSearch="Y" >
				     	  <option value="">-- SELECT --</option>
						 	<cfloop query="application.qry_NoCrimeReason">
								<option value="#NCR_CODE#">#DESCRIPTION#</option>				 
						 	</cfloop>
						</select>											
					</td>											
		  		</tr>		
				<tr>
		  			<td valign="top" width="15%"><label for="detected_flag">Detected</label></td>
					<td  valign="top" width="20%">
						<select name="detected_flag" id="detected_flag" displayInPane="Detected" displayPrevSearch="Y" >
					         <option value="">-- SELECT --</option>
							 <cfloop query="application.qry_Detected">
							 	 <option value="#RV_LOW_VALUE#">#RV_MEANING#</option>
							 </cfloop>							 
						</select>
					</td>
					<td width="5%">&nbsp;</td>
					<td width="15%" valign="top"><label for="cuc_code">Clear Up Code</label></td>
					<td valign="top">
						<select name="cuc_code" id="cuc_code" displayInPane="Clear Up Code" displayPrevSearch="Y" >
						    <option value="">-- SELECT --</option>								
							<cfloop query="Application.qry_CUC">
							<option value="#CUC_CODE#">#DESCRIPTION#</option>		
							</cfloop>
						</select>
					</td>										
		  		</tr>			
				<tr>
		  			<td valign="top"><label for="validation_status">Validation Status</label></td>
					<td  valign="top">
						<select name="validation_status" id="validation_status" displayInPane="Validation Status" displayPrevSearch="Y" >
					         <option value="">-- SELECT --</option>
							 <cfloop query="application.qry_Validation">
							 	 <option value="#RV_LOW_VALUE#">#RV_MEANING#</option>
							 </cfloop>							 
						</select>
					</td>
					<td>&nbsp;</td>
					<td valign="top"><label for="report_method">How Reported</label></td>
					<td valign="top">
						<select name="report_method" id="report_method" displayInPane="How Reported" displayPrevSearch="Y" >
						    <option value="">-- SELECT --</option>								
							<cfloop query="Application.qry_HowReported">
							<option value="#RV_LOW_VALUE#">#RV_MEANING#</option>	
							</cfloop>
						</select>
					</td>										
		  		</tr>					
				<tr>
		  			<td valign="top"><label for="mopi_group">MOPI Group</label></td>
					<td  valign="top">
						<select name="mopi_group" id="mopi_group" displayInPane="MOPI Group" displayPrevSearch="Y" >
					         <option value="">-- SELECT --</option>
							 <cfloop query="application.qry_MOPI">
							 	 <option value="#RV_LOW_VALUE#">#RV_MEANING#</option>
							 </cfloop>							 
						</select>
					</td>
					<td>&nbsp;</td>
					<td valign="top"><label for="outcome">Outcome</label></td>
					<td valign="top">
						<select name="outcome" id="outcome" displayInPane="Outcome" displayPrevSearch="Y" >
						    <option value="">-- SELECT --</option>								
							  <cfloop query="application.qCrimeOutcomes">				  
								 <option value="#OUTCOME_CODE#">#DESCRIPTION#</option>
							  </cfloop>	
						</select>
					</td>										
		  		</tr>										
		  	</table>	
	  	 </div>		     
	  <div class="spacer">&nbsp;</div>
  	  <table width="100%" class="searchButtonsTable">
	  		<tr>
	  			<td width="50%" align="left"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY" accesskey="N"></td>
				<td width="50%" align="right"><input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button" accesskey="S"></td>
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